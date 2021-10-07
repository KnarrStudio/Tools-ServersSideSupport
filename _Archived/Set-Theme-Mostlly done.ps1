

$ItemCount = 100
$ThemeSelection = $null

$PuTTYRegHash = @{
  LogFileName             = @{
    PropertyType = 'String'
    Value        = $PuttyLogFile
  }
  LogType                 = @{
    PropertyType = 'dword'
    Value        = 00000002
  }
  LogFileClash            = @{
    PropertyType = 'dword'
    Value        = -1
  }
  WinNameAlways           = @{
    PropertyType = 'dword'
    Value        = 00000001
  }
  WinTitle                = @{
    PropertyType = 'String'
    Value        = ''
  }
  TermWidth               = @{
    PropertyType = 'dword'
    Value        = 00000050
  }
  TermHeight              = @{
    PropertyType = 'dword'
    Value        = 00000018
  }
  Font                    = @{
    PropertyType = 'String'
    Value        = 'Courier New'
  }
  'Default Foreground'    = @{
    NounName     = 'Colour0'
    PropertyType = 'String'
    Value        = '123,456,789'
  }
  'Default Bold Forground' = @{
    NounName     = 'Colour1'
    PropertyType = 'String'
    Value        = '123,456,789'
  }
  'Default Background'    = @{
    NounName     = 'Colour2'
    PropertyType = 'String'
    Value        = '0,0,0'
  }
  'Default Bold Background' = @{
    NounName     = 'Colour3'
    PropertyType = 'String'
    Value        = '85,85,85'
  }
  'Cursor Text'           = @{
    NounName     = 'Colour4'
    PropertyType = 'String'
    Value        = '0,0,0'
  }
  'Cursor Colour'         = @{
    NounName     = 'Colour5 '
    PropertyType = 'String'
    Value        = '0,255,0'
  }
  'ANSI Black'            = @{
    NounName     = 'Colour6'
    PropertyType = 'String'
    Value        = '0,0,0'
  }
  'ANSI Black Bold'       = @{
    NounName     = 'Colour 7'
    PropertyType = 'String'
    Value        = '85,85,85'
  }
  'ANSI Red'              = @{
    NounName     = 'Colour 8'
    PropertyType = 'String'
    Value        = '187,0,0'
  }
  'ANSI Bold Red'         = @{
    NounName     = 'Colour9'
    PropertyType = 'String'
    Value        = '255,85,85'
  }
  'ANSI Green'            = @{
    NounName     = 'Colour10'
    PropertyType = 'String'
    Value        = '0,187,0'
  }
  'ANSI Green Bold'       = @{
    NounName     = 'Colour11'
    PropertyType = 'String'
    Value        = '85,255,85'
  }
  'ANSI Yellow'           = @{
    NounName     = 'Colour12'
    PropertyType = 'String'
    Value        = '187,187,0'
  }
  'ANSI Yellow Bold'      = @{
    NounName     = 'Colour13'
    PropertyType = 'String'
    Value        = '255,255,85'
  }
  'ANSI Blue'             = @{
    NounName     = 'Colour14'
    PropertyType = 'String'
    Value        = '0,0,187'
  }
  'ANSI Blue Bold'        = @{
    NounName     = 'Colour15'
    PropertyType = 'String'
    Value        = '85,85,255'
  }
  'ANSI Magenta'          = @{
    NounName     = 'Colour16'
    PropertyType = 'String'
    Value        = '187,0,187'
  }
  'ANSI Magenta Bold'     = @{
    NounName     = 'Colour17'
    PropertyType = 'String'
    Value        = '255,85,255'
  }
  'ANSI Cyan'             = @{
    NounName     = 'Colour18'
    PropertyType = 'String'
    Value        = '0,187,187'
  }
  'ANSI Cyan Bold'        = @{
    NounName     = 'Colour19'
    PropertyType = 'String'
    Value        = '85,255,255'
  }
  'ANSI White'            = @{
    NounName     = 'Colour20'
    PropertyType = 'String'
    Value        = '187,187,187'
  }
  'White Bold'            = @{
    NounName     = 'Colour21'
    PropertyType = 'String'
    Value        = '255,255,255'
  }
}
$RgbColor = @{
  'Black' = '0,0,0'
  'Blue' = '0,0,255'
  'Green' = '0,255,0'
  'Red'  = '255,0,0'
  'Yellow' = '255,255,0'
  'Gray' = '85,85,85'
  'White' = '255,255,255'
}
$ThemeHash = @{
  Saroja  = @{
    'Default Foreground' = '222,222,222'
    'Default Background' = '222,222,222'
    'Cursor Colour'    = '255,128,128'
    'Cursor Text'      = '255,128,128'
    ThemeSelection     = 'Saroja'
  }
  Lonnie  = @{
    'Default Foreground' = '0,255,255'
    'Default Background' = '255,0,255-lonnie'
    'Cursor Colour'    = '255,0,0'
    ThemeSelection     = 'Lonnie'
  }
  Default = @{
    'Default Foreground' = $RgbColor.Gray
    'Default Background' = $RgbColor.Black
    'Cursor Colour'    = $RgbColor.Gray
    ThemeSelection     = 'Default'
  }
  SIPR    = @{
    'Default Foreground' = $RgbColor.Gray
    'Default Background' = $RgbColor.Black
    'Cursor Colour'    = $RgbColor.Red
    ThemeSelection     = 'SIPR'
  }
  NIPR    = @{
    'Default Foreground' = $RgbColor.Gray
    'Default Background' = $RgbColor.Black
    'Cursor Colour'    = $RgbColor.Green
    ThemeSelection     = 'NIPR'
  }
}  #| ConvertTo-Json | Out-File C:\temp\PuttyTheme.json

