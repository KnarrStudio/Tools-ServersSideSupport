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
    Value        = '{2}'
  }
  LogType                     = @{
    PropertyType = 'dword'
    Value        = 00000002
  }
  LogFileClash                = @{
    PropertyType = 'dword'
    Value        = 'ffffffff'
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
    Value        = '0000003c'
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
    Value        = '000007d0'
  }
  BellOverloadS               = @{
    PropertyType = 'dword'
    Value        = 00001388
  }
  ScrollbackLines             = @{
    PropertyType = 'dword'
    Value        = '000007d0'
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
    Value        = '0000000a'
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



