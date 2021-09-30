Function Show-PuTTYSessions 
{
  [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Low',
      DefaultParameterSetName = 'Default'
  )]

  Param
  ([Parameter(
        Position = 0
    )]
    [Alias('session')]
    [ValidateSet('All','User','Built-In')]
    [string]$SessionType = 'All'
  )
  
  DynamicParam {
    if ($SessionType -eq 'User') 
    {
      $UserSessionAttribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
      $UserSessionAttribute.Position = 1
      $UserSessionAttribute.Mandatory = $true
      $UserSessionAttribute.HelpMessage = 'Enter Session Name'
      $UserSessionCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
      $UserSessionCollection.Add($UserSessionAttribute)
      $UserSession = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('SessionName', [String], $UserSessionCollection)
      $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
      $paramDictionary.Add('SessionName', $UserSession)
      return $paramDictionary
    }
  }
  
  Begin {
    $session = $PSBoundParameters.SessionName
    $HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
    $PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name 
    if($UserSession)
    {
      if ($PuTTYSessions -notcontains $session)
      {
        Write-Error 'Not a session name.  Try Using the - SessionType "All"' -ErrorAction Stop
      }
    }
    
    $SessionHash = @{}
    $NewLength = 0
    
  }
  
  Process{

    switch ($SessionType)
    {

      'Built-In' 
      {
        $PuTTYSessions  = $PuTTYSessions | Where-Object -FilterScript {
          $_ -Match 'Default'
        }
      }
      Default 
      {
        $PuTTYSessions  = $PuTTYSessions
      }
    }

    foreach($session in $PuTTYSessions)
    {
      $SessionName = (Get-ItemProperty -Path ('{0}\{1}' -f $HkcuPuttyReg,$session)).PSChildName
      $HostName = (Get-ItemProperty -Path ('{0}\{1}' -f $HkcuPuttyReg,$session)).HostName
      
      if(($HostName -eq $null) -or ($HostName -eq '')){
        $HostName = 'Blank'
      }
      if(($SessionName -eq $null) -or ($SessionName -eq '')){
        $SessionName = 'Blank'
      }
      $SessionHash.add($SessionName,$HostName )

      if($NewLength -lt ($SessionName.Length))
      {
        $NewLength = $SessionName.Length
      }
    }
  }
  
  End{
    if($SessionType -ne 'User'){
      $Padding = $NewLength + 5
      $SessionHash.keys | ForEach-Object -Process {
        $message = ("{0,-$Padding}{2}{1}" -f  $_, $SessionHash[$_], ' = ')
        Write-Output -InputObject $message
    }}
    else{
      Get-ItemProperty -Path ('{0}\{1}' -f $HkcuPuttyReg,$Session)
    }
  }
}