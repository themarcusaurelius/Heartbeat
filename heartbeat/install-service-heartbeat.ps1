# Delete and stop the service if it already exists.
if (Get-Service heartbeat -ErrorAction SilentlyContinue) {
  $service = Get-WmiObject -Class Win32_Service -Filter "name='heartbeat'"
  $service.StopService()
  Start-Sleep -s 1
  $service.delete()
}

$workdir = Split-Path $MyInvocation.MyCommand.Path

# Create the new service.
New-Service -name heartbeat `
  -displayName Heartbeat `
  -binaryPathName "`"$workdir\heartbeat.exe`" -c `"$workdir\heartbeat.yml`" -path.home `"$workdir`" -path.data `"C:\ProgramData\heartbeat`" -path.logs `"C:\ProgramData\heartbeat\logs`""
