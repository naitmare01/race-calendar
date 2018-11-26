New-UDPage -Name "Cykelcross" -Icon bicycle -Content{
    New-UDRow{
        New-UDColumn -Size 12 {
            New-UDHtml -Markup "<div class='center-align white-text'><h3>Cykelcross</h3></h3><h5>Nedan listas alla cross-tävlingar som ligger upp på swecyclingone.se från idag och 1år framåt och endast dem 100 första tävlingarna som listas). Detta är endast tänkt som ett komplement till swecyclingonline.se och är ett hemma-projekt.</h5></div>"
        }#End new-udcolumn
    }#End new-udrow
    New-UDRow {
        New-UDLayout -Columns 3 -Content{
            foreach($r in $Cache:cxResult[0..2]){
                New-UDCard -FontColor $Colors.FontColor -BackgroundColor $Colors.UDCardBakgroundColor -Links (New-UDLink -Text "Mer information och anmälan(extern sida)" -Url $r.url.url -OpenInNewWindow -Icon bicycle) -Content{
                    New-UDParagraph -Text $r.Namn -Color $Colors.FontColor
                    New-UDParagraph -Text ("Typ av lopp: " + $r.Kategori) -Color $Colors.FontColor
                    New-UDParagraph -Text ("Loppet går: " + $r.StartTid) -Color $Colors.FontColor
                    New-UDParagraph -Text ("Sista anmälningsdag: " + $r.SistaAnmälningsDatum) -Color $Colors.FontColor
                    New-UDParagraph -Text ("Antal dagar till start: " + $r.DagarTillStart) -Color $Colors.FontColor
                    New-UDParagraph -Text ("Antal dagar till sista anmälningsdagen: " + $r.DagarTillSistaAnmalning) -Color $Colors.FontColor
                }#End content
            }#End foreach
        }#End new-udlayout
        New-UDGrid -AutoRefresh -RefreshInterval 60 -FontColor $Colors.FontColor -BackgroundColor $Colors.UDCardBakgroundColor -DefaultSortColumn 2 -PageSize 20 -Id cx -Title "Cykel tävlingar landväg"  -Headers @($Cache:DatagridValues) -Properties @($Cache:DatagridValues) -Endpoint {
            $Cache:cxResult | Out-UDGridData
        }#End New-udgrid
    }#End new-udrow
}#End new-udpage