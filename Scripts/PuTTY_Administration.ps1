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
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [string]
    $SessionName = '*',
    $outputPath = 'c:\temp\Putty\',

    [Switch]$Bundle
  )

  function New-RegistryFile
  {
    <#
        .SYNOPSIS
        Creates new file
    #>
      
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$FileName,
      [String]$outputPath 
    )
    $FileRegHeader = 'Windows Registry Editor Version 5.00'  
    if(Test-path $outputPath){ 
    
      $outputfile = $('{0}\{1}.reg' -f $outputPath, $FileName)
    }
  
    if(Test-Path $outputfile)
    {
      $outputfile = $outputfile.Replace('.reg',('({0}).reg' -f (Get-Date -Format yyMMdd)))
    }
    $FileRegHeader | Out-File $outputfile -Force
    
    Return $outputfile
  }
  function Export-SessionToFile
  {
    <#
        .SYNOPSIS
        Export Reg Session to file
    #>
  
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
      [String]$outputfile ,
    
      [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Please add a help message here')]
      [String]$item
    )
    
    ('[{0}]' -f $item) | Out-File $outputfile -Append  # Output session header to file
 
    Get-ItemProperty -Path ('HKCU:{0}' -f $($item.TrimStart('HKEY_CURRENT_USER'))) | Out-File $outputfile  -Append
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

}

function Set-PuTTYTheme 
{

}

function Connect-PuTTYSession 
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
    $PuttyPath = 'putty.exe'
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






