# anzeigen
$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'

# default
$VerbosePreference = 'SilentlyContinue'
$DebugPreference = 'SilentlyContinue'


function Get-Something
{
    [CmdletBinding()]
    param
    ()

    $VerbosePreference
    $DebugPreference 
    #Content
    Write-Output 'Hallo'
    'Hallo'
    echo 'Hallo'
    Write-Verbose 'Huhu'
    Write-Debug 'Hello Dude!'
    Write-Host 'Hallo Write-host'

}
