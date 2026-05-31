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
    $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
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

if (-not $NoWhkd) {
    $whkd = Get-Command whkd.exe -ErrorAction SilentlyContinue
    if ($whkd -or (Test-Path (Join-Path $KomorebiBin "whkd.exe"))) {
        $startArgs += "--whkd"
    } elseif (Test-Path (Join-Path $ConfigRoot "whkdrc")) {
        Write-Warning "whkd.exe was not found on PATH, so komorebi hotkeys will not be started."
    }
}

& $Komorebic @startArgs
