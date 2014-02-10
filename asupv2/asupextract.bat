@echo off
:: Couleur de fond fenetre DOS et du retour commandes
COLOR 1F

REM :: Taille de la fenetre DOS
REM MODE CON: COLS=80 LINES=10

REM :: Titre
Title " ..::: ASUP Extract V 2.1 :::.. "

rem Initialisation des varibales
setlocal EnableDelayedExpansion
set source="C:\ASUPV2"

rem Choix dun repertoire de destination via le vbs

echo.
echo  Choix du repertoire de destination...
echo.

REM for /f "delims=" %%h in ('cscript %source%\asupextract.vbs') do (set destination=%%h)

REM :: Si la destination est vide / NULL on termine le programme
REM if "%destination%" == "ANNUL" goto fin1
set destination=D:\_Stordata\traitement

	:: Deplacement dans le repertoire source
	pushd "%source%"

	
	:: Suppression du repertoire de destination si deja existant (ASUP EXTRACT deja fait)
	if exist %destination%\%~n1 (
		rmdir %destination%\%~n1 /s /q
	)
	
	:: Creation du repertoire de destination pour reception de lASUP
	mkdir %destination%\%~n1
	
echo.
echo  Choix de la version DOT...
echo.


:question
echo Quelle est la version de DOT (1/2/3)? :
echo 1 : DOT 8.0 et inferieur
echo 2 : DOT 8.1 et superieur
echo 3 : Extract info Mail dot 8.0
echo 4 : Inconnu

set /p choix=
 
if %choix%==1 goto DOT7
if %choix%==2 goto DOT81
if %choix%==3 goto split
if %choix%==4 goto fin
goto question

:DOT7

	
	echo Extract via l outil UUD64
	Uud64winpe.exe %~dpnx1 /Extract /OutDir=%destination%\%~n1
	
	
	:: Tant quil y a des archives
rem	CLS
	echo.
	echo  Decompression des archives...
	echo.
	
	:loopArchive
	set flagArchive=0
	
	:: Pour chaque archive generee par UUD64
	for /r "%destination%\%~n1\" %%I in (*.gz *.7z *.tar) do (
	
		:: Decompression des archives 7z et gz dans le repertoire de destination
		7za.exe x "%%I" -o%destination%\%~n1\ -aoa 
		
		:: Suppression de l archive
		DEL %%I

		:: On change le flag
		set flagArchive=1
		
		)
	:: Fin de FOR
	
	if not "%flagArchive%" == "0" goto loopArchive
	:: Fin de tant que

	:: Traitement des fichiers ems ou EMS-LOG-FILE
rem	CLS
	echo.
	echo  Traitement des fichiers EMS...
	echo.
	
	for /r "%destination%\%~n1" %%I in (*.ems) do (
	
		:: Lancement du script sed
		sed\sed.exe -f sed\ems_logdump.sed "%%I" > %%~dpnI.dump%%~xI
		
	)
	if exist %destination%\%~n1\EMS-LOG-FILE (
		sed\sed.exe -f sed\ems_logdump.sed %destination%\%~n1\EMS-LOG-FILE > %destination%\%~n1\EMS-LOG-FILE.dump
	)
	:: Fin de traitement ems
	
	:: Ouvrir lASUP extrait
	
rem	%SystemRoot%\explorer.exe %destination%\%~n1

pushd %destination%\%~n1

:: split du fichier fourni avec comme separateur "===== "
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
mv "%1" "%name:~6,-6%.txt"
rem echo "%1" "%name%" "%name:~6,-6%" >> rename.txt
:: on supprime le fichier temporaire
del var.txt
GOTO :EOF
	
:fin
exit

:DOT81
 
	:: Extract via loutil UUD64
	Uud64winpe.exe %~dpnx1 /Extract /OutDir=%destination%\%~n1
	
	:: Tant quil y a des archives
