$datelog=Get-Date -UFormat %d-%m-%y
Start-Transcript -path "D:\_Stordata\log\$datelog.log" -Append
$date=get-date

$destination="D:\_Stordata\traitement"

cd $destination

# on recupere le repertoire courant
$rep = (Get-Location).path

$items=Get-ChildItem -Directory -Name
foreach ($item in $items) {
$split=$item.Split("_") 
$serial=$split[1]
$serial
$name=$split[2]
$name

if(test-path "$name-$serial.xlsx") {remove-item "$name-$serial.xlsx"}

# declaration des fichiers textes
$df=get-content "$item\df.txt" | ? {$_ -NotMatch "==="}
$dfa=get-content "$item\df-a.txt" | ? {$_ -NotMatch "==="}
$dfs=get-content "$item\df-s.txt" | ? {$_ -NotMatch "==="}

#clean des fichiers textes
# on remplace tous les espaces par une virgule pour creer un fichier csv 
$df -replace '\s+', ',' >cdf.csv
$dfa -replace '\s+', ',' >cdfa.csv
$dfs -replace '\s+', ',' >cdfs.csv

# on speicifie le fichier de sortie 
$xlout = "$($rep)\$name-$serial.xlsx"

# on importe et variabilise les csv precedement généré
$bladf=import-csv cdf.csv -header Filesystem, kbytes, used, avail, capacity, "Mounted on" | where {$_.Filesystem -match "/vol/" -or $_.Filesystem -match "Filesystem"}
$bladfa=import-csv cdfa.csv -header Aggregate, kbytes, used, avail, capacity
$bladfs=import-csv cdfs.csv -header Filesystem, used, total-saved, %total-saved, deduplicated, %deduplicated, compressed, %compressed, "vbn zero", "%vbn zero"

# on créé l'appel de l'application excel
$Excel = New-Object -ComObject excel.application 
# on créé un nouveau classeur 
$workbook = $Excel.workbooks.add(1)
#on créé des onglets
$Global:ws=$workbook.WorkSheets.item(1)

# compteur pour les lignes
$i = 1 
$Global:ws.Name="$($name)-DFS"

#on boucle sur chaque ligne afin de remplire le fichier excel 
foreach ($blah in $bladfs) {

$excel.cells.item($i,1) = $blah.Filesystem
$excel.cells.item($i,2) = $blah."used"
$excel.cells.item($i,3) = $blah."total-saved"
$excel.cells.item($i,4) = $blah."%total-saved"
$excel.cells.item($i,5) = $blah."deduplicated"
$excel.cells.item($i,6) = $blah."%deduplicated"
$excel.cells.item($i,7) = $blah."compressed"
$excel.cells.item($i,8) = $blah."%compressed"
$excel.cells.item($i,9) = $blah."a-sis"
$excel.cells.item($i,10) = $blah."%saved"
 $i++
}

#on remet le compteur a 1
$i = 1 
# on ajoute un onglet
$Global:ws=$workbook.WorkSheets.Add()
# on donne un nom a l'onglet
$Global:ws.Name="$($name)-DF"

#on boucle sur chaque ligne afin de remplir le fichier excel 
foreach ($blah in $bladf) {

$excel.cells.item($i,1) = $blah.Filesystem
$excel.cells.item($i,2) = $blah."kbytes"
$excel.cells.item($i,3) = $blah."used"
$excel.cells.item($i,4) = $blah."avail"
$excel.cells.item($i,5) = $blah."capacity"
$excel.cells.item($i,6) = $blah."Mounted on"
 
 $i++
}

#on remet le compteur a 1
$i = 1 
# on ajoute un onglet
$Global:ws=$workbook.WorkSheets.Add()
#on nomme l'onglet
$Global:ws.Name="$($name)-DFA"

#on boucle sur chaque ligne afin de remplir le fichier excel 

foreach ($blah in $bladfa) {

$excel.cells.item($i,1) = $blah.Aggregate
$excel.cells.item($i,2) = $blah."kbytes"
$excel.cells.item($i,3) = $blah."used"
$excel.cells.item($i,4) = $blah."avail"
$excel.cells.item($i,5) = $blah."capacity"
 $i++
}



# on affiche ou pas Excel
$Excel.visible = $false

# on enregistre le ficheir excel 
$Workbook.SaveAs($xlout, 51)
# on quitte excel
$excel.Quit()

remove-item cdfs.csv
remove-item cdfa.csv
remove-item cdf.csv

}

$elapsed=[math]::round(((Get-Date) - $Date).TotalMinutes,2)
echo "This report took $elapsed minutes to run all scripts."

Stop-Transcript