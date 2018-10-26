@ECHO OFF
del "c:\users\coraje180\desktop\p5-2\p5ver2.map"
del "c:\users\coraje180\desktop\p5-2\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\coraje180\desktop\p5-2\labels.tmp" -fI  -o "c:\users\coraje180\desktop\p5-2\p5ver2.hex" -d "c:\users\coraje180\desktop\p5-2\p5ver2.obj" -e "c:\users\coraje180\desktop\p5-2\p5ver2.eep" -m "c:\users\coraje180\desktop\p5-2\p5ver2.map" -W+ie   "C:\Users\Coraje180\Desktop\p5-2\p5ver2.asm"
