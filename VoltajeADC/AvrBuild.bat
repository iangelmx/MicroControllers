@ECHO OFF
del "c:\users\coraje180\desktop\voltajeadc\pvoltaje.map"
del "c:\users\coraje180\desktop\voltajeadc\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\coraje180\desktop\voltajeadc\labels.tmp" -fI  -o "c:\users\coraje180\desktop\voltajeadc\pvoltaje.hex" -d "c:\users\coraje180\desktop\voltajeadc\pvoltaje.obj" -e "c:\users\coraje180\desktop\voltajeadc\pvoltaje.eep" -m "c:\users\coraje180\desktop\voltajeadc\pvoltaje.map" -W+ie   "C:\Users\Coraje180\Desktop\VoltajeADC\Pvoltaje.asm"
