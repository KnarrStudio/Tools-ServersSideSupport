﻿function New-PuTTYRegFile
{
  <#
      .SYNOPSIS
      Automates the build-out of all your Putty sessions.  
      
      .DESCRIPTION
      Builds out your PuTTY console sessions
      All you need to do is supply your hostnames and ipaddresses.  
      Normally this is done by one by one, but this makes it easier to modify or rebuild your sessions

      .PARAMETER InputFileCsv
      This is the csv file that has the Hostnames and Ip Addresses.  

      File format:
      ╔=============================╗
      ║        InputFile.csv        ║ 
      ╠=============================╣
      ║                             ║ 
      ║ "Hostname","IpAddress"      ║ 
      ║ "Old_Router","192.168.1.2"  ║ 
      ║ "My Firewall","192.168.1.3" ║ 
      ║ "Switch-Four","192.168.1.4" ║ 
      ╚=============================╝

      .PARAMETER OutputFileReg
      Output file.  This is just a file name.  
      If you leave it blank, the script will create a filename with the current user and Julian date appended.

      .EXAMPLE
      New-PuTTYRegFile -InputFileCsv Value -OutputFileReg Value
      This will take the hostnames and ipadresses in the -InputFile file and create a registry file by the name of the -PuttyReg

      .NOTES
      Nothing signifigant at this time.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online New-PuTTYRegFile

      .INPUTS
      A CSV file with the formatting provided in this help file.

      .OUTPUTS
      A single .reg (Registry) file 
  #>
  
  param
  (
    [Parameter(Mandatory,HelpMessage = 'A CSV file using the format in "Get-help New-PuTTYRegFile -Full" ',Position = 0)]
    [ValidateScript({
          If($_ -match '.csv')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be CSV'
          }
    })][String]$InputFileCsv,
    [Parameter(Position = 1)]
    [ValidateScript({
          If($_ -match '.reg')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be reg'
          }
    })][String]$OutputFileReg = (New-Item -Path ('{2}\PuttySessions-{0}-({1}).reg' -f $env:USERNAME, $(Get-Date -UFormat %j%S), "$env:USERPROFILE\Desktop") -ItemType File -Force),
    [Parameter(Mandatory = $false, Position = 2)]  
    [String]$PuttyLogPath = "$env:TEMP\putty-&H-&Y&M&D-&T.log"
  ) 
  BEGIN{
    $ImportSessions = Import-Csv -Path $InputFileCsv
  
    $RegFileHeader = 'Windows Registry Editor Version 5.00'  
    $RegFileHeader | Out-File -FilePath $OutputFileReg
  }
  PROCESS{
  foreach($PuttySession in $ImportSessions)
  {
    $PuttySessionHost = $PuttySession.'HostName'
    $PuttySessionIPAdd = $PuttySession.'ipaddress'
    
    $PuttyBlurb = (@'
[HKEY_CURRENT_USER\Software\Simontatham\PuTTY\Sessions\{0}]
"Present"=dword:00000001
"HostName"="{1}"
"LogFileName"="{2}"
"LogType"=dword:00000002
"LogFileClash"=dword:ffffffff
"LogFlush"=dword:00000001
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
"TerminalModes"="CS7=A,CS8=A,DISCARD=A,DSUSP=A,ECHO=A,ECHOCTL=A,ECHOE=A,ECHOK=A,ECHOKE=A,ECHONL=A,EOF=A,EOL=A,EOL2=A,ERASE=A,FLUSH=A,ICANON=A,ICRNL=A,IEXTEN=A,IGNCR=A,IGNPAR=A,IMAXBEL=A,INLCR=A,INPCK=A,INTR=A,ISIG=A,ISTRIP=A,IUCLC=A,IXANY=A,IXOFF=A,IXON=A,KILL=A,LNEXT=A,NOFLSH=A,OCRNL=A,OLCUC=A,ONLCR=A,ONLRET=A,ONOCR=A,OPOST=A,PARENB=A,PARMRK=A,PARODD=A,PENDIN=A,QUIT=A,REPRINT=A,START=A,STATUS=A,STOP=A,SUSP=A,SWTCH=A,TOSTOP=A,WERASE=A,XCASE=A"
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
"Cipher"="aes,blowfish,3des,WARN,arcfour,des"
"KEX"="dh-gex-sha1,dh-group14-sha1,dh-group1-sha1,rsa,WARN"
"RekeyTime"=dword:0000003c
"RekeyBytes"="1G"
"SshNoAuth"=dword:00000000
"SshBanner"=dword:00000001
"AuthTIS"=dword:00000000
"AuthKI"=dword:00000001
"AuthGSSAPI"=dword:00000001
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
"PasteRTF"=dword:00000000
"MouseIsXterm"=dword:00000000
"RectSelect"=dword:00000000
"MouseOverride"=dword:00000001
"Wordness0"="0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
"Wordness32"="0,1,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1"
"Wordness64"="1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,2"
"Wordness96"="1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1"
"Wordness128"="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
"Wordness160"="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
"Wordness192"="2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2"
"Wordness224"="2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2"
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
"AuthCAPI"=dword:00000000
"CAPICertID"=""
"BugOldGex2"=dword:00000000
"BugWinadj"=dword:00000000
"BugChanReq"=dword:00000000
"ConnectionSharing"=dword:00000000
"ConnectionSharingUpstream"=dword:00000001
"ConnectionSharingDownstream"=dword:00000001
"SSHManualHostKeys"=""
"2"=dword:00000002


'@ -f $PuttySessionHost, $PuttySessionIPAdd, $PuttyLogPath)
    $PuttyBlurb | Out-File  -FilePath $OutputFileReg -Append
  }}
  END{
    Write-Output -InputObject (@'
  File Name: {1}
  File Location: {0}\Desktop'
'@  -f $env:USERPROFILE, $OutputFileReg)
  }
}
