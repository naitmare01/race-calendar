function Get-RaceFromApi{
    [CmdletBinding()]
    param(
        $Gren,
        $BaseUrl = "http://swecyclingonline.se/",
        $Url = "/api/v1/tavling/sok2"
    )#End param
    
    begin{
        $returnArray = [System.Collections.ArrayList]@()
        $apiUrl = "$BaseUrl$Url"


        $Body = @{
            SportId = 'sport/3'
            EvenemangId = ''
            StartTid = ((Get-Date).AddDays(-7).ToString('yyyy-MM-dd'))
            SlutTid = ((Get-Date).AddYears(1).ToString('yyyy-MM-dd'))
            Namn = ''
            Tags = ''
            Nivåer = $Gren
            Tillhör = 'sport/3'
            SortBy = 'StartTid'
            SökOrdning = 'Asc'
            Skip = 0
            Take = '100'
            IsCal = ''
        }#End body

        $Result = Invoke-RestMethod -Method 'Post' -Uri $apiUrl -Body $Body
    }#End begin

    process{
        foreach($r in $Result){
            $sistaAnmalan = $r.SistaAnmälningsDatum
            $starttid = $r.StartTid
            $today = Get-Date
            $urlToRace = $BaseUrl + $r.documentId
            $eventNumber = ($r.documentId).Split('/')[-1]

            $MoreEventInfo = Invoke-RestMethod -uri "http://swecyclingonline.se/api/v1/tavling/$eventNumber" -Method Get

            if($sistaAnmalan -notlike ""){
                $sistaAnmalan = $sistaAnmalan.ToString("yyyy-MM-dd")
                $DagarTillSistaAnmalning = (New-TimeSpan -Start $today -End $sistaAnmalan).Days
            }#End if
    
            if($starttid -notlike ""){
                $starttid = $starttid.ToString("yyyy-MM-dd")
                $dagartillstart = (New-TimeSpan -Start $today -End $starttid).Days
            }#End if
            
            #Att göra, ta fram plats och arrangerande klubb!
            #Tex: $moreinfo = Invoke-RestMethod -uri "http://swecyclingonline.se/api/v1/tavling/16551" -Method get
            
            $customObject = New-Object System.Object
            $customObject | Add-Member -Type NoteProperty -Name Namn -Value $r.namn
            $customObject | Add-Member -Type NoteProperty -Name Plats -Value $MoreEventInfo.Plats
            $customObject | Add-Member -Type NoteProperty -Name Arrangör -Value $MoreEventInfo.arrangörInfos.arrangörNamn
            $customObject | Add-Member -Type NoteProperty -Name Typ -Value $r.Typ
            $customObject | Add-Member -Type NoteProperty -Name StartTid -Value $starttid
            $customObject | Add-Member -Type NoteProperty -Name SistaAnmälningsDatum -Value $sistaAnmalan
            $customObject | Add-Member -Type NoteProperty -Name DagarTillStart -Value $dagartillstart
            $customObject | Add-Member -Type NoteProperty -Name DagarTillSistaAnmalning -Value $DagarTillSistaAnmalning
            $customObject | Add-Member -Type NoteProperty -Name URL -Value (New-UDLink -Text "Mer information och anmälan(extern sida)" -Url $urlToRace -OpenInNewWindow)
            $customObject | Add-Member -Type NoteProperty -Name Kategori -Value $r.Kategori
            $returnArray.Add($customObject) | Out-Null
        }#End foreach
    }#End process

    end{
        return $returnArray
    }#End end
}#End function

function Get-TotalRacesFromApi{
    [CmdletBinding()]
    param()#End param
    begin{
        $returnArray = [System.Collections.ArrayList]@()
        $grenar = "landsväg", "mountainbike", "cykelcross"
    }#End begin

    process{
        foreach($g in $grenar){
            $result = (Get-RaceFromApi -Gren $g) | Measure-Object | Select-Object count
            $customObject = New-Object System.Object
            $customObject | Add-Member -Type NoteProperty -Name Gren -Value $g
            $customObject | Add-Member -Type NoteProperty -Name Antal -Value $result
            $returnArray.Add($customObject) | Out-Null
        }#End foreach
    }#End process

    end{
        return $returnArray
    }
}#End function