$countryName = "Germany"

$uri = "http://www.officeholidays.com/countries/$countryName/index.php"
$html = Invoke-WebRequest -Uri $uri
$holidays = ($html.ParsedHtml.getElementsByTagName("table") | Where-Object ClassName -eq 'list-table' | Select-Object -ExpandProperty InnerText) -split "`n"

$holidays.Count

$hols = foreach ($holiday in $holidays[1..($holidays.Count -1)]){
   $x = $holiday -split " "
   $y = $x[0] -split "day"
   
   $props = [ordered]@{
     DayOfWeek = "$($y[0])day"
     Day = $x[1]
     Month = $y[1]
     Holiday = $x[4..($x.Count-1)] -join " "
   }
   
   New-Object -TypeName PSObject -Property $props
 }

$hols | Format-Table -AutoSize -Wrap