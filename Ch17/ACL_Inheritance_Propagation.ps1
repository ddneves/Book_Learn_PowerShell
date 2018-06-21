# directory to update
$directory = "C:\Temp\test"
 
# group object 'sAMAccountName' to add to NTFS permission
$addGroup  = "foobar_access_read"
 
# Configure the access object values - chosen by matrix
$access      = [System.Security.AccessControl.AccessControlType]::Allow 
$rights      = [System.Security.AccessControl.FileSystemRights]"Read,ReadAndExecute,ListDirectory"
$inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
$propagation = [System.Security.AccessControl.PropagationFlags]::None 
$ace         = New-Object System.Security.AccessControl.FileSystemAccessRule($addGroup,$rights,$inheritance,$propagation,$access) 
 
# Retrieve the directory ACL and add a new ACL rule
$acl = Get-Acl $directory
$acl.AddAccessRule($ace) 
$acl.SetAccessRuleProtection($false,$false) 
Set-Acl $directory $acl