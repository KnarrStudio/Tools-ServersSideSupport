function Copy-PuTTYSettings #Incomplete - inop
{
  param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [string]$SessionName
  )

  Write-Warning -Message 'This script is not complete.'
  Write-Host 'This will allow you to copy all of the settings from one session to all of the other sessions. ' -ForegroundColor Cyan
  Return
  
    function script:New_RegistryFile
    {
    <#
        .SYNOPSIS
        Creates new file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$FileName,
      [Parameter(Mandatory = $true)]
      [String]$outputPath 
    )
    $FileRegHeader = 'Windows Registry Editor Version 5.00'  
    if(Test-Path -Path $outputPath)
    {
      $outputfile = $('{0}\{1}.reg' -f $outputPath, $FileName)
    }
    if(Test-Path -Path $outputfile)
    {
      $outputfile = $outputfile.Replace('.reg',('({0}).reg' -f (Get-Date -Format yyMMdd)))
    }
    $FileRegHeader | Out-File -FilePath $outputfile -Force
    Return $outputfile
    }
    function script:Export_SessionToFile
    {
    <#
        .SYNOPSIS
        Export Reg Session to file
    #>
    param
    (
      [Parameter(Mandatory = $true, Position = 0)]
      [String]$outputfile ,
      [Parameter(Mandatory = $true, Position = 1)]
      [String]$item
    )
    ('[{0}]' -f $item) | Out-File -FilePath $outputfile -Append  # Output session header to file
    Get-ItemProperty -Path ('HKCU:{0}' -f $($item.TrimStart('HKEY_CURRENT_USER'))) | Out-File -FilePath $outputfile  -Append
    }
  
    $PuttyRegPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\'
  #$PuTTYSessions = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $SessionName)).Name)
    [System.Collections.ArrayList] $PuTTYSessions = @(Get-ChildItem -Path $PuttyRegPath -Name)
  $PuTTYSessions.Remove('Default%20Settings')
    #$HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
    #$PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name 
    

    foreach($item in $PuTTYSessions)
    {
    $PuttyRegPathSessions = '{0}{1}' -f $PuttyRegPath, $item
    $PuttyRegPathSessions
    #$itemName = Split-Path -Path $item -Leaf
    #Export_SessionToFile -outputfile $(New_RegistryFile  -FileName $itemName -outputPath $outputPath ) -item $item
    }



    $PuttyRegPathSessions | ForEach-Object -Process {
    $r = Get-ItemProperty -Path ('HKCU:{0}' -f $($_.TrimStart('HKEY_CURRENT_USER')))
    }
    }

