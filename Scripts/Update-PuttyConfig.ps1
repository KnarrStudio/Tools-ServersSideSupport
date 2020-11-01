 <#
     'Black' = '0,0,0'
     'Blue' = '0,0,255'
     'Green' = '0,128,0'
     'Red'  = '255,0,0'
     'Yellow' = '255,255,0'
     'Gray' = '85,85,85'
     'White' = '255,255,255'
     'Custom' = $CustomColor
 #>
 


 $ThemeHash = @{
   Saroja   = @{
     TxtColor       = '0,255,255'
     BkColor        = '255,0,255'
     CrsrColor      = '255,0,0'
     ThemeSelection = 'Saroja'
   }
   Lonnie   = @{
     TxtColor       = '0,255,255'
     BkColor        = '255,0,255-lonnie'
     CrsrColor      = '255,0,0'
     ThemeSelection = 'Lonnie'
   }
   Default  = @{
     TxtColor       = '0,255,255'
     BkColor        = '255,0,255'
     CrsrColor      = '255,0,0'
     ThemeSelection = 'Default'
   }
   SIPR     = @{
     TxtColor       = '0,255,255'
     BkColor        = '255,0,255-sipr'
     CrsrColor      = '255,0,0'
     ThemeSelection = 'SIPR'
   }
   NIPR     = @{
     TxtColor       = '0,255,255'
     BkColor        = '255,0,255-nipr'
     CrsrColor      = '0,255,0'
     ThemeSelection = 'NIPR'
   }
   Default3 = @{
     TxtColor       = '0,255,255'
     BkColor        = '255,0,255-3'
     CrsrColor      = '255,0,0'
     ThemeSelection = 'Default'
   }
 }

 $MenuItems = ($ThemeHash.GetEnumerator() | ForEach-Object{$_.Key})


 $MenuSplat = @{
   Title     = 'Putty Theme and Reg File Builder'
   MenuItems = $MenuItems
 }

 $PuttyConfigSplat = @{
 }

 $ItemCount = 100
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
     [string]$PuttyTheme = 'Default',
     [Parameter(Mandatory = $false, Position = 2,ParameterSetName = 'Default')]
     [string]$TxtColor = 'Default',
     [Parameter(Mandatory = $false, Position = 3,ParameterSetName = 'Default')]
     [string]$BkColor = 'Default',
     [Parameter(Mandatory = $false, Position = 4,ParameterSetName = 'Default')]
     [string]$CurserColor = 'Default',
     [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Template')]
     [Switch]$CreateTemplate
    
   )

   if($CreateTemplate)
   {
     '"HostName","IPAddress"' | Out-File -FilePath $File -Force
     return
   }
  
  
 }

 Do 
 {
   #Show-AsciiMenu -Title 'Putty Reg File Builder' -MenuItems 'Saroja Theme', 'Lonnie Theme', 'Default Theme' #-Debug
   Show-AsciiMenu @MenuSplat
   $ThemeSelection = Read-Host -Prompt 'Select Number'
   [String]$PuttyThemeSelection = $MenuItems[$ThemeSelection-1]
 }
 Until($ThemeSelection -le $ItemCount)

 Write-Host ('Theme Selected: {0}' -f $PuttyThemeSelection)

 $TextColorRGB = $ThemeHash.$PuttyThemeSelection.TxtColor
 $BackgroundColorRGB = $ThemeHash.$PuttyThemeSelection.BkColor
 $CurserColorRGB = $ThemeHash.$PuttyThemeSelection.CrsrColor  
 $TextColorRGB
 $BackgroundColorRGB
 $CurserColorRGB 


 New-PuttyConfig -File $env:HOMEDRIVE\temp\Putty\Input.csv -TxtColor $TextColorRGB -BkColor $BackgroundColorRGB -CurserColor $CurserColorRGB 

   