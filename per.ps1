
# variable generale 
$asupv2="C:\ASUPV2"
$destination="D:\_Stordata\perf"
$stornetapp="\\10.10.10.18\autosupport"
#$stornetapp="z:"
$date=get-date
$csv="D:\_Stordata\Services_Manages\serial.csv"
$7z="$asupv2\7za.exe"

Import-Module PSFTP 

if (Test-Path $destination) { Remove-Item $destination -Recurse -Force}
new-item -ItemType Directory $destination

$datelog=Get-Date -UFormat %d-%m-%y
Start-Transcript -path "D:\_Stordata\log\perf-$datelog.log" -Append


 # decoleration des elements de dates
 $month=$date.month
 $year=$date.Year
 $day=$date.day
 
#mis en coresspondance des clients avec le rerpertoire
$refs=ipcsv $csv -Delimiter ";" | where {$_.folder -ne "$null"} # -and $_.clients -eq "CH-Montfermeil"} 

# attribution du repertoire dans la variable $rep
foreach ($ref in $refs) {


  if ($day -lt "10") {

 $perf="NTAP_$($ref.serial)_0$day*PERFORMANCE-INFO.box"
 }

 else { 
 $perf="NTAP_$($ref.serial)_$day*PERFORMANCE-INFO.box"
 }

  if ($month -lt "10") {
  $final="$($ref.folder)\$Year\0$month\"
}

else { 
$final="$($ref.folder)\$Year\$month\"
}


$junk=get-item "$stornetapp\$final\junk\$perf"
$name=$item.BaseName

echo "traitement de $($ref.clients)"
echo "copie de $junk"
Copy-Item  $junk -Destination $destination

}


# unboxing des fichiers

$items=Get-Item "$destination\*.box"
foreach ($item in $items) {
 
 $name=$item.BaseName
 $extract="$($item.BaseName.Split("_")[3])_$($item.BaseName.Split("_")[1])_$($item.BaseName.Split("_")[2])"

 if (-not (test-path "$destination\$extract")) {new-item -ItemType Directory "$destination\$extract"}

 
& $asupv2\Uud64winpe.exe "$item" /Extract /OutDir="$destination\$extract" | Out-Null

Remove-Item $item

 }



$bodys=dir "$destination" -Directory
foreach ($body in $bodys) {

& "$7z" x "$destination\$body\body.7Z" -o"$destination\$body" -aoa

if (Test-Path $destination\$body\cm_stats_hourly_data.xml) {
& $7z a -tgzip "$destination\$body\cm_hourly_stats.gz" "$destination\$body\cm_stats_hourly_data.xml"}

$gz=Get-Item $destination\$body\*cm_hourly_stats.gz
Rename-Item $gz $destination\$body\$body-cm_hourly_stats.gz
Move-Item $destination\$body\$body-cm_hourly_stats.gz $destination\
}


# envoi par ftp du fichier 
$password = ConvertTo-SecureString "K&dSt0red0t020140429" -AsPlainText -Force
$username = "stordata"
$ftpCreds = New-Object System.Management.Automation.PSCredential $Username, $Password
set-FTPConnection -Credentials $ftpCreds -server ftp://ftp.k-and-decide.com -UsePassive 

$stats=Get-ChildItem $destination *cm_hourly_stats.gz -Recurse

foreach ($stat in $stats) {
Echo "Envoi du Fichier $stat.fullname"
send-FTPItem -LocalPath $stat.fullname -Path /test -Overwrite

}

$elapsed=[math]::round(((Get-Date) - $Date).TotalMinutes,2)
echo "This report took $elapsed minutes to run all scripts."


Stop-Transcript