function Set-PuTTYTheme #Completed
{
    <#
      .SYNOPSIS
      Allows users to set all of thier Putty Sessions to the same theme.  Currently only a few exist.

      .DESCRIPTION
      Allows users to set all of thier Putty Sessions to the same theme by making changes to HKEY_CURRENT_USER\SOFTWARE\SimonTatham\PuTTY\Sessions.
      

      .EXAMPLE
      Set-PuTTYTheme
      Displays a text based menu that you can choose a theme from.  It copies those colour settings to all of the saved putty sessions.

      ╔══════════════════════════════════════════╗
      ║     Putty Theme and Reg File Builder     ║
      ╠══════════════════════════════════════════╣
      ║	1. Default                               ║
      ║	2. Lonnie                                ║
      ║	3. NIPR                                  ║
      ║	4. Saroja                                ║
      ║	5. SIPR                                  ║
      ║	6. System                                ║
      ╚══════════════════════════════════════════╝
      Select Number: 1
      Theme Selected: Default


      .NOTES
      Current themes are stored in the script as a hash table.  Future features will be to use a json file for the themes

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Set-PuTTYTheme

      .INPUTS
      Only a path to the log file otherwise default is the "Temp" directory

      .OUTPUTS
      Changes the HKCU registy settings for all saved Putty sessions of only the currently logged on user.
    #>
    [cmdletbinding(DefaultParameterSetName = 'Default')]
    param
    (
    [Parameter(Position = 0)]
    [string]$LogPath = $env:TEMP
    )
    $ItemCount = 100
    $ThemeSelection = $null 
  $PuttyLogFile = ('{0}\putty-&H-&Y&M&D-&T.log' -f $LogPath)
    $SessionName = '*'
    $PuttyRegPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\'
  
    $PuTTYRegHash = @{
    LogFileName             = @{
    NounName     = 'LogFileName'
    PropertyType = 'String'
    Value        = $PuttyLogFile
    }
    LogType                 = @{
    NounName     = 'LogType'
    PropertyType = 'dword'
    Value        = 00000002
    }
    LogFileCache            = @{
    NounName     = 'LogFileCache'
    PropertyType = 'dword'
    Value        = -1
    }
    WinNameAlways           = @{
    NounName     = 'WinNameAlways'
    PropertyType = 'dword'
    Value        = 00000001
    }
    WinTitle                = @{
    NounName     = 'WinTitle'
    PropertyType = 'String'
    Value        = ''
    }
    TermWidth               = @{
    NounName     = 'TermWidth'
    PropertyType = 'dword'
    Value        = 00000050
    }
    TermHeight              = @{
    NounName     = 'TermHeight'
    PropertyType = 'dword'
    Value        = 00000018
    }
    Font                    = @{
    NounName     = 'Font'
    PropertyType = 'String'
    Value        = 'Courier New'
    }
  'Default Foreground'    = @{ 
    NounName     = 'Colour0'
    PropertyType = 'String'
    Value        = '187,187,187'
    }
  'Default Bold Forground' = @{
    NounName     = 'Colour1'
    PropertyType = 'String'
    Value        = '255,255,255'
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
    NounName     = 'Colour5'
    PropertyType = 'String'
    Value        = '0,255,0'
    }
  'ANSI Black'            = @{
    NounName     = 'Colour6'
    PropertyType = 'String'
    Value        = '0,0,0'
    }
  'ANSI Black Bold'       = @{
    NounName     = 'Colour7'
    PropertyType = 'String'
    Value        = '85,85,85'
    }
  'ANSI Red'              = @{
    NounName     = 'Colour8'
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
    UseSystemColours        = @{
    NounName = 'UseSystemColours'
    PropertyType = 'dword'
    Value        = 00000000
    }
    }
    $RgbColor = @{
  'Black' = '0,0,0'
  'Blue' = '0,0,255'
  'Green' = '0,255,0'
  'Red'  = '255,0,0'
  'Yellow' = '255,255,0'
  'DarkGray' = '85,85,85'
  'LightGray' = '187,187,187'
  'White' = '255,255,255'
    }
    $ThemeHash = @{
    Saroja    = @{
    'Default Foreground' = '222,222,222'
    'Default Background' = '222,222,222'
    'Cursor Colour'    = '255,128,128'
    'Cursor Text'      = '255,128,128'
    ThemeSelection     = 'Saroja'
    }
    Lonnie    = @{
    'Default Foreground' = $RgbColor.LightGray
    'Default Background' = $RgbColor.Blue
    'Cursor Colour'    = '255,0,255'
    'Cursor Text'      =  '255,0,255'
    'UseSystemColours' = 0
    ThemeSelection     = 'Lonnie'
    }
    Default   = @{
    'Default Foreground' = '187,187,187'
    'Default Background' = $RgbColor.Black
    'Cursor Colour'    = $RgbColor.LightGray
    'Cursor Text'      = $RgbColor.DarkGray
    'UseSystemColours' = 0
    ThemeSelection     = 'Default'
    }
    SIPR      = @{
    'Default Foreground' = $RgbColor.Red
    'Default Bold Forground' = $RgbColor.Black
    'Default Background' = $RgbColor.Black
    'Default Bold Background' = $RgbColor.Red
    'Cursor Colour'    = '255,0,0'
    'Cursor Text'      = $RgbColor.Red
    'UseSystemColours' = 0
    ThemeSelection     = 'SIPR'
    }
    NIPR      = @{
    'Default Foreground' = $RgbColor.Green
    'Default Bold Forground' = $RgbColor.Black
    'Default Background' = $RgbColor.Black
    'Default Bold Background' = $RgbColor.Green
    'Cursor Colour'    = '0,255,0'
    'Cursor Text'      = $RgbColor.Green
    'UseSystemColours' = 0
    ThemeSelection     = 'NIPR'
    }
    System = @{
    'UseSystemColours' = 1
    ThemeSelection     = 'System'
    }
    }  #| ConvertTo-Json | Out-File C:\temp\PuttyTheme.json

    <#
    $MenuItems = ($ThemeHash.GetEnumerator() | ForEach-Object -Process {
    $_.Key
    })
    #>
    $MenuItems = $ThemeHash.GetEnumerator().Name | Sort-Object

    $MenuSplat = @{
  Title     = 'Putty Theme and Reg File Builder'
    MenuItems = $MenuItems
    }
  
    function Script:Set_RegistryValue
    {
    <#
      .SYNOPSIS
      Set registry
    #>
    param
    (
    [Parameter(Mandatory,HelpMessage='Putty Saved Name',Position = 0)]
    [string]$SessionPath,
    [Parameter(Mandatory,HelpMessage='Hash Key',Position = 1)]
    [string]$keyTitle,
    [Parameter(Mandatory,HelpMessage='Hash to pass',Position = 2)]
    [string]$PuTTYRegHash
    )
    $null = Set-ItemProperty -Path $SessionPath -Name $keyTitle -Value $PuTTYRegHash[$keyTitle].Value
    }
    function Script:Show_AsciiMenu 
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
      <#
          .SYNOPSIS
          Internal function to write Horizontal Line for menu
      #>
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
      <#
          .SYNOPSIS
          Internal function to calculate spacing
      #>
      param
      (
        [Parameter(Mandatory,HelpMessage='Number of times to multiply. Most often as String.length()', Position = 0)]
        [int]$Multiplier 
      )
      "`0"*$Multiplier
    }
    function Write-MenuTitle
    {
      <#
          .SYNOPSIS
          Internal function to write menu title
      #>    
      Write-Host -Object ('{0}{1}' -f $VertLine, $TextPadding) -NoNewline -ForegroundColor $LineColor
      Write-Host -Object ($Title) -NoNewline -ForegroundColor $TitleColor
      if(($TotalTitlePadding % 2) -eq 1)
      {
        $TextPadding = Get-Padding -Multiplier ($TitlePaddingCount + 1)
      }
      Write-Host -Object ('{0}{1}' -f $TextPadding, $VertLine) -ForegroundColor $LineColor
    }
    function Write-MenuItems
    {
      <#
          .SYNOPSIS
          Internal function to write menu items
      #>
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
  
    Show_AsciiMenu @MenuSplat
    Do 
    {
  $ThemeSelection = Read-Host -Prompt 'Select Number'
    [String]$PuttyThemeSelection = $MenuItems[$ThemeSelection-1]
  Write-Verbose -Message ('ThemeSelection: {0}' -f $ThemeSelection)
    }
    Until($ThemeSelection -le $ItemCount)
  Write-Output -InputObject ('Theme Selected: {0}' -f $PuttyThemeSelection)
  
    [Collections.ArrayList] $PuTTYSessions = @(Get-ChildItem -Path $PuttyRegPath -Name)
  $PuTTYSessions.Remove('Default%20Settings')
    foreach($RegItem in $PuTTYSessions) # Loops through all of the Putty Sessions in the Registry
    {
  $SessionName = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $RegItem)).Name)
  $SessionPath = $SessionName -replace 'HKEY_CURRENT_USER', 'HKCU:'
  
    foreach($CustRegVal in $PuTTYRegHash.Keys) # Keys from the default settings
    {
      if($CustRegVal -ne 'ThemeSelection') # Prevents processing of the Theme Name
      {
        $KeyName = $PuTTYRegHash.$CustRegVal.NounName
        $KeyValue = $PuTTYRegHash.$CustRegVal.Value
        $null = Set-ItemProperty -Path $SessionPath -Name $KeyName -Value $KeyValue  # Sets the value in the registry
      }
    }
    }
    if($PuttyThemeSelection -ne 'Default'){
      foreach($CustRegVal in $ThemeHash.$PuttyThemeSelection.Keys) # CustomRegistryValue in the ThemeSelection
      {
        if($CustRegVal -ne 'ThemeSelection') # Prevents processing of the Theme Name
        {
          $KeyName = $PuTTYRegHash.$CustRegVal.NounName
          $KeyValue = $ThemeHash.$PuttyThemeSelection.$CustRegVal
          $PuTTYRegHash.$CustRegVal.Value = $ThemeHash.$PuttyThemeSelection.$CustRegVal
          Write-Verbose -Message ('SessionPath: {0} ' -f $SessionPath)
          Write-Verbose -Message ('KeyTitle: {0}' -f $KeyName)
          Write-Verbose -Message ('PuttyRegHash: {0} ' -f $KeyValue)
          $null = Set-ItemProperty -Path $SessionPath -Name $KeyName -Value $KeyValue  # Sets the value in the registry
        }
      }
    }
}

