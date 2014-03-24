:: recuperation des informations SN Date Name et deduction du fichier contenant le messages.log
:: %%a = Serial number
:: %%b = Date
:: %%c = Nom netapp
@echo off


for /F "tokens=2,3,5 delims=_-" %%a IN ("%~nx1") do (
echo %%a %%b %%c

dir /B %~dp1\junk\NTAP_%%a_%%b*MANAGEMENT_LOG-INFO.box > %temp%\tmp.txt
)


:: recuperation du fichier box contenant le messages.log dans le rep /junk
for /f %%i in (%temp%\tmp.txt) do (
echo %%i
IF EXIST %~dp1\junk\%%i (
mkdir D:\_Stordata\traitement\%%~ni

D:\_Stordata\ASUPV2\ASUPV2\Uud64winpe.exe %~dp1\junk\%%i /Extract /OutDir=D:\_Stordata\traitement\%%~ni

echo suppression du fichier tmp.txt
del %temp%\tmp.txt
) else (
echo Fichier Introuvable
)

)
pause