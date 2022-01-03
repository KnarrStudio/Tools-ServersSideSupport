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

# That worked, but let's get just the first five with dependent services. 

# This will show the importance of order command.  When sending something to a pipe the order is important.  
# They all get the list of services first, but then they do different things in different orders.

# Get the list of services and sort on DisplayName. Take that list and select only ones that have Dependent services.  Lastly, select the first five in the list.  
Get-Service | sort DisplayName | Where DependentServices -NE $null | select -First 5
Write-Host '-'

# This one gets the list of services that have dependent services, then it takes the first five and finally sorts them 
Get-Service | Where DependentServices -NE $null | select -First 5  | sort DisplayName
Write-Host '-'

# Again, get the list of services, but only take the first five.  Now sort sort those five by DisplayName and of those ones that have Dependent services
Get-Service | select -First 5 | sort DisplayName | Where DependentServices -NE $null

# Let's do it again, but show the dependent services in the output
Get-Service | Where DependentServices -NE $null | Select -First 5 | Select Name,Status,DependentServices
#{________}   {_______________________________}  {_______________}  {__________________________________}
#  Main Cmdlet    Where Statement                    select amount        Select what you want to capture

# All these work at getting information to output, and does output it, but we are not in control of the output
# Let's look at Get-Aduser (You may have to: Import-Module ActiveDirectory)
Get-Aduser 

# That is a lot of users, and it is in a List view, which is tough to read.  
# So let's use some of the tricks from above

Get-Printer | Where Name -Like 'C*' | Select -First 10