rem	CLS
	echo.
	echo  Decompression des archives...
	echo.
	
	:loopArchive1
	set flagArchive=0
	
	:: Pour chaque archive generee par UUD64
	for /r "%destination%\%~n1\" %%I in (*.gz *.7z *.tar) do (
	
		:: Decompression des archives 7z et gz dans le repertoire de destination
		7za.exe x "%%I" -o%destination%\%~n1\ -aoa df-a.txt df.txt df-s.txt environment.txt
		
		:: Suppression de l archive
		DEL %%I

		:: On change le flag
		set flagArchive=1
		
		)
	:: Fin de FOR
	
	if not "%flagArchive%" == "0" goto loopArchive1
	:: Fin de tant que
	
	:: traitement du fichier management-log.box
	
	for /F "tokens=2,3,5 delims=_-" %%a IN ("%~nx1") do (

dir /B %~dp1\junk\NTAP_%%a_%%b*MANAGEMENT_LOG-INFO.box > %temp%\tmp.txt
)

rem verification du fichier %temp%\tmp.txt

find "NTAP" %temp%\tmp.txt>null
if %errorlevel%==0 (
goto suite
) else (
goto introuvable
)
:: recuperation du fichier box contenant le messages.log dans le rep /junk

:suite
set /p messages=< %temp%\tmp.txt
echo le fichier trouvé est : %messages%

Uud64winpe.exe %~dp1\junk\%messages% /Extract /OutDir=%destination%\%~n1

echo suppression du fichier tmp.txt
del %temp%\tmp.txt

rem Decompression des archives 7z et gz 
rem dans le repertoire de destination


for /r "%destination%\%~n1\" %%A in (*.gz *.7z *.tar) do (
	
		7za.exe x "%%A" -o%destination%\%~n1\ -aoa messages.log.gz EMS-LOG-FILE.gz
		7za.exe x "%destination%\%~n1\*.gz" -o%destination%\%~n1\ -aoa
		
		DEL %destination%\%~n1\*.7z %destination%\%~n1\*.gz
		)
	
	:: Traitement des fichiers ems ou EMS-LOG-FILE
rem	CLS
	echo.
	echo  Traitement des fichiers EMS...
	echo.
	
	for /r "%destination%\%~n1" %%I in (*.ems) do (
	
		:: Lancement du script sed
		sed\sed.exe -f sed\ems_logdump.sed "%%I" > %%~dpnI.dump%%~xI
		
	)
	if exist %destination%\%~n1\EMS-LOG-FILE (
		sed\sed.exe -f sed\ems_logdump.sed %destination%\%~n1\EMS-LOG-FILE > %destination%\%~n1\EMS-LOG-FILE.dump
	)
	:: Fin de traitement ems	
		
	:: Ouvrir l ASUP extrait
rem	%SystemRoot%\explorer.exe %destination%\%~n1

goto fin1

REM Action si on n'arrive pas a trouver
REM un fichier 	MANAGEMENT_LOG-INFO
REM correspondant a la date de l'ASUP

:introuvable
cls
color C1
echo Aucun Fichier MANAGEMENT_LOG-INFO ne correspond 
echo verifier par vous meme :
echo le repertoire est : %~dp1%junk
pause
%SystemRoot%\explorer.exe %~dp1%junk
:fin1
exit

REM :split
REM :: execution dans le repertoire
REM pushd %destination%\%~n1

REM :: split du fichier fourni avec comme separateur "===== "
REM csplit -ks %~dpnx1 "/^===== /" {*}


REM :: boucle pour renommer les fichiers splités en fonction de la commande passé

REM FOR /r %%X IN (xx*) DO CALL :loopbody %%X

REM GOTO :EOF

REM :loopbody
REM :: on recupere la 1ere ligne du fichier 
REM head -n 1 %1 > var.txt
REM :: on variabilise la ligne recuperé
REM set /P name=<var.txt
REM :: on renomme le fichier xx0* avec le nom de la commande netapp pour plus de lisibilité 
REM mv "%1" "%name:~6,-6%.txt"
rem echo "%1" "%name%" "%name:~6,-6%" >> rename.txt
REM :: on supprime le fichier temporaire
REM del var.txt
REM GOTO :EOF
rem exit
