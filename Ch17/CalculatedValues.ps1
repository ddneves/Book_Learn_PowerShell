Get-ChildItem C:\Test | Select-Object Name, CreationTime,  @{Name="Kbytes";Expression={$_.Length / 1Kb}}
