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
$footer = New-UDFooter -Links (New-UDLink -Text " swecyclingonline.se " -Url "http://swecyclingonline.se" -Icon bicycle)

#Import-Module and fetch the data for the first time only.
Import-Module (Join-Path $PSScriptRoot "functions\Get-RaceFromApi.psm1")
$Cache:lvgResult = Get-RaceFromApi -Gren "landsväg"
$Cache:cxResult = Get-RaceFromApi -Gren "cykelcross"
$Cache:mtbResult = Get-RaceFromApi -Gren "mountainbike"
$Cache:AntalRace = Get-TotalRacesFromApi

$ne = New-UDEndpointInitialization -Module ".\$PSScriptRoot\functions\Get-RaceFromApi.psm1" -Variable @("$Cache:lvgResult", "$Cache:cxResult", "$Cache:AntalRace", "$Cache:mtbResult")

$Cache:DatagridValues = "Namn", "Plats", "Arrangör", "Typ", "StartTid", "SistaAnmälningsDatum", "DagarTillStart", "DagarTillSistaAnmalning", "URL", "Kategori"
$landsvag = . (Join-Path $PSScriptRoot "pages\landsvag.ps1")
$mtb = . (Join-Path $PSScriptRoot "pages\mtb.ps1")
$cross = . (Join-Path $PSScriptRoot "pages\cross.ps1")
$hem = . (Join-Path $PSScriptRoot "pages\hem.ps1")

$Schedule = New-UDEndpointSchedule -Every 1 -Minute
$Everyminute = New-UDEndpoint -Schedule $Schedule -Endpoint{
    $Cache:lvgResult = Get-RaceFromApi -Gren "landsväg"
    $Cache:cxResult = Get-RaceFromApi -Gren "cykelcross"
    $Cache:mtbResult = Get-RaceFromApi -Gren "mountainbike"
    $Cache:AntalRace = Get-TotalRacesFromApi
}

Get-UDDashboard | Stop-UDDashboard
 
Start-UDDashboard -Content{ 
    New-UDDashboard -NavbarLinks $NavBarLinks -Title "Svenska cykelförbundets tävlingar" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor $Colors.BackgroundColor -FontColor $Colors.FontColor -Pages @(
        $hem,    
        $landsvag,
        $mtb,
        $cross
    ) -Footer $Footer -EndpointInitialization $ne
} -Port 8080 -Endpoint @($Everyminute)