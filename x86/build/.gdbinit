set print pretty on
set print object on
set pagination off
set disassembly-flavor intel

set args images/5x5.bmp
b flipdiagbmp24
run
layout next