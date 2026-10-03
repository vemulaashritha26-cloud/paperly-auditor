Set-Location $PSScriptRoot
$python = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"
$port = 8011

if (-not (Test-Path $python)) {
    Write-Host "Creating the virtual environment..."
    py -m venv .venv
    if ($LASTEXITCODE -ne 0) {
        throw "Could not create the virtual environment. Install Python and try again."
    }
}

& $python -m pip check *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installing project dependencies..."
    & $python -m pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) {
        throw "Dependency installation failed."
    }
}

if (Test-NetConnection -ComputerName 127.0.0.1 -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue) {
    $listener = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort $port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($listener) {
        $process = Get-Process -Id $listener.OwningProcess -ErrorAction SilentlyContinue
        $owner = if ($process) { "$($process.ProcessName) (PID $($process.Id))" } else { "PID $($listener.OwningProcess)" }
        throw "Port $port is already in use by $owner. Open http://127.0.0.1:$port or stop that process before starting another server."
    }
    throw "Port $port is already in use. Open http://127.0.0.1:$port or choose another port."
}

Write-Host "AuditQuest is running at http://127.0.0.1:$port"
& $python -m uvicorn app:app --host 127.0.0.1 --port $port