$MenuItems = ($ThemeHash.GetEnumerator() | ForEach-Object -Process {
    $_.Key
})

$MenuSplat = @{
  Title     = 'Putty Theme and Reg File Builder'
  MenuItems = $MenuItems
}

function Set-RegistryValue
{
  <#
      .SYNOPSIS
      Set registry
  #>
 
  param
  (
    [Parameter(Mandatory,Position = 0)]
    [string]$SessionPath,
    [Parameter(Mandatory,Position = 1)]
    [string]$keyTitle,
    [Parameter(Mandatory,Position = 2)]
    [string]$PuTTYRegHash
  )
  
  $null = Set-ItemProperty -Path $SessionPath -Name $keyTitle -Value $PuTTYRegHash[$keyTitle].Value
}


function Show-AsciiMenu 
{
  <#
      .SYNOPSIS
      Describe purpose of "Show-AsciiMenu" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .PARAMETER Title
      Describe parameter -Title.

      .PARAMETER MenuItems
      Describe parameter -MenuItems.

      .PARAMETER TitleColor
      Describe parameter -TitleColor.

      .PARAMETER LineColor
      Describe parameter -LineColor.

      .PARAMETER MenuItemColor
      Describe parameter -MenuItemColor.

      .EXAMPLE
      Show-AsciiMenu -Title Value -MenuItems Value -TitleColor Value -LineColor Value -MenuItemColor Value
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Show-AsciiMenu

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>
  [CmdletBinding()]
  param
  (
    [string]$Title = 'Title',

    [String[]]$MenuItems = 'None',

    [string]$TitleColor = 'Red',

    [string]$LineColor = 'Yellow',

    [string]$MenuItemColor = 'Cyan'
  )
  Begin {
    # Set Variables
    $i = 1
    $Tab = "`t"
    $VertLine = '║'
    $Script:ItemCount = $MenuItems.Count

  
    function Write-HorizontalLine
    {
      param
      (
        [Parameter(Position = 0)]
        [string]
        $DrawLine = 'Top'
      )
      Switch ($DrawLine) {
        Top 
        {
          Write-Host -Object ('╔{0}╗' -f $HorizontalLine) -ForegroundColor $LineColor
        }
        Middle 
        {
          Write-Host -Object ('╠{0}╣' -f $HorizontalLine) -ForegroundColor $LineColor
        }
        Bottom 
        {
          Write-Host -Object ('╚{0}╝' -f $HorizontalLine) -ForegroundColor $LineColor
        }
      }
    }
    function Get-Padding
    {
      param
      (
        [Parameter(Mandatory, Position = 0)]
        [int]$Multiplier 
      )
      "`0"*$Multiplier
    }
    function Write-MenuTitle
    {
      Write-Host -Object ('{0}{1}' -f $VertLine, $TextPadding) -NoNewline -ForegroundColor $LineColor
      Write-Host -Object ($Title) -NoNewline -ForegroundColor $TitleColor
      if($TotalTitlePadding % 2 -eq 1)
      {
        $TextPadding = Get-Padding -Multiplier ($TitlePaddingCount + 1)
      }
      Write-Host -Object ('{0}{1}' -f $TextPadding, $VertLine) -ForegroundColor $LineColor
    }
    function Write-MenuItems
    {
      foreach($menuItem in $MenuItems)
      {
        $number = $i++
        $ItemPaddingCount = $TotalLineWidth - $menuItem.Length - 6 #This number is needed to offset the Tab, space and 'dot'
        $ItemPadding = Get-Padding -Multiplier $ItemPaddingCount
        Write-Host -Object $VertLine  -NoNewline -ForegroundColor $LineColor
        Write-Host -Object ('{0}{1}. {2}{3}' -f $Tab, $number, $menuItem, $ItemPadding) -NoNewline -ForegroundColor $LineColor
        Write-Host -Object $VertLine -ForegroundColor $LineColor
      }
    }
  }

  Process {
    $TitleCount = $Title.Length
    $LongestMenuItemCount = ($MenuItems | Measure-Object -Maximum -Property Length).Maximum
    Write-Debug -Message ('LongestMenuItemCount = {0}' -f $LongestMenuItemCount)

    if  ($TitleCount -gt $LongestMenuItemCount)
    {
      $ItemWidthCount = $TitleCount
    }
    else
    {
      $ItemWidthCount = $LongestMenuItemCount
    }

    if($ItemWidthCount % 2 -eq 1)
    {
      $ItemWidth = $ItemWidthCount + 1
    }
    else
    {
      $ItemWidth = $ItemWidthCount
    }
    Write-Debug -Message ('Item Width = {0}' -f $ItemWidth)
   
    $TotalLineWidth = $ItemWidth + 10
    Write-Debug -Message ('Total Line Width = {0}' -f $TotalLineWidth)
  
    $TotalTitlePadding = $TotalLineWidth - $TitleCount
    Write-Debug -Message ('Total Title Padding  = {0}' -f $TotalTitlePadding)
  
    $TitlePaddingCount = [math]::Floor($TotalTitlePadding / 2)
    Write-Debug -Message ('Title Padding Count = {0}' -f $TitlePaddingCount)

    $HorizontalLine = '═'*$TotalLineWidth
    $TextPadding = Get-Padding -Multiplier $TitlePaddingCount
    Write-Debug -Message ('Text Padding Count = {0}' -f $TextPadding.Length)


    Write-HorizontalLine -DrawLine Top
    Write-MenuTitle
    Write-HorizontalLine -DrawLine Middle
    Write-MenuItems
    Write-HorizontalLine -DrawLine Bottom
  }

  End {

  }
}

