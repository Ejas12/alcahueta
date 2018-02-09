$students = Import-Csv .\students.csv
$profeslist = Import-Csv .\profes.csv
$emailbody1 = gc .\emailtemplate.html
$Header = @"
 <style type="text/css">
@page {
  size: A4 landscape;
}
table, figure {
  page-break-inside: avoid;
}

        body {
            font-family: verdana, arial, sans-serif ;
            font-size: 12px ;
            }
        th,
        td {
            padding: 4px 4px 4px 4px ;
            text-align: center ;
            }
        th {
            border-bottom: 2px solid #333333 ;
            }
        td {
            border-bottom: 1px dotted #999999 ;
            }
        tfoot td {
            border-bottom-width: 0px ;
            border-top: 2px solid #333333 ;
            padding-top: 20px ;
            }


</style>
"@ 

foreach ($profe in $profeslist) {


$outcsv = $profe.profenombre+".html"


$profeid= $profe.profeid
$curso = $profe.profecurso

$titulo = "<title>Lista de clase $curso</title>
<p> Lista de clase $curso</p>"

$listafiltrada = $students | where {$_.ProfeID -eq $profeid} | select Nombre, Apellido, "Segundo Apellido", "Telefono directo", "Encargado 1", "Telefono Encargado 1", "Encargado 2", "Telefono Encargado 2"


$outputhtml = $listafiltrada | ConvertTo-Html -as Table -Head $Header -Body $titulo

$outputhtml | Out-File $outcsv

} 