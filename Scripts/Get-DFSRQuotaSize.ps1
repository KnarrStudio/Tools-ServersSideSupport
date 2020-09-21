#requires -Modules Microsoft.PowerShell.Utility
#requires -Version 3.0
#requires -runasAdministrator

function Get-DFSRQuotaSize
{
  <#
      .SYNOPSIS
      Returns the recomended size of the DFS-R Quota

      .EXAMPLE
      Get-DFSRQuotaSize -Path 'S:\DFSR-Folder'
      Will give you the quota to the screen and add it to a temp file.

      .EXAMPLE 
      Get-DFSRQuotaSize -Path 'S:\DFSR-Folder' -$LogFile c:\temp\Log.txt
      Will give you the quota to a file in the folder you provide

  #>
  
  [CmdletBinding(SupportsPaging)]
  Param
  (
    [Parameter(Mandatory, Position = 0,HelpMessage = 'Enter the full path of the DFS-R path. S:\DFSR-Folder')]
    [string]$FullPath,
    
    [Parameter(Position = 1)]
    [AllowNull()]
    [ValidateScript({
          If($_ -notmatch '.csv')
          {
            $true
          }
          Else
          {
            Throw 'Output file can not be a .csv'
          }
    })][String]$LogFile = $null
  )

  $NewLine = "`n"
  $DateNow = Get-Date -UFormat %Y%m%d-%S
  $LogFile = [String]$($LogFile.Replace('.',('_{0}.' -f $DateNow)))

  $TotalFiles = Get-ChildItem -Path $FullPath -Recurse
  $Big32 = $TotalFiles |
  Sort-Object -Property length -Descending |
  Select-Object -First 32 |
  Measure-Object -Property length -Sum
  $DfsrQuota = $Big32.sum /1GB

  if($DfsrQuota -gt 1)
  {
    $OutputInformation = ('The recommended Quota size is {0:n2} GB.' -f $DfsrQuota)
    #Write-Output -InputObject $OutputInformation
  }
  else
  {
    $DfsrQuota = $Big32.sum /1MB
    $OutputInformation = ('The recommended Quota size is {0:n2} MB.' -f $DfsrQuota)
  }
  if(-not $LogFile)
  {
    $LogFile = New-TemporaryFile
  }
  if(-not $(Test-Path -Path $LogFile))
  {
    $null = New-Item -Path $LogFile -ItemType File -Force
  }

  
  ('The path tested: {0}.' -f $FullPath) | Tee-Object  -FilePath $LogFile
  ('Of the {0} files reviewed, the 32 largest have a total size of {1:n2}.' -f $($TotalFiles.Length, $($Big32.Sum))) | Tee-Object  -FilePath $LogFile -Append
  ('Math: ({1:n2} / 1GB) = {0:n4}{2}GB' -f $DfsrQuota, $($Big32.Sum), $NewLine) | Tee-Object -FilePath $LogFile -Append
  
  $OutputInformation | Tee-Object  -FilePath $LogFile -Append
    
  Write-Output -InputObject ('The log can be found: {0}{1}' -f  $LogFile, $NewLine)
}


Get-DFSRQuotaSize -FullPath "$env:HOMEDRIVE\Temp"




