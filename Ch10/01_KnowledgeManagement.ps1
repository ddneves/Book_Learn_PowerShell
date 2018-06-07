# The PlatyPS module makes generating help a breeze
Install-Module PlatyPS -Force -Scope CurrentUser

# If you want, review the module code first
Get-Content .\VoiceCommands\VoiceCommands.psd1
Get-Content .\VoiceCommands\VoiceCommands.psm1

# For an existing module, generate help
# WithModulePage generates an additional landing page
Import-Module .\VoiceCommands
$param = @{
    Module = 'VoiceCommands'
    WithModulePage = $true
    OutputFolder = '.\MarkdownHelp'
}
New-MarkdownHelp @param

# The generated help content can be extended
psedit .\MarkdownHelp\Out-Voice.md

# After each commit to a specific branch
# or as a regular task, the help can be updated
# Existing documentation will be kept intact
Update-MarkdownHelp -Path .\MarkdownHelp

# As a build task, you might want to generate the
# MAML help
New-ExternalHelp -Path .\MarkdownHelp -OutputPath .\VoiceCommands\en-us

# Try it out
Remove-Module VoiceCommands
Import-Module .\VoiceCommands
Get-Help Out-Voice -Full