param(
    [switch]$UseWinget,
    [switch]$DownloadOnly,
    [switch]$ApplyDockTweaks,
    [switch]$TweaksOnly,
    [string]$DownloadDirectory = $env:TEMP
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-OsArchitectureName {
    $arch = $env:PROCESSOR_ARCHITEW6432
    if ([string]::IsNullOrWhiteSpace($arch)) {
        $arch = $env:PROCESSOR_ARCHITECTURE
    }

    if ($arch -match "ARM64") {
        return "arm64"
    }

    return "x64"
}

function Invoke-ExplorerPatcherWingetInstall {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget) {
        throw "winget.exe was not found. Run without -UseWinget to download from the official GitHub release instead."
    }

    Write-Host "Installing ExplorerPatcher with winget..."
    & $winget.Source install -e --id valinet.ExplorerPatcher
}

function Get-ExplorerPatcherInstallerInfo {
    $arch = Get-OsArchitectureName

    if ($arch -eq "arm64") {
        $fileName = "ep_setup_arm64.exe"
    } else {
        $fileName = "ep_setup.exe"
    }

    [pscustomobject]@{
        Architecture = $arch
        FileName = $fileName
        Url = "https://github.com/valinet/ExplorerPatcher/releases/latest/download/$fileName"
    }
}

function Invoke-ExplorerPatcherGithubInstall {
    $installer = Get-ExplorerPatcherInstallerInfo
    $downloadRoot = (New-Item -ItemType Directory -Force -Path $DownloadDirectory).FullName
    $installerPath = Join-Path $downloadRoot $installer.FileName

    Write-Host "Detected Windows architecture: $($installer.Architecture)"
    Write-Host "Downloading ExplorerPatcher from official GitHub release..."
    Write-Host $installer.Url

    $previousProgressPreference = $ProgressPreference
    $ProgressPreference = "SilentlyContinue"

    try {
        Invoke-WebRequest -Uri $installer.Url -OutFile $installerPath -UseBasicParsing
    } finally {
        $ProgressPreference = $previousProgressPreference
    }

    if (-not (Test-Path $installerPath)) {
        throw "Download failed: $installerPath was not created."
    }

    $download = Get-Item $installerPath
    if ($download.Length -le 0) {
        throw "Download failed: $installerPath is empty."
    }

    Write-Host "Downloaded installer: $installerPath"

    $signature = Get-AuthenticodeSignature -FilePath $installerPath
    if ($signature.Status -ne "Valid") {
        Write-Warning "Installer signature status is '$($signature.Status)'. Only continue if you trust the official ExplorerPatcher GitHub release."
    }

    if ($DownloadOnly) {
        Write-Host "Download-only mode complete."
        return
    }

    Write-Host "Launching ExplorerPatcher installer with admin permission..."
    Write-Host "The taskbar and File Explorer may restart during installation."
    Start-Process -FilePath $installerPath -Verb RunAs
}

function Set-DockLikeTaskbarTweaks {
    $advancedKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    if (-not (Test-Path $advancedKey)) {
        New-Item -Path $advancedKey -Force | Out-Null
    }

    Write-Host "Applying current-user taskbar cleanup settings..."
    Set-ExplorerAdvancedDword -Path $advancedKey -Name "TaskbarAl" -Value 1
    Set-ExplorerAdvancedDword -Path $advancedKey -Name "ShowTaskViewButton" -Value 0
    Set-ExplorerAdvancedDword -Path $advancedKey -Name "TaskbarDa" -Value 0
    Set-ExplorerAdvancedDword -Path $advancedKey -Name "SearchboxTaskbarMode" -Value 0
    Set-ExplorerAdvancedDword -Path $advancedKey -Name "TaskbarSi" -Value 0

    Write-Host "Restarting Explorer to apply taskbar changes..."
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Process explorer.exe
}

function Set-ExplorerAdvancedDword {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [int]$Value
    )

    try {
        Set-ItemProperty -Path $Path -Name $Name -Type DWord -Value $Value -ErrorAction Stop
        Write-Host "Set $Name=$Value"
    } catch {
        Write-Warning "Could not set $Name. $($_.Exception.Message)"
    }
}

if (-not $TweaksOnly) {
    if ($UseWinget) {
        Invoke-ExplorerPatcherWingetInstall
    } else {
        Invoke-ExplorerPatcherGithubInstall
    }
}

if ($ApplyDockTweaks -or $TweaksOnly) {
    Set-DockLikeTaskbarTweaks
}
