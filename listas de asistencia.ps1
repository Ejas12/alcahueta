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
do {
    try {
        
        $emailcheck = Read-host "Desea Enviar correos? (Y/N)"
        } # end try
    catch {Write-Host 'escoja entre Y o N, no se ponga creativa'}
    } # end do 
until ($emailcheck -eq 'y' -or $emailcheck -eq 'n' )





foreach ($profe in $profeslist) {
$profecourseid = $profe.courseID



$outpng = $profecourseid+".png"
#$snapurl = "https://s3-us-west-2.amazonaws.com/liftinglistsnaps/"+$outpng
$profeid= $profe.profeid
$curso = $profe.profecurso
$profefull = $profe.profenombre+" "+$profe.profeapellido
$profeemail = $profe.profeemai
$profephone = $profe.profephone
$outcsv = $profefull+"-"+$curso+"-"+$profecourseid+".csv"
$outhtml = $profefull+"-"+$curso+"-"+$profecourseid+".html"
####definir dias#####

$horas = $profe.short_name
if ($profe.profedia -eq "S") {$cursodia= "Sabado"}
if ($profe.profedia -eq "M") {$cursodia = "Lunes"} 
if ($profe.profedia -eq "T") {$cursodia = "Martes"} 
if ($profe.profedia -eq "W") {$cursodia = "Miercoles"}
if ($profe.profedia-eq "H") {$cursodia = "Jueves"}
if ($profe.profedia -eq "F") {$cursodia = "Viernes"}

#############################################


$listafiltrada = $students | where {$_.courseID -eq $profecourseid} | select Nombre, Apellido, 'Telefono directo'



$listafiltrada |  Export-Csv $outcsv -NoTypeInformation
$addprofe = $emailtemplate -replace '@PROFE', $profefull
$addcourse = $addprofe -replace '@coursename', $curso
$adddias = $addcourse -replace '@dias', $cursodia
$addhora = $adddias -replace '@hora', $profe.profehorariostart
$addhora | Out-File $outhtml
$emailbody = gc $outhtml -Encoding UTF8 | Out-String 
$Subject = "Listas de Clase - Lifting Hands"
#Write-Host $profeemail $snapurl
#$msgid = Get-Random -Minimum 3 -Maximum 9999
#python convert-csv-to-jpg.py $outcsv
#$whatsappapicall = 'https://www.waboxapp.com/api/send/media?token=2f9946f8f7dbfc1cfb8ddeb854b10f3a5aca527b4b2a7&uid=50689910903&to='+$profephone+'&custom_uid=msg'+$msgid+'&caption=test+alcahueta&url='+$snapurl
#Invoke-WebRequest $whatsappapicall

if ($emailcheck -eq 'Y') {

$email = "monica@liftinghands.org" 
$pass = "####" 
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$gmailcred = Get-Credential "monica@liftinghands.org"


Send-MailMessage -From $email -to $profeemail -Subject $Subject -Credential $gmailcred -Attachments $outcsv -Body $emailbody  -SmtpServer $SMTPServer  -port $SMTPPort -UseSsl -BodyAsHtml -Encoding UTF8 -Bcc 'esteban128a@hotmail.com', 'monica@liftinghands.org'
$profeemail
}

} 

