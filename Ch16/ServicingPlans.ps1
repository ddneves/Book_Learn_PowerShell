############ WINDOWS 10 SERVICING ###############################

    Get-CMWindowsServicingPlan 
    New-CMWindowsServicingPlan

#These cmdlets require Configuration Manager 1511 or newer.

$DeploymentPackageName = ‘Windows 10 1511 Education’ 
New-Item -Path CTP:\DeviceCollection -Name ‘Software Updates’

New-CMCollection -Name ‘SUM – RING1’ -CollectionType Device -LimitingCollectionName ‘All Systems’ 
New-CMCollection -Name ‘SUM – RING2’ -CollectionType Device -LimitingCollectionName ‘All Systems’ 
New-CMCollection -Name ‘SUM – RING3’ -CollectionType Device -LimitingCollectionName ‘All Systems’ 
New-CMCollection -Name ‘SUM – RING4’ -CollectionType Device -LimitingCollectionName ‘All Systems’ 
New-CMCollection -Name ‘SUM – RING5’ -CollectionType Device -LimitingCollectionName ‘All Systems’

### Move-CMObject is broken

New-CMSoftwareUpdateDeploymentPackage ` 
    -Name $DeploymentPackageName ` 
    -Path "\\CMTP\Sources\Updates\$DeploymentPackageName"

$DeploymentPackage = Get-CMSoftwareUpdateDeploymentPackage ` 
    -Name $DeploymentPackageName

$UpgradePackge = Get-CMWindowsUpdate ` 
    -Name ‘Upgrade to Windows 10 Education, version 1511, 10586 – en-us, Volume’ ` 
    -Fast

Save-CMSoftwareUpdate ` 
    -SoftwareUpdate $UpgradePackge ` 
    -DeploymentPackageName $DeploymentPackageName ` 
    -Verbose

Start-CMContentDistribution ` 
    -DeploymentPackage $DeploymentPackageName ` 
    -DistributionPointName ‘CMTP.corp.viamonstra.com’

New-CMWindowsServicingPlan ` 
    -Name ‘SUM – RING1’ ` 
    -CollectionName ‘SUM – RING1’ ` 
    -EnabledAfterCreate $True ` 
    -Language English ` 
    -VerboseLevel AllMessages ` 
    -SendWakeupPacket $True ` 
    -RunType RunTheRuleAfterAnySoftwareUpdatePointSynchronization ` 
    -DeploymentRing CB ` 
    -DeploymentPackage $DeploymentPackage ` 
    -UpdateDeploymentWaitDay 10 ` 
    

New-CMWindowsServicingPlan ` 
    -Name ‘SUM – RING2’ ` 
    -CollectionName ‘SUM – RING2’ ` 
    -EnabledAfterCreate $True ` 
    -Language English ` 
    -VerboseLevel AllMessages ` 
    -SendWakeupPacket $True ` 
    -RunType RunTheRuleAfterAnySoftwareUpdatePointSynchronization ` 
    -DeploymentRing CB ` 
    -DeploymentPackage $DeploymentPackage ` 
    -UpdateDeploymentWaitDay 15

New-CMWindowsServicingPlan ` 
    -Name ‘SUM – RING3’ ` 
    -CollectionName ‘SUM – RING3’ ` 
    -EnabledAfterCreate $True ` 
    -Language English ` 
    -VerboseLevel AllMessages ` 
    -SendWakeupPacket $True ` 
    -RunType RunTheRuleAfterAnySoftwareUpdatePointSynchronization ` 
    -DeploymentRing Cbb ` 
    -DeploymentPackage $DeploymentPackage ` 
    -UpdateDeploymentWaitDay 50

New-CMWindowsServicingPlan ` 
    -Name ‘SUM – RING4’ ` 
    -CollectionName ‘SUM – RING4’ ` 
    -EnabledAfterCreate $True ` 
    -Language English ` 
    -VerboseLevel AllMessages ` 
    -SendWakeupPacket $True ` 
    -RunType RunTheRuleAfterAnySoftwareUpdatePointSynchronization ` 
    -DeploymentRing Cbb ` 
    -DeploymentPackage $DeploymentPackage ` 
    -UpdateDeploymentWaitDay 75

New-CMWindowsServicingPlan ` 
    -Name ‘SUM – RING5’ ` 
    -CollectionName ‘SUM – RING5’ ` 
    -EnabledAfterCreate $True ` 
    -Language English ` 
    -VerboseLevel AllMessages ` 
    -SendWakeupPacket $True ` 
    -RunType RunTheRuleAfterAnySoftwareUpdatePointSynchronization ` 
    -DeploymentRing Cbb ` 
    -DeploymentPackage $DeploymentPackage ` 
    -UpdateDeploymentWaitDay 100 
