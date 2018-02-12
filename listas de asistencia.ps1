$students = Import-Csv .\students.csv
$profeslist = Import-Csv .\profes.csv
$emailtemplate = gc .\emailtemplate.html -Encoding UTF8
$email = "myemail3@gmail.com" 
$pass = "MyPass@123" 
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$gmailcred = Get-Credential "Entre su usuario y contrasena"


foreach ($profe in $profeslist) {


$outcsv = $profe.profenombre+".csv"
$outhtml = $profe.profenombre+".html"

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



$listafiltrada = $students | where {$_.ProfeID -eq $profeid} 



$listafiltrada | Export-Csv $outcsv -NoTypeInformation
$addprofe = $emailtemplate -replace '@PROFE', $profefull
$addcourse = $addprofe -replace '@coursename', $curso
$adddias = $addcourse -replace '@dias', $cursodia
$addhora = $adddias -replace '@hora', $profe.profehorariostart
$emailbody = $addhora 
$emailbody | Out-File $outhtml
$Subject = "Email Subject"

#Send-MailMessage -From $email -to $profeemail -BCc 'esteban128a@hotmail.com' -Subject $Subject `
#-Body $emailbody -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
#-Credential $gmailcred -Attachments $outcsv

} 