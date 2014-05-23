$exp="services_manages@stordata.fr"
$dest="mbehidi@lagardere.fr"
#$dest2="patrick.lebre@liebherr.com"
$filename="D:\_Stordata\Template\_CR\98-cv-Lagardere\Lagardere_20140523.pdf"




#$exp=Read-Host "qui est l'expediteur ?"
#$dest=Read-Host "quelle est l'adresse du destinataire ?"
#
#$user=Read-Host "quel est l'user smtp ?"
#$pwd=Read-Host -assecurestring "quel est le mdp smtp ?"

$smtpserver = “10.10.120.52”
$msg = new-object Net.Mail.MailMessage
$att = new-object Net.Mail.Attachment("$filename")
$smtp = new-object Net.Mail.SmtpClient($smtpServer, 25)
$smtp.EnableSsl = $false
#$smtp.Credentials = New-Object System.Net.NetworkCredential(“$user”, “$pwd”); # Put username without the @GMAIL.com or – @gmail.com
$msg.From = “$exp”
$msg.To.Add($dest)
#$msg.to.add($dest2)
$msg.Subject = “Services Managés”
$msg.Body = “Bonjour, 


Veuillez trouver ci joint le rapport concernant la periode du 22/05/2014 au 23/05/2014

Cordialement

L’équipe du Support Stordata

”
$msg.Attachments.Add($att)
$smtp.Send($msg)
echo "message envoyé a $dest"