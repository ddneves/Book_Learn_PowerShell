<#
        .NOTES
        ===========================================================================
        Created on:     06.10.2016
        Created by:     David das Neves, PFE
        Project:        Schwäbisch Hall, Powershell
        Customer:       Schwäbisch Hall         
        Organization:   Microsoft Germany GmbH
        Filename:       Write-CMLogEntry.ps1

        ===========================================================================
        .DESCRIPTION
        Loggt den Befehl in ein CMTrace-kompatibles Log.

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

 
function Write-CMLogEntryToFile
{
    <#
    .Synopsis
       Logs the entry in an CMTrace-compatible format to an logpath.
    .EXAMPLE
       Write-CMLogEntryToFile -Value 'Example' -Severity 2 -LogFilePath $LogFilePath 
    .EXAMPLE
        $TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
        $LogFilePath = Join-Path -Path $Script:TSEnvironment.Value('_SMSTSLogPath') -ChildPath $FileName
        Write-CMLogEntryToFile -Value 'ExampleWithLogFilePath' -Severity 1 -LogFilePath $LogFilePath 
    .EXAMPLE
    Begin {
            # Construct TSEnvironment object
            try 
            {
                $TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
            }
            catch
            {
                Write-Warning -Message 'Unable to construct Microsoft.SMS.TSEnvironment object' 
                exit 1
            }
            $Filename = 'LogDateiName.log'

            # Determine log file location
            $LogFilePath = Join-Path -Path $Script:TSEnvironment.Value('_SMSTSLogPath') -ChildPath $FileName
        }
    Process {
            Write-CMLogEntryToFile -Value 'ExampleWithLogFilePath' -Severity 3 -LogFilePath $LogFilePath 
        }
    #>
    param(
        [parameter(Mandatory = $true, HelpMessage = 'Value added to the logfile.')]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [parameter(Mandatory = $true, HelpMessage = 'Severity for the log entry. 1 for Informational, 2 for Warning and 3 for Error.')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('1', '2', '3')]
        [string]$Severity,

        [parameter(Mandatory = $true, HelpMessage = 'Name of the log file that the entry will written to.')]
        [ValidateNotNullOrEmpty()]
        [string]$LogFilePath
    )
    Process {
        # Construct time stamp for log entry
        $Time = -join @((Get-Date -Format 'HH:mm:ss.fff'), '+', (Get-WmiObject -Class Win32_TimeZone | Select-Object -ExpandProperty Bias))

        # Construct date for log entry
        $Date = (Get-Date -Format 'MM-dd-yyyy')

        # Construct context for log entry
        $Context = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)

        # Construct final log entry
        $LogText = "<![LOG[$($Value)]LOG]!><time=""$($Time)"" date=""$($Date)"" component=""DynamicApplicationsList"" context=""$($Context)"" type=""$($Severity)"" thread=""$($PID)"" file="""">"
	
        # Add value to log file
        try 
        {
            Add-Content -Value $LogText -LiteralPath $LogFilePath -ErrorAction Stop
        }
        catch
        {
            Write-Warning -Message "Unable to append log entry to logfile: $LogFilePath"
        }
    }
}
