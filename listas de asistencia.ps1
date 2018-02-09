$students = Import-Csv .\students.csv
$profeslist = Import-Csv .\profes.csv
$emailbody1 = gc .\emailtemplate.html
$Header = @"
 <style type="text/css">
@page {
  size: A4 landscape;
}


        body {
            font-family: verdana, arial, sans-serif ;
            font-size: 12px ;
            }
table {
    border-collapse: collapse;page-break-inside: avoid;left:35px; position:relative;page-break-inside:auto
}

table, th, td {
    border: 1px solid black;
}

    thead { display:table-header-group }
    tfoot { display:table-footer-group }
 tr {height: 25%; font-size: 18px;page-break-inside:avoid; page-break-after:auto}
</style>
"@ 

$Header | Out-File out.html

foreach ($profe in $profeslist) {


$outcsv = $profe.profenombre+".html"


$profeid= $profe.profeid
$curso = $profe.profecurso
$profefull = $profe.profenombre+" "+$profe.profeapellido

####definir dias#####

$horas = $profe.short_name
if ($profe.profedia -eq "S") {$cursodia= "Sabado"}
if ($profe.profedia -eq "M") {$cursodia = "Lunes"} 
if ($profe.profedia -eq "T") {$cursodia = "Martes"} 
if ($profe.profedia -eq "W") {$cursodia = "Miercoles"}
if ($profe.profedia-eq "H") {$cursodia = "Jueves"}
if ($profe.profedia -eq "F") {$cursodia = "Viernes"}

#############################################


$titulo = "
<p style='page-break-before: always'>
<img src='Untitled.png' style='width:160px;height:40px; position:relative;'>
<p style='position:relative;left:90px;'> Lista de clase $curso</p>
<p style='position:relative;left:90px;'> Profesor $profefull </p>
<p style='position:relative;left:90px;'> $cursodia de $horas</p>"
$titulo | out-file out.html -Append


$listafiltrada = $students | where {$_.ProfeID -eq $profeid} | select Nombre, Apellido, "Segundo Apellido", "_1", "_2", "_3", "_4","_5", "_6", "_7", "_8", "_9", "10", "11", "12", "13", "14"


$outputhtml = $listafiltrada | ConvertTo-Html -as Table -fragment

$outputhtml | Out-File out.html -Append

} 