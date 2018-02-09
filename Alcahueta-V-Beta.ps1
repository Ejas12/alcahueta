$students = Import-Csv .\students.csv
$profeslist = Import-Csv .\profes.csv
$emailbody1 = gc .\emailtemplate.html

foreach ($profe in $profeslist) {


$outcsv = $profename+" "+$profeapellido+".csv"



$listafiltrada = $students | where {$_.profeiD -eq $profeID}


$listafiltrada | Export-Csv -NoTypeInformation -path $outcsv 



} 