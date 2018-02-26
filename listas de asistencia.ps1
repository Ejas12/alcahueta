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
$emailtemplate = gc .\emailtemplate.html -Encoding UTF8
$email = "liftinghandstest2@gmail.com" 
$pass = "MyPass@123" 
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$gmailcred = Get-Credential "liftinghandstest2@gmail.com"






foreach ($profe in $profeslist) {
$profecourseid = $profe.courseID

$outcsv = $profecourseid+".csv"
$outhtml = $profecourseid+".html"

$profeid= $profe.profeid
$curso = $profe.profecurso
$profefull = $profe.profenombre+" "+$profe.profeapellido
$profeemail = $profe.profeemail

####definir dias#####

$horas = $profe.short_name
if ($profe.profedia -eq "S") {$cursodia= "Sabado"}
if ($profe.profedia -eq "M") {$cursodia = "Lunes"} 
if ($profe.profedia -eq "T") {$cursodia = "Martes"} 
if ($profe.profedia -eq "W") {$cursodia = "Miercoles"}
if ($profe.profedia-eq "H") {$cursodia = "Jueves"}
if ($profe.profedia -eq "F") {$cursodia = "Viernes"}

#############################################


$listafiltrada = $students | where {$_.courseID -eq $profecourseid} 



$listafiltrada | Export-Csv $outcsv -NoTypeInformation
$addprofe = $emailtemplate -replace '@PROFE', $profefull
$addcourse = $addprofe -replace '@coursename', $curso
$adddias = $addcourse -replace '@dias', $cursodia
$addhora = $adddias -replace '@hora', $profe.profehorariostart
$addhora | Out-File $outhtml
$emailbody = gc $outhtml -Encoding UTF8 | Out-String 
$Subject = "Email Subject"
Write-Host $profeemail
#Send-MailMessage -From $email -to $profeemail -Subject $Subject -Credential $gmailcred -Attachments $outcsv -Body $emailbody  -SmtpServer $SMTPServer  -port $SMTPPort -UseSsl -BodyAsHtml -Encoding UTF8
} 