# Compares two files and removes the lines that are the same
function test-One{
param(
$DefaultTheme = (Get-Content -Path .\Default%20Settings.reg),
$NewTheme = (Get-Content -Path .\Alphabet.reg)
)
$NewThemeFile = New-TemporaryFile
'Windows Registry Editor Version 5.00' | Add-Content $NewThemeFile

$diff = Compare-Object -ReferenceObject $DefaultTheme -DifferenceObject $NewTheme # -PassThru 
$diff | Where-Object -Property SideIndicator -Match '=>'  | foreach {

$line = $_.InputObject
$ItemKey = $row.


    $splitLine = $line -split ':', 2
    $ItemKey = $splitLine[0].ToString().Trim()
    $ItemValue = $splitLine[1].ToString().Trim()




'"{0}"="{1}"' -f $ro | Add-Content $NewThemeFile}

$ThemeOutput = Get-Content $NewThemeFile

#Clean Up
Remove-Item $NewThemeFile -Force

Return $ThemeOutput
}
