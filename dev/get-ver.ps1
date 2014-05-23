$destination="D:\_Stordata\traitement\_traités"
$items=Get-Item "$destination\*weekly*.box"
foreach($item in $items){
$version=Get-Content $item | where {$_ -match "VERSION=NetApp"}
$serial=$($item.BaseName.Split("_")[1])
$name=$($item.BaseName.Split("_")[3])
$vers=$($version.Split(":""=")[1])
"$serial,$name,$vers" >> version.txt
}