Import-Module (Join-Path $PSScriptRoot "..\functions\Get-RaceFromApi.psm1")
$AntalRace = Get-TotalRacesFromApi

New-UDPage -Name "Hem" -Icon home -Content{
    New-UDRow{
        New-UDColumn -Size 12 {
            New-UDHtml -Markup "<div class='center-align white-text'><h3>Race-Calendar</h3></h3><h5>Denna sida listar alla tävlningar på swecyclingonline.se på ett lättöverskådligt och enkelt sätt.</h5></div>"
        }#End new-udcolumn
    }#End new-udrow
    New-UDRow{
        New-UDLayout -Columns 3 -Content{
            New-UDCard -BackgroundColor '#383838' -Links (New-UDLink -Text "Landsvägs-tävlingar" -Url /landsväg -Icon bicycle) -Content{
                New-UDParagraph -Text "Klicka här för att se alla aktuella Landsvägs-tävlingar." -Color "#FFFFFF"
                }#end content
            New-UDCard -BackgroundColor '#383838' -Links (New-UDLink -Text "Mountainbike-tävlingar" -Url /mountainbike -Icon bicycle) -Content{
                New-UDParagraph -Text "Klicka här för att se alla aktuella Mountainbike-tävlingar." -Color "#FFFFFF"
                }#end content
            New-UDCard -BackgroundColor '#383838' -Links (New-UDLink -Text "Cross-tävlingar" -Url /cross -Icon bicycle) -Content{
                New-UDParagraph -Text "Klicka här för att se alla aktuella Cross-tävlingar." -Color "#FFFFFF"
                }#end content
            }#End new-udlayout     
        }#End new-udrow
    New-UDRow{
        New-UDLayout -Columns 3 -Content{
            New-UDChart -Title "Antal tävlingar per gren" -Type Bar -Endpoint {
                $AntalRace | ForEach-Object{
                    [PSCustomObject]@{ 
                        Gren = $_.Gren
                        Antal = $_.Antal.Count
                    }#End custom object
                }#End foreach-object | Out-UDChartData -LabelProperty "Gren" -DataProperty "Antal" -DatasetLabel "Tävlingar per gren" -BackgroundColor "#FF0000" -BorderColor "#6F0000" -HoverBackgroundColor "#CC0786" -HoverBorderColor "#900786"
            }#End new-udchart -BackgroundColor "#252525" -FontColor "#FFFFFF"
        }#End new-udlayout
    }#End new-udrow
}#End new-udpage
