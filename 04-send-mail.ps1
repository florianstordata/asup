$exp="services_manages@stordata.fr"

$dest="vide"
$dest2="vide"
$dest3="vide"

#netapp
#$dest="dsi_heb@monaco-telecom.mc"
#$dest="infrastructure@edokial.com"
#$dest="sic@bordeaux.inra.fr"
#$dest="laurent.capelli@ccsd.cnrs.fr"
#$dest="Duc.TRAN@dexia.com"
#$dest="christian.avramakis@continental-corporation.com"

#$dest="fguillaud@groupe-atlantic.com"
#$dest2="mmanach@groupe-atlantic.com"

#$dest="adupouy@index-education.fr"
#$dest2="dbarrile@index-education.fr"
#
#$dest="sebastien.mangel@trixell-thalesgroup.com"
#$dest2="thomas.goirand@trixell-thalesgroup.com"
#
#$dest="emmanuel.mercadie@liebherr.com"
#$dest2="patrick.lebre@liebherr.com"

#$dest="christophe.caillet@sfr.com"
#$dest="mbehidi@lagardere.fr"
#$dest="philippe.rousseaux@mt.com"
#$dest="clement.paumier@materis.fr"
#$dest="franck.pignard@biogemma.com"
#$dest="osimpere@bouyguestelecom.fr"

$dest="mmouheb@ch-montfermeil.fr"
$dest2="dschmitt@ch-montfermeil.fr"

# Networker
#$dest="GCA-Networker@groupama-ca.fr"

#$dest="WALLEAUME@gtt.fr"
#$dest2="jmanson@gtt.fr"
#$dest3="prodiere@gtt.fr"

#$dest="frederic.joneau@horiba.com"
#$dest="michel.radovanovitch@tigf.fr"

# Commvault
#$dest="mbehidi@lagardere.fr"
#$dest="LBUART@groupama-loire-bretagne.fr"
#$dest="philippe.rousseaux@mt.com"
#$dest="jean-francois.davis@sdmo.com"

$filename="D:\_Stordata\Template\_CR\30-ch-montfermeil\ch-montfermeil-Managed-Services-20140601.pdf"



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
if ($dest2 -ne "vide"){
$msg.to.add($dest2)}
if ($dest3 -ne "vide"){
$msg.to.add($dest3)}
$msg.Subject = “Services Managés”
$msg.Body = “Bonjour, 


Veuillez trouver ci joint le rapport concernant la periode du 25/05/2014 au 01/06/2014

Cordialement

L’équipe du Support Stordata

”
$msg.Attachments.Add($att)
$smtp.Send($msg)
echo "message envoyé a $dest $dest2 $dest3"