Function Show-PuTTYSessions #Completed
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

  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]

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
    function Script:Show_HashOutput
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

        Write-Output -InputObject ("{0,$($SessNamePad)}{1,$($HostNamePad)}{2}" -f $InputObject.Key, $($InputObject.value['hostname']), $($InputObject.value['logfilename']))
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
    $HostNamePad = (0-$HostNameLength-3)
    if(-not $NoHeading)
    {
      Write-Output -InputObject ("{0,$($SessNamePad)}{1,$($HostNamePad)}{2}" -f  $SessionHeading, $HostHeading, $LogFileHeading)    
      Write-Output -InputObject  ("{0,$($SessNamePad)}{1,$($HostNamePad)}{2}" -f  $($UnderlineHeading*($SessionHeading).Length), $($UnderlineHeading*($HostHeading).Length), $($UnderlineHeading*($LogFileHeading).Length))  
    }
    $SessionHash.GetEnumerator() | Script:Show_HashOutput -SessNamePad $SessNamePad -HostNamePad $HostNamePad
  }
}

function New-PuttySessionsRegistryFile #Completed
{
  <#
      .SYNOPSIS
      Creates a registry file that can be merged and transported from a list of hostnames and ip addresses

      .DESCRIPTION
      Creates a registry file with the default PuTTy settings that can be merged and transported.
      Requires an import file as a csv and an output location.  
      If you don't know how to format the input file use the "CreateTemplate" switch to build out a template file to edit.


      .PARAMETER InputFileName
      This is the csv file that contains the Session Titles (Often hostname) and IP addresses of the putty sessions you want to import

      .PARAMETER OutputFolder
      Where you want the output file to be saved

      .PARAMETER CreateTemplate
      Used to create an example csv inputfile 

      .EXAMPLE
      New-PuttySessionsRegistryFile -InputFileName Value -OutputFolder Value
      Will create an MS registry file (.reg) based on the inputfilename and save it in the outputfolder

      .EXAMPLE
      New-PuttySessionsRegistryFile -CreateTemplate -OutputFolder Value
      Creates a sample/example input file and saves it as "InputFileExample.csv" in the outputfolder

      .NOTES
      None at this time.

      .LINK
      None

      .INPUTS
      A CSV file with hostname and IP address

      .OUTPUTS
      Either a registry (.reg) file or a comma separated value (.csv) file
  #>
  [cmdletbinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory, HelpMessage = 'Import file in CSV format. See the "CreateTemplate" switch ', Position = 0,ParameterSetName = 'Default')]
    [ValidateScript({
          If($_ -match '.csv')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be CSV formatted with "HostName" , "IPAddress".  Use -CreateTemplate switch to build a template file.'
          }
    })][String]$InputFileName,
    [Parameter(Position = 1,ParameterSetName = 'Default')]
    [Parameter(Mandatory, HelpMessage = 'Location to put the example file', Position = 1,ParameterSetName = 'Template')]
    [String]$OutputFolder = (Get-Location).path,
    [Parameter(ParameterSetName = 'Template')]
    [Switch]$CreateTemplate
  )
  
  #$PuttyLogFile = ('{0}\putty-&H-&Y&M&D-&T.log' -f $LogPath)
  $OutputFileName = ('PuttySessions-{0}_{1}.reg' -f $env:USERNAME, $(Get-Date -UFormat %j))#%H%M%S))
  #$RegFile = (New-Item -Path ('{2}\PuttySessions -{0}- ({1}).reg' -f $env:USERNAME, $(Get-Date -UFormat %j%H%M%S), "$env:userprofile\Desktop") -ItemType File -Force)
  if($CreateTemplate)
  {
    $FileTemplate = @'
"HostName","IPAddress"
"Switch-42","192.168.0.42"
'@
    $FileTemplate | Out-File -FilePath $('{0}\InputFileExample.csv' -f $OutputFolder) -Force
    return
  }
   
  try # Try to import the csv file
  {
    if(-not $CreateTemplate)
    {
      $ImportedData = Import-Csv -Path $InputFileName -ErrorAction Stop
    }
  }
  catch
  {
    $FileTemplate = @'
"HostName","IPAddress"
"Switch-42","192.168.0.42"

-- We couldn't find your input file where you told us it would be, so we created this example for you. --
-- Double check your file path and run again, or make changes to this file, save it and run it again. --
'@
    $FileTemplate | Out-File -FilePath $InputFileName -Force
    'File path: {0}\{1}' -f $(Get-Location), $InputFileName | Out-File -FilePath $InputFileName -Append
    Start-Process -FilePath notepad -ArgumentList $InputFileName
    return
  }
  function script:New_RegistryFile
  {
    <#
        .SYNOPSIS
        Creates new file
    #>
    param
    (
      [Parameter(Mandatory, Position = 0)]
      [String]$FileName ,
      [Parameter(Mandatory)]
      [String]$outputPath
    )
    $FileExt = '.reg'
    $i = 1
    if(-not $FileName.EndsWith($FileExt))
    {
      $FileName = '{0}.reg' -f $FileName
    } 
    if(-not (Test-Path -Path $outputPath))
    {
      New-Item -Path $outputPath -ItemType Directory
    }
    $outputPath  = (Get-Item -Path $outputPath).FullName
    $outputfile = $('{0}\{1}' -f $outputPath, $FileName)
    if(Test-Path -Path $outputfile)
    {
      $outputfile = $outputfile.Replace($FileExt,('({0}).reg' -f $i))
    }
    while(Test-Path -Path $outputfile)
    {
      $match = Select-String -Pattern '([\(]\d+[\)])' -InputObject $outputfile
      $inc = [int](($match.matches.groups[1].Value).Split('(')).Split(')')[1]+1
      [String]$outputfile = $outputfile.Replace("($($inc-1))","($inc)")
    }
    New-Item -Path $outputfile -ItemType File -Force
    Return $outputfile
  }
  
  $RegistryFile = (New_RegistryFile -FileName $OutputFileName  -outputPath $OutputFolder).FullName
  'Windows Registry Editor Version 5.00' | Out-File -FilePath $RegistryFile 
  
  foreach($Device in $ImportedData)
  {
    $SessionName = $Device.HostName
    $SessionIP = $Device.IPAddress
    $PuttyBlurb = (@'

[HKEY_CURRENT_USER\Software\Simontatham\PuTTY\Sessions\{0}]
"Present"=dword:00000001
"HostName"="{1}"
"LogFileName"="C:\\Temp\\putty-&H-&Y&M&D-&T.log"
"LogType"=dword:00000000
"LogFileClash"=dword:ffffffff
"LogFlush"=dword:00000001
"LogHeader"=dword:00000001
"SSHLogOmitPasswords"=dword:00000001
"SSHLogOmitData"=dword:00000000
"Protocol"="ssh"
"PortNumber"=dword:00000016
"CloseOnExit"=dword:00000001
"WarnOnClose"=dword:00000001
"PingInterval"=dword:00000000
"PingIntervalSecs"=dword:00000000
"TCPNoDelay"=dword:00000001
"TCPKeepalives"=dword:00000000
"TerminalType"="xterm"
"TerminalSpeed"="38400,38400"
"TerminalModes"="CS7=A,CS8=A,DISCARD=A,DSUSP=A,ECHO=A,ECHOCTL=A,ECHOE=A,ECHOK=A,ECHOKE=A,ECHONL=A,EOF=A,EOL=A,EOL2=A,ERASE=A,FLUSH=A,ICANON=A,ICRNL=A,IEXTEN=A,IGNCR=A,IGNPAR=A,IMAXBEL=A,INLCR=A,INPCK=A,INTR=A,ISIG=A,ISTRIP=A,IUCLC=A,IUTF8=A,IXANY=A,IXOFF=A,IXON=A,KILL=A,LNEXT=A,NOFLSH=A,OCRNL=A,OLCUC=A,ONLCR=A,ONLRET=A,ONOCR=A,OPOST=A,PARENB=A,PARMRK=A,PARODD=A,PENDIN=A,QUIT=A,REPRINT=A,START=A,STATUS=A,STOP=A,SUSP=A,SWTCH=A,TOSTOP=A,WERASE=A,XCASE=A"
"AddressFamily"=dword:00000000
"ProxyExcludeList"=""
"ProxyDNS"=dword:00000001
"ProxyLocalhost"=dword:00000000
"ProxyMethod"=dword:00000000
"ProxyHost"="proxy"
"ProxyPort"=dword:00000050
"ProxyUsername"=""
"ProxyPassword"=""
"ProxyTelnetCommand"="connect %host %port\\n"
"ProxyLogToTerm"=dword:00000001
"Environment"=""
"UserName"=""
"UserNameFromEnvironment"=dword:00000000
"LocalUserName"=""
"NoPTY"=dword:00000000
"Compression"=dword:00000000
"TryAgent"=dword:00000001
"AgentFwd"=dword:00000000
"GssapiFwd"=dword:00000000
"ChangeUsername"=dword:00000000
"Cipher"="aes,chacha20,3des,WARN,des,blowfish,arcfour"
"KEX"="ecdh,dh-gex-sha1,dh-group14-sha1,rsa,WARN,dh-group1-sha1"
"HostKey"="ed25519,ecdsa,rsa,dsa,WARN"
"PreferKnownHostKeys"=dword:00000001
"RekeyTime"=dword:0000003c
"GssapiRekey"=dword:00000002
"RekeyBytes"="1G"
"SshNoAuth"=dword:00000000
"SshBanner"=dword:00000001
"AuthTIS"=dword:00000000
"AuthKI"=dword:00000001
"AuthGSSAPI"=dword:00000001
"AuthGSSAPIKEX"=dword:00000001
"GSSLibs"="gssapi32,sspi,custom"
"GSSCustom"=""
"SshNoShell"=dword:00000000
"SshProt"=dword:00000003
"LogHost"=""
"SSH2DES"=dword:00000000
"PublicKeyFile"=""
"RemoteCommand"=""
"RFCEnviron"=dword:00000000
"PassiveTelnet"=dword:00000000
"BackspaceIsDelete"=dword:00000001
"RXVTHomeEnd"=dword:00000000
"LinuxFunctionKeys"=dword:00000000
"NoApplicationKeys"=dword:00000000
"NoApplicationCursors"=dword:00000000
"NoMouseReporting"=dword:00000000
"NoRemoteResize"=dword:00000000
"NoAltScreen"=dword:00000000
"NoRemoteWinTitle"=dword:00000000
"NoRemoteClearScroll"=dword:00000000
"RemoteQTitleAction"=dword:00000001
"NoDBackspace"=dword:00000000
"NoRemoteCharset"=dword:00000000
"ApplicationCursorKeys"=dword:00000000
"ApplicationKeypad"=dword:00000000
"NetHackKeypad"=dword:00000000
"AltF4"=dword:00000001
"AltSpace"=dword:00000000
"AltOnly"=dword:00000000
"ComposeKey"=dword:00000000
"CtrlAltKeys"=dword:00000001
"TelnetKey"=dword:00000000
"TelnetRet"=dword:00000001
"LocalEcho"=dword:00000002
"LocalEdit"=dword:00000002
"Answerback"="PuTTY"
"AlwaysOnTop"=dword:00000000
"FullScreenOnAltEnter"=dword:00000000
"HideMousePtr"=dword:00000000
"SunkenEdge"=dword:00000000
"WindowBorder"=dword:00000001
"CurType"=dword:00000000
"BlinkCur"=dword:00000000
"Beep"=dword:00000001
"BeepInd"=dword:00000000
"BellWaveFile"=""
"BellOverload"=dword:00000001
"BellOverloadN"=dword:00000005
"BellOverloadT"=dword:000007d0
"BellOverloadS"=dword:00001388
"ScrollbackLines"=dword:000007d0
"DECOriginMode"=dword:00000000
"AutoWrapMode"=dword:00000001
"LFImpliesCR"=dword:00000000
"CRImpliesLF"=dword:00000000
"DisableArabicShaping"=dword:00000000
"DisableBidi"=dword:00000000
"WinNameAlways"=dword:00000001
"WinTitle"=""
"TermWidth"=dword:00000050
"TermHeight"=dword:00000018
"Font"="Courier New"
"FontIsBold"=dword:00000000
"FontCharSet"=dword:00000000
"FontHeight"=dword:0000000a
"FontQuality"=dword:00000000
"FontVTMode"=dword:00000004
"UseSystemColours"=dword:00000000
"TryPalette"=dword:00000000
"ANSIColour"=dword:00000001
"Xterm256Colour"=dword:00000001
"TrueColour"=dword:00000001
"BoldAsColour"=dword:00000001
"Colour0"="187,187,187"
"Colour1"="255,255,255"
"Colour2"="0,0,0"
"Colour3"="85,85,85"
"Colour4"="0,0,0"
"Colour5"="0,255,0"
"Colour6"="0,0,0"
"Colour7"="85,85,85"
"Colour8"="187,0,0"
"Colour9"="255,85,85"
"Colour10"="0,187,0"
"Colour11"="85,255,85"
"Colour12"="187,187,0"
"Colour13"="255,255,85"
"Colour14"="0,0,187"
"Colour15"="85,85,255"
"Colour16"="187,0,187"
"Colour17"="255,85,255"
"Colour18"="0,187,187"
"Colour19"="85,255,255"
"Colour20"="187,187,187"
"Colour21"="255,255,255"
"RawCNP"=dword:00000000
"UTF8linedraw"=dword:00000000
"PasteRTF"=dword:00000000
"MouseIsXterm"=dword:00000000
"RectSelect"=dword:00000000
"PasteControls"=dword:00000000
"MouseOverride"=dword:00000001
"Wordness0"="0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
"Wordness32"="0,1,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1"
"Wordness64"="1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,2"
"Wordness96"="1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1"
"Wordness128"="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
"Wordness160"="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
"Wordness192"="2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2"
"Wordness224"="2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2"
"MouseAutocopy"=dword:00000001
"MousePaste"="explicit"
"CtrlShiftIns"="explicit"
"CtrlShiftCV"="none"
"LineCodePage"=""
"CJKAmbigWide"=dword:00000000
"UTF8Override"=dword:00000001
"Printer"=""
"CapsLockCyr"=dword:00000000
"ScrollBar"=dword:00000001
"ScrollBarFullScreen"=dword:00000000
"ScrollOnKey"=dword:00000000
"ScrollOnDisp"=dword:00000001
"EraseToScrollback"=dword:00000001
"LockSize"=dword:00000000
"BCE"=dword:00000001
"BlinkText"=dword:00000000
"X11Forward"=dword:00000000
"X11Display"=""
"X11AuthType"=dword:00000001
"X11AuthFile"=""
"LocalPortAcceptAll"=dword:00000000
"RemotePortAcceptAll"=dword:00000000
"PortForwardings"=""
"BugIgnore1"=dword:00000000
"BugPlainPW1"=dword:00000000
"BugRSA1"=dword:00000000
"BugIgnore2"=dword:00000000
"BugHMAC2"=dword:00000000
"BugDeriveKey2"=dword:00000000
"BugRSAPad2"=dword:00000000
"BugPKSessID2"=dword:00000000
"BugRekey2"=dword:00000000
"BugMaxPkt2"=dword:00000000
"BugOldGex2"=dword:00000000
"BugWinadj"=dword:00000000
"BugChanReq"=dword:00000000
"StampUtmp"=dword:00000001
"LoginShell"=dword:00000001
"ScrollbarOnLeft"=dword:00000000
"BoldFont"=""
"BoldFontIsBold"=dword:00000000
"BoldFontCharSet"=dword:00000000
"BoldFontHeight"=dword:00000000
"WideFont"=""
"WideFontIsBold"=dword:00000000
"WideFontCharSet"=dword:00000000
"WideFontHeight"=dword:00000000
"WideBoldFont"=""
"WideBoldFontIsBold"=dword:00000000
"WideBoldFontCharSet"=dword:00000000
"WideBoldFontHeight"=dword:00000000
"ShadowBold"=dword:00000000
"ShadowBoldOffset"=dword:00000001
"SerialLine"="COM1"
"SerialSpeed"=dword:00002580
"SerialDataBits"=dword:00000008
"SerialStopHalfbits"=dword:00000002
"SerialParity"=dword:00000000
"SerialFlowControl"=dword:00000001
"WindowClass"=""
"ConnectionSharing"=dword:00000000
"ConnectionSharingUpstream"=dword:00000001
"ConnectionSharingDownstream"=dword:00000001
"SSHManualHostKeys"=""

'@ -f $SessionName, $SessionIP)
    $PuttyBlurb | Out-File -FilePath $RegistryFile -Append 
  } 
}

