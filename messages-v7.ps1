$items=get-item *WEEKLY_LOG-INFO.box |where {$_ -match "nash" -or $_ -match "NTAP_200000237623" -or $_ -match "NTAP_200000237697"}
foreach ($item in $items) {
$base=$item.basename.split('_')
#$item="NTAP_20020019_11-00h00_nash1_Cluster-Notification-WEEKLY_LOG-INFO.box"
& csplit -ks -f $base[3] $item "/^===== MESSAGE/" "{*}"

$messages=$base[3] + "01"
& csplit -ks -f $base[3] $messages "/^===== ASUP END/" "{*}"

Rename-Item (($base[3]) + "00") messages.log
 $finale=$($base[0]) + "_" + ($base[1]) + "_" + ($base[3])

Move-Item messages.log $finale

remove-Item ($base[3] + '*')
}
