param([switch]$Elevated)
function Check-Admin 
{
  $currentUser = New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Check-Admin) -eq $false)  
{
  if ($Elevated)
  {
    # could not elevate, quit
  }
 
  else 
  {
    Start-Process -FilePath powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
  }
  exit
}