function New-PuTTYSessions #Completed-New
{
  <#
      .SYNOPSIS
      A simple way to import the switches or devices into PuTTY for the first time or update the current list.

      .DESCRIPTION
      Reads a CSV file with "Hostname","IPAddress" columns and builds PuTTY "Sessions" which are added to the registry of the current user.  
      Adds to the registry 'HKCU:\Software\Simontatham\PuTTY\Sessions\'   
      From this point you can use PuTTY as normal

      .PARAMETER File
      The CSV formatted file with the hostnames and IPs. (Hint: See the 'CreateTemplate' switch)

      .PARAMETER LogPath
      By default it will put the file in $env:TEMP

      .PARAMETER CreateTemplate
      This will create the file template for you.  
      To ensure that you build the CSV file correctly.  
      Then you can edit it

      .EXAMPLE
      Import-PuTTYSessions -File Value.csv
      Standard import of sessions.  The first thing to run when you arrive at your new computer.

      .EXAMPLE
      Import-PuTTYSessions -File Value.csv -CreateTemplate
      Will write an example into "value.csv"
    

      .EXAMPLE
      Import-PuTTYSessions -File Value -LogPath Value
      Imports the PuTTY sessions and sets the putty log location to "Value"

      .NOTES
      Often the only module you will need to get your PuTTY operational in your environment.
      There is an assumption that your data is good and therefore there is no error checking, so Hostname "P@55Word" IP "999.123.000.333" will populate the registry, but obviously not work when called.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Import-PuTTYSessions

      .INPUTS
      .csv file with hostname and IP address.

      .OUTPUTS
      Registry keys based on the data in the csv file.
  #>
  [cmdletbinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory, HelpMessage = 'Import file in CSV format. See the "CreateTemplate" switch ', Position = 0,ParameterSetName = 'Default')]
    [Parameter(Mandatory, HelpMessage = 'Import file in CSV format ',  Position = 0,ParameterSetName = 'Template')]
    [ValidateScript({
          If($_ -match '.csv')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be CSV formatted with "HostName" , "IPAddress".  Use -CreateTemplate switch to build a template file.'
          }
    })][String]$ImportCsvFile,
    [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Template')]
    [Switch]$CreateTemplate
  )
  try
  {
    if(-not $CreateTemplate)
    {
      $ImportedData = Import-Csv -Path $ImportCsvFile -ErrorAction Stop
    }
  }
  catch [System.IO.DirectoryNotFoundException] 
  {
    Write-Output -InputObject 'Directory Not Found Exception'
  }
  catch [System.IO.IOException], [System.IO.FileNotFoundException] 
  {
    Write-Output -InputObject 'Input File Not Found. Check the file path.'
  }
  if($CreateTemplate)
  {
    $FileTemplate = @'
"HostName","IPAddress","LogPath"
"Switch-42","192.168.0.42","C:\Temp\PuttyLogs"
'@
    $FileTemplate | Out-File -FilePath "$env:systemdrive\Temp" -Force
    Start-Process -FilePath notepad -ArgumentList $File
    return
  }
  foreach($Device in $ImportedData)
  {
    $SessionName = $Device.HostName
    $SessionIP = $Device.IPAddress
    $LogPath = ($Device.LogPath).trim('\ ')
    $PuttyLogFile = ('{0}\putty-&H-&Y&M&D-&T.log' -f $LogPath)
    $SessionPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\{0}' -f $SessionName
    Write-Verbose -Message ('Session: {0}' -f $SessionPath)
    
    if(-not (Test-Path -Path $SessionPath))
    {
      $null = New-Item -Path $SessionPath -Value $null
      $null = Set-ItemProperty -Path $SessionPath -Name HostName -Value $SessionIP
      $null = Set-ItemProperty -Path $SessionPath -Name LogFileName -Value $PuttyLogFile
    }
  }
}

