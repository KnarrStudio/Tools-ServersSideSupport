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
