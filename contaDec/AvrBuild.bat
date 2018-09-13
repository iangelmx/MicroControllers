@ECHO OFF
del "c:\users\coraje180\desktop\contadec\contadec.map"
del "c:\users\coraje180\desktop\contadec\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\coraje180\desktop\contadec\labels.tmp" -fI  -o "c:\users\coraje180\desktop\contadec\contadec.hex" -d "c:\users\coraje180\desktop\contadec\contadec.obj" -e "c:\users\coraje180\desktop\contadec\contadec.eep" -m "c:\users\coraje180\desktop\contadec\contadec.map" -W+ie   "C:\Users\Coraje180\Desktop\contaDec\contaDec.asm"
