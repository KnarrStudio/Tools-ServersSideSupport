# Compares two files and removes the lines that are the same


$DefaultTheme = (Get-Content -Path .\Default%20Settings.reg)
$NewTheme = (Get-Content -Path .\Alphabet.reg)

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

#Clean Up
Remove-Item $NewThemeFile -Force