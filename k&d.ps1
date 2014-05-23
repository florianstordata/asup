
#<Techno>_<serial>_<date>-<heure>_<nom>_<bla-bla_inutile>
#<codeclient>_<SITE>_<SERIALNUMBER>_<AAAAMMJJ>_NTAPP001.zip
$rep="D:\_Stordata\traitement"
$asupv2="C:\ASUPV2"
$kd="D:\_Stordata\kandd"

$items=Get-ChildItem -path $rep -Directory -Name

foreach ($item in $items) { 
$split=$item.Split("_")

$serial=$split[1]
$name=$split[2]

$date=Get-Date -Format yyyyMMdd



#client : Monaco Telecom
if ($serial -eq 200000200711 -or $serial -eq 20020019) {$site="Monaco-Telecom"}

#client : Edokial
if ($serial -eq 650002038971) {$site="Edokial"}

#client : INRA BDX
if ($serial -eq 210002038498 -or $serial -eq 210002038486) {$site="Inra-Bordeaux"}

#client : CNRS CSSD
if ($serial -eq 650002056715 -or $serial -eq 650002056727) {$site="CNRS-CSSD"}

#client : DEXIA
if ($serial -eq 200000699857 -or $serial -eq 200000699869) {$site="Dexia"}

#client : Monaco Telecom	
if ($serial -eq 200000706076  -or $serial -eq 200000706569 -or $serial -eq 200000706284  -or $serial -eq 200000708218) {$site="Monaco-Telecom"}

#client : Continental
if ($serial -eq 210002058450 -or $serial -eq 210002058462) {$site="Continental"}

#client : GFC ATLANTIC
if ($serial -eq 210002060178 -or $serial -eq 210002060180) {$site="GFC-Atlantic"}

#client : INDEX EDUCATION
if ($serial -eq 210002072834 -or $serial -eq 210002072846 -or $serial -eq 210002072858 -or $serial -eq 210002072860) {$site="Index-Education"}

#client : SFR Vénissieux
if ($serial -eq 700001008794 -or $serial -eq 500000297473) {$site="SFR-Venissieux"}

#client : LAGARDERE
if ($serial -eq 650002073153 -or $serial -eq 650002073165 -or $serial -eq 500000296572) {$site="Lagardere"}

#client : METTLER-TOLEDO
if ($serial -eq 650002075515 -or $serial -eq 650002075527) {$site="Mettler-Toledo"}

#client : Materis
if ($serial -eq 200000702680 -or $serial -eq 200000702678) {$site="Materis"}

#client : TRIXELL
if ($serial -eq 210002013527 -or $serial -eq 210002013723 -or $serial -eq 200000237623 -or $serial -eq 200000237697) {$site="Thales-trixell"}


$archive="RD1403047_$($site)_$($serial)_$($date)_NTAPP001.zip"
#on zippe le contenu du répertoire dans l’archive précédemment défini

& $asupv2\7za.exe a -tzip $kd\$archive $rep\$item\* }