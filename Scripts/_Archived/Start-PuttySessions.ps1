return  # This has been migrated to Putty_Administration under connect-puttysession


#requires -Version 3.0
function Start-PuttySessions
{
  <#
      .SYNOPSIS
      Allows you to open a putty session via Powershell

      .DESCRIPTION
      Reads the registry for the available sessions and then presents them to you in a grid that you can select and open
    
      .PARAMETER LoginName
      If you have a bunch of switches, you can use this to populate the "login" field.

      .PARAMETER PuttyPath
      Full path to the location of the PuTTY.exe

      .EXAMPLE
      Start-PuttySessions -LoginName StanSmith -PuttyPath 'c:\Putty\putty.exe'
      This will open a grid view with all of your putty sessions displayed.  When you start them the username will be populated.

  #>

  [CmdletBinding()]
  param
  (
    [Parameter(Position = 0)]
    [string]
    $LoginName = 'pi',
    [Parameter(Position = 1)]
    [string]
    $PuttyPath = 'C:\Users\NewUser\OneDrive\Downloads\putty.exe'
  )
  $PuTTYSessions = Get-ItemProperty -Path HKCU:\Software\Simontatham\PuTTY\Sessions\*
  function Start-PuttySession
  {
    param
    (
      [Object]
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to process')]
      $InputObject
    )
    process
    {
      & $PuttyPath -load $InputObject.pschildname  ('{0}@{1}' -f $LoginName, $InputObject.hostname)
    }
  }
  $MySession = $PuTTYSessions |
  Select-Object -Property pschildname, hostname |
  Out-GridView -PassThru
  $MySession | Start-PuttySession
}

Start-PuttySessions