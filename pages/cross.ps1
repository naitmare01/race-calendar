Import-Module (Join-Path $PSScriptRoot "..\functions\Get-RaceFromApi.psm1")
$Result = Get-RaceFromApi -Gren "cykelcross"

New-UDPage -Name "Cykelcross" -Icon bicycle -Content{
    New-UDRow{
        New-UDColumn -Size 12 {
            New-UDHtml -Markup "<div class='center-align white-text'><h3>Cykelcross</h3></h3><h5>Nedan listas alla cross-tävlingar som ligger upp på swecyclingone.se från idag och 1år framåt och endast dem 100 första tävlingarna som listas). Detta är endast tänkt som ett komplement till swecyclingonline.se och är ett hemma-projekt.</h5></div>"
        }#End new-udcolumn
    }#End new-udrow
    New-UDRow {
        New-UDLayout -Columns 3 -Content{
            foreach($r in $Result[0..2]){
                New-UDCard -FontColor "#FFFFFF" -BackgroundColor '#383838' -Links (New-UDLink -Text "Mer information och anmälan(extern sida)" -Url $r.url.url -OpenInNewWindow -Icon bicycle) -Content{
                    New-UDParagraph -Text $r.Namn -Color "#FFFFFF"
                    New-UDParagraph -Text ("Typ av lopp: " + $r.Typ) -Color "#FFFFFF"
                    New-UDParagraph -Text ("Loppet går: " + $r.StartTid) -Color "#FFFFFF"
                    New-UDParagraph -Text ("Sista anmälningsdag: " + $r.SistaAnmälningsDatum) -Color "#FFFFFF"
                    New-UDParagraph -Text ("Antal dagar till start: " + $r.DagarTillStart) -Color "#FFFFFF"
                    New-UDParagraph -Text ("Antal dagar till sista anmälningsdagen: " + $r.DagarTillSistaAnmalning) -Color "#FFFFFF"
                }#End content
            }#End foreach
        }#End new-udlayout
        New-UDGrid -FontColor "#FFFFFF" -BackgroundColor '#383838' -DefaultSortColumn 2 -PageSize 20 -Id maindatagrid -Title "Cykel tävlingar landväg"  -Headers @("Namn", "Typ", "StartTid", "SistaAnmälningsDatum", "DagarTillStart", "DagarTillSistaAnmalning", "URL", "Kategori") -Properties @("Namn", "Typ", "StartTid", "SistaAnmälningsDatum", "DagarTillStart", "DagarTillSistaAnmalning", "URL", "Kategori") -Endpoint {
            $Result | Out-UDGridData
        }#End New-udgrid
    }#End new-udrow
}#End new-udpage