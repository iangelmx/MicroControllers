@ECHO OFF
del "c:\users\coraje180\desktop\teclado_matriz\teclado.map"
del "c:\users\coraje180\desktop\teclado_matriz\labels.tmp"
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\users\coraje180\desktop\teclado_matriz\labels.tmp" -fI  -o "c:\users\coraje180\desktop\teclado_matriz\teclado.hex" -d "c:\users\coraje180\desktop\teclado_matriz\teclado.obj" -e "c:\users\coraje180\desktop\teclado_matriz\teclado.eep" -m "c:\users\coraje180\desktop\teclado_matriz\teclado.map" -W+ie   "C:\Users\Coraje180\Desktop\teclado_matriz\teclado.asm"
