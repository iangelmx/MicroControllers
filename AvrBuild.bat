@ECHO OFF
del "c:\users\iangelmx\documents\github\microcontrollers\fliptimercounter.map"
del "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp" -fI  -o "c:\users\iangelmx\documents\github\microcontrollers\fliptimercounter.hex" -d "c:\users\iangelmx\documents\github\microcontrollers\fliptimercounter.obj" -e "c:\users\iangelmx\documents\github\microcontrollers\fliptimercounter.eep" -m "c:\users\iangelmx\documents\github\microcontrollers\fliptimercounter.map" -W+ie   "C:\Users\iAngelMx\Documents\GitHub\microControllers\FlipTimerCounter.asm"
