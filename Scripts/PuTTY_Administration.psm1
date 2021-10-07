function Update-PuTTYSessions 
{
  <#
      .SYNOPSIS
      Describe purpose of "Update-PuTTYSessions" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .EXAMPLE
      Update-PuTTYSessions
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Update-PuTTYSessions

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


}

function Set-PuTTYTheme 
{
  <#
      .SYNOPSIS
      Describe purpose of "Set-PuTTYTheme" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .EXAMPLE
      Set-PuTTYTheme
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Set-PuTTYTheme

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


}

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

function New-PuttySessionsRegistryFile #Complete
{
  <#
      .SYNOPSIS
      Creates a registry file with the default PuTTy settings that can be merged and transported

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
  
  foreach($switchData in $InputFileName)
  {
    $SwitchName = $switchData.'HostName'
    $SwitchIp = $switchData.'ipaddress'
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

'@ -f $SwitchName, $SwitchIp)
    $PuttyBlurb | Out-File -FilePath $RegistryFile -Append 
  } 
}

function Import-PuTTYSessions #Completed
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
    })][String]$File,
    [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Default')]
    [string]$LogPath = $env:TEMP,
    [Parameter(Mandatory = $false, Position = 1,ParameterSetName = 'Template')]
    [Switch]$CreateTemplate
  )
  
  $PuttyLogFile = ('{0}\putty-&H-&Y&M&D-&T.log' -f $LogPath)
  $ImportedData = Import-Csv -Path $File
  
  function Test-KeyPresence
  {
    param (
      [parameter(Mandatory)]
      [ValidateNotNullOrEmpty()]
      [String]$Path,
      [parameter(Mandatory)]
      [ValidateNotNullOrEmpty()]
      [String]$Key
    ) 
    try 
    {
      $null = Get-ItemProperty -Path $Path -Name $Key -ErrorAction Stop
      return $true
    }
    catch 
    {
      return $false
    }
  }
  
  if($CreateTemplate)
  {
    $FileTemplate = @'
"HostName","IPAddress"
"Switch-42","192.168.0.42"
'@
    $FileTemplate | Out-File -FilePath $File -Force
    return
  }
  
  $PuTTYRegHash = @{
    Present                     = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    HostName                    = @{
      PropertyType = 'String'
      Value        = '{1}'
    }
    LogFileName                 = @{
      PropertyType = 'String'
      Value        = $PuttyLogFile
    }
    LogType                     = @{
      PropertyType = 'dword'
      Value        = 00000002
    }
    LogFileClash                = @{
      PropertyType = 'dword'
      Value        = -1
    }
    LogFlush                    = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    SSHLogOmitPasswords         = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    SSHLogOmitData              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    Protocol                    = @{
      PropertyType = 'String'
      Value        = 'ssh'
    }
    PortNumber                  = @{
      PropertyType = 'dword'
      Value        = 00000016
    }
    CloseOnExit                 = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    WarnOnClose                 = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    PingInterval                = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    PingIntervalSecs            = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    TCPNoDelay                  = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    TCPKeepalives               = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    TerminalType                = @{
      PropertyType = 'String'
      Value        = 'xterm'
    }
    TerminalSpeed               = @{
      PropertyType = 'String'
      Value        = '38400,38400'
    }
    TerminalModes               = @{
      PropertyType = 'String'
      Value        = 'CS7=A,CS8=A,DISCARD=A,DSUSP=A,ECHO=A,ECHOCTL=A,ECHOE=A,ECHOK=A,ECHOKE=A,ECHONL=A,EOF=A,EOL=A,EOL2=A,ERASE=A,FLUSH=A,ICANON=A,ICRNL=A,IEXTEN=A,IGNCR=A,IGNPAR=A,IMAXBEL=A,INLCR=A,INPCK=A,INTR=A,ISIG=A,ISTRIP=A,IUCLC=A,IXANY=A,IXOFF=A,IXON=A,KILL=A,LNEXT=A,NOFLSH=A,OCRNL=A,OLCUC=A,ONLCR=A,ONLRET=A,ONOCR=A,OPOST=A,PARENB=A,PARMRK=A,PARODD=A,PENDIN=A,QUIT=A,REPRINT=A,START=A,STATUS=A,STOP=A,SUSP=A,SWTCH=A,TOSTOP=A,WERASE=A,XCASE=A'
    }
    AddressFamily               = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ProxyExcludeList            = @{
      PropertyType = 'String'
      Value        = ''
    }
    ProxyDNS                    = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    ProxyLocalhost              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ProxyMethod                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ProxyHost                   = @{
      PropertyType = 'String'
      Value        = 'proxy'
    }
    ProxyPort                   = @{
      PropertyType = 'dword'
      Value        = 00000050
    }
    ProxyUsername               = @{
      PropertyType = 'String'
      Value        = ''
    }
    ProxyPassword               = @{
      PropertyType = 'String'
      Value        = ''
    }
    ProxyTelnetCommand          = @{
      PropertyType = 'String'
      Value        = 'connect %host %port\\n'
    }
    Environment                 = @{
      PropertyType = 'String'
      Value        = ''
    }
    UserName                    = @{
      PropertyType = 'String'
      Value        = ''
    }
    UserNameFromEnvironment     = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    LocalUserName               = @{
      PropertyType = 'String'
      Value        = ''
    }
    NoPTY                       = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    Compression                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    TryAgent                    = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    AgentFwd                    = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    GssapiFwd                   = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ChangeUsername              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    Cipher                      = @{
      PropertyType = 'String'
      Value        = 'aes,blowfish,3des,WARN,arcfour,des'
    }
    KEX                         = @{
      PropertyType = 'String'
      Value        = 'dh-gex-sha1,dh-group14-sha1,dh-group1-sha1,rsa,WARN'
    }
    RekeyTime                   = @{
      PropertyType = 'dword'
      Value        = 60
    }
    RekeyBytes                  = @{
      PropertyType = 'String'
      Value        = '1G'
    }
    SshNoAuth                   = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    SshBanner                   = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    AuthTIS                     = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    AuthKI                      = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    AuthGSSAPI                  = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    GSSLibs                     = @{
      PropertyType = 'String'
      Value        = 'gssapi32,sspi,custom'
    }
    GSSCustom                   = @{
      PropertyType = 'String'
      Value        = ''
    }
    SshNoShell                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    SshProt                     = @{
      PropertyType = 'dword'
      Value        = 00000003
    }
    LogHost                     = @{
      PropertyType = 'String'
      Value        = ''
    }
    SSH2DES                     = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    PublicKeyFile               = @{
      PropertyType = 'String'
      Value        = ''
    }
    RemoteCommand               = @{
      PropertyType = 'String'
      Value        = ''
    }
    RFCEnviron                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    PassiveTelnet               = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BackspaceIsDelete           = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    RXVTHomeEnd                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    LinuxFunctionKeys           = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NoApplicationKeys           = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NoApplicationCursors        = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NoMouseReporting            = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NoRemoteResize              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NoAltScreen                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NoRemoteWinTitle            = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    RemoteQTitleAction          = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    NoDBackspace                = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NoRemoteCharset             = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ApplicationCursorKeys       = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ApplicationKeypad           = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    NetHackKeypad               = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    AltF4                       = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    AltSpace                    = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    AltOnly                     = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ComposeKey                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    CtrlAltKeys                 = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    TelnetKey                   = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    TelnetRet                   = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    LocalEcho                   = @{
      PropertyType = 'dword'
      Value        = 00000002
    }
    LocalEdit                   = @{
      PropertyType = 'dword'
      Value        = 00000002
    }
    Answerback                  = @{
      PropertyType = 'String'
      Value        = 'PuTTY'
    }
    AlwaysOnTop                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    FullScreenOnAltEnter        = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    HideMousePtr                = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    SunkenEdge                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WindowBorder                = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    CurType                     = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BlinkCur                    = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    Beep                        = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    BeepInd                     = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BellWaveFile                = @{
      PropertyType = 'String'
      Value        = ''
    }
    BellOverload                = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    BellOverloadN               = @{
      PropertyType = 'dword'
      Value        = 00000005
    }
    BellOverloadT               = @{
      PropertyType = 'dword'
      Value        = 2000
    }
    BellOverloadS               = @{
      PropertyType = 'dword'
      Value        = 00001388
    }
    ScrollbackLines             = @{
      PropertyType = 'dword'
      Value        = 2000
    }
    DECOriginMode               = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    AutoWrapMode                = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    LFImpliesCR                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    CRImpliesLF                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    DisableArabicShaping        = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    DisableBidi                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WinNameAlways               = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    WinTitle                    = @{
      PropertyType = 'String'
      Value        = ''
    }
    TermWidth                   = @{
      PropertyType = 'dword'
      Value        = 00000050
    }
    TermHeight                  = @{
      PropertyType = 'dword'
      Value        = 00000018
    }
    Font                        = @{
      PropertyType = 'String'
      Value        = 'Courier New'
    }
    FontIsBold                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    FontCharSet                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    FontHeight                  = @{
      PropertyType = 'dword'
      Value        = 10
    }
    FontQuality                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    FontVTMode                  = @{
      PropertyType = 'dword'
      Value        = 00000004
    }
    UseSystemColours            = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    TryPalette                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ANSIColour                  = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    Xterm256Colour              = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    BoldAsColour                = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    Colour0                     = @{
      PropertyType = 'String'
      Value        = '187,187,187'
    }
    Colour1                     = @{
      PropertyType = 'String'
      Value        = '255,255,255'
    }
    Colour2                     = @{
      PropertyType = 'String'
      Value        = '0,0,0'
    }
    Colour3                     = @{
      PropertyType = 'String'
      Value        = '85,85,85'
    }
    Colour4                     = @{
      PropertyType = 'String'
      Value        = '0,0,0'
    }
    Colour5                     = @{
      PropertyType = 'String'
      Value        = '0,255,0'
    }
    Colour6                     = @{
      PropertyType = 'String'
      Value        = '0,0,0'
    }
    Colour7                     = @{
      PropertyType = 'String'
      Value        = '85,85,85'
    }
    Colour8                     = @{
      PropertyType = 'String'
      Value        = '187,0,0'
    }
    Colour9                     = @{
      PropertyType = 'String'
      Value        = '255,85,85'
    }
    Colour10                    = @{
      PropertyType = 'String'
      Value        = '0,187,0'
    }
    Colour11                    = @{
      PropertyType = 'String'
      Value        = '85,255,85'
    }
    Colour12                    = @{
      PropertyType = 'String'
      Value        = '187,187,0'
    }
    Colour13                    = @{
      PropertyType = 'String'
      Value        = '255,255,85'
    }
    Colour14                    = @{
      PropertyType = 'String'
      Value        = '0,0,187'
    }
    Colour15                    = @{
      PropertyType = 'String'
      Value        = '85,85,255'
    }
    Colour16                    = @{
      PropertyType = 'String'
      Value        = '187,0,187'
    }
    Colour17                    = @{
      PropertyType = 'String'
      Value        = '255,85,255'
    }
    Colour18                    = @{
      PropertyType = 'String'
      Value        = '0,187,187'
    }
    Colour19                    = @{
      PropertyType = 'String'
      Value        = '85,255,255'
    }
    Colour20                    = @{
      PropertyType = 'String'
      Value        = '187,187,187'
    }
    Colour21                    = @{
      PropertyType = 'String'
      Value        = '255,255,255'
    }
    RawCNP                      = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    PasteRTF                    = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    MouseIsXterm                = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    RectSelect                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    MouseOverride               = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    Wordness0                   = @{
      PropertyType = 'String'
      Value        = '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0'
    }
    Wordness32                  = @{
      PropertyType = 'String'
      Value        = '0,1,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1'
    }
    Wordness64                  = @{
      PropertyType = 'String'
      Value        = '1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,2'
    }
    Wordness96                  = @{
      PropertyType = 'String'
      Value        = '1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1'
    }
    Wordness128                 = @{
      PropertyType = 'String'
      Value        = '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'
    }
    Wordness160                 = @{
      PropertyType = 'String'
      Value        = '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'
    }
    Wordness192                 = @{
      PropertyType = 'String'
      Value        = '2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2'
    }
    Wordness224                 = @{
      PropertyType = 'String'
      Value        = '2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2'
    }
    LineCodePage                = @{
      PropertyType = 'String'
      Value        = ''
    }
    CJKAmbigWide                = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    UTF8Override                = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    Printer                     = @{
      PropertyType = 'String'
      Value        = ''
    }
    CapsLockCyr                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ScrollBar                   = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    ScrollBarFullScreen         = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ScrollOnKey                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ScrollOnDisp                = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    EraseToScrollback           = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    LockSize                    = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BCE                         = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    BlinkText                   = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    X11Forward                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    X11Display                  = @{
      PropertyType = 'String'
      Value        = ''
    }
    X11AuthType                 = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    X11AuthFile                 = @{
      PropertyType = 'String'
      Value        = ''
    }
    LocalPortAcceptAll          = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    RemotePortAcceptAll         = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    PortForwardings             = @{
      PropertyType = 'String'
      Value        = ''
    }
    BugIgnore1                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugPlainPW1                 = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugRSA1                     = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugIgnore2                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugHMAC2                    = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugDeriveKey2               = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugRSAPad2                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugPKSessID2                = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugRekey2                   = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugMaxPkt2                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    StampUtmp                   = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    LoginShell                  = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    ScrollbarOnLeft             = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BoldFont                    = @{
      PropertyType = 'String'
      Value        = ''
    }
    BoldFontIsBold              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BoldFontCharSet             = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BoldFontHeight              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WideFont                    = @{
      PropertyType = 'String'
      Value        = ''
    }
    WideFontIsBold              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WideFontCharSet             = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WideFontHeight              = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WideBoldFont                = @{
      PropertyType = 'String'
      Value        = ''
    }
    WideBoldFontIsBold          = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WideBoldFontCharSet         = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    WideBoldFontHeight          = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ShadowBold                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ShadowBoldOffset            = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    SerialLine                  = @{
      PropertyType = 'String'
      Value        = 'COM1'
    }
    SerialSpeed                 = @{
      PropertyType = 'dword'
      Value        = 00002580
    }
    SerialDataBits              = @{
      PropertyType = 'dword'
      Value        = 00000008
    }
    SerialStopHalfbits          = @{
      PropertyType = 'dword'
      Value        = 00000002
    }
    SerialParity                = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    SerialFlowControl           = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    WindowClass                 = @{
      PropertyType = 'String'
      Value        = ''
    }
    AuthCAPI                    = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    CAPICertID                  = @{
      PropertyType = 'String'
      Value        = ''
    }
    BugOldGex2                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugWinadj                   = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    BugChanReq                  = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ConnectionSharing           = @{
      PropertyType = 'dword'
      Value        = 00000000
    }
    ConnectionSharingUpstream   = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    ConnectionSharingDownstream = @{
      PropertyType = 'dword'
      Value        = 00000001
    }
    SSHManualHostKeys           = @{
      PropertyType = 'String'
      Value        = ''
    }
    2                           = @{
      PropertyType = 'dword'
      Value        = 00000002
    }
  }

  foreach($Device in $ImportedData)
  {
    $SessionName = $Device.HostName
    $sessionIP = $Device.IPAddress
    $SessionPath = 'HKCU:\Software\Simontatham\PuTTY\Sessions\{0}' -f $SessionName
    Write-Verbose -Message ('Session: {0}' -f $SessionPath)
    
    if(-not (Test-Path -Path $SessionPath))
    {
      $null = New-Item -Path $SessionPath -Value $null
    }
    foreach($keyTitle in $PuTTYRegHash.Keys)
    {
      if(-not (Test-KeyPresence -Path $SessionPath -Key $keyTitle))
      {
        $null = New-ItemProperty -Path $SessionPath -Name $keyTitle -PropertyType $PuTTYRegHash[$keyTitle].PropertyType -Value $PuTTYRegHash[$keyTitle].Value
      }
      else
      {
        if(((Get-ItemProperty -Path $SessionPath -Name $keyTitle).$keyTitle) -ne $PuTTYRegHash[$keyTitle].Value)
        {
          $null = Set-ItemProperty -Path $SessionPath -Name $keyTitle -Value $PuTTYRegHash[$keyTitle].Value
        }
      }
    }
    
    $null = Set-ItemProperty -Path $SessionPath -Name HostName -Value $sessionIP
  }
}

