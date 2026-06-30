[CmdletBinding()]
param(
    [string]$ShimDir = (Join-Path $env:USERPROFILE ".local\bin"),
    [switch]$IncludeMaintenance,
    [switch]$DryRun,
    [switch]$Force,
    [switch]$AddToUserPath
)

$ErrorActionPreference = "Stop"

$setupDir = $PSScriptRoot
$dotfilesRoot = (Resolve-Path -LiteralPath (Join-Path $setupDir "..\..")).ProviderPath
$runner = Join-Path $setupDir "run-msys-script.ps1"

$scriptRoots = @(
    "sh\convert",
    "sh\copy",
    "sh\delete",
    "sh\document",
    "sh\export",
    "sh\file",
    "sh\format",
    "sh\launch",
    "sh\make",
    "sh\maketiny",
    "sh\move",
    "sh\plan",
    "sh\psd",
    "sh\rename",
    "sh\run",
    "sh\shell_files",
    "sh\web"
)

$maintenanceRoots = @(
    "sh\fix",
    "sh\install",
    "sh\setup"
)

$skipPrefixes = @(
    "sh\trash",
    "sh\ps1",
    "sh\fix\debloat-pc",
    "sh\fix\fix.sh",
    "sh\fix\list.sh"
)

$windowsSkipPrefixes = @(
    "sh\fix\arch-audio",
    "sh\fix\arch-rm-pacman-cache",
    "sh\fix\fix-mount.sh",
    "sh\fix\hard-drive",
    "sh\fix\permanent-drive",
    "sh\fix\set-default-imv",
    "sh\fix\set-default-pdf-to-open",
    "sh\fix\set-default-sioyek",
    "sh\fix\set-default-sioyek-mime",
    "sh\fix\shutdown-reset-suspend-arch.sh",
    "sh\fix\wifi-restart",
    "sh\launch\ghostty-launcher.sh",
    "sh\run\record.sh"
)

$aliases = @{
    "sh\document\ffmpeg-record" = "ffmpeg-record-gdigrab"
    "sh\shell_files\jfif_jpeg.sh" = "shell_jfif_jpeg.sh"
}

$replacements = @(
    @{ Old = "sh\convert\untar.sh"; New = "sh\PC\untar.sh"; Command = "untar.sh" },
    @{ Old = "sh\move\FI_^.sh"; New = "sh\PC\FI_^"; Command = "FI_^.sh" }
)

function Normalize-RelativePath {
    param([Parameter(Mandatory = $true)][string]$Path)
    return ($Path -replace "/", "\").TrimStart(".\")
}

function Test-UnderPrefix {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string[]]$Prefixes
    )

    $normalized = Normalize-RelativePath $Path
    foreach ($prefix in $Prefixes) {
        $normalizedPrefix = (Normalize-RelativePath $prefix).TrimEnd("\")
        if ($normalized -eq $normalizedPrefix -or $normalized.StartsWith("$normalizedPrefix\")) {
            return $true
        }
    }

    return $false
}

function Test-CandidateScript {
    param([Parameter(Mandatory = $true)][string]$Path)

    $name = [System.IO.Path]::GetFileName($Path)
    if ($name.StartsWith(".") -or $name.EndsWith("~") -or ($name.StartsWith("#") -and $name.EndsWith("#"))) {
        return $false
    }

    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()
    if ($extension -in @(".sh", ".bash", ".fish")) {
        return $true
    }

    if ($extension -eq ".py") {
        $firstLine = Get-Content -LiteralPath $Path -TotalCount 1 -ErrorAction SilentlyContinue
        return ($firstLine -like "#!*")
    }

    return [string]::IsNullOrEmpty($extension)
}

function Get-CommandName {
    param([Parameter(Mandatory = $true)][string]$RelativePath)

    $normalized = Normalize-RelativePath $RelativePath
    if ($aliases.ContainsKey($normalized)) {
        return $aliases[$normalized]
    }

    return [System.IO.Path]::GetFileName($normalized)
}

$entries = [ordered]@{}

function Add-Entry {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [string]$CommandName
    )

    $relative = Normalize-RelativePath $RelativePath
    $absolute = Join-Path $dotfilesRoot $relative

    if (-not (Test-Path -LiteralPath $absolute -PathType Leaf)) {
        return
    }

    if (-not (Test-CandidateScript $absolute)) {
        return
    }

    if ((Test-UnderPrefix $relative $skipPrefixes) -or (Test-UnderPrefix $relative $windowsSkipPrefixes)) {
        return
    }

    if (-not $CommandName) {
        $CommandName = Get-CommandName $relative
    }

    if ($entries.Contains($CommandName)) {
        Write-Warning "Skipping duplicate command '$CommandName': $relative already maps to $($entries[$CommandName])"
        return
    }

    $entries[$CommandName] = $relative
}

