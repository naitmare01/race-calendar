$NavBarLinks = @((New-UDLink -Text "Github till projektet" -Url "https://github.com/naitmare01/" -Icon github),(New-UDLink -Text "Startsida" -Url "/hem" -Icon home))
$footer = New-UDFooter -Links (New-UDLink -Text "swecyclingonline.se" -Url "http://swecyclingonline.se" -Icon bicycle)

$landsvag = . (Join-Path $PSScriptRoot "pages\landsvag.ps1")
$mtb = . (Join-Path $PSScriptRoot "pages\mtb.ps1")
$cross = . (Join-Path $PSScriptRoot "pages\cross.ps1")
$hem = . (Join-Path $PSScriptRoot "pages\hem.ps1")

Get-UDDashboard | Stop-UDDashboard
 
Start-UDDashboard -Content { 
    New-UDDashboard -NavbarLinks $NavBarLinks -Title "Svenska cykelförbundets tävlingar" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFFF" -Pages @(
        $hem,    
        $landsvag,
        $mtb,
        $cross
    ) -Footer $Footer
} -Port 10001
