Function Show-PuTTYSessions #Complete
{
  <#
      .SYNOPSIS
      A quick list of saved PuTTY sessions

      .DESCRIPTION
      Searches the registry for all of the PuTTY sessions that you have saved and returns the session name, ip address and log file name and location..

      .PARAMETER NoHeading
      Removes the heading from the output.

      .EXAMPLE
      Show-PuTTYSessions

      Session Name         Hostname          Log File Name
      ============         ========          =============
      My Firewall          192.168.1.3       C:\temp\putty-&H-&Y&M&D-&T.log
      Foil                 192.168.0.4       putty.log
      Switch-Four          192.168.1.4       C:\temp\putty-&H-&Y&M&D-&T.log

      .EXAMPLE
      Show-PuTTYSessions -NoHeading
    
      My Firewall          192.168.1.3       C:\temp\putty-&H-&Y&M&D-&T.log
      Foil                 192.168.0.4       putty.log
      Switch-Four          192.168.1.4       C:\temp\putty-&H-&Y&M&D-&T.log

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Show-PuTTYSessions

      .INPUTS
      None.

      .OUTPUTS
      List to console.
  #>


  [CmdletBinding(
      SupportsShouldProcess,
  ConfirmImpact = 'Low')]

  Param
  (
    [Parameter(Position = 0)]
    [Switch]$NoHeading
  )
  
  Begin {
    
    $UnderlineHeading = '='
    $LogFileHeading = 'Log File Name'
    $HostHeading = 'Hostname'
    $SessionHeading = 'Session Name'
    function Show-HashOutput
    {
      param
      (
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to process')]
        [Object]$InputObject,
        [Parameter(Mandatory)]
        [int]$SessNamePad,
        [Parameter(Mandatory)]
        [int]$HostNamePad
      )
      process
      {

        Write-Output -InputObject  (('{0,{0}}{1,{1}}{4}' -f  ($SessNamePad), ($HostNamePad), $InputObject.Key, $InputObject.value['hostname'], $InputObject.value['logfilename']))    
      }
    }

    $BlankText = 'Blank'
    $RegPathFormat = '{0}\{1}'
    $session = $PSBoundParameters.SessionName
    $HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
    $PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name 
    $SessionHash = @{}
    $SessionObject = [PSCustomObject]@{
      PSTypeName = 'My.Object'
    }
    $null = @{}
    $SessionNameLength = 0
    $HostNameLength = 0
    $i = 0
  }
  Process{
    foreach($session in $PuTTYSessions)
    {
      $i++
      $SessionName = (Get-ItemProperty -Path ($RegPathFormat -f $HkcuPuttyReg, $session)).PSChildName
      $HostName = (Get-ItemProperty -Path ($RegPathFormat -f $HkcuPuttyReg, $session)).HostName
      $LogFileName = (Get-ItemProperty -Path ($RegPathFormat -f $HkcuPuttyReg, $session)).LogFileName 
      if(($HostName -eq $null) -or ($HostName -eq ''))
      {
        $HostName = $BlankText+$i
      }
      if(($SessionName -eq $null) -or ($SessionName -eq ''))
      {
        $SessionName = $BlankText+$i
      }
      if(($LogFileName -eq $null) -or ($LogFileName -eq ''))
      {
        $LogFileName = $BlankText+$i
      }
      $SessionHash.$SessionName = @{}
      $SessionHash.$SessionName.HostName = $HostName
      $SessionHash.$SessionName.LogFileName = $LogFileName
      if($SessionNameLength -lt ($SessionName.Length))
      {
        $SessionNameLength = $SessionName.Length
      }
      if($HostNameLength -lt ($HostName.Length))
      {
        $HostNameLength = $HostName.Length
      }
    }
    $null = $SessionHash | ConvertTo-Json
    <#    $SessionObject = [PSCustomObject]$SessionHash

        $TypeData = @{
        TypeName = 'My.Object'
        DefaultDisplayPropertySet = 'SessionName','Hostname'
        }
    Update-TypeData @TypeData#>
  }
  End{
    $SessNamePad = (0-$SessionNameLength -3)
    $HostNamePad = (-18)
    if(-not $NoHeading)
    {
      Write-Output -InputObject  (('{0,{0}}{1,{1}}{4}' -f  ($SessNamePad), ($HostNamePad), $SessionHeading, $HostHeading, $LogFileHeading))    
      Write-Output -InputObject  (('{0,{0}}{1,{1}}{4}' -f  ($SessNamePad), ($HostNamePad), $($UnderlineHeading*($SessionHeading).Length), $($UnderlineHeading*($HostHeading).Length), $($UnderlineHeading*($LogFileHeading).Length))    )
    }
    $SessionHash.GetEnumerator() | Show-HashOutput -SessNamePad $SessNamePad -HostNamePad $HostNamePad
  }
}
