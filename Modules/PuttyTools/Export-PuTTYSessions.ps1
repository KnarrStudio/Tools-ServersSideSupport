function Export-PuTTYSessions #Completed
{
  param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [string]
    $SessionName = '*',
    [string]$outputPath = "$env:HOMEDRIVE\temp\Putty\",
    [Switch]$Bundle
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
  if(-not $Bundle)
  {
    foreach($item in $PuTTYSessions)
    {
      $itemName = Split-Path -Path $item -Leaf
      Export_SessionToFile -outputfile $(New_RegistryFile  -FileName $itemName -outputPath $outputPath ) -item $item
    }
  }
  else
  {
    $outputfile = New_RegistryFile -FileName 'PuttyBundle' -outputPath $outputPath 
    foreach($item in $PuTTYSessions)
    {
      $itemName = Split-Path -Path $item -Leaf
      Export_SessionToFile -outputfile $outputfile -item $item
    }
  }
}