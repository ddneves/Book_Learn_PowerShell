        
<#     
        .NOTES
        ===========================================================================
        Created on:     07.10.2016
        Created by:     David das Neves, PFE
        Project:        Schwäbisch Hall, Powershell
        Customer:       Schwäbisch Hall         
        Organization:   Microsoft Germany GmbH
        Filename:       Initialize-Logging.ps1
        ===========================================================================
        .DESCRIPTION
        Loads the HelperModule and initializes the Logging for CMTrace-Logging.

        .DISCLAIMER
        THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER 
        EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
        OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.

        This sample is not supported under any Microsoft standard support program 
        or service. The script is provided AS IS without warranty of any kind. 
        Microsoft further disclaims all implied warranties including, without 
        limitation, any implied warranties of merchantability or of fitness for a 
        particular purpose. The entire risk arising out of the use or performance
        of the sample and documentation remains with you. In no event shall 
        Microsoft, its authors, or anyone else involved in the creation, 
        production, or delivery of the script be liable for any damages whatsoever 
        (including, without limitation, damages for loss of business profits, 
        business interruption, loss of business information, or other pecuniary 
        loss) arising out of the use of or inability to use the sample or 
        documentation, even if Microsoft has been advised of the possibility of 
        such damages.
#>

<#
.Synopsis
   Loads the module and fills the data for logging.
.DESCRIPTION
    Loads the module and fills the data for logging.
   Should be placed in the init block.
.EXAMPLE
   Initialize-TSLogging
#>
function Initialize-TSLogging
{
    # Construct TSEnvironment object
    try 
    {
        $TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    }
    catch
    {
        Write-Error -Message 'Unable to construct Microsoft.SMS.TSEnvironment Object' 
        Start-Sleep -Seconds 1
        exit 1
    }
    
    #gets the parent calling function to retrieve the executing function
    #for example: Set-NetConfig uses this script - the logfile will be Set-NetConfig.log
    $Filename =  (Get-PSCallStack)[1].Command -replace "ps1","log"
 
    # Determine log file location
    $LogFilePath = Join-Path -Path $Script:TSEnvironment.Value('_SMSTSLogPath') -ChildPath $Filename

    Write-Information -MessageData "Logfile: $LogFilePath"

    return $LogFilePath
}
