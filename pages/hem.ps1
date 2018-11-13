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
            New-UDCard -BackgroundColor $Colors.UDCardBakgroundColor -Links (New-UDLink -Text "Landsvägs-tävlingar" -Url /landsväg -Icon bicycle) -Content{
                New-UDParagraph -Text "Klicka här för att se alla aktuella Landsvägs-tävlingar." -Color $Colors.FontColor
                }#end content
            New-UDCard -BackgroundColor $Colors.UDCardBakgroundColor -Links (New-UDLink -Text "Mountainbike-tävlingar" -Url /mountainbike -Icon bicycle) -Content{
                New-UDParagraph -Text "Klicka här för att se alla aktuella Mountainbike-tävlingar." -Color $Colors.FontColor
                }#end content
            New-UDCard -BackgroundColor $Colors.UDCardBakgroundColor -Links (New-UDLink -Text "Cross-tävlingar" -Url /cykelcross -Icon bicycle) -Content{
                New-UDParagraph -Text "Klicka här för att se alla aktuella Cross-tävlingar." -Color $Colors.FontColor
                }#end content
            }#End new-udlayout     
        }#End new-udrow
    New-UDRow{
        New-UDLayout -Columns 3 -Content{
            New-UDChart -Title "Antal tävlingar per gren" -Type Bar -BackgroundColor $Colors.BackgroundColor2 -FontColor $Colors.FontColor -Endpoint {
                $AntalRace | ForEach-Object{
                    [PSCustomObject]@{ 
                        Gren = $_.Gren
                        Antal = $_.Antal.Count
                    }#End custom object
                } | Out-UDChartData -LabelProperty "Gren" -DataProperty "Antal" -DatasetLabel "Tävlingar per gren" -BackgroundColor $Colors.BackgroundColor3 -BorderColor $Colors.UDChartBorderColor -HoverBackgroundColor $Colors.UDChartHoverBackgroundColor -HoverBorderColor $Colors.UDChartHoverBorderColor #End foreach-object
            }#End new-udchart
        }#End new-udlayout
    }#End new-udrow
}#End new-udpage
