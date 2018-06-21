$serviceName = "My Service Name"
$exePath = "C:\Program Files\foo\bar.exe"
$username = "someUser"
$password = convertto-securestring -String "somePassword" -AsPlainText -Force  
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

$existingService = Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'"

if ($existingService) 
{
  "'$serviceName' exists already. Stopping."
  Stop-Service $serviceName
  "Waiting 3 seconds to allow existing service to stop."
  Start-Sleep -s 3

  $existingService.Delete()
  "Waiting 5 seconds to allow service to be uninstalled."
  Start-Sleep -s 5  
}

"Installing the service."
New-Service -BinaryPathName $exePath -Name $serviceName -Credential $cred -DisplayName $serviceName -StartupType Automatic 
"Installed the service."
$ShouldStartService = Read-Host "Would you like the '$serviceName ' service started? Y or N"
if($ShouldStartService -eq "Y")
{
    "Starting the service."
    Start-Service $serviceName
}
"Completed."