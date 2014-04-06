$exp="services_manages@stordata.fr"
$dest="mbehidi@lagardere.fr"
$dest2="florian.firminhac@stordata.fr"
$filename=get-item "D:\_Stordata\lagardere\Lagardere_Services_managés-20140331.pdf"


#$exp=Read-Host "qui est l'expediteur ?"
#$dest=Read-Host "quelle est l'adresse du destinataire ?"
#
#$user=Read-Host "quel est l'user smtp ?"
#$pwd=Read-Host -assecurestring "quel est le mdp smtp ?"

$smtpserver = “smtp.free.fr”
$msg = new-object Net.Mail.MailMessage
$att = new-object Net.Mail.Attachment("$filename")
$smtp = new-object Net.Mail.SmtpClient($smtpServer, 25)
$smtp.EnableSsl = $false
#$smtp.Credentials = New-Object System.Net.NetworkCredential(“$user”, “$pwd”); # Put username without the @GMAIL.com or – @gmail.com
$msg.From = “$exp”
$msg.To.Add($dest)
$msg.to.add($dest2)
$msg.Subject = “Services Managés”
$msg.Body = “Bonjour 

Veuillez trouver ci joint le rapport des Services Commvault

Cordialement
L’équipe du Support Stordata
”
$msg.Attachments.Add($att)
$smtp.Send($msg)