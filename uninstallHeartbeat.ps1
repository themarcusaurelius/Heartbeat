Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser	
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope Process

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Set-ExecutionPolicy Unrestricted

    #Change Directory to Heartbeat
    Set-Location -Path 'c:\Heartbeat-master\heartbeat'

    #Stops heartbeat from running
    Stop-Service -Force heartbeat

    #Get The heartbeat Status
    Get-Service heartbeat

    #Change Directory to heartbeat5
    Set-Location -Path 'c:\'

    "`nUninstalling Heartbeat Now..."

    $Target = "C:\Heartbeat-master"

    Get-ChildItem -Path $Target -Recurse -force |
        Where-Object { -not ($_.pscontainer)} |
            Remove-Item -Force -Recurse

    Remove-Item -Recurse -Force $Target

    "`nHeartbeat Uninstall Successful."

    #Close Powershell window
    Stop-Process -Id $PID
}
else {
    Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
}