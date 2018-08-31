@ECHO OFF
del "c:\users\coraje180\desktop\matriz\matriz.map"
del "c:\users\coraje180\desktop\matriz\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\coraje180\desktop\matriz\labels.tmp" -fI  -o "c:\users\coraje180\desktop\matriz\matriz.hex" -d "c:\users\coraje180\desktop\matriz\matriz.obj" -e "c:\users\coraje180\desktop\matriz\matriz.eep" -m "c:\users\coraje180\desktop\matriz\matriz.map" -W+ie   "C:\Users\Coraje180\Desktop\matriz\matriz.asm"
