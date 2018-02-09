$students = Import-Csv .\students.csv
$profeslist = Import-Csv .\profes.csv
$emailbody1 = gc .\emailtemplate.html

foreach ($profe in $profeslist) {

$profename = $profe.profenombre
$profeapellido = $profe.profeapellido
$profeemail = $profe.profeemail
$profeID = $profe.profeid

$addprofe = $emailbody1 -replace "@PROFE", $profename
$add


$listafiltrada = $students | where {$_.profeiD -eq $profe.profeID}




$listafiltrada 


} 