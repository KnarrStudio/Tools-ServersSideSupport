function Import-PuTTYSessions 
{
  [cmdletbinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory, Position = 0,ParameterSetName = 'Default')]
    [Parameter(Mandatory, Position = 0,ParameterSetName = 'Template')]
    [ValidateScript({
          If($_ -match '.csv')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be CSV formatted with "HostName" , "IPAddress"'
          }
    })][String]$File,
    [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Default')]
    [string]$PuttyTheme = 'Default',
    [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Template')]
    [Switch]$CreateTemplate
  )
  if($CreateTemplate)
  {
    $FileTemplate = @'
"HostName","IPAddress"
"Switch-42","192.168.0.42"
'@
    $FileTemplate | Out-File -FilePath $File -Force
    return
  }
}
function Export-PuTTYSessions 
{
  param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [string]
    $SessionName = '*',
    [string]$outputPath = "$env:HOMEDRIVE\temp\Putty\",
    [Switch]$Bundle
  )
  function New-RegistryFile
  {
    <#
        .SYNOPSIS
        Creates new file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$FileName,
      [Parameter(Mandatory=$true)]
      [String]$outputPath 
    )
    $FileRegHeader = 'Windows Registry Editor Version 5.00'  
    if(Test-path -Path $outputPath){ 
      $outputfile = $('{0}\{1}.reg' -f $outputPath, $FileName)
    }
    if(Test-Path -Path $outputfile)
    {
      $outputfile = $outputfile.Replace('.reg',('({0}).reg' -f (Get-Date -Format yyMMdd)))
    }
    $FileRegHeader | Out-File -FilePath $outputfile -Force
    Return $outputfile
  }
  function Export-SessionToFile
  {
    <#
        .SYNOPSIS
        Export Reg Session to file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
      [String]$outputfile ,
      [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Please add a help message here')]
      [String]$item
    )
    ('[{0}]' -f $item) | Out-File -FilePath $outputfile -Append  # Output session header to file
    Get-ItemProperty -Path ('HKCU:{0}' -f $($item.TrimStart('HKEY_CURRENT_USER'))) | Out-File -FilePath $outputfile  -Append
  }
  $PuttyRegPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\'
  $PuTTYSessions = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $SessionName)).Name)
  if(-not $Bundle)
  {
    foreach($item in $PuTTYSessions)
    {
      $itemName = $item.Split('\')[5]
      Export-SessionToFile -outputfile $(New-RegistryFile  -FileName $itemName -outputPath $outputPath ) -item $item
    }
  }
  else
  {
    $outputfile = New-RegistryFile -FileName 'PuttyBundle' -outputPath $outputPath 
    foreach($item in $PuTTYSessions)
    {
      $itemName = $item.Split('\')[5]
      Export-SessionToFile -outputfile $outputfile -item $item
    }
  }
}
function Update-PuTTYSessions 
{
  <#
      .SYNOPSIS
      Describe purpose of "Update-PuTTYSessions" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .EXAMPLE
      Update-PuTTYSessions
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Update-PuTTYSessions

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


}
function Set-PuTTYTheme 
{
  <#
      .SYNOPSIS
      Describe purpose of "Set-PuTTYTheme" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .EXAMPLE
      Set-PuTTYTheme
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Set-PuTTYTheme

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


}

function Connect-PuTTYSession 
{
  <#
      .SYNOPSIS
      Allows you to open one or many putty session via Powershell

      .DESCRIPTION
      Reads the registry for the available sessions and then presents them to you in a grid that you can select and open
    
      .PARAMETER LoginName
      If you have a bunch of switches, you can use this to populate the "login" field.  You can use "$env:username" or "root"

      .PARAMETER PuttyPath
      Full path to the location of the PuTTY.exe

      .EXAMPLE
      Start-PuttySessions -LoginName StanSmith -PuttyPath 'c:\Putty\putty.exe'
      This will open a grid view with all of your putty sessions displayed.  When you start them the username will be populated.

  #>
  param
  (
    [Parameter(Position = 0)]
    [string]$LoginName,
    [Parameter(Mandatory = $true,HelpMessage='Full path to the PuTTY.exe file.  example:"c:\Putty\putty.exe"',Position = 1)]
    [string]$PuttyPath
  )
  $PuTTYSessions = Get-ItemProperty -Path HKCU:\Software\Simontatham\PuTTY\Sessions\*
  function Start-PuttySession
  {<#
      .SYNOPSIS
      Starts the actual puTTY session
      #>
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