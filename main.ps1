#Css-ish 
$Global:Colors = @{
    FontColor = "#FFFFFF"
    BackgroundColor = "#FF333333"
    BackgroundColor2 = "#252525"
    BackgroundColor3 = "#FF0000"
    UDCardBakgroundColor = "#383838"
    UDChartBorderColor = "#6F0000"
    UDChartHoverBackgroundColor = "#CC0786"
    UDChartHoverBorderColor = "#900786"
}

$NavBarLinks = @((New-UDLink -Text "Github till projektet" -Url "https://github.com/naitmare01/race-calendar" -Icon github),(New-UDLink -Text "Startsida" -Url "/hem" -Icon home))
$footer = New-UDFooter -Links (New-UDLink -Text "swecyclingonline.se" -Url "http://swecyclingonline.se" -Icon bicycle)

$landsvag = . (Join-Path $PSScriptRoot "pages\landsvag.ps1")
$mtb = . (Join-Path $PSScriptRoot "pages\mtb.ps1")
$cross = . (Join-Path $PSScriptRoot "pages\cross.ps1")
$hem = . (Join-Path $PSScriptRoot "pages\hem.ps1")
Import-Module (Join-Path $PSScriptRoot "functions\Get-RaceFromApi.psm1")

Get-UDDashboard | Stop-UDDashboard
 
Start-UDDashboard -Content { 
    New-UDDashboard -NavbarLinks $NavBarLinks -Title "Svenska cykelförbundets tävlingar" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor $Colors.BackgroundColor -FontColor $Colors.FontColor -Pages @(
        $hem,    
        $landsvag,
        $mtb,
        $cross
    ) -Footer $Footer
} -Port 10001
