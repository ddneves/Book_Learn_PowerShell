#region Variables

# The variable cmdlets
Get-Command -Noun Variable

# Why use the cmdlets?
# In case of dynamically named variables
New-Variable -Name "Variables we don't like" -Value 'Because they contain special characters'

# Accessing those variables is not that nice
${Variables we don't like}
(Get-Variable -Name "Variables we don't like").Value

# or in case of read-only or constant variables
New-Variable -Name LogPath -Value D:\Logs -Option ReadOnly
New-Variable -Name Pi -Value ([Math]::PI) -Option Constant

# Changing read-only or constant variables throws an exception
$LogPath = 'C:\Temp' # VariableNotWritable
$Pi = [Math]::E # VariableNotWritable

# Changing read-only variables only possible with cmdlets
Set-Variable -Name LogPath -Value 'C:\Temp' -Force
Set-Variable -Name Pi -Value ([Math]::E) -Force # Still throws, requires you to restart the session

# Reviewing built-in variables
Get-Variable

# The most important ones
$? # Returns true or false depending on the last expression that was executed. Here: $true
$args # All parameter values passed to your script
$Error # A list containing up to 256 errors that occured in your session
$FormatEnumerationLimit # Default: 4. The amount of list entries enumerated when formatting output
$LASTEXITCODE # Default: 0. The last exit code of an external application
$PSVersionTable # Displays the PowerShell and OS version. On PowerShell Core, also shows the platform and edition
$PID # The process ID of the current PowerShell process
$profile # The profile script paths
#endregion

#region OOP
$process = Get-Process -Id $pid
$date = Get-Date

# What types do my variables have
$process.GetType().FullName # System.Diagnostics.Process
$date.GetType().FullName # System.DateTime

# Everything you do in PowerShell creates instances of a class
# or objects of a type.
# All objects share the same properties but with different values
Get-Process | Get-Member # Hundreds of System.Diagnostics.Process objects
Get-ChildItem | Get-Member # System.IO.FileInfo and System.IO.DirectoryInfo objects

# Notice that some properties seem to be read-only ( {get} ), while
# others can be changed
Get-ChildItem | Get-Member -Name FullName,CreationTime

# All objects also have methods that can be executed
$item = Get-Item -Path $pshome\Modules
$item.CreateSubdirectory('MyModule')

# But what arguments may be used?
$item | Get-Member -Name CreateSubdirectory

# A type is comprised of a namespace (System.Diagnostics)
# and a class name (Process).
# Let's create our own class.
Add-Type -TypeDefinition '
using System;
namespace MyNamespace // Your own namespace. Can also be nested in System by calling it System.MyNamespace
{
    public class LogObject // You own class (object template)
    {
        public string LogPath { get; set; }
        public string LogName {get; set;}
        public DateTime LogCreated { get; private set; }

        public LogObject ()
        {
            LogCreated = DateTime.Now;
        }

        public LogObject (string logPath, string logName)
        {
            LogPath = logPath;
            LogName = logName;
        }

        public void WriteLog(string logMessage)
        {
            System.IO.File.WriteAllText(LogPath, logMessage);
        }
    }
}
'

# Instanciate our new object - this is what your cmdlets usually do internally
$logObject = New-Object -TypeName MyNamespace.LogObject
$logObject # The date is preset
$logObject | Get-Member # LogCreated is read-only, LogName and LogPath are writable
$logObject | Get-Member -Name WriteLog # Method allows interacting with the object
#endregion

#region Types

# Basic types
[bool] # True or False
[string] # A collection of UTF16 characters
[int16] # 16bit integer
[int32] # 32bit integer
[int64] # 64bit integer
[char] # UTF16 character
[array] # A list of objects
[hashtable] # A special type of collection that derives from a dictionary
[datetime] # Represents date and time in the Gregorian calendar using the unit Tick (100ns)
[timespan] # Represents a duration of time

# Easy type conversion
Get-Process -Name powershell # powershell is converted to a string
Get-Date -Date 2018-08-01 # String is converted to DateTime automatically
Get-WinEvent -LogName Application -MaxEvents '000030' # Integers in Strings are automatically converted

# Type-casting variables to aid conversion
[string]$NoStringsAttached = 'Value'
[int]$Only32BitIntegerHere = 42
[]

#endregion