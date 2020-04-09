Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser	
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope Process

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    "`nYou are running Powershell with full privilege`n"

    Set-Location -Path 'c:\Heartbeat-master\heartbeat'
    Set-ExecutionPolicy Unrestricted
    
    "Heartbeat Execution policy set - Success`n"

    #=========== Filebeat Credentials Form ===========#
    "`nAdding Heartbeat Credentials`n"

    #Pop-up Box that Adds Credentials 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

    #============ Box ============#
    $objForm = New-Object System.Windows.Forms.Form 
    $objForm.Text = "Vizion.ai Credentials Form"
    $objForm.Size = New-Object System.Drawing.Size(300,450) 
    $objForm.StartPosition = "CenterScreen"

    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown({
        if ($_.KeyCode -eq "Enter" -or $_.KeyCode -eq "Escape"){
            $objForm.Close()
        }
    })

    #============= Buttons =========#
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(75,340)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(150,340)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($CancelButton)

    #============= Header ==========#
    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,10) 
    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel.Text = "Please enter the following:"
    $objForm.Controls.Add($objLabel)

    #============ First Input =======#
    $objLabel1 = New-Object System.Windows.Forms.Label
    $objLabel1.Location = New-Object System.Drawing.Size(10,40) 
    $objLabel1.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel1.Text = "Kibana URL"
    $objForm.Controls.Add($objLabel1)

    $objTextBox = New-Object System.Windows.Forms.TextBox 
    $objTextBox.Location = New-Object System.Drawing.Size(10,60) 
    $objTextBox.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($objTextBox) 

    #============ Second Input =======#
    $objLabel2 = New-Object System.Windows.Forms.Label
    $objLabel2.Location = New-Object System.Drawing.Size(10,100) 
    $objLabel2.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel2.Text = "Username:"
    $objForm.Controls.Add($objLabel2)

    $objTextBox2 = New-Object System.Windows.Forms.TextBox 
    $objTextBox2.Location = New-Object System.Drawing.Size(10,120) 
    $objTextBox2.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($objTextBox2)

    # #============ Third Input =======#
    $objLabel3 = New-Object System.Windows.Forms.Label
    $objLabel3.Location = New-Object System.Drawing.Size(10,160) 
    $objLabel3.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel3.Text = "Password:"
    $objForm.Controls.Add($objLabel3)

    $objTextBox3 = New-Object System.Windows.Forms.TextBox 
    $objTextBox3.Location = New-Object System.Drawing.Size(10,180) 
    $objTextBox3.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($objTextBox3)

    #============ Fourth Input =======#
    $objLabel4 = New-Object System.Windows.Forms.Label
    $objLabel4.Location = New-Object System.Drawing.Size(10,220) 
    $objLabel4.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel4.Text = "Vizion Elasticsearch API Endpoint:"
    $objForm.Controls.Add($objLabel4)

    $objTextBox4 = New-Object System.Windows.Forms.TextBox 
    $objTextBox4.Location = New-Object System.Drawing.Size(10,240) 
    $objTextBox4.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($objTextBox4)

    #============ Fifth Input =======#
    $objLabel5 = New-Object System.Windows.Forms.Label
    $objLabel5.Location = New-Object System.Drawing.Size(10,280) 
    $objLabel5.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel5.Text = "URL you would like to monitor:"
    $objForm.Controls.Add($objLabel5)

    $objTextBox5 = New-Object System.Windows.Forms.TextBox
    $objTextBox5.Location = New-Object System.Drawing.Size(10,300) 
    $objTextBox5.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($objTextBox5)


    $objForm.Topmost = $True

    $objForm.Add_Shown({$objForm.Activate()})
    [void]$objForm.ShowDialog()

    #Opens up YML file and inserts Kibana URL
    (Get-Content heartbeat.yml) |
        ForEach-Object {$_ -Replace 'host: ""', "host: ""$($objTextBox.Text)"""} |
            Set-Content heartbeat.yml

    #Opens Up YML and sets Password
    (Get-Content heartbeat.yml) |       
        ForEach-Object {$_ -Replace 'password: ""', "password: ""$($objTextBox3.Text)""" } |
            Set-Content heartbeat.yml

    #Opens Up YML and sets Username
    (Get-Content heartbeat.yml) |       
        ForEach-Object {$_ -Replace 'username: ""', "username: ""$($objTextBox2.Text)""" } |
            Set-Content heartbeat.yml

    #Opens up YML and inserts Elasticsearch API Endpoint
    (Get-Content heartbeat.yml) |
        ForEach-Object {$_ -Replace 'elasticsearch-api-endpoint', "$($objTextBox4.Text)"} |
            Set-Content heartbeat.yml

    (Get-Content heartbeat.yml) |
        ForEach-Object {$_ -Replace 'heartbeat-url', "$($objTextBox5.Text)"} |
            Set-Content heartbeat.ym

    #Runs the config test to make sure all data has been inputted correctly
    .\heartbeat.exe -e -configtest

    #Load heartbeat Preconfigured Dashboards
    .\heartbeat.exe setup --dashboards

    #Install heartbeat as a service
    .\install-service-heartbeat.ps1

    #Runs heartbeat as a Service
    Start-service heartbeat

    #Show that heartbeat is running
    Get-Service heartbeat

    "`nHeartbeat Started. Check Kibana For The Incoming Data!"

    #Close Powershell window
    Stop-Process -Id $PID

}
else {
    Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
}