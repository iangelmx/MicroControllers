@ECHO OFF
del "c:\users\iangelmx\documents\github\microcontrollers\practica08_2.map"
del "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp" -fI  -o "c:\users\iangelmx\documents\github\microcontrollers\practica08_2.hex" -d "c:\users\iangelmx\documents\github\microcontrollers\practica08_2.obj" -e "c:\users\iangelmx\documents\github\microcontrollers\practica08_2.eep" -m "c:\users\iangelmx\documents\github\microcontrollers\practica08_2.map" -W+ie   "C:\Users\iAngelMx\Documents\GitHub\microControllers\Practica08_2.asm"
