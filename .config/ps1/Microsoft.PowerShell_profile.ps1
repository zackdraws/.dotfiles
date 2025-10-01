# Clear the banner
if ($Host.Name -eq 'ConsoleHost') {
    Clear-Host
}
# Initialize Oh My Posh with the Tokyo Night Storm theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\tokyonight_storm.omp.json" | Invoke-Expression

# Initialize zoxide for PowerShell
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Create a new alias for mov-cli pointing to pip (fixing invalid path)
New-Alias mov-cli "C:\Users\zacha\AppData\Roaming\Python\Python313\Scripts\pip.exe"

# Custom PSReadLine key handler for accepting suggestions on Tab
Set-PSReadLineKeyHandler -Key Tab `
    -BriefDescription "ForwardCharAndAcceptNextSuggestionWord" `
    -LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of the current editing line" `
    -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($cursor -lt $line.Length) {
            [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
        }
    }
# Use Emacs editing mode (haven't checked yet)
Set-PSReadLineOption -EditMode Emacs

# Enable prediction like Fish (if not already enabled)
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView


Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Ctrl+b -Function BackwardChar
Set-PSReadLineKeyHandler -Key Ctrl+f -Function ForwardChar
Set-PSReadLineKeyHandler -Key Alt+b  -Function BackwardWord
Set-PSReadLineKeyHandler -Key Alt+f  -Function ForwardWord


Set-PSReadLineKeyHandler -Key Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Key Ctrl+n -Function NextHistory
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward


Set-PSReadLineKeyHandler -Key Ctrl+k -Function KillLine
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardKillLine
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+d   -Function KillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord


Set-PSReadLineKeyHandler -Key Ctrl+y -Function Yank
Set-PSReadLineKeyHandler -Key Ctrl+_ -Function Undo    # Ctrl+_ = Undo in Emacs
Set-PSReadLineKeyHandler -Key Ctrl+g -Function Abort   # Cancel current input


Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+Spacebar -Function Complete
Set-PSReadLineKeyHandler -Key Ctrl+l -Function ClearScreen



Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
Set-PSReadLineKeyHandler -Key Ctrl+s -Function ForwardSearchHistory


Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar      # Like EOF in Unix
Set-PSReadLineKeyHandler -Key Ctrl+h -Function BackwardDeleteChar
Set-PSReadLineKeyHandler -Key Ctrl+t -Function SwapCharacters

# Custom Tab behavior (Fish-style)
Set-PSReadLineKeyHandler -Key Tab `
    -BriefDescription "Smart Tab" `
    -LongDescription "Accept suggestion or perform completion" `
    -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($cursor -lt $line.Length) {
            [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
        }
    }

