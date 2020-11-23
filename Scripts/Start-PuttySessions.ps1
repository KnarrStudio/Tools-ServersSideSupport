function Start-PuttySessions
{
  <#
    .SYNOPSIS
    Short Description
    .DESCRIPTION
    Detailed Description
    .EXAMPLE
    Start-Something
    explains how to use the command
    can be multiple lines
    .EXAMPLE
    Start-Something
    another example
    can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [System.String]
    $LoginName = 'pi',
    [Parameter(Mandatory=$false, Position=1)]
    [System.String]
    $PuttyPath = 'C:\Users\New User\OneDrive\Downloads\putty.exe'
  )
  $PuTTYSessions = Get-ItemProperty -Path HKCU:\Software\Simontatham\PuTTY\Sessions\*
  function Start-PuttySession
  {
    param
    (
      [Object]
      [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Data to process")]
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