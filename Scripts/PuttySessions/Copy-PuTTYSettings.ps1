function Export-PuTTYSession #Completed
{
    [CmdletBinding(DefaultParameterSetName='ParaSet1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory = $false)]
    [string]$outputPath = (Get-Location).Path,
    [Parameter(Mandatory,ParameterSetName='ParaSet1')]
    [Switch]$BundleAll,
    [Parameter(Mandatory,ParameterSetName='ParaSet2')]
    [String]$SessionName = '*'
    
  )
  
  function script:New_RegistryFile
  {
    <#
        .SYNOPSIS
        Creates new file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$FileName,
      [Parameter(Mandatory = $true)]
      [String]$outputPath 
    )
    $FileRegHeader = 'Windows Registry Editor Version 5.00'  
    if(Test-Path -Path $outputPath)
    {
      $outputfile = $('{0}\{1}.reg' -f $outputPath, $FileName)
    }
    if(Test-Path -Path $outputfile)
    {
      $outputfile = $outputfile.Replace('.reg',('({0}).reg' -f (Get-Date -Format yyMMdd)))
    }
    $FileRegHeader | Out-File -FilePath $outputfile -Force
    Return $outputfile
  }
  function script:Export_SessionToFile
  {
    <#
        .SYNOPSIS
        Export Reg Session to file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$outputfile ,
      [Parameter(Mandatory = $true, Position = 1)]
      [String]$item
    )
    ('[{0}]' -f $item) | Out-File -FilePath $outputfile -Append  # Output session header to file
    Get-ItemProperty -Path ('HKCU:{0}' -f $($item.TrimStart('HKEY_CURRENT_USER'))) | Out-File -FilePath $outputfile  -Append
  }
  
  $PuttyRegPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\'
  $PuTTYSessions = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $SessionName)).Name)
  #$HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
  #$PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name 
    
  if(-not $BundleAll)
  {
    foreach($item in $PuTTYSessions)
    {
      $itemName = Split-Path -Path $item -Leaf
      Export_SessionToFile -outputfile $(New_RegistryFile  -FileName $itemName -outputPath $outputPath ) -item $item
    }
  }
  else
  {
    $PuTTYSessions = ((Get-Item -Path ('{0}*' -f $PuttyRegPath)).Name)
    $outputfile = New_RegistryFile -FileName 'PuttyBundle' -outputPath $outputPath 
    foreach($item in $PuTTYSessions)
    {
      $itemName = Split-Path -Path $item -Leaf
      Export_SessionToFile -outputfile $outputfile -item $item
    }
  }
}
function Copy-PuTTYSettings #Incomplete - inop
{
  param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [string]$SessionName
  )

  Write-Warning -Message 'This script is not complete.'
  Write-Host 'This will allow you to copy all of the settings from one session to all of the other sessions. ' -ForegroundColor Cyan
  
    function script:New_RegistryFile
    {
    <#
        .SYNOPSIS
        Creates new file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$FileName,
      [Parameter(Mandatory = $true)]
      [String]$outputPath 
    )
    $FileRegHeader = 'Windows Registry Editor Version 5.00'  
    if(Test-Path -Path $outputPath)
    {
      $outputfile = $('{0}\{1}.reg' -f $outputPath, $FileName)
    }
    if(Test-Path -Path $outputfile)
    {
      $outputfile = $outputfile.Replace('.reg',('({0}).reg' -f (Get-Date -Format yyMMdd)))
    }
    $FileRegHeader | Out-File -FilePath $outputfile -Force
    Return $outputfile
    }
    function script:Export_SessionToFile
    {
    <#
        .SYNOPSIS
        Export Reg Session to file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$outputfile ,
      [Parameter(Mandatory = $true, Position = 1)]
      [String]$item
    )
    ('[{0}]' -f $item) | Out-File -FilePath $outputfile -Append  # Output session header to file
    Get-ItemProperty -Path ('HKCU:{0}' -f $($item.TrimStart('HKEY_CURRENT_USER'))) | Out-File -FilePath $outputfile  -Append
    }
  
    $PuttyRegPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\'
  #$PuTTYSessions = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $SessionName)).Name)
    [System.Collections.ArrayList] $PuTTYSessions = @(Get-ChildItem -Path $PuttyRegPath -Name)
  #$PuTTYSessions.Remove('Default%20Settings')
    #$HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
    #$PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name 
    
    $ItemCount = Show_AsciiMenu -Title Copy -MenuItems $PuTTYSessions
    Write-Verbose -Message ('ItemCount: {0}' -f $ItemCount)
 
   Do 
  {
    [int]$ThemeSelection = Read-Host -Prompt 'Select Number'
    [String]$PuttyThemeSelection = $PuTTYSessions[$ThemeSelection-1]
    Write-Verbose -Message ('ThemeSelection: {0}' -f $ThemeSelection)
  }
  Until($ThemeSelection -in (1..$ItemCount))
  Write-Output -InputObject ('Theme Selected: {0}' -f $PuttyThemeSelection)
   


Export-PuTTYSession -SessionName $PuttyThemeSelection -outputpath $env:TEMP
Export-PuTTYSession -SessionName "Default%20Settings" -outputpath $env:TEMP

$DefaultTheme = (Get-Content -Path "$env:TEMP\Default%20Settings.reg")
$NewTheme = (Get-Content -Path "$env:TEMP\$PuttyThemeSelection.reg")

$NewThemeFile = New-TemporaryFile

Compare-Object -ReferenceObject $DefaultTheme -DifferenceObject $NewTheme -PassThru |
Where-Object -Property sideindicator -EQ -Value '=>'  |
Out-File $NewThemeFile



$theme = Get-Content $NewThemeFile

foreach($line in $theme)
{
  if($line.Contains('[HKEY_CURRENT_USER'))
  {
    $RegPath = $line.Replace('HKEY_CURRENT_USER','HKCU:').Trim(']','[')
    $RegPath ='HKCU:\SOFTWARE\SimonTatham\PuTTY\Sessions\Colors'
  }
  elseif($line.Contains(':'))
  {
    $splitLine = $line -split ':', 2
    $ItemKey = $splitLine[0].ToString().Trim()
    $ItemValue = $splitLine[1].ToString().Trim()
  }
  else
  {

  }
  Set-ItemProperty -Path $RegPath -Name $ItemKey -Value $ItemValue

}

























    foreach($item in $PuTTYSessions)
    {
    $PuttyRegPathSessions = '{0}{1}' -f $PuttyRegPath, $item
    $PuttyRegPathSessions
    #$itemName = Split-Path -Path $item -Leaf
    #Export_SessionToFile -outputfile $(New_RegistryFile  -FileName $itemName -outputPath $outputPath ) -item $item
    }



    $PuttyRegPathSessions | ForEach-Object -Process {
    $r = Get-ItemProperty -Path ('HKCU:{0}' -f $($_.TrimStart('HKEY_CURRENT_USER')))
    }
    }