Show-AsciiMenu @MenuSplat
Do 
{
  $ThemeSelection = Read-Host -Prompt 'Select Number'
  [String]$PuttyThemeSelection = $MenuItems[$ThemeSelection-1]
}
Until($ThemeSelection -le $ItemCount)

Write-Host ('Theme Selected: {0}' -f $PuttyThemeSelection)

<#
    $TextColorRGB = $ThemeHash.$PuttyThemeSelection.'Default Foreground'
    #$BackgroundColorRGB = $ThemeHash.$PuttyThemeSelection.'Default Background'
    $BackgroundColorRGB = $ThemeHash.$PuttyThemeSelection.'Default Background'
    $CurserColorRGB = $ThemeHash.$PuttyThemeSelection.'Cursor Colour'
    $CurserTextRGB = $ThemeHash.$PuttyThemeSelection.'Cursor Text'
    $TextColorRGB
    $BackgroundColorRGB
    $CurserColorRGB 
#>
foreach($CustRegVal in $ThemeHash.$PuttyThemeSelection.Keys)
{
  if($CustRegVal -ne 'ThemeSelection')
  {
    Write-Host $CustRegVal
  $PuTTYRegHash.$CustRegVal.Value  = $ThemeHash.$PuttyThemeSelection.$CustRegVal
  }
}

$SessionName = '*'
$PuttyRegPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\'
$PuTTYSessions = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $SessionName)).Name)

foreach($CustRegVal in $ThemeHash.$PuttyThemeSelection.Keys)
{
  if($CustRegVal -ne 'ThemeSelection')
  {
    foreach($RegItem in $PuTTYSessions)
    {
      $SessionName = Split-Path -Path $RegItem -Leaf
      
      if($SessionName -ne 'Default%20Settings')
      {
        $SessionPath = $RegItem -replace 'HKEY_CURRENT_USER', 'HKCU:'
        
        <#foreach($keyTitle in $PuTTYRegHash.Keys)
        {      
          if(((Get-ItemProperty -Path $SessionPath -Name $($PuTTYRegHash[$keyTitle].NounName))) -ne $PuTTYRegHash[$keyTitle].Value)
              {
          #>           
          $KeyName = $($PuTTYRegHash[$keyName].NounName)
          $KeyValue = $($PuTTYRegHash[$keyTitle].Value) 
          Write-Host "SessionPath: $SessionPath "
            Write-Host "KeyTitle: $KeyName"
            Write-Host "PuttyRegHash: $KeyValue "
            Set-RegistryValue -SessionPath $SessionPath -keyTitle $KeyName -PuTTYRegHash $KeyValue 
          # }
        }
        #$null = Set-ItemProperty -Path $SessionPath -Name $PuTTYRegHash.($ThemeHash.$PuttyThemeSelection.$CustRegVal.'Default Background') -Value ($ThemeHash.$PuttyThemeSelection.Value)
      }
    }
  }

  

