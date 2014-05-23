
# variables generale

$asupv2="C:\ASUPV2"
$destination="D:\_Stordata\traitement"
$7z="$asupv2\7za.exe"

$datelog=Get-Date -UFormat %d-%m-%y
Start-Transcript -path "D:\_Stordata\log\$datelog.log" -Append


# recuperation des *.box copié et decompression avec Uud64winpe.exe
Write-host "_                                        _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ traitement des Weeklylog ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                        _" -foregroundcolor "black" -BackgroundColor "white"
$items=Get-Item "$destination\*WEEKLY_LOG-INFO.box"
#if (-not (test-path "$destination\box")) {new-item -ItemType Directory "$destination\box"}
foreach ($item in $items) {
 
 $name=$item.BaseName
 $extract="WKL_$($item.BaseName.Split("_")[0])_$($item.BaseName.Split("_")[1])_$($item.BaseName.Split("_")[3])"

 if (-not (test-path "$destination\$extract")) {new-item -ItemType Directory "$destination\$extract"}

 
& $asupv2\Uud64winpe.exe "$item" /Extract /OutDir="$destination\$extract" | Out-Null
 }

Write-host "_                                                   _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ traitement des management log (v8+) ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                                   _" -foregroundcolor "black" -BackgroundColor "white"

 $mgmts=Get-Item "$destination\*MANAGEMENT_LOG-INFO.box"


foreach ($mgmt in $mgmts) {
 
 $name=$mgmt.BaseName
 $extract="MGMT_$($mgmt.BaseName.Split("_")[0])_$($mgmt.BaseName.Split("_")[1])_$($mgmt.BaseName.Split("_")[3])"

 if (-not (test-path "$destination\$extract")) {new-item -ItemType Directory "$destination\$extract"}

 
& $asupv2\Uud64winpe.exe "$mgmt" /Extract /OutDir="$destination\$extract" | Out-Null
 }


 #recuperation des repertoires suite a la decompression pour traitement des archives

 $directory=dir -Path $destination -Directory

Write-host "_                                                  _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ deplacement des fichiers Message1* ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ traitement des archives 1ere passe ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                                  _" -foregroundcolor "black" -BackgroundColor "white"


 foreach ($dir in $directory){
 $rep=$dir.basename.split("_")
 $finale=$($rep[1]) + "_" + ($rep[2]) + "_" + ($rep[3])
 if (-not (test-path "$destination\$finale")) {new-item -ItemType Directory "$destination\$finale"}
# traitement des archives

Move-Item "$destination\$dir\message1*" -Destination $destination\$finale

do {

$archives=Get-Item -Path $destination\$dir\* -Include *.7z, *.tar, *.gz

foreach ($archive in $archives.Name)
{
& "$7z" x "$destination\$dir\$archive" -o"$destination\$finale" -aoa
Remove-Item "$destination\$dir\$archive"
}}
while ($flagArchive=(Test-Path -Path $destination\$dir\* -Include *.7z, *.tar, *.gz))

Remove-Item $destination\$dir
}

Write-host "_                                                  _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ traitement des archives 2eme passe ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                                  _" -foregroundcolor "black" -BackgroundColor "white"


$ntaps=dir -Path $destination -Directory -Filter NTAP*
 foreach ($ntap in $ntaps){



do {

$archives=Get-Item -Path $destination\$ntap\* -Include *.7z, *.tar, *.gz

foreach ($archive in $archives.Name)
{
& "$7z" x "$destination\$ntap\$archive" -o"$destination\$ntap" -aoa
Remove-Item "$destination\$ntap\$archive"
}}
while ($flagArchive=(Test-Path -Path $destination\$ntap\* -Include *.7z, *.tar, *.gz))
}


#recuperation des repertoires suite a la decompression pour traitement des EMS
$directory=dir -Path $destination -Directory

Write-host "_                                  _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ traitement des EMS ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                  _" -foregroundcolor "black" -BackgroundColor "white"

 foreach ($dir in $directory){


# traitement des EMS

if (Get-Item -Path $destination\$dir\* -Include *.ems) {
$ems=Get-Item -Path $destination\$dir\* -Include *.ems
$ems
& "$asupv2\sed\sed.exe" -f "$asupv2\sed\ems_logdump.sed" "$ems" > "$ems.dump"
}

if (Get-Item -Path $destination\$dir\* -Include EMS-LOG-FILE) {

$ems1=Get-Item -Path $destination\$dir\* -Include EMS-LOG-FILE
$ems1
& "$asupv2\sed\sed.exe" -f "$asupv2\sed\ems_logdump.sed" "$ems1" > "$ems1.dump"
}
}

