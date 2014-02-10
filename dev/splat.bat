@echo off
setlocal EnableDelayedExpansion

:: creation du repertoire de destination
mkdir %~n1
:: execution dans le repertoire
cd %~n1

:: split du fichier fourni avec comme separateur ===== 
csplit -ks %~dpnx1 "/^===== /" {*}


:: boucle pour renommer les fichiers splités en fonction de la commande passé

FOR /r %%X IN (xx*) DO CALL :loopbody %%X

GOTO :EOF

:loopbody
:: on recupere la 1ere ligne du fichier 
head -n 1 %1 > var.txt
:: on variabilise la ligne recuperé
set /P name=<var.txt
:: on renomme le fichier xx0* avec le nom de la commande netapp pour plus de lisibilité 
mv "%1" "%name%"
:: on supprime le fichier temporaire
del var.txt
GOTO :EOF