function Import-PuTTYSessions #Completed-Updated
{
  <#
      .SYNOPSIS
      A simple way to import the switches or devices into PuTTY from an exported .REG file.

      .DESCRIPTION
      Reads an exported reg file and imports it.  The exported file can be from either the GUI or Export-PuTTYsessions script.

      .PARAMETER $ImportFile
      The exported .REG file

      .EXAMPLE
      Import-PuTTYSessions -File Value.csv
      Standard import of sessions.  The first thing to run when you arrive at your new computer.

      .EXAMPLE
      Import-PuTTYSessions -ImportFile .\Bundle3.reg

  #>
  [cmdletbinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Mandatory, HelpMessage = 'Import file in CSV format ',  Position = 0)]
    [ValidateScript({
          If($_ -match '.reg')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be REG file.'
          }
    })][String]$ImportFile
  )
 
  $regexe = "$env:windir\system32\reg.exe"
  $arguments = "import $ImportFile"
  Start-Process -FilePath $regexe -ArgumentList $arguments -NoNewWindow
}

function Export-PuTTYSessions #Completed-Updated
{
  param
  (
    [Parameter(Mandatory,Position = 0)]
    [string]$outputFile
  )
  
  $PuttyRegPath = 'HKCU\Software\Simontatham\PuTTY\Sessions\'
  $regexe = "$env:windir\system32\reg.exe"
  $arguments = "export $PuttyRegPath $outputFile"
  Start-Process -FilePath $regexe -ArgumentList $arguments -NoNewWindow
  
}
 
