
# Fish Shell-like Shortcuts in PowerShell

# 1. History Search (Ctrl+R) -  `Select
-History |
# Where-Object { $_ -like "*<search term>*" }`
Function Find-History
{
    $searchTerm = Read-Host "Enter search term"
    if ($searchTerm) {
        $history = Select-History
        try {
            $results = $history | Where-Object { $_ -like
"*$searchTerm*" }
        } catch {
            Write-Host "Error during history search:
$($Error[0])"
        }

        if ($results) {
            $results | ForEach-Object {
                Write-Host $_
            }
        } else {
            Write-Host "No matching history found."
        }
    } else {
        Write-Host "No search term entered."
    }
}

# 2. Cycle Through History (Ctrl+Left/Ctrl+Right) -
# Simulate with arrow keys
#    This is a simplified approximation.
#    Uses arrow keys to move through the last few
#    commands in history.
#    Requires you to have a relatively small number of
#    commands in your history.

Function Cycle-History
{
    $direction = Read-Host "Enter direction (Left/Right)"
    if ($direction -eq "Left") {
        $index = $history.Count - 1
        if ($index -gt 0) {
            $index--
            Write-Host ($history[$index])
        }
    } elseif ($direction -eq "Right") {
        $index = 0
        if ($index < $history.Count) {
            $index++
            Write-Host ($history[$index])
        }
    } else {
        Write-Host "Invalid direction. Use 'Left' or 'Right'."
    }
}


# 3. Execute Previous Command (Ctrl+P) -
# `Invoke-History -Count 1`
Function Execute-Previous
{
    Invoke-History -Count 1
}


# 4. Display Current Command (Ctrl+X) - Shows the
# command that's currently being executed.
Function Show-CurrentCommand
{
    Write-Host "Currently executing command:
$($history[-1])"
}

# Add the functions to the history so they're easily
# accessible
$history += Find-History
$history += Cycle-History
$history += Execute-Previous
$history += Show-CurrentCommand


# Optional:  Add a help function (you'll need to add
# this to your profile).
Function Get-Help -Verbose
{
    Write-Host "This is a placeholder for Fish's help.
Real Fish help is not available in PowerShell."
}


Write-Host "Fish-like shortcuts enabled in your
PowerShell profile."
Write-Host "Press Ctrl+R to search history,
Ctrl+Left/Right to cycle, Ctrl+P to execute previous,
and Ctrl+X to see current command."
