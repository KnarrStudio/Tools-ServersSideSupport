#requires -Version 3.0 -Modules NetTCPIP
function Test-OpenPort 
{
  <# 
 
      .SYNOPSIS
      Test-OpenPort is an advanced Powershell function. Test-OpenPort acts like a port scanner. 
 
      .DESCRIPTION
      Uses Test-NetConnection. Define multiple targets and multiple ports. 
 
      .PARAMETER
      Target
      Define the target by hostname or IP-Address. Separate them by comma. Default: localhost 
 
      .PARAMETER
      Port
      Mandatory. Define the TCP port. Separate them by comma. 
 
      .EXAMPLE
      Test-OpenPort -Target sid-500.com,cnn.com,10.0.0.1 -Port 80,443 
 
      .NOTES
      Author: Patrick Gruenauer
      Web:
      https://sid-500.com  
  #>
  param
  (
    [Parameter(Position = 0)]
    [string]$Targets = 'localhost',
    [Parameter(Mandatory, Position = 1, Helpmessage = 'Enter Port Numbers. Separate them by comma.')]
    [Object]$Ports
  )
  $result = @()
  foreach ($Target in $Targets)
  {
    foreach ($Port in $Ports)
    {
      $TestResult = Test-NetConnection -ComputerName $Target -Port $Port -WarningAction SilentlyContinue
      $result += New-Object -TypeName PSObject -Property ([ordered]@{
          'Target'      = $TestResult.ComputerName
          'RemoteAddress' = $TestResult.RemoteAddress
          'Port'        = $TestResult.RemotePort
          'Status'      = $TestResult.tcpTestSucceeded
      })
    }
  }
  Write-Output -InputObject $result
}
