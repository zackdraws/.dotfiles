[CmdletBinding()]
param(
    [int]$Framerate = 30,
    [string]$OutputDirectory = "",
    [switch]$Start,
    [switch]$Stop,
    [switch]$Status,
    [switch]$Worker,
    [string]$OutputPath = "",
    [int]$Workspace = 1,
    [int]$WorkspaceSwitchDelayMilliseconds = 600,
    [int]$ScreenIndex = -1,
    [switch]$CaptureVirtualDesktop,
    [string]$AudioDevice = $env:SCREEN_RECORD_AUDIO_DEVICE,
    [switch]$NoAudio,
    [switch]$ListAudioDevices
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$stateDirectory = Join-Path ([IO.Path]::GetTempPath()) "ok-ffmpeg-screen-record"
$statePath = Join-Path $stateDirectory "state.json"
$stopPath = Join-Path $stateDirectory "stop.signal"

function Get-VideoFolder {
    $videos = [Environment]::GetFolderPath("MyVideos")
    if ([string]::IsNullOrWhiteSpace($videos)) {
        $videos = Join-Path $HOME "Videos"
    }

    return $videos
}

function Get-PowerShellExecutable {
    $current = Get-Process -Id $PID -ErrorAction SilentlyContinue
    if ($current -and -not [string]::IsNullOrWhiteSpace($current.Path)) {
        return $current.Path
    }

    $pwsh = Get-Command pwsh.exe -ErrorAction SilentlyContinue
    if ($pwsh) {
        return $pwsh.Source
    }

    $powershell = Get-Command powershell.exe -ErrorAction SilentlyContinue
    if ($powershell) {
        return $powershell.Source
    }

    throw "PowerShell executable was not found."
}

function Get-Ffmpeg {
    $ffmpeg = Get-Command ffmpeg.exe -ErrorAction SilentlyContinue
    if (-not $ffmpeg) {
        $ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
    }

    if (-not $ffmpeg) {
        $ffmpegCandidates = @(
            "C:\msys64\ucrt64\bin\ffmpeg.exe",
            "C:\msys64\mingw64\bin\ffmpeg.exe",
            "C:\msys64\usr\bin\ffmpeg.exe"
        )

        $ffmpegPath = $ffmpegCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
        if ($ffmpegPath) {
            return $ffmpegPath
        }
    }

    if (-not $ffmpeg) {
        throw "ffmpeg was not found on PATH. Install ffmpeg before using the screen recorder shortcut."
    }

    return $ffmpeg.Source
}

function Get-Komorebic {
    $configuredPath = Join-Path $env:ProgramFiles "komorebi\bin\komorebic.exe"
    if (Test-Path -LiteralPath $configuredPath) {
        return $configuredPath
    }

    $komorebic = Get-Command komorebic.exe -ErrorAction SilentlyContinue
    if ($komorebic) {
        return $komorebic.Source
    }

    return $null
}

function Select-KomorebiWorkspace {
    param([int]$WorkspaceNumber)

    if ($WorkspaceNumber -lt 1) {
        return
    }

    $komorebic = Get-Komorebic
    if (-not $komorebic) {
        Write-Warning "komorebic.exe was not found; continuing without switching workspace."
        return
    }

    $workspaceIndex = $WorkspaceNumber - 1
    & $komorebic focus-workspaces $workspaceIndex
}

function Test-ProcessRunning {
    param([Nullable[int]]$Id)

    if (-not $Id) {
        return $false
    }

    return [bool](Get-Process -Id $Id -ErrorAction SilentlyContinue)
}

function Read-State {
    if (-not (Test-Path -LiteralPath $statePath)) {
        return $null
    }

    try {
        return Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    }
    catch {
        Remove-Item -LiteralPath $statePath -Force -ErrorAction SilentlyContinue
        return $null
    }
}

function Clear-State {
    Remove-Item -LiteralPath $stopPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $statePath -Force -ErrorAction SilentlyContinue
}

function Write-State {
    param([object]$State)

    New-Item -ItemType Directory -Force -Path $stateDirectory | Out-Null
    $State | ConvertTo-Json | Set-Content -LiteralPath $statePath -Encoding UTF8
}

function Quote-NativeArgument {
    param([string]$Argument)

    if ($null -eq $Argument -or $Argument.Length -eq 0) {
        return '""'
    }

    if ($Argument -notmatch '[\s"]') {
        return $Argument
    }

    $quoted = '"'
    $backslashes = 0

    foreach ($char in $Argument.ToCharArray()) {
        if ($char -eq '\') {
            $backslashes++
            continue
        }

        if ($char -eq '"') {
            $quoted += ('\' * (($backslashes * 2) + 1))
            $quoted += '"'
            $backslashes = 0
            continue
        }

        if ($backslashes -gt 0) {
            $quoted += ('\' * $backslashes)
            $backslashes = 0
        }

        $quoted += $char
    }

    if ($backslashes -gt 0) {
        $quoted += ('\' * ($backslashes * 2))
    }

    $quoted += '"'
    return $quoted
}

function Join-NativeArguments {
    param([string[]]$Arguments)

    return ($Arguments | ForEach-Object { Quote-NativeArgument $_ }) -join " "
}

function Get-DirectShowAudioDevices {
    param([string]$Ffmpeg)

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $Ffmpeg
    $startInfo.Arguments = Join-NativeArguments @("-hide_banner", "-f", "dshow", "-list_devices", "true", "-i", "dummy")
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardError = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo

    try {
        [void]$process.Start()
        $stderr = $process.StandardError.ReadToEnd()
        $stdout = $process.StandardOutput.ReadToEnd()
        if (-not $process.WaitForExit(10000)) {
            $process.Kill()
            [void]$process.WaitForExit(5000)
        }
    }
    finally {
        $process.Dispose()
    }

    $output = @($stderr -split "`r?`n") + @($stdout -split "`r?`n")
    $devices = New-Object System.Collections.Generic.List[string]

    foreach ($line in $output) {
        if ($line -match '^\[.*?\]\s+"(.+)"\s+\(audio\)\s*$') {
            $devices.Add($Matches[1])
        }
    }

    return @($devices)
}

function Resolve-DirectShowAudioDevice {
    param(
        [string]$Ffmpeg,
        [string]$RequestedDevice,
        [bool]$Disabled
    )

    if ($Disabled) {
        return ""
    }

    $devices = @(Get-DirectShowAudioDevices -Ffmpeg $Ffmpeg)

    if (-not [string]::IsNullOrWhiteSpace($RequestedDevice)) {
        $requestedMatch = $devices | Where-Object { $_ -ieq $RequestedDevice } | Select-Object -First 1
        if ($requestedMatch) {
            return $requestedMatch
        }

        $requestedContainsMatch = $devices | Where-Object { $_ -like "*$RequestedDevice*" } | Select-Object -First 1
        if ($requestedContainsMatch) {
            return $requestedContainsMatch
        }

        if ($devices.Count -lt 1) {
            Show-RecordingNotice -Title "Screen recording without audio" -Message "Audio device '$RequestedDevice' was not found; recording video only."
            Write-Warning "Audio device '$RequestedDevice' was not found; recording video only."
            return ""
        }
    }

    $preferred = $devices |
        Where-Object { $_ -match '(?i)(stereo mix|what u hear|virtual-audio-capturer|cable output|vb-audio|voicemeeter|loopback|monitor)' } |
        Select-Object -First 1

    if ($preferred) {
        if (-not [string]::IsNullOrWhiteSpace($RequestedDevice)) {
            Show-RecordingNotice -Title "Screen recording audio fallback" -Message "Audio device '$RequestedDevice' was not found; using '$preferred'."
            Write-Warning "Audio device '$RequestedDevice' was not found; using '$preferred'."
        }

        return $preferred
    }

    if ($devices.Count -lt 1) {
        $message = "No FFmpeg DirectShow audio input was found; recording video only."
        Show-RecordingNotice -Title "Screen recording without audio" -Message $message
        Write-Warning $message

        return ""
    }

    if (-not [string]::IsNullOrWhiteSpace($RequestedDevice)) {
        Show-RecordingNotice -Title "Screen recording audio fallback" -Message "Audio device '$RequestedDevice' was not found; using '$($devices[0])'."
        Write-Warning "Audio device '$RequestedDevice' was not found; using '$($devices[0])'."
    }

    return $devices[0]
}

function Get-CaptureBounds {
    Add-Type -AssemblyName System.Windows.Forms

    if ($CaptureVirtualDesktop) {
        $bounds = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $name = "virtual desktop"
    } else {
        $screens = @([System.Windows.Forms.Screen]::AllScreens)
        if ($screens.Count -lt 1) {
            throw "No screens were found for recording."
        }

        if ($ScreenIndex -ge 0) {
            if ($ScreenIndex -ge $screens.Count) {
                throw "ScreenIndex $ScreenIndex was requested, but only $($screens.Count) screen(s) were found."
            }

            $screen = $screens[$ScreenIndex]
        } else {
            $screen = $screens | Where-Object { $_.Primary } | Select-Object -First 1
            if (-not $screen) {
                $screen = $screens[0]
            }
        }

        $bounds = $screen.Bounds
        $name = $screen.DeviceName
    }

    $width = [int]$bounds.Width
    $height = [int]$bounds.Height

    if (($width % 2) -ne 0) {
        $width -= 1
    }

    if (($height % 2) -ne 0) {
        $height -= 1
    }

    [pscustomobject]@{
        X = [int]$bounds.X
        Y = [int]$bounds.Y
        Width = $width
        Height = $height
        VideoSize = "{0}x{1}" -f $width, $height
        Name = $name
    }
}

function Show-RecordingNotice {
    param(
        [string]$Title,
        [string]$Message
    )

    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        Add-Type -AssemblyName System.Drawing -ErrorAction Stop

        $notice = New-Object System.Windows.Forms.NotifyIcon
        $notice.Icon = [System.Drawing.SystemIcons]::Information
        $notice.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
        $notice.BalloonTipTitle = $Title
        $notice.BalloonTipText = $Message
        $notice.Visible = $true
        $notice.ShowBalloonTip(2500)
        Start-Sleep -Milliseconds 500
        $notice.Dispose()
    }
    catch {
        # Notifications are best-effort; terminal output still shows the state.
    }
}

function Get-RecordingOutputPath {
    param([string]$Directory)

    $startedAt = Get-Date
    $timestamp = $startedAt.ToString("yyyy-MM-dd_HH-mm-ss", [Globalization.CultureInfo]::InvariantCulture)
    return Join-Path $Directory "screen-recording_$timestamp.mp4"
}

function Get-ActiveState {
    $state = Read-State
    if (-not $state) {
        return $null
    }

    $workerRunning = $false
    $ffmpegRunning = $false

    if ($state.PSObject.Properties.Name -contains "WorkerPid") {
        $workerRunning = Test-ProcessRunning ([int]$state.WorkerPid)
    }

    if ($state.PSObject.Properties.Name -contains "FfmpegPid") {
        $ffmpegRunning = Test-ProcessRunning ([int]$state.FfmpegPid)
    }

    if ($workerRunning -or $ffmpegRunning) {
        return $state
    }

    Clear-State
    return $null
}

function Start-Recording {
    $active = Get-ActiveState
    if ($active) {
        Write-Host "Already recording: $($active.OutputPath)"
        return
    }

    if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
        $OutputDirectory = Get-VideoFolder
    }

    Select-KomorebiWorkspace -WorkspaceNumber $Workspace
    if ($Workspace -gt 0 -and $WorkspaceSwitchDelayMilliseconds -gt 0) {
        Start-Sleep -Milliseconds $WorkspaceSwitchDelayMilliseconds
    }
    $ffmpeg = Get-Ffmpeg
    $resolvedAudioDevice = Resolve-DirectShowAudioDevice -Ffmpeg $ffmpeg -RequestedDevice $AudioDevice -Disabled ([bool]$NoAudio)
    New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
    New-Item -ItemType Directory -Force -Path $stateDirectory | Out-Null
    Remove-Item -LiteralPath $stopPath -Force -ErrorAction SilentlyContinue

    $recordingPath = Get-RecordingOutputPath -Directory $OutputDirectory
    $powershell = Get-PowerShellExecutable
    $arguments = @(
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        $PSCommandPath,
        "-Worker",
        "-Framerate",
        [string]$Framerate,
        "-OutputDirectory",
        $OutputDirectory,
        "-OutputPath",
        $recordingPath,
        "-ScreenIndex",
        [string]$ScreenIndex
    )

    if ($CaptureVirtualDesktop) {
        $arguments += "-CaptureVirtualDesktop"
    }

    if (-not [string]::IsNullOrWhiteSpace($resolvedAudioDevice)) {
        $arguments += @("-AudioDevice", $resolvedAudioDevice)
    }

    if ($NoAudio) {
        $arguments += "-NoAudio"
    }

    $workerProcess = Start-Process -FilePath $powershell -ArgumentList (Join-NativeArguments $arguments) -WindowStyle Hidden -PassThru
    Write-State ([pscustomobject]@{
            WorkerPid = $workerProcess.Id
            FfmpegPid = $null
            OutputPath = $recordingPath
            AudioDevice = $resolvedAudioDevice
            StartedAt = (Get-Date).ToString("o", [Globalization.CultureInfo]::InvariantCulture)
        })

    Write-Host "Recording started: $recordingPath"
    if (-not [string]::IsNullOrWhiteSpace($resolvedAudioDevice)) {
        Write-Host "Recording audio from: $resolvedAudioDevice"
    }
    Write-Host "Run this script again to stop and save."
    Show-RecordingNotice -Title "Screen recording started" -Message $recordingPath
}

function Stop-Recording {
    $active = Get-ActiveState
    if (-not $active) {
        Write-Host "No active screen recording."
        return
    }

    New-Item -ItemType Directory -Force -Path $stateDirectory | Out-Null
    Set-Content -LiteralPath $stopPath -Value "stop" -Encoding ASCII

    if ($active.PSObject.Properties.Name -contains "WorkerPid") {
        $worker = Get-Process -Id ([int]$active.WorkerPid) -ErrorAction SilentlyContinue
        if ($worker) {
            [void]$worker.WaitForExit(15000)
        }
    }

    $stillActive = Get-ActiveState
    if ($stillActive) {
        Write-Warning "Stop was requested, but ffmpeg is still running. Run again in a few seconds or close ffmpeg manually."
        return
    }

    $savedPath = $active.OutputPath
    Write-Host "Recording stopped: $savedPath"
    Show-RecordingNotice -Title "Screen recording saved" -Message $savedPath
}

function Show-Status {
    $active = Get-ActiveState
    if ($active) {
        Write-Host "Recording: $($active.OutputPath)"
        if ($active.PSObject.Properties.Name -contains "AudioDevice" -and -not [string]::IsNullOrWhiteSpace($active.AudioDevice)) {
            Write-Host "Audio: $($active.AudioDevice)"
        }
        return
    }

    Write-Host "Not recording."
}

function Start-Worker {
    if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
        $OutputDirectory = Get-VideoFolder
    }

    if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        $OutputPath = Get-RecordingOutputPath -Directory $OutputDirectory
    }

    New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
    New-Item -ItemType Directory -Force -Path $stateDirectory | Out-Null

    $startedAt = Get-Date
    $creationTime = $startedAt.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ", [Globalization.CultureInfo]::InvariantCulture)
    $ffmpeg = Get-Ffmpeg
    $captureBounds = Get-CaptureBounds
    $resolvedAudioDevice = Resolve-DirectShowAudioDevice -Ffmpeg $ffmpeg -RequestedDevice $AudioDevice -Disabled ([bool]$NoAudio)
    $ffmpegInputArguments = @(
        "-hide_banner",
        "-y",
        "-thread_queue_size",
        "1024",
        "-f",
        "gdigrab",
        "-framerate",
        [string]$Framerate,
        "-offset_x",
        [string]$captureBounds.X,
        "-offset_y",
        [string]$captureBounds.Y,
        "-video_size",
        $captureBounds.VideoSize,
        "-i",
        "desktop"
    )

    $mapArguments = @("-map", "0:v:0")
    $audioArguments = @("-an")

    if (-not [string]::IsNullOrWhiteSpace($resolvedAudioDevice)) {
        $ffmpegInputArguments += @(
            "-thread_queue_size",
            "1024",
            "-f",
            "dshow",
            "-audio_buffer_size",
            "100",
            "-i",
            "audio=$resolvedAudioDevice"
        )
        $mapArguments = @("-map", "0:v:0", "-map", "1:a:0")
        $audioArguments = @(
            "-c:a",
            "aac",
            "-b:a",
            "160k",
            "-ar",
            "48000"
        )
    }

    $ffmpegOutputArguments = @()
    $ffmpegOutputArguments += $mapArguments
    $ffmpegOutputArguments += @(
        "-c:v",
        "libx264",
        "-preset",
        "veryfast",
        "-pix_fmt",
        "yuv420p",
        "-movflags",
        "+faststart",
        "-metadata",
        "creation_time=$creationTime"
    )
    $ffmpegOutputArguments += $audioArguments
    $ffmpegOutputArguments += $OutputPath
    $ffmpegArguments = Join-NativeArguments @($ffmpegInputArguments + $ffmpegOutputArguments)

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $ffmpeg
    $startInfo.Arguments = $ffmpegArguments
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardInput = $true
    $startInfo.CreateNoWindow = $true

    $ffmpegProcess = New-Object System.Diagnostics.Process
    $ffmpegProcess.StartInfo = $startInfo

    try {
        [void]$ffmpegProcess.Start()
        Write-State ([pscustomobject]@{
                WorkerPid = $PID
                FfmpegPid = $ffmpegProcess.Id
                OutputPath = $OutputPath
                AudioDevice = $resolvedAudioDevice
                StartedAt = $startedAt.ToString("o", [Globalization.CultureInfo]::InvariantCulture)
            })

        while (-not $ffmpegProcess.HasExited) {
            if (Test-Path -LiteralPath $stopPath) {
                try {
                    $ffmpegProcess.StandardInput.WriteLine("q")
                    $ffmpegProcess.StandardInput.Flush()
                }
                catch {
                }

                if (-not $ffmpegProcess.WaitForExit(10000)) {
                    $ffmpegProcess.Kill()
                    [void]$ffmpegProcess.WaitForExit(5000)
                }

                break
            }

            Start-Sleep -Milliseconds 250
        }

        if ($ffmpegProcess.HasExited -and $ffmpegProcess.ExitCode -ne 0) {
            exit $ffmpegProcess.ExitCode
        }
    }
    finally {
        Clear-State
        if ($ffmpegProcess) {
            $ffmpegProcess.Dispose()
        }
    }
}

if ($Worker) {
    Start-Worker
    exit
}

if ($ListAudioDevices) {
    $ffmpeg = Get-Ffmpeg
    $devices = @(Get-DirectShowAudioDevices -Ffmpeg $ffmpeg)
    if ($devices.Count -lt 1) {
        Write-Host "No DirectShow audio devices found."
    } else {
        $devices | ForEach-Object { Write-Host $_ }
    }
    exit
}

if ($Status) {
    Show-Status
    exit
}

if ($Stop) {
    Stop-Recording
    exit
}

if ($Start) {
    Start-Recording
    exit
}

$activeRecording = Get-ActiveState
if ($activeRecording) {
    Stop-Recording
}
else {
    Start-Recording
}
