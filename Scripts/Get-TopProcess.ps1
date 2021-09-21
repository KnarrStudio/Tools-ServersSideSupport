Function Get-TopProcess
{
  param($Count = 10)

  Get-Process |
  Sort-Object -Property CPU -Descending |
  Microsoft.PowerShell.Utility\Select-Object -First $Count
}
