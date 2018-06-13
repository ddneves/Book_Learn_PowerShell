$targetData = Get-Content C:\Windows\Logs\DISM\dism.log

$TemplateContent = @'
{Date*:2015-12-15} {Time:21:04:26}, {Level:Info}                  {Component:DISM}   API: PID={PID:1472} TID={TID:5760} {Info:DismApi.dll:                                            - DismInitializeInternal}
{Date*:2015-12-15} {Time:21:04:26}, {Level:Info}                  {Component:DISM}   API: PID={PID:1472} TID={TID:5760} {Info:DismApi.dll: <----- Starting DismApi.dll session -----> - DismInitializeInternal}
'@
$test=$targetData | ConvertFrom-String -TemplateContent $TemplateContent 


$test | Select-Object -First 50 |  Format-Table -AutoSize -Wrap