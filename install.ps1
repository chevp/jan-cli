# jan-cli installer for Windows PowerShell.
#
# Initializes the chi submodule, builds it, and adds bin/ to the user PATH
# so that `jan` is available in new terminals.
#
# Usage:
#   .\install.ps1              # interactive
#   .\install.ps1 -AssumeYes   # unattended
#
# Requires: node 20+, npm, git.
#
# Tip: easier install path — `npm install -g github:chevp/jan-cli`.

[CmdletBinding()]
param(
    [switch]$AssumeYes
)

$ErrorActionPreference = 'Stop'

$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$binDir = Join-Path $src 'bin'

Write-Host "jan-cli install"
Write-Host "  source: $src" -ForegroundColor DarkGray

try {
    $nodeVersion = (& node -e "process.stdout.write(process.versions.node)" 2>$null)
} catch { Write-Error "node not found. Install Node.js 20+: https://nodejs.org/"; exit 1 }
if (-not $nodeVersion) { Write-Error "node not on PATH. Install Node.js 20+: https://nodejs.org/"; exit 1 }
$nodeMajor = [int]($nodeVersion -split '\.')[0]
if ($nodeMajor -lt 20) { Write-Error "node $nodeVersion found, jan requires node 20+"; exit 1 }

try { & npm --version | Out-Null } catch { Write-Error "npm not on PATH"; exit 1 }
try { & git --version | Out-Null } catch { Write-Error "git not on PATH"; exit 1 }

Push-Location $src
try {
    & git submodule update --init --recursive
    if ($LASTEXITCODE -ne 0) { throw "submodule init failed" }

    & npm install --no-audit --no-fund
    if ($LASTEXITCODE -ne 0) { throw "npm install / build failed" }
} finally { Pop-Location }

# Add bin/ to user PATH (HKCU\Environment) if not already present
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$paths = if ($userPath) { $userPath -split ';' } else { @() }
if ($paths -notcontains $binDir) {
    if ($AssumeYes -or (Read-Host "add $binDir to your user PATH? [Y/n]") -ne 'n') {
        [Environment]::SetEnvironmentVariable('Path', ($userPath + ';' + $binDir).TrimStart(';'), 'User')
        Write-Host "  path  + $binDir on user PATH (open a new terminal)"
    }
}

Write-Host "→ ready. next: jan status" -ForegroundColor Green
