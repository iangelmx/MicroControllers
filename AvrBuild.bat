@ECHO OFF
del "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\iangelmx\documents\github\microcontrollers\labels.tmp" -fI  -o "c:\users\iangelmx\documents\github\microcontrollers\lcd_example.hex" -d "c:\users\iangelmx\documents\github\microcontrollers\lcd_example.obj" -e "c:\users\iangelmx\documents\github\microcontrollers\lcd_example.eep" -m "c:\users\iangelmx\documents\github\microcontrollers\lcd_example.map" -W+ie   "C:\Users\iAngelMx\Documents\GitHub\microControllers\LCD_example.asm"
