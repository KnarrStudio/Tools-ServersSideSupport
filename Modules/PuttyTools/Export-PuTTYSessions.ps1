function Export-PuTTYSessions #Completed
{
  [CmdletBinding(PositionalBinding = $true,DefaultParameterSetName='Session Set')]
  param
  (
    [Parameter(Position = 0,ParameterSetName = 'Session Set')]
    [string]$SessionName = '*',
    [Parameter(Mandatory = $false,Position = 1,ParameterSetName = 'Session Set')]
    [Parameter(Mandatory = $false,Position = 0,ParameterSetName = 'Bundle Set')]
    [string]$OutputPath = (Get-Location).Path,
    [Parameter(Position = 1,ParameterSetName = 'Bundle Set')]
    [Switch]$Bundle
  )
  
  Begin{
    $PuttyRegPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\'
    $PuTTYSessions = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $SessionName)).Name)

    if(-not (Test-Path -Path $OutputPath))
    {
      Write-Warning -Message ("The path '{0}' was not found. Create path and run again. " -f $OutputPath)
      Break
    }

    function script:New_RegistryFile
    {
      <#
          .SYNOPSIS
          Creates new file
      #>
      param
      (
        [Parameter(Mandatory, Position = 0)]
        [String]$FileName,
        [Parameter(Mandatory)]
        [String]$OutputPath 
      )
      $FileRegHeader = 'Windows Registry Editor Version 5.00'  
      if(Test-Path -Path $OutputPath)
      {
        $outputfile = $('{0}\{1}.reg' -f $OutputPath, $FileName)
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
        [Parameter(Mandatory, Position = 0)]
        [String]$outputfile ,
        [Parameter(Mandatory, Position = 1)]
        [String]$item
      )
      ('[{0}]' -f $item) | Out-File -FilePath $outputfile -Append  # Output session header to file
      Get-ItemProperty -Path ('HKCU:{0}' -f $($item.TrimStart('HKEY_CURRENT_USER'))) | Out-File -FilePath $outputfile  -Append
    }
  }

  Process{
    if(-not $Bundle)
    {
      foreach($item in $PuTTYSessions)
      {
        $itemName = Split-Path -Path $item -Leaf
        Export_SessionToFile -outputfile $(New_RegistryFile  -FileName $itemName -outputPath $OutputPath ) -item $item
      }
    }
    else
    {
      $outputfile = New_RegistryFile -FileName 'PuttyBundle' -outputPath $OutputPath 
      foreach($item in $PuTTYSessions)
      {
        $itemName = Split-Path -Path $item -Leaf
        Export_SessionToFile -outputfile $outputfile -item $item
      }
    }
  }
  End{}
}
