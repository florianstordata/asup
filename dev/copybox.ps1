# variable generale 
$asupv2="C:\ASUPV2"
$destination="D:\_Stordata\traitement"
#$stornetapp="\\10.10.10.18\autosupport"
$stornetapp="z:"
$date=get-date
$csv="D:\_Stordata\Services_Manages\serial.csv"


# decalage des jours par rapport a dimanche
If ((get-date).DayOfWeek -eq "monday") {$delta=-1}
If ((get-date).DayOfWeek -eq "tuesday") {$delta=-2}
If ((get-date).DayOfWeek -eq "wednesday") {$delta=-3}
If ((get-date).DayOfWeek -eq "thursday") {$delta=-4}
If ((get-date).DayOfWeek -eq "friday") {$delta=-5}
If ((get-date).DayOfWeek -eq "saturday") {$delta=-6}
If ((get-date).DayOfWeek -eq "sunday") {$delta=-0}

#calcul de la date du dernier dimanche
 $lastsunday=$date.AddDays(+ $delta)

 # decoleration des elements de dates
 $month=$lastsunday.month
 $year=$lastsunday.Year
 $day=$lastsunday.day
 
#mis en coresspondance des clients avec le rerpertoire
$refs=ipcsv $csv -Delimiter ";" | where {$_.folder -ne "$null"} 

# attribution du repertoire dans la variable $rep
foreach ($ref in $refs) {


  if ($day -lt "10") {

 $file="NTAP_$($ref.serial)_0$day*WEEKLY_LOG-INFO.box"
 $mgmt="NTAP_$($ref.serial)_0$day*MANAGEMENT_LOG-INFO.box"
 }

 else { 
 $file="NTAP_$($ref.serial)_$day*WEEKLY_LOG-INFO.box"
 $mgmt="NTAP_$($ref.serial)_$day*MANAGEMENT_LOG-INFO.box"
 }

  if ($month -lt "10") {
  $final="$($ref.folder)\$Year\0$month\"
}

else { 
$final="$($ref.folder)\$Year\$month\"
}

$item=get-item "$stornetapp\$final\$file"
$junk=get-item "$stornetapp\$final\junk\$mgmt"
$name=$item.BaseName

echo "traitement de $($ref.clients)"
echo "copie de $item"
Copy-Item  $item -Destination $destination
echo "copie de $junk"
Copy-Item  $junk -Destination $destination

}

$elapsed=[math]::round(((Get-Date) - $Date).TotalMinutes,2)
echo "This report took $elapsed minutes to run all scripts."