# traitement des fichiers message1* afin de splitter le fichier en categories

Write-host "_                                            _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ Split des fichiers Message1* ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                            _" -foregroundcolor "black" -BackgroundColor "white"

 foreach ($dir in $directory){
$message1=Get-Item "$destination\$dir\message1*(WEEKLY_LOG) INFO.txt"
 $dir
 $message1

 foreach ($msg in $message1) {
cd $msg.DirectoryName
& csplit -ks $msg "/^===== /" "{*}"
cd ..
}}

Write-host "_                                                _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ traitement des fichiers Splittés ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                                _" -foregroundcolor "black" -BackgroundColor "white"

# renomage des fichiers splité

foreach ($dir in $directory){

if ((Test-Path "$dir\xx*") -eq "True"){
$xx=get-item $dir\xx*

foreach ($x in $xx) {
$string=head -n 1 $x



$strings=$string.Substring(6,$string.Length-12)
$strings
mv "$x" "$dir\$strings.txt"
}}}


# extract des alertes et anomalies dans les fichiers dump

Write-host "_                                       _" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "________ Recherche des anomalies ________" -foregroundcolor "black" -BackgroundColor "white"
Write-Host "_                                       _" -foregroundcolor "black" -BackgroundColor "white"

foreach ($dir in $directory){

if ((Test-Path $dir\*.dump) -eq "true")
{
$file="$dir\_grep.txt"
$dumpalert=Get-Content $dir\*.dump | where {$_ -match "alert"}
$dumpcritical=Get-Content $dir\*.dump | where {$_ -match "critical"}
$dumperror=Get-Content $dir\*.dump | where {$_ -match "error"}
$dumpwarning=Get-Content $dir\*.dump | where {$_ -match "warning"}

$msgalert=Get-Content $dir\messages.* | where {$_ -match "alert"}
$msgcritical=Get-Content $dir\messages.* | where {$_ -match "critical"}
$msgerror=Get-Content $dir\messages.* | where {$_ -match "error"}
$msgwarning=Get-Content $dir\messages.* | where {$_ -match "warning"}

echo "------- dump -------" > $file
echo "nbre de ligne contenant Alert : $($dumpalert.count)" >> $file
echo "nbre de ligne contenant critical : $($dumpcritical.count)" >> $file
echo "nbre de ligne contenant error : $($dumperror.Count)" >> $file
echo "nbre de ligne contenant Warning : $($dumpwarning.count)" >> $file
echo " "  >> $file
echo "------- messages -------" >> $file
echo "nbre de ligne contenant Alert : $($msgalert.count)" >> $file
echo "nbre de ligne contenant critical : $($msgcritical.count)" >> $file
echo "nbre de ligne contenant error : $($msgerror.Count)" >> $file
echo "nbre de ligne contenant Warning : $($msgwarning.count)" >> $file
echo " "  >> $file
echo " "  >> $file

echo "====== Alert ======" >> $file
echo " "  >> $file

echo "------- dump -------" >> $file
echo $dumpalert >> $file
echo " "  >> $file

echo "------- messages -------" >> $file
echo $msgalert >> $file
echo " "  >> $file
echo " "  >> $file

echo "====== Critical ======" >> $file
echo " "  >> $file

echo "------- dump -------" >> $file
echo $dumpcritical  >> $file
echo " "  >> $file

echo "------- messages -------" >> $file
echo $msgcritical >> $file

echo " "  >> $file
echo " "  >> $file

echo "====== Error ======" >> $file
echo " "  >> $file

echo "------- dump -------" >> $file
echo $dumperror  >> $file
echo " "  >> $file

echo "------- messages -------" >> $file
echo $msgerror >> $file
echo " "
echo " "

echo "====== Warning ======" >> $file
echo " "  >> $file

echo "------- dump -------" >> $file
echo $dumpwarning  >> $file
echo " "  >> $file

echo "------- messages -------" >> $file
echo $msgwarning >> $file

}

if ((Test-Path $dir\ENVIRONMENT*) -eq "true")
{
$env=Get-Content .\ENVIRONMENT.txt | where {$_ -match '^Voltage.Status' -or $_ -match 'psu[0-9] FAN[0-9] FAULT' -or $_ -match 'psu[0-9].pseudo' -or $_ -match 'psu[0-9].status' -or $_ -match 'Battery.charge'}

$filenv="$dir\_env.txt"
echo $env  > $filenv
}
}


Stop-Transcript