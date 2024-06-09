function Copy-PuTTYsessionColour #Completed-New
{
  <#
    .SYNOPSIS
    Copies the colors of one session to one or many others.

    .DESCRIPTION
    Allows you to copy the colors of your session to other sessions that might have the same operation for you to help you stay organized.

    .EXAMPLE
    Copy-PuTTYsessionColour
    Opens the Grid view of all your saved settings.  Select the one you want to copy and click OK. On the next Grid-View select as many as you want to change and click OK.

    .NOTES
    None at this time
  #>


$PuTTYRegistryPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\{0}'
$DefaultColours = @{
  'Colour0' = '187,187,187'
  'Colour1' = '255,255,255'
  'Colour2' = '0,0,0'
  'Colour3' = '85,85,85'
  'Colour4' = '0,0,0'
  'Colour5' = '0,255,0'
  'Colour6' = '0,0,0'
  'Colour7' = '85,85,85'
  'Colour8' = '187,0,0'
  'Colour9' = '255,85,85'
  'Colour10' = '0,187,0'
  'Colour11' = '85,255,85'
  'Colour12' = '187,187,0'
  'Colour13' = '255,255,85'
  'Colour14' = '0,0,187'
  'Colour15' = '85,85,255'
  'Colour16' = '187,0,187'
  'Colour17' = '255,85,255'
  'Colour18' = '0,187,187'
  'Colour19' = '85,255,255'
  'Colour20' = '187,187,187'
  'Colour21' = '255,255,255'
}


$SessionNames = Get-ItemProperty -Path ($PuTTYRegistryPath -f '*') | Select-Object -Property @{  n = 'Saved Session'; e = {$_.pschildname }}
$SessionToCopy = $SessionNames | Out-GridView -Title 'Colours to Copy' -OutputMode Single
$SessionToChange = $SessionNames | Where-Object 'Saved Session' -NotMatch 'Default' | Out-GridView -Title 'Colours to Change' -OutputMode Multiple

foreach($sessionName in $SessionToChange)
{
  $SessionPath = ($PuTTYRegistryPath -f $sessionName)
    
  foreach($keyTitle in $DefaultColours.keys)
  {
    $Value = (Get-ItemProperty -Path ($PuTTYRegistryPath -f $SessionToCopy) -Name $keyTitle).$keyTitle
    $null = Set-ItemProperty -Path $SessionPath -Name $keyTitle -Value $Value
  }
}

<# Future Use
    $null = $ColourNames @{
    "Colour0"="Default Foreground" 
    "Colour1"="Default Bold Foreground"
    "Colour10"="ANSI Green"
    "Colour11"="ANSI Green Bold"
    "Colour12"="ANSI Yellow"
    "Colour13"="ANSI Yellow Bold"
    "Colour14"="ANSI Blue"
    "Colour15"="ANSI Blue Bold"
    "Colour16"="ANSI Magenta"
    "Colour17"="ANSI Magenta Bold"
    "Colour18"="ANSI Cyan"
    "Colour19"="ANSI Cyan Bold"
    "Colour2"="Default Background"  
    "Colour20"="ANSI White"
    "Colour21"="ANSI White Bold"
    "Colour3"="Default Bold Background"
    "Colour4"="Cursor Text"  
    "Colour5"="Cursor Color"
    "Colour6"="ANSI Black"
    "Colour7"="ANSI Black Bold" 
    "Colour8"="ANSI Red"
    "Colour9"="ANSI Red Bold"
    }
#>
}
Copy-PuTTYsessionColour
