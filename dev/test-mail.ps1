$exp=Read-Host "qui est l'expediteur ?"
$dest=Read-Host "quelle est l'adresse du destinataire ?"
$user=Read-Host "quel est l'user smtp ?"
$pwd=Read-Host -assecurestring "quel est le mdp smtp ?"

#$filename = “path\to\file.ext”
$smtpserver = “smtp.gmail.com”
$msg = new-object Net.Mail.MailMessage
#$att = new-object Net.Mail.Attachment($filename)
$smtp = new-object Net.Mail.SmtpClient($smtpServer, 587)
$smtp.EnableSsl = $True
$smtp.Credentials = New-Object System.Net.NetworkCredential(“$user”, “$pwd”); # Put username without the @GMAIL.com or – @gmail.com
$msg.From = “$exp”
$msg.To.Add($dest)
$msg.Subject = “Sujet du mail”
$msg.Body = “Bonjour, 
Veuillez trouver ci joint le mail attendu.
Cordialement”
#$msg.Attachments.Add($att)
$smtp.Send($msg)