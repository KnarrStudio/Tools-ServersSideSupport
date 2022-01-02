<#

Today we are going to use BOTH PowerShell (console) and PowerShell (ISE), so open both

Copy the everything in this email between the #Start ---- AND #End ----

    Paste it into PowerShell ISE

    ISE Tricks:
    1. Select any piece of code and press F8 to run it. Multiple lines or even in the comment section
       Example: Select the following: Get-Date
    2. Place your cursor on a line and press F8 to run the whole line 
#>

#Start -------------------------------------------- 
<#
    Welcome again to Friday Power,

    Today we are going to work with output.

    Most of the time you run as script it is for some form of output.  We are going to look at how to get what you want.

#>  

# Let's start with the simple default.
# Using just the default output provides some information.
Get-Service

# Now pipe that to a select statement to return all of the properties
Get-Service | select -Property * 

# That worked, but let's get just the first five running services
Get-Service | sort DisplayName | Where Status -eq 'Running' | select -First 5 
Write-Host '-'
Get-Service | Where Status -eq 'Running' | select -First 5  | sort DisplayName
Write-Host '-'
Get-Service | select -First 5 | sort DisplayName | Where Status -eq 'Running'
