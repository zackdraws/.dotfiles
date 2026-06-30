[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ScriptPath,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ScriptArgs
)

$ErrorActionPreference = "Stop"

function Find-MsysBash {
    $candidates = @()

    if ($env:MSYS2_BASH) {
        $candidates += $env:MSYS2_BASH
    }

    if ($env:MSYS2_ROOT) {
        $candidates += (Join-Path $env:MSYS2_ROOT "usr\bin\bash.exe")
    }

    $candidates += @(
        "C:\msys64\usr\bin\bash.exe",
        "C:\msys64\ucrt64\bin\bash.exe"
    )

    $command = Get-Command bash.exe -ErrorAction SilentlyContinue
    if ($command) {
        $candidates += $command.Source
    }

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return (Resolve-Path -LiteralPath $candidate).ProviderPath
        }
    }

    throw "MSYS2 bash.exe was not found. Install MSYS2 or set MSYS2_BASH to C:\msys64\usr\bin\bash.exe."
}

function ConvertTo-MsysPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Bash
    )

    $converted = & $Bash -lc 'cygpath -u "$1"' cygpath $Path
    if ($LASTEXITCODE -ne 0) {
        throw "cygpath failed for path: $Path"
    }

    return (($converted | Select-Object -First 1).Trim())
}

$bash = Find-MsysBash
$resolvedScript = (Resolve-Path -LiteralPath $ScriptPath).ProviderPath
$currentPath = (Get-Location).ProviderPath

$env:MSYS_SCRIPT = ConvertTo-MsysPath -Path $resolvedScript -Bash $bash
$env:MSYS_CWD = ConvertTo-MsysPath -Path $currentPath -Bash $bash

$bootstrap = @'
set -e
cd "$MSYS_CWD"

case "$MSYS_SCRIPT" in
  *.fish)
    exec fish "$MSYS_SCRIPT" "$@"
    ;;
  *.py)
    if command -v python3 >/dev/null 2>&1; then
      exec python3 "$MSYS_SCRIPT" "$@"
    fi
    exec python "$MSYS_SCRIPT" "$@"
    ;;
  *)
    if IFS= read -r first_line < "$MSYS_SCRIPT" && [[ "$first_line" == '#!'* ]]; then
      chmod +x "$MSYS_SCRIPT" 2>/dev/null || true
      exec "$MSYS_SCRIPT" "$@"
    fi
    exec bash "$MSYS_SCRIPT" "$@"
    ;;
esac
'@

& $bash -lc $bootstrap dotfiles-shim @ScriptArgs
exit $LASTEXITCODE