function Export-PuTTYSessions #Completed
{
  param
  (
    [Parameter(Mandatory = $false,Position = 0)]
    [string]$outputPath = (Get-Location).Path,
    [Switch]$Bundle
  )
  $SessionName = '*'
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
  $PuTTYSessions = ((Get-Item -Path ('{0}{1}' -f $PuttyRegPath, $SessionName)).Name)
  #$HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
  #$PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name 
    
  if(-not $Bundle)
  {
    foreach($item in $PuTTYSessions)
    {
      $itemName = Split-Path -Path $item -Leaf
      Export_SessionToFile -outputfile $(New_RegistryFile  -FileName $itemName -outputPath $outputPath ) -item $item
    }
  }
  else
  {
    $outputfile = New_RegistryFile -FileName 'PuttyBundle' -outputPath $outputPath 
    foreach($item in $PuTTYSessions)
    {
      $itemName = Split-Path -Path $item -Leaf
      Export_SessionToFile -outputfile $outputfile -item $item
    }
  }
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
    [Parameter(Mandatory = $true,HelpMessage='Full path to the PuTTY.exe file.  example:"c:\Putty\putty.exe"',Position = 1)]
    [string]$PuttyPath
  )
  $PuTTYSessions = Get-ItemProperty -Path HKCU:\Software\Simontatham\PuTTY\Sessions\*
  function Start-PuttySession
  {<#
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



Export-ModuleMember -Function 'Connect-PuTTYSession','Export-PuTTYSessions','Import-PuTTYSessions','New-PuttySessionsRegistryFile','Set-PuTTYTheme','Show-PuTTYSessions','Update-PuTTYSessions' -Verbose

