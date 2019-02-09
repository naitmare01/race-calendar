function Get-RaceFromApi{
    [CmdletBinding()]
    param(
        $Gren,
        $BaseUrl = "http://swecyclingonline.se/",
        $Url = "api/v1/tavling/sok2"
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
        if(($Result | Measure-Object).count -eq 0){
            $returnArray = Get-NullResult
        }#End if
        else{
            foreach($r in $Result){
                if($r.Typ -like "Evenemang"){
                    $EvenemangResult = Get-EvenemangFromApi -EvenemangID $r.documentId
                    foreach($e in $EvenemangResult){
                        $returnArray.Add($e) | Out-Null
                    }#End foreach
                }#End if
                else{
                    $urlToRace = $BaseUrl + $r.documentId
                    $MoreEventInfoURL = "$BaseUrl/api/v1/" + $r.documentId
                    $MoreEventInfo = Invoke-RestMethod -uri $MoreEventInfoURL -Method Get

                    if($r.SistaAnmälningsDatum -notlike ""){
                        $sistaAnmalan = Get-SistaAnmalningsDag -SistaAnmalningsDag $r.SistaAnmälningsDatum
                    }#End if
            
                    if($r.StartTid -notlike ""){
                        $starttid = Get-StartTid -StartTid $r.StartTid
                    }#End if

                    $UrlForObject = (New-UDLink -Text "Mer information och anmälan(extern sida)" -Url $urlToRace -OpenInNewWindow)
                    
                    $customObject = New-Object System.Object
                    $customObject | Add-Member -Type NoteProperty -Name Namn -Value $r.namn
                    $customObject | Add-Member -Type NoteProperty -Name Plats -Value $MoreEventInfo.Plats
                    $customObject | Add-Member -Type NoteProperty -Name Arrangör -Value $MoreEventInfo.arrangörInfos.arrangörNamn
                    $customObject | Add-Member -Type NoteProperty -Name Kategori -Value $r.Kategori
                    $customObject | Add-Member -Type NoteProperty -Name StartTid -Value $StartTid.StartTid
                    $customObject | Add-Member -Type NoteProperty -Name SistaAnmälningsDatum -Value $sistaAnmalan.SistaAnmalningsDag
                    $customObject | Add-Member -Type NoteProperty -Name DagarTillStart -Value $StartTid.DagarTillStart
                    $customObject | Add-Member -Type NoteProperty -Name DagarTillSistaAnmalning -Value $sistaAnmalan.DagarTillSistaAnmalning
                    $customObject | Add-Member -Type NoteProperty -Name URL -Value $UrlForObject
                    $returnArray.Add($customObject) | Out-Null
                }#End else
            }#End foreach
        }#End else
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
function Get-EvenemangFromApi{
    [CmdletBinding()]
    param(
        $BaseUrl = "http://swecyclingonline.se/", 
        [Parameter(Mandatory=$True)]
        $EvenemangID
    )#End param
    begin{
        $returnArray = [System.Collections.ArrayList]@()
        $apiUrl = "api/v1/tavling/"
        $apiUrl = "$BaseUrl$apiUrl$EvenemangID"

        $Result = Invoke-RestMethod -Method 'Get' -Uri $apiUrl
    }#End begin

    process{
        foreach($r in $Result){
            $eId = $r.id
            $newApiUrl = "http://swecyclingonline.se/api/v1/$eId"
            try{
                $RaceResult = Invoke-RestMethod -Method 'Get' -Uri $newApiUrl -ErrorAction Stop
            }#End try
            catch{
                continue
            }#End catch
            
            $urlToRace = $BaseUrl + $RaceResult.id

            if($RaceResult.StartTid -notlike ""){
                $starttid = Get-StartTid -StartTid $RaceResult.StartTid
            }#End if

            if($RaceResult.SistaAnmälningsDatum -notlike ""){
                $sistaAnmalan = Get-SistaAnmalningsDag -SistaAnmalningsDag $RaceResult.SistaAnmälningsDatum
            }#End if

            $UrlForObject = (New-UDLink -Text "Mer information och anmälan(extern sida)" -Url $urlToRace -OpenInNewWindow)

            $customObject = New-Object System.Object
            $customObject | Add-Member -Type NoteProperty -Name Namn -Value $RaceResult.namn
            $customObject | Add-Member -Type NoteProperty -Name Plats -Value $RaceResult.Plats
            $customObject | Add-Member -Type NoteProperty -Name Arrangör -Value $RaceResult.arrangörInfos.arrangörNamn
            $customObject | Add-Member -Type NoteProperty -Name Kategori -Value $r.Kategori
            $customObject | Add-Member -Type NoteProperty -Name StartTid -Value $StartTid.StartTid
            $customObject | Add-Member -Type NoteProperty -Name SistaAnmälningsDatum -Value $sistaAnmalan.SistaAnmalningsDag
            $customObject | Add-Member -Type NoteProperty -Name DagarTillStart -Value $StartTid.DagarTillStart
            $customObject | Add-Member -Type NoteProperty -Name DagarTillSistaAnmalning -Value $sistaAnmalan.DagarTillSistaAnmalning
            $customObject | Add-Member -Type NoteProperty -Name URL -Value $UrlForObject
            $returnArray.Add($customObject) | Out-Null
        }#End foreach
    }#End process

    end{
        return $returnArray
    }#End end
}#End function
function Get-StartTid{
    [CmdletBinding()]
    param(
        #Starttime from the api.
        [Parameter(Mandatory=$True)]
        $StartTid
    )#End param

    begin{
        $returnArray = [System.Collections.ArrayList]@()
        $today = Get-Date
    }#End begin

    process{
        foreach($s in $StartTid){
            $s = $s.ToString("yyyy-MM-dd")
            $dagartillstart = (New-TimeSpan -Start $today -End $s).Days

            $customObject = New-Object System.Object
            $customObject | Add-Member -Type NoteProperty -Name StartTid -Value $s
            $customObject | Add-Member -Type NoteProperty -Name DagarTillStart -Value $dagartillstart
            $returnArray.Add($customObject) | Out-Null
        }#End foreach
    }#End process

    end{
        return $returnArray
    }#End end
}#End function
function Get-SistaAnmalningsDag{
    [CmdletBinding()]
    param(
        #Sista SistaAnmalningsDag from the api.
        [Parameter(Mandatory=$True)]
        $SistaAnmalningsDag
    )#End param

    begin{
        $returnArray = [System.Collections.ArrayList]@()
        $today = Get-Date
    }#End begin

    process{
        foreach($s in $SistaAnmalningsDag){
            $s = $s.ToString("yyyy-MM-dd")
            $DagarTillSistaAnmalning = (New-TimeSpan -Start $today -End $s).Days

            $customObject = New-Object System.Object
            $customObject | Add-Member -Type NoteProperty -Name SistaAnmalningsDag -Value $s
            $customObject | Add-Member -Type NoteProperty -Name DagarTillSistaAnmalning -Value $DagarTillSistaAnmalning
            $returnArray.Add($customObject) | Out-Null
        }#End foreach
    }#End process

    end{
        return $returnArray
    }#End end
}#End function

function Get-NullResult{
    [CmdletBinding()]
    param(
    )#End param

    begin{
        $returnArray = [System.Collections.ArrayList]@()
    }#End begin

    process{
        $UrlForObject = (New-UDLink -Text "Inga resultat" -Url "#")

        $customObject = New-Object System.Object
        $customObject | Add-Member -Type NoteProperty -Name Namn -Value ""
        $customObject | Add-Member -Type NoteProperty -Name Plats -Value ""
        $customObject | Add-Member -Type NoteProperty -Name Arrangör -Value ""
        $customObject | Add-Member -Type NoteProperty -Name Kategori -Value ""
        $customObject | Add-Member -Type NoteProperty -Name StartTid -Value ""
        $customObject | Add-Member -Type NoteProperty -Name SistaAnmälningsDatum -Value ""
        $customObject | Add-Member -Type NoteProperty -Name DagarTillStart -Value ""
        $customObject | Add-Member -Type NoteProperty -Name DagarTillSistaAnmalning -Value ""
        $customObject | Add-Member -Type NoteProperty -Name URL -Value $UrlForObject
        $returnArray.Add($customObject) | Out-Null
    }#End process

    end{
        return $returnArray
    }#End end

}#End function