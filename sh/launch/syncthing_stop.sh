powershell.exe -Command "Stop-Process -Name syncthing -Force -ErrorAction SilentlyContinue"




set status $status

if test $status -eq 0

    echo "Syncthing stopped successfully."

else

    echo "Failed to stop Syncthing (it may not be running)."

end

