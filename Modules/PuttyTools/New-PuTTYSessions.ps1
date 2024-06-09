function New-PuTTYSessions #Completed-New
{
  <#
      .SYNOPSIS
      A simple way to import the switches or devices into PuTTY for the first time or update the current list.

      .DESCRIPTION
      Reads a CSV file with "Hostname","IPAddress" columns and builds PuTTY "Sessions" which are added to the registry of the current user.  
      Adds to the registry 'HKCU:\Software\Simontatham\PuTTY\Sessions\'   
      From this point you can use PuTTY as normal

      .PARAMETER File
      The CSV formatted file with the hostnames and IPs. (Hint: See the 'CreateTemplate' switch)

      .PARAMETER LogPath
      By default it will put the file in $env:TEMP

      .PARAMETER CreateTemplate
      This will create the file template for you.  
      To ensure that you build the CSV file correctly.  
      Then you can edit it

      .EXAMPLE
      Import-PuTTYSessions -File Value.csv
      Standard import of sessions.  The first thing to run when you arrive at your new computer.

      .EXAMPLE
      Import-PuTTYSessions -File Value.csv -CreateTemplate
      Will write an example into "value.csv"
    

      .EXAMPLE
      Import-PuTTYSessions -File Value -LogPath Value
      Imports the PuTTY sessions and sets the putty log location to "Value"

      .NOTES
      Often the only module you will need to get your PuTTY operational in your environment.
      There is an assumption that your data is good and therefore there is no error checking, so Hostname "P@55Word" IP "999.123.000.333" will populate the registry, but obviously not work when called.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Import-PuTTYSessions

      .INPUTS
      .csv file with hostname and IP address.

      .OUTPUTS
      Registry keys based on the data in the csv file.
  #>
  [cmdletbinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory, HelpMessage = 'Import file in CSV format. See the "CreateTemplate" switch ', Position = 0,ParameterSetName = 'Default')]
    [Parameter(Mandatory, HelpMessage = 'Import file in CSV format ',  Position = 0,ParameterSetName = 'Template')]
    [ValidateScript({
          If($_ -match '.csv')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be CSV formatted with "HostName" , "IPAddress".  Use -CreateTemplate switch to build a template file.'
          }
    })][String]$ImportCsvFile,
    [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Template')]
    [Switch]$CreateTemplate
  )
  try
  {
    if(-not $CreateTemplate)
    {
      $ImportedData = Import-Csv -Path $ImportCsvFile -ErrorAction Stop
    }
  }
  catch [System.IO.DirectoryNotFoundException] 
  {
    Write-Output -InputObject 'Directory Not Found Exception'
  }
  catch [System.IO.IOException], [System.IO.FileNotFoundException] 
  {
    Write-Output -InputObject 'Input File Not Found. Check the file path.'
  }
  if($CreateTemplate)
  {
    $FileTemplate = @'
"HostName","IPAddress","LogPath"
"Switch-42","192.168.0.42","C:\Temp\PuttyLogs"
'@
    $FileTemplate | Out-File -FilePath "$env:systemdrive\Temp" -Force
    Start-Process -FilePath notepad -ArgumentList $File
    return
  }
  foreach($Device in $ImportedData)
  {
    $SessionName = $Device.HostName
    $SessionIP = $Device.IPAddress
    $LogPath = ($Device.LogPath).trim('\ ')
    $PuttyLogFile = ('{0}\putty-&H-&Y&M&D-&T.log' -f $LogPath)
    $SessionPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\{0}' -f $SessionName
    Write-Verbose -Message ('Session: {0}' -f $SessionPath)
    
    if(-not (Test-Path -Path $SessionPath))
    {
      $null = New-Item -Path $SessionPath -Value $null
      $null = Set-ItemProperty -Path $SessionPath -Name HostName -Value $SessionIP
      $null = Set-ItemProperty -Path $SessionPath -Name LogFileName -Value $PuttyLogFile
    }
  }
}
