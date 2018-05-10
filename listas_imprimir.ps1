####functions######
Function Get-FileName($initialDirectory)
{   
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "All files (*.*)| *.*"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
} #end function Get-FileName


Write-Host 'Seleccione archivo que contiene los alumnos'
$studentsfilename =  Get-FileName
$students = Import-Csv $studentsfilename
Write-Host 'Seleccione archivo que contiene los profes'
$profeslistfilename = Get-FileName
$profeslist = Import-Csv $profeslistfilename

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
$profecourseid = $profe.courseID

$profeid= $profe.profeid
$curso = $profe.profecurso
$profefull = $profe.profenombre+" "+$profe.profeapellido

####definir dias#####

$horas = $profe.profehorariostart+" a "+$profe.profehorariosend

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


$listafiltrada = $students | where {$_.courseID -eq $profecourseid} | select Nombre, Apellido, "Telefono Directo", "_1", "_2", "_3", "_4","_5", "_6", "_7", "_8", "_9", "10", "11", "12", "13", "14"


$outputhtml = $listafiltrada | ConvertTo-Html -as Table -fragment

$outputhtml | Out-File out.html -Append

} 