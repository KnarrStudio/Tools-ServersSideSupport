Function Get-TopProcess
{
  param([int]$Amount = 10)

  Get-Process |
  Sort-Object -Property CPU -Descending | 
  Select-Object -First $Amount
}
