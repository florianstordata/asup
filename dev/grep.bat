@echo off

for /D /R "D:\_Stordata\traitement\" %%g in (NTAP*) do (
echo traitement du dossier %%g
egrep -i ^Voltage.Status %%g\ENVIRONMENT.txt > %%g\0_env.txt
egrep -i ^psu[0-9].pseudo %%g\ENVIRONMENT.txt >> %%g\0_env.txt
egrep -i ^psu[0-9].status %%g\ENVIRONMENT.txt >> %%g\0_env.txt
egrep -i ^Battery.charge %%g\ENVIRONMENT.txt >> %%g\0_env.txt
egrep -i ^psu[0-9].fan[0-9].*[K] %%g\ENVIRONMENT.txt >> %%g\0_env.txt
egrep -i error %%g\messages.* > %%g\1_error.txt
egrep -i warning %%g\messages.* > %%g\2_warning.txt
egrep -i alert %%g\messages.* > %%g\3_alert.txt
egrep -i critical %%g\messages.* > %%g\4_critical.txt
egrep -i error %%g\*.dump* > %%g\1b_error.txt
egrep -i warning %%g\*.dump* > %%g\2b_warning.txt
egrep -i alert %%g\*.dump* > %%g\3b_alert.txt
egrep -i critical %%g\*.dump* > %%g\4b_critical.txt
)
