@ECHO OFF
del "c:\users\iangelmx\documents\github\microcontrollers\p6\p6.map"
del "c:\users\iangelmx\documents\github\microcontrollers\p6\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\iangelmx\documents\github\microcontrollers\p6\labels.tmp" -fI  -o "c:\users\iangelmx\documents\github\microcontrollers\p6\p6.hex" -d "c:\users\iangelmx\documents\github\microcontrollers\p6\p6.obj" -e "c:\users\iangelmx\documents\github\microcontrollers\p6\p6.eep" -m "c:\users\iangelmx\documents\github\microcontrollers\p6\p6.map" -W+ie   "C:\Users\iAngelMx\Documents\GitHub\microControllers\P6\p6.asm"