function Connect-PuTTYSession #Completed
{
  <#
      .SYNOPSIS
      Allows you to open one or many putty session via Powershell

      .DESCRIPTION
      Reads the registry for the available sessions and then presents them to you in a grid that you can select and open
    
      .PARAMETER LoginName
      If you have a bunch of switches, you can use this to populate the "login" field.  You can use "$env:username" or "root"

      .PARAMETER PuttyPath
      Full path to the location of the PuTTY.exe

      .EXAMPLE
      Start-PuttySessions -LoginName StanSmith -PuttyPath 'c:\Putty\putty.exe'
      This will open a grid view with all of your putty sessions displayed.  When you start them the username will be populated.

  #>
  param
  (
    [Parameter(Position = 0)]
    [string]$LoginName,
    [Parameter(Mandatory = $true,HelpMessage = 'Full path to the PuTTY.exe file.  example:"c:\Putty\putty.exe"',Position = 1)]
    [string]$PuttyPath
  )
  $PuTTYSessions = Get-ItemProperty -Path HKCU:\Software\Simontatham\PuTTY\Sessions\*
  function Start-PuttySession
  {
    <#
        .SYNOPSIS
        Starts the actual puTTY session
    #>
    param
    (
      [Object]
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to process')]
      $InputObject
    )
    process
    {
      & $PuttyPath -load $InputObject.pschildname  ('{0}@{1}' -f $LoginName, $InputObject.hostname)
    }
  }
  $MySession = $PuTTYSessions |
  Select-Object -Property pschildname, hostname |
  Out-GridView -PassThru
  $MySession | Start-PuttySession
}

Export-ModuleMember -Function 'Connect-PuTTYSession', 'Export-PuTTYSessions', 'Import-PuTTYSessions', 'New-PuttySessionsRegistryFile', 'Set-PuTTYTheme', 'Show-PuTTYSessions' -Verbose
