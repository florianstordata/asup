REM @Echo off
rem ------ Initialisation
set fichier_source=%1
set dossier_destination=.
set chaine_delimitation_sections="===== SIS STAT ====="
set chaine_recherche_date="Date de la saisie"

setlocal enabledelayedexpansion
set i1=0
rem if not exist "%dossier_destination%" md "%dossier_destination%"

rem ------ Création du tableau
rem --- Boucle parcourant le fichier source
for /f "tokens=*" %%i in ('type "%fichier_source%"') do (
   rem --- recherche dans la ligne en cours la variable chaine_delimitation_sections 
   echo %%i|find %chaine_delimitation_sections% >nul
   rem --- si recherche positive on fait
   if !errorlevel!==0 (
      rem --- on ajoute 1 a la variable i1
      set /a i1+=1
      rem --- on réinitialise la variable i2
      set i2=0
   )
   rem --- on ajoute 1 a la variable i2
   set /a i2+=1
   rem --- on créé la variable "tab_[numéro de section]_nb" qui contient le nombre de lignes pour la section en cours
   set tab_!i1!_nb=!i2!
   rem --- on créé la variable "tab_[numéro de section]_[numéro de ligne]" qui contient la ligne en cours de la section en cours
   set tab_!i1!_!i2!=%%i
   rem --- recherche dans la ligne en cours la variable chaine_recherche_date
   echo %%i|find %chaine_recherche_date% >nul
   rem --- si recherche positive on créé la varaible "tab_[numéro de section]_date" qui contient la date de la section en cours au format "[mois] [année]"
   if !errorlevel!==0 for /f "tokens=8*" %%j in ("%%i") do set tab_!i1!_date=%%j %%k
)

rem ------ Création des fichiers
rem --- boucle parcourant les sections
for /l %%i in (0,1,%i1%) do (
   rem --- boucle parcourant les lignes de la section en cours
   for /l %%j in (1,1,!tab_%%i_nb!) do (
      rem --- écriture du contenu de la section en cours dans le fichier "[mois] [année].txt"
      echo.!tab_%%i_%%j!>>"%dossier_destination%\!tab_%%i_date!.txt"
   )
)

pause