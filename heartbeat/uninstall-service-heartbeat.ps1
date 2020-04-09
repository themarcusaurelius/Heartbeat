# Delete and stop the service if it already exists.
if (Get-Service heartbeat -ErrorAction SilentlyContinue) {
  $service = Get-WmiObject -Class Win32_Service -Filter "name='heartbeat'"
  $service.StopService()
  Start-Sleep -s 1
  $service.delete()
}
