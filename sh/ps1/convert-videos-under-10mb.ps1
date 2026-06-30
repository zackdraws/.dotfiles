#!/usr/bin/env -S powershell.exe -NoProfile -ExecutionPolicy Bypass -File
<#
.SYNOPSIS
Compress every video in a folder to files under a target size.

.DESCRIPTION
Finds video files in a folder, writes compressed MP4 versions into a
10_mb_versions folder inside that folder, and verifies each result is below
the requested size. Requires ffmpeg and ffprobe on PATH.

.EXAMPLE
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sh\ps1\convert-videos-under-10mb.ps1 -Folder "C:\Users\ok\Videos\clips"

.EXAMPLE
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\sh\ps1\convert-videos-under-10mb.ps1 -Folder . -Recurse -Overwrite

.EXAMPLE
./sh/ps1/convert-videos-under-10mb.ps1 -Folder . -Recurse -Overwrite
#>

[CmdletBinding()]
param(
    [string]$Folder = ".",
    [decimal]$TargetMB = 10,
    [string]$OutputFolderName = "10_mb_versions",
    [switch]$Recurse,
    [switch]$Overwrite,
    [int]$MaxHeight = 720,
    [string]$Preset = "medium",
    [string[]]$Extensions = @(
        ".mp4",
        ".mov",
        ".m4v",
        ".mkv",
        ".avi",
        ".wmv",
        ".webm",
        ".flv",
        ".mpeg",
        ".mpg",
        ".3gp"
    )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-OptionalCommand {
    param([string[]]$Names)

    foreach ($name in $Names) {
        $command = Get-Command $name -ErrorAction SilentlyContinue
        if ($command) {
            return $command.Source
        }
    }

    return $null
}

function Get-MsysRoot {
    $cygpath = Get-OptionalCommand -Names @("cygpath.exe", "cygpath")
    if (-not $cygpath) {
        return $null
    }

    $root = & $cygpath -w /
    if ($LASTEXITCODE -ne 0) {
        return $null
    }

    $rootText = ([string]$root).Trim()
    if ([string]::IsNullOrWhiteSpace($rootText)) {
        return $null
    }

    return $rootText
}

function ConvertFrom-MsysPath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $Path
    }

    if ($Path -notmatch '^(~(/|$)|/)') {
        return $Path
    }

    $cygpath = Get-OptionalCommand -Names @("cygpath.exe", "cygpath")
    if (-not $cygpath) {
        return $Path
    }

    $convertedPath = & $cygpath -w -- $Path
    if ($LASTEXITCODE -ne 0) {
        return $Path
    }

    $convertedText = ([string]$convertedPath).Trim()
    if ([string]::IsNullOrWhiteSpace($convertedText)) {
        return $Path
    }

    return $convertedText
}

function Get-RequiredCommand {
    param([string[]]$Names)

    $command = Get-OptionalCommand -Names $Names
    if ($command) {
        return $command
    }

    $msysRoot = Get-MsysRoot
    if ($msysRoot) {
        $prefixes = New-Object System.Collections.Generic.List[string]
        if (-not [string]::IsNullOrWhiteSpace($env:MSYSTEM)) {
            $prefixes.Add($env:MSYSTEM.ToLowerInvariant())
        }

        foreach ($prefix in @("ucrt64", "mingw64", "clang64", "usr")) {
            if (-not $prefixes.Contains($prefix)) {
                $prefixes.Add($prefix)
            }
        }

        foreach ($prefix in $prefixes) {
            if ($prefix -eq "usr") {
                $binDirectory = Join-Path $msysRoot "usr\bin"
            }
            else {
                $binDirectory = Join-Path $msysRoot "$prefix\bin"
            }

            foreach ($name in $Names) {
                $candidate = Join-Path $binDirectory $name
                if (Test-Path -LiteralPath $candidate -PathType Leaf) {
                    return $candidate
                }
            }
        }
    }

    throw "Required command was not found on PATH: $($Names -join ' or ')"
}

