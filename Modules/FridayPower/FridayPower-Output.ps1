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

    Today we are going to figure out how to get the output data you want with a little formating.

    You run a script or cmdlet to get some output. The problem it may not give you what you want. 
    So we are going to look as some ways to get more data and diffent ways to look at it.
    
#>  

# Let's start with the simple default.
# Using just the default output provides some information.
Get-Service

# That worked, but let's get just the first five.
Get-Service | select -First 5

# Now with dependent services. 
Get-Service | Where DependentServices -NE $null

# Where did I get "DependentServices"?  From the Get-Member command the alias 'gm'
Get-Service | gm

# The Get-Member command shows you all sorts of good information about the piped command
<#
A Method - is sort of an action word
A Property - is like a setting
#>
# So if we wanted collect only the Services that are stopped we need to find the Property that gives that information.
# An easy way to do that is to return all of the properties
Get-Service | select -Property * | select -First 5

#OR Guess

(Get-Service).Site
(Get-Service).StartType
(Get-Service).Status 

# Now we can see that "Status" will give the current state
Get-Service | Where Status -EQ 'Stopped'

#Again, Not real helpful.  Should they be stopped and do we need the "Stopped" column?
Get-Service | Where-Object Status -EQ 'Stopped' | Select StartType,Name,DisplayName,ServicesDependedOn

#Again, helpful information, but should they be stopped and do we need the "Stopped" and "DisplayName" columns?
# Up until this time I have been using an "Alias" for the "Where" and "Select" statements.  I am going to expand them in this example
# I am also going to add a little more code and then explain
Get-Service | Where-Object{($_.Status -EQ 'Stopped') -and ($_.StartType -eq 'Automatic')} | Select-Object StartType,Name,@{Label = "Depended On" ; Expression = {$_.ServicesDependedOn}}

<#
Get-Service - Default cmdlet
Where-Object{  } - This is where we filter the information we are looking for.  Information from the pipe is sent using "$_" variable
($_.Status -EQ 'Stopped') -and ($_.StartType -eq 'Automatic') - We want to find the ("Services.Status" the equal 'Stopped') AND (Services.StartType that equal 'Automatic')
Select-Object - The items that we want sent to the output.
@{Label = "Depended On" ; Expression = {$_.ServicesDependedOn}} - This allows us to change the name of our output column from "ServicesDependedOn" to "Depended On"
#>



# Okay we are going to start combining things.
# What I want to show is the importance of order command.  When sending something to a pipe the order is important.  
# They all get the list of services first, but then they do different things in different orders.


# The next three commands, have the same commands, but in different orders

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

Get-Printer | Where Name -Like 'Micro*' | Select -First 10 


Get-Service | Where-Object{($_.Status -EQ 'Stopped') -and ($_.StartType -eq 'Automatic')} | Select-Object StartType,Name,@{Label = "Depended On" ; Expression = {$_.ServicesDependedOn}}