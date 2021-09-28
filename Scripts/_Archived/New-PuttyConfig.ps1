function New-PuttyConfig
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
    [ValidateSet('Black','Blue','Green','Red','Yellow','Gray','White','Custom')] 
    $ForegroundColor = 'Default',
    [Parameter(Mandatory = $false, Position = 2,ParameterSetName = 'Default')]
    [ValidateSet('Black','Blue','Green','Red','Yellow','Gray','White','Custom')] 
    $BoldForegroundColor = 'Default',
    [Parameter(Mandatory = $false, Position = 3,ParameterSetName = 'Default')]
    [ValidateSet('Black','Blue','Green','Red','Yellow','Gray','White','Custom')] 
    $BackgroundColor = 'Default',
    [Parameter(Mandatory = $false, Position = 4,ParameterSetName = 'Default')]
    [ValidateSet('Black','Blue','Green','Red','Yellow','Gray','White','Custom')] 
    $BoldBackgroundColor = 'Default',
    [Parameter(Mandatory = $false, Position = 5,ParameterSetName = 'Default')]
    [ValidateScript({
          If($_ -match '^(0|[1-5][0-5]{1,3}),(0|[1-5][0-5]{1,3}),(0|[1-5][0-5]{1,3})$')
          {
            $true
          }
          Else
          {
            Throw 'Custom Color needs to be in "255,255,255" format'
          }
    })][String]$CustomColor,
    [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Template')]
    [Switch]$Template
    
  )

  if($Template)
  {
    '"HostName","IPAddress"' | Out-File $File
    return
  }

  $ColorSelection = @{
    'Black' = '0,0,0'
    'Blue' = '0,0,255'
    'Green' = '0,128,0'
    'Red'  = '255,0,0'
    'Yellow' = '255,255,0'
    'Gray' = '85,85,85'
    'White' = '255,255,255'
    'Custom' = $CustomColor
  }

  If($ForegroundColor -eq 'Default')
  {
    $Color0 = '255.255.255'
  }
  Else
  {
    $Color0 = $ColorSelection.$ForegroundColor
  }
      
  If($BoldForegroundColor -eq 'Default')
  {
    $Color1 = '255.255.255'
  }
  Else
  {
    $Color1 = $ColorSelection.$BoldForegroundColor
  }

  If($BackgroundColor -eq 'Default')
  {
    $Color2 = '0,0,0'
  }
  Else
  {
    $Color2 = $ColorSelection.$BackgroundColor
  }

  If($BoldBackgroundColor -eq 'Default')
  {
    $Color3 = '85,85,85'
  }
  Else
  {
    $Color3 = $ColorSelection.$BoldBackgroundColor
  }
   


  Write-Host -Object $Color0
  Write-Host -Object $Color1
  Write-Host -Object $Color2
  Write-Host -Object $Color3
}

New-PuttyConfig -File C:\temp\template.csv -ForegroundColor Blue