function Test-IsInsidePath {
    param(
        [string]$Path,
        [string]$ParentPath
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $fullParent = [IO.Path]::GetFullPath($ParentPath)

    if (-not $fullParent.EndsWith([IO.Path]::DirectorySeparatorChar)) {
        $fullParent += [IO.Path]::DirectorySeparatorChar
    }

    return $fullPath.StartsWith($fullParent, [StringComparison]::OrdinalIgnoreCase)
}

function Get-RelativeDirectory {
    param(
        [string]$BasePath,
        [string]$DirectoryPath
    )

    $fullBase = [IO.Path]::GetFullPath($BasePath).TrimEnd('\', '/')
    $fullDirectory = [IO.Path]::GetFullPath($DirectoryPath).TrimEnd('\', '/')

    if ($fullDirectory.Length -le $fullBase.Length) {
        return ""
    }

    return $fullDirectory.Substring($fullBase.Length).TrimStart('\', '/')
}

function Get-OutputPath {
    param(
        [IO.FileInfo]$InputFile,
        [string]$InputRoot,
        [string]$OutputRoot,
        [bool]$PreserveSubfolders
    )

    $destinationDirectory = $OutputRoot
    if ($PreserveSubfolders) {
        $relativeDirectory = Get-RelativeDirectory -BasePath $InputRoot -DirectoryPath $InputFile.DirectoryName
        if (-not [string]::IsNullOrWhiteSpace($relativeDirectory)) {
            $destinationDirectory = Join-Path $OutputRoot $relativeDirectory
        }
    }

    New-Item -ItemType Directory -Force -Path $destinationDirectory | Out-Null

    $baseName = [IO.Path]::GetFileNameWithoutExtension($InputFile.Name)
    return Join-Path $destinationDirectory "$baseName`_10mb.mp4"
}

function Invoke-CheckedCommand {
    param(
        [string]$CommandPath,
        [string[]]$Arguments,
        [string]$FailureMessage
    )

    & $CommandPath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$FailureMessage Exit code: $LASTEXITCODE"
    }
}

function Get-VideoDurationSeconds {
    param(
        [string]$Ffprobe,
        [string]$Path
    )

    $durationText = & $Ffprobe @(
        "-v",
        "error",
        "-show_entries",
        "format=duration",
        "-of",
        "default=noprint_wrappers=1:nokey=1",
        $Path
    )

    if ($LASTEXITCODE -ne 0) {
        throw "ffprobe could not read duration for: $Path"
    }

    $duration = 0.0
    if (-not [double]::TryParse(
            ([string]$durationText).Trim(),
            [Globalization.NumberStyles]::Float,
            [Globalization.CultureInfo]::InvariantCulture,
            [ref]$duration
        )) {
        throw "Could not parse duration for: $Path"
    }

    if ($duration -le 0) {
        throw "Video duration must be greater than zero: $Path"
    }

    return $duration
}

function Get-SizeLimitedBitrates {
    param(
        [double]$DurationSeconds,
        [decimal]$TargetMegabytes,
        [int]$Attempt
    )

    $targetBytes = [math]::Floor([double]$TargetMegabytes * 1024 * 1024 * 0.94)
    $totalKbps = [math]::Floor(($targetBytes * 8) / $DurationSeconds / 1000)

    if ($Attempt -gt 1) {
        $totalKbps = [math]::Floor($totalKbps * [math]::Pow(0.86, $Attempt - 1))
    }

    if ($totalKbps -ge 450) {
        $audioKbps = 64
    }
    elseif ($totalKbps -ge 240) {
        $audioKbps = 48
    }
    elseif ($totalKbps -ge 150) {
        $audioKbps = 32
    }
    else {
        $audioKbps = 0
    }

    $videoKbps = [math]::Max(24, $totalKbps - $audioKbps)

    [pscustomobject]@{
        TotalKbps = [int]$totalKbps
        VideoKbps = [int]$videoKbps
        AudioKbps = [int]$audioKbps
    }
}

function Get-ScaleFilter {
    param(
        [int]$VideoKbps,
        [int]$RequestedMaxHeight
    )

    if ($VideoKbps -lt 250) {
        $height = [math]::Min($RequestedMaxHeight, 240)
        $width = 426
    }
    elseif ($VideoKbps -lt 450) {
        $height = [math]::Min($RequestedMaxHeight, 360)
        $width = 640
    }
    elseif ($VideoKbps -lt 900) {
        $height = [math]::Min($RequestedMaxHeight, 480)
        $width = 854
    }
    else {
        $height = $RequestedMaxHeight
        $width = 1280
    }

    return "scale=w=min(iw\,$width):h=min(ih\,$height):force_original_aspect_ratio=decrease:force_divisible_by=2"
}

function Convert-VideoUnderTarget {
    param(
        [string]$Ffmpeg,
        [IO.FileInfo]$InputFile,
        [string]$OutputPath,
        [decimal]$TargetMegabytes,
        [int]$RequestedMaxHeight,
        [string]$EncodingPreset
    )

    $duration = Get-VideoDurationSeconds -Ffprobe $script:FfprobePath -Path $InputFile.FullName
    $maxBytes = [math]::Floor([double]$TargetMegabytes * 1024 * 1024)
    $attempt = 1

    while ($attempt -le 4) {
        $rates = Get-SizeLimitedBitrates -DurationSeconds $duration -TargetMegabytes $TargetMegabytes -Attempt $attempt
        $scaleFilter = Get-ScaleFilter -VideoKbps $rates.VideoKbps -RequestedMaxHeight $RequestedMaxHeight
        $passDirectory = Join-Path ([IO.Path]::GetTempPath()) ("ffmpeg-10mb-" + [guid]::NewGuid().ToString("N"))
        New-Item -ItemType Directory -Force -Path $passDirectory | Out-Null
        $passLog = Join-Path $passDirectory "pass"
        $nullOutput = if ($env:OS -eq "Windows_NT") { "NUL" } else { "/dev/null" }

        Write-Host ("  attempt {0}: video {1}k, audio {2}k" -f $attempt, $rates.VideoKbps, $rates.AudioKbps)

        $passOneArguments = @(
            "-hide_banner",
            "-loglevel",
            "warning",
            "-y",
            "-i",
            $InputFile.FullName,
            "-map",
            "0:v:0",
            "-c:v",
            "libx264",
            "-preset",
            $EncodingPreset,
            "-b:v",
            "$($rates.VideoKbps)k",
            "-vf",
            $scaleFilter,
            "-pix_fmt",
            "yuv420p",
            "-pass",
            "1",
            "-passlogfile",
            $passLog,
            "-an",
            "-f",
            "null",
            $nullOutput
        )

        $passTwoArguments = @(
            "-hide_banner",
            "-loglevel",
            "warning",
            "-y",
            "-i",
            $InputFile.FullName,
            "-map",
            "0:v:0",
            "-map",
            "0:a?",
            "-c:v",
            "libx264",
            "-preset",
            $EncodingPreset,
            "-b:v",
            "$($rates.VideoKbps)k",
            "-vf",
            $scaleFilter,
            "-pix_fmt",
            "yuv420p",
            "-pass",
            "2",
            "-passlogfile",
            $passLog,
            "-movflags",
            "+faststart"
        )

        if ($rates.AudioKbps -gt 0) {
            $passTwoArguments += @(
                "-c:a",
                "aac",
                "-b:a",
                "$($rates.AudioKbps)k",
                "-ac",
                "2"
            )
        }
        else {
            $passTwoArguments += "-an"
        }

        $passTwoArguments += $OutputPath

        try {
            Invoke-CheckedCommand -CommandPath $Ffmpeg -Arguments $passOneArguments -FailureMessage "ffmpeg first pass failed for: $($InputFile.FullName)"
            Invoke-CheckedCommand -CommandPath $Ffmpeg -Arguments $passTwoArguments -FailureMessage "ffmpeg second pass failed for: $($InputFile.FullName)"
        }
        finally {
            Remove-Item -LiteralPath $passDirectory -Recurse -Force -ErrorAction SilentlyContinue
        }

        $outputSize = (Get-Item -LiteralPath $OutputPath).Length
        if ($outputSize -le $maxBytes) {
            return [pscustomobject]@{
                Path = $OutputPath
                SizeBytes = $outputSize
                Attempts = $attempt
                VideoKbps = $rates.VideoKbps
                AudioKbps = $rates.AudioKbps
            }
        }

        Write-Warning ("  output was {0:N2} MB, retrying lower" -f ($outputSize / 1MB))
        $attempt++
    }

    throw "Could not compress under $TargetMegabytes MB after 4 attempts: $($InputFile.FullName)"
}

$resolvedFolder = ConvertFrom-MsysPath -Path $Folder
$folderItem = Get-Item -LiteralPath $resolvedFolder
if (-not $folderItem.PSIsContainer) {
    throw "Folder is not a directory: $Folder"
}

if ($TargetMB -le 0) {
    throw "TargetMB must be greater than zero."
}

if ($MaxHeight -lt 120) {
    throw "MaxHeight must be at least 120."
}

$script:FfprobePath = Get-RequiredCommand -Names @("ffprobe.exe", "ffprobe")
$ffmpegPath = Get-RequiredCommand -Names @("ffmpeg.exe", "ffmpeg")
$inputRoot = $folderItem.FullName
$outputRoot = Join-Path $inputRoot $OutputFolderName
$normalizedExtensions = @($Extensions | ForEach-Object { $_.ToLowerInvariant() })

New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null

$candidateFiles = if ($Recurse) {
    Get-ChildItem -LiteralPath $inputRoot -File -Recurse
}
else {
    Get-ChildItem -LiteralPath $inputRoot -File
}

$videoFiles = @(
    $candidateFiles |
        Where-Object {
            $normalizedExtensions -contains $_.Extension.ToLowerInvariant() -and
            -not (Test-IsInsidePath -Path $_.FullName -ParentPath $outputRoot)
        } |
        Sort-Object FullName
)

if ($videoFiles.Count -lt 1) {
    Write-Host "No video files found in: $inputRoot"
    exit 0
}

Write-Host "Input:  $inputRoot"
Write-Host "Output: $outputRoot"
Write-Host "Target: $TargetMB MB"
Write-Host "Videos: $($videoFiles.Count)"

$completed = 0
$skipped = 0
$failed = 0

foreach ($file in $videoFiles) {
    $outputPath = Get-OutputPath -InputFile $file -InputRoot $inputRoot -OutputRoot $outputRoot -PreserveSubfolders ([bool]$Recurse)
    $relativeName = Get-RelativeDirectory -BasePath $inputRoot -DirectoryPath $file.DirectoryName
    if ([string]::IsNullOrWhiteSpace($relativeName)) {
        $displayName = $file.Name
    }
    else {
        $displayName = Join-Path $relativeName $file.Name
    }

    if ((Test-Path -LiteralPath $outputPath) -and -not $Overwrite) {
        Write-Host "Skipping existing: $outputPath"
        $skipped++
        continue
    }

    Write-Host ""
    Write-Host "Converting: $displayName"

    try {
        $result = Convert-VideoUnderTarget `
            -Ffmpeg $ffmpegPath `
            -InputFile $file `
            -OutputPath $outputPath `
            -TargetMegabytes $TargetMB `
            -RequestedMaxHeight $MaxHeight `
            -EncodingPreset $Preset

        Write-Host ("  saved: {0} ({1:N2} MB)" -f $result.Path, ($result.SizeBytes / 1MB))
        $completed++
    }
    catch {
        $failed++
        Write-Warning $_.Exception.Message
    }
}

Write-Host ""
Write-Host "Done. Converted: $completed, skipped: $skipped, failed: $failed"

if ($failed -gt 0) {
    exit 1
}
