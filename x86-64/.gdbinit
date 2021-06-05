add-auto-load-safe-path /home/pawel/ARKO/x86/build/.gdbinit

set print pretty on
set print object on
set pagination off
set disassembly-flavor intel

set args images/5x5.bmp
b flipdiagbmp1
run
layout next