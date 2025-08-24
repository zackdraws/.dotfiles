#!/usr/bin/env fish



# Kill Windows Syncthing process from WSL (via PowerShell)

powershell.exe -Command "Stop-Process -Name syncthing -Force -ErrorAction SilentlyContinue"



# Check if it succeeded

set status $status

if test $status -eq 0

    echo "Syncthing stopped successfully."

else

    echo "Failed to stop Syncthing (it may not be running)."

end

