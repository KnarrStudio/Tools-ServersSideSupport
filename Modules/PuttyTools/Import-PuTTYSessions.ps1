function Import-PuTTYSessions #Completed-Updated
{
  <#
      .SYNOPSIS
      A simple way to import the switches or devices into PuTTY from an exported .REG file.

      .DESCRIPTION
      Reads an exported reg file and imports it.  The exported file can be from either the GUI or Export-PuTTYsessions script.

      .PARAMETER $ImportFile
      The exported .REG file

      .EXAMPLE
      Import-PuTTYSessions -File Value.csv
      Standard import of sessions.  The first thing to run when you arrive at your new computer.

      .EXAMPLE
      Import-PuTTYSessions -ImportFile .\Bundle3.reg

  #>
  [cmdletbinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory, HelpMessage = 'Import file in CSV format ',  Position = 0)]
    [ValidateScript({
          If($_ -match '.reg')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be REG file.'
          }
    })][String]$ImportFile
  )
 
  $regexe = "$env:windir\system32\reg.exe"
  $arguments = "import $ImportFile"
  Start-Process -FilePath $regexe -ArgumentList $arguments -NoNewWindow
}
