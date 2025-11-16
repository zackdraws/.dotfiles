# Check if Scoop is installed, if not, install Scoop
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop is not installed. Installing Scoop..."
    # Install Scoop
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iex (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    Start-Sleep -Seconds 5
}

$software = @(
    "jellyfin",        # jellyfin
    "obsidian",        # Obsidian
    "syncthing",       # SyncThing
    "ffmpeg",          # FFmpeg
    "mpv",             # mpv
    "7zip",            # 7-Zip
    "vscode",          # VSCode
    "git",             # Git
    "teams",           # Microsoft Teams
    "curl",            # cURL (handy command line tool)
    "jq",              # jq (command-line JSON processor)
    "nodejs",          # Node.js
    "python",          # Python
    "java",            # Java Development Kit
    "visualstudio",    # Visual Studio (for development)
    "wget",            # Wget (for downloading files via HTTP/HTTPS)
    "grep",            # GNU Grep (for pattern searching)
    "htop",            # htop (for process monitoring)
    "vcredist",        # Visual C++ Redistributables
    "zoom",            # Zoom (for video conferencing)
    "chromium",        # Chromium (open-source browser)
    "slack",           # Slack (for team communication)
    "discord",         # Discord (for chat and communities)
    "obs-studio",      # OBS Studio (for video recording/streaming)
    "fzf",             # fzf (Fuzzy Finder for the terminal)
    "yazi",            # yazi (Fuzzy file opener)
    "broot",           # broot (Modern file explorer)
    "sumatrapdf"       # SumatraPDF (open-source PDF viewer)
)
foreach ($app in $software) {
    try {
        Write-Host "Installing $app..."
        scoop install $app
        Start-Sleep -Seconds 5
    } catch {
        Write-Host "Failed to install $app"
    }
}
Write-Host "Installation completed. Please check each application to ensure successful installation."

#use this to install files in powershell