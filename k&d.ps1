
#<Techno>_<serial>_<date>-<heure>_<nom>_<bla-bla_inutile>
#<codeclient>_<SITE>_<SERIALNUMBER>_<AAAAMMJJ>_NTAPP001.zip
$rep="D:\_Stordata\traitement"
$asupv2="C:\ASUPV2"
$kd="D:\_Stordata\kandd"
$csv="D:\_Stordata\Services_Manages\serial.csv"

$items=Get-ChildItem -path $rep -Directory -Name

foreach ($item in $items) { 
$split=$item.Split("_")

$serial=$split[1]
$name=$split[2]

$date=Get-Date -Format yyyyMMdd

$sites=ipcsv $csv -Delimiter ";"|where {$_.serial -eq $serial}
$site=$sites.site

$archive="RD1403047_$($site)_$($serial)_$($date)_NTAPP001.zip"
#on zippe le contenu du répertoire dans l’archive précédemment défini

& $asupv2\7za.exe a -tzip $kd\$archive $rep\$item\* }