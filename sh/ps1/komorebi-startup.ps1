param(
    [switch]$Install,
    [switch]$Uninstall,
    [switch]$NoBar,
    [switch]$NoWhkd
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DotfilesRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$ConfigRoot = Join-Path $DotfilesRoot ".config"
$KomorebiConfigHome = Join-Path $ConfigRoot "komorebi"
$KomorebiConfig = Join-Path $KomorebiConfigHome "komorebi.json"
$WhkdConfig = Join-Path $ConfigRoot "whkdrc"
$KomorebiBin = Join-Path $env:ProgramFiles "komorebi\bin"
$Komorebic = Join-Path $KomorebiBin "komorebic.exe"
$ShortcutName = "komorebi-dotfiles.lnk"

function Get-StartupShortcutPath {
    $startup = [Environment]::GetFolderPath("Startup")
    if ([string]::IsNullOrWhiteSpace($startup)) {
        throw "Could not find the current user's Startup folder."
    }

    Join-Path $startup $ShortcutName
}

function Get-WindowsPowerShellPath {
    $powershell = Get-Command powershell.exe -ErrorAction SilentlyContinue
    if ($powershell) {
        return $powershell.Source
    }

    Join-Path $PSHOME "powershell.exe"
}

if ($Uninstall) {
    $shortcutPath = Get-StartupShortcutPath
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath
        Write-Host "Removed startup shortcut: $shortcutPath"
    } else {
        Write-Host "No startup shortcut found: $shortcutPath"
    }

    return
}

if ($Install) {
    $shortcutPath = Get-StartupShortcutPath
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = Get-WindowsPowerShellPath
    $shortcutArgs = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"")
    if ($NoBar) {
        $shortcutArgs += "-NoBar"
    }
    if ($NoWhkd) {
        $shortcutArgs += "-NoWhkd"
    }
    $shortcut.Arguments = $shortcutArgs -join " "
    $shortcut.WorkingDirectory = $DotfilesRoot
    $shortcut.WindowStyle = 7
    $shortcut.Description = "Start komorebi with dotfiles config"
    $shortcut.Save()

    Write-Host "Installed startup shortcut: $shortcutPath"
    return
}

if (-not (Test-Path $Komorebic)) {
    throw "komorebic.exe was not found at $Komorebic"
}

if (-not (Test-Path $KomorebiConfig)) {
    throw "komorebi.json was not found at $KomorebiConfig"
}

if ($NoBar) {
    Get-Process komorebi-bar -ErrorAction SilentlyContinue | Stop-Process -Force
}

$env:KOMOREBI_CONFIG_HOME = $KomorebiConfigHome
$env:WHKD_CONFIG_HOME = $ConfigRoot

$startArgs = @("start", "--config", $KomorebiConfig)

if (-not $NoBar) {
    $bar = Join-Path $KomorebiBin "komorebi-bar.exe"
    if (Test-Path $bar) {
        $startArgs += "--bar"
    } else {
        Write-Warning "komorebi-bar.exe was not found, so the bar will not be started."
    }
}

$Whkd = $null
if (-not $NoWhkd) {
    $whkdCommand = Get-Command whkd.exe -ErrorAction SilentlyContinue
    if ($whkdCommand) {
        $Whkd = $whkdCommand.Source
    } else {
        $whkdCandidates = @(
            (Join-Path $env:ProgramFiles "whkd\bin\whkd.exe"),
            (Join-Path $KomorebiBin "whkd.exe")
        )

        foreach ($whkdCandidate in $whkdCandidates) {
            if (Test-Path $whkdCandidate) {
                $Whkd = $whkdCandidate
                break
            }
        }
    }

    if (-not $Whkd) {
        Write-Warning "whkd.exe was not found on PATH, so komorebi hotkeys will not be started."
    } elseif (-not (Test-Path $WhkdConfig)) {
        Write-Warning "whkdrc was not found at $WhkdConfig, so komorebi hotkeys will not be started."
        $Whkd = $null
    }
}

& $Komorebic @startArgs

if ($Whkd) {
    $whkdProcesses = @(Get-CimInstance Win32_Process -Filter "name='whkd.exe'" -ErrorAction SilentlyContinue)
    $hasDesiredWhkd = $whkdProcesses | Where-Object { $_.CommandLine -like "*$WhkdConfig*" } | Select-Object -First 1

    if (-not $hasDesiredWhkd) {
        $whkdProcesses | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
        Start-Process $Whkd -ArgumentList @("--config", $WhkdConfig) -WindowStyle Hidden
    }
}
