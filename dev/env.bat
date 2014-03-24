for /f %%i in (NTAP*) do (



egrep -i ^Voltage.Status %%iENVIRONMENT.txt > %%i0_env.txt
egrep -i ^psu[0-9].pseudo %%iENVIRONMENT.txt >> %%i0_env.txt
egrep -i ^psu[0-9].status %%iENVIRONMENT.txt >> %%i0_env.txt
egrep -i ^Battery.charge %%iENVIRONMENT.txt >> %%i0_env.txt
egrep -i ^psu[0-9].fan[0-9].*[K] %%iENVIRONMENT.txt >> %%i0_env.txt
egrep -i error %%imessages.log > %%i1_error.txt
egrep -i warning %%imessages.log > %%i2_warning.txt
egrep -i alert %%imessages.log > %%i_alert.txt
egrep -i critical %%imessages.log > %%i4_critical.txt
egrep -i error %%iEMS-LOG-FILE.dump > %%i1b_error.txt
egrep -i warning %%iEMS-LOG-FILE.dump > %%i2b_warning.txt
egrep -i alert %%iEMS-LOG-FILE.dump > %%i3b_alert.txt
egrep -i critical %%iEMS-LOG-FILE.dump > %%i4b_critical.txt
)