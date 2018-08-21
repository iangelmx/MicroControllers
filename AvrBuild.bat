@ECHO OFF
del "c:\users\iangelmx\documents\github\microcontrollers\kit_coninterrupcion.map"
del "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp" -fI  -o "c:\users\iangelmx\documents\github\microcontrollers\kit_coninterrupcion.hex" -d "c:\users\iangelmx\documents\github\microcontrollers\kit_coninterrupcion.obj" -e "c:\users\iangelmx\documents\github\microcontrollers\kit_coninterrupcion.eep" -m "c:\users\iangelmx\documents\github\microcontrollers\kit_coninterrupcion.map" -W+ie   "C:\Users\iAngelMx\Documents\GitHub\microControllers\kit_conInterrupcion.asm"
