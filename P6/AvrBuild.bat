@ECHO OFF
del "c:\users\coraje180\desktop\p6\p6.map"
del "c:\users\coraje180\desktop\p6\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\coraje180\desktop\p6\labels.tmp" -fI  -o "c:\users\coraje180\desktop\p6\p6.hex" -d "c:\users\coraje180\desktop\p6\p6.obj" -e "c:\users\coraje180\desktop\p6\p6.eep" -m "c:\users\coraje180\desktop\p6\p6.map" -W+ie   "C:\Users\Coraje180\Desktop\P6\p6.asm"