function Add-Root {
    param([Parameter(Mandatory = $true)][string]$RelativeRoot)

    $root = Join-Path $dotfilesRoot $RelativeRoot
    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        return
    }

    Get-ChildItem -LiteralPath $root -Recurse -File |
        Sort-Object FullName |
        ForEach-Object {
            $relative = $_.FullName.Substring($dotfilesRoot.Length).TrimStart("\")
            Add-Entry $relative
        }
}

foreach ($root in $scriptRoots) {
    Add-Root $root
}

if ($IncludeMaintenance) {
    foreach ($root in $maintenanceRoots) {
        Add-Root $root
    }
}

foreach ($replacement in $replacements) {
    $oldCommand = Get-CommandName $replacement.Old
    if ($entries.Contains($oldCommand)) {
        $entries.Remove($oldCommand)
    }

    Add-Entry -RelativePath $replacement.New -CommandName $replacement.Command
}

function Get-ShimNames {
    param([Parameter(Mandatory = $true)][string]$CommandName)

    $names = New-Object System.Collections.Generic.List[string]
    $withoutScriptExtension = $CommandName -replace "\.(sh|bash|fish|py)$", ""
    $names.Add("$withoutScriptExtension.cmd")

    if ($withoutScriptExtension -ne $CommandName) {
        $names.Add("$CommandName.cmd")
    }

    return $names
}

function Write-Shim {
    param(
        [Parameter(Mandatory = $true)][string]$ShimPath,
        [Parameter(Mandatory = $true)][string]$SourcePath
    )

    if ((Test-Path -LiteralPath $ShimPath) -and -not $Force) {
        Write-Host "Skipping existing shim: $ShimPath"
        return
    }

    $content = @"
@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$runner" "$SourcePath" %*
exit /b %ERRORLEVEL%
"@

    if ($DryRun) {
        Write-Host "shim $ShimPath -> $SourcePath"
        return
    }

    Set-Content -LiteralPath $ShimPath -Value $content -Encoding ASCII
}

function Write-PowerShellShim {
    param(
        [Parameter(Mandatory = $true)][string]$ShimPath,
        [Parameter(Mandatory = $true)][string]$SourcePath
    )

    if ((Test-Path -LiteralPath $ShimPath) -and -not $Force) {
        Write-Host "Skipping existing shim: $ShimPath"
        return
    }

    $content = @"
@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$SourcePath" %*
exit /b %ERRORLEVEL%
"@

    if ($DryRun) {
        Write-Host "powershell shim $ShimPath -> $SourcePath"
        return
    }

    Set-Content -LiteralPath $ShimPath -Value $content -Encoding ASCII
}

if (-not $DryRun) {
    New-Item -ItemType Directory -Force -Path $ShimDir | Out-Null
}

$created = 0
foreach ($commandName in $entries.Keys) {
    $sourcePath = Join-Path $dotfilesRoot $entries[$commandName]
    foreach ($shimName in (Get-ShimNames $commandName)) {
        Write-Shim -ShimPath (Join-Path $ShimDir $shimName) -SourcePath $sourcePath
        $created++
    }
}

$ps1Root = Join-Path $dotfilesRoot "sh\ps1"
if (Test-Path -LiteralPath $ps1Root -PathType Container) {
    Get-ChildItem -LiteralPath $ps1Root -Filter "*.ps1" -File |
        Sort-Object FullName |
        ForEach-Object {
            $shimName = "$($_.BaseName).cmd"
            Write-PowerShellShim -ShimPath (Join-Path $ShimDir $shimName) -SourcePath $_.FullName
            $script:created++
        }
}

if ($AddToUserPath -and -not $DryRun) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $parts = @()
    if ($userPath) {
        $parts = $userPath -split ";" | Where-Object { $_ }
    }

    if ($parts -notcontains $ShimDir) {
        $newPath = (($parts + $ShimDir) -join ";")
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-Host "Added to user PATH: $ShimDir"
    }
}

Write-Host "Done. Windows shim dir: $ShimDir"
Write-Host "Shim files considered: $created"
Write-Host "Open a new terminal after PATH changes."
