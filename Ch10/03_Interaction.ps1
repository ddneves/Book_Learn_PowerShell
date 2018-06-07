#region NuGet setup
# Bootstrapping the PowerShellGet NuGet provider for offline systems
# nuget.exe is necessary to use Publish-Module and nuget pack

# Systemwide
$PSGetProgramDataPath = Join-Path -Path $env:ProgramData -ChildPath 'Microsoft\Windows\PowerShell\PowerShellGet\'

# CurrentUser
$PSGetAppLocalPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'Microsoft\Windows\PowerShell\PowerShellGet\'

if (-not $PSGetProgramDataPath)
{
    [void] (New-Item -ItemType Directory -Path $PSGetProgramDataPath -Force)
}

if (-not $PSGetAppLocalPath)
{
    [void] (New-Item -ItemType Directory -Path $PSGetAppLocalPath -Force)
}

Invoke-WebRequest https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile (Join-Path $PSGetAppLocalPath nuget.exe)

# Bootstrapping the NuGet dll for the PackageManagement module
# Systemwide 
$assemblyPath = 'C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208'

# Current user
$assemblyPath = Join-Path $env:LOCALAPPDATA 'PackageManagement\ProviderAssemblies\nuget\2.8.5.208'


[void] (New-Item -ItemType Directory -Path $assemblyPath -Force)
Invoke-WebRequest https://oneget.org/Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll -OutFile "$assemblyPath\Microsoft.PackageManagement.NuGetProvider.dll" 
#endregion

#region Interacting with a repository

# Register internal repository
Register-PSRepository -Name Internal -SourceLocation https://NUGSV01/api/v2 -PublishLocation https://NUGSV01/api/v2/package

# Recreate PSGallery repository if it has been removed
Register-PSRepository -Default

# Discover any existing modules
Find-Module -Repository Internal

# Upload VoiceCommands module
# Data in PSD1 file will be used to generate metadata
$apiKey = 'oy2ihe7sqbggn4e7hcwq66ipg2btwduutimb3bbyxrfdm4'
Publish-Module -Name VoiceCommands -NuGetApiKey $apiKey -Repository Internal -Tags Voice, Automation

# Install module on another server, another user, ...
Install-Module -Name VoiceCommands -Repository Internal -Scope CurrentUser

# Done with a module?
Uninstall-Module -Name VoiceCommands

# JEA

# Find role capability by name
Find-RoleCapability -Name FirstLevelUserSupport

# Find modules with specific role capability
Find-Module -RoleCapability FirstLevelUserSupport

# Install modules with found psrc files to prepare for a JEA endpoint deployment
Find-Module -RoleCapability FirstLevelUserSupport |
    Install-Module

# Register endpoint with freshly downloaded, production JEA psrc files
$parameters = @{
    Path                = '.\JeaWithPowerShellGet.pssc'
    RunAsVirtualAccount = $true
    TranscriptDirectory = 'C:\Transcripts'
    SessionType         = 'RestrictedRemoteServer'
    LanguageMode        = 'ConstrainedLanguage'
    RoleDefinitions     = @{'contoso\FirstLevel' = @{RoleCapabilities = 'FirstLevelUserSupport'}}
}

# This would come from source control
New-PSSessionConfigurationFile @parameters

# This would be part of an automated rollout
Register-PSSessionConfiguration -Name SupportSession -Path .\JeaWithPowerShellGet.pssc

#endregion

#region Deploying

# Interactive
# AllowClobber allows installing modules that overwrite existing cmdlets
Install-Module AutomatedLab -Scope CurrentUser -RequiredVersion 5.3 -AllowClobber
Install-Script -Name Speedtest -Scope CurrentUser

# 1-m
Invoke-Command -ComputerName HostA,HostB,HostC -ScriptBlock {
    Install-Module -Name MyInfrastructureModule -Repository InternalGallery
}

# Explore the PowerShellGet module
psedit (Join-Path (Get-Module PowerShellGet -List)[-1].ModuleBase PSModule.psm1)

#endregion