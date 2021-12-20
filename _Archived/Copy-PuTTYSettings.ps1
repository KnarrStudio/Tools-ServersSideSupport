function Copy-PuTTYSettings #Incomplete - inop
{
  param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [string]$SessionName
  )

  Write-Warning -Message 'This script is not complete.'
  Write-Host 'This will allow you to copy all of the settings from one session to all of the other sessions. ' -ForegroundColor Cyan
  Return
  
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
  $PuTTYSessions.Remove('Default%20Settings')
    #$HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
    #$PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name 
    

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