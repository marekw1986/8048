# Example Makefile for CP/M 2.2 bdos and ccp using Macro Assembler AS

#all: boot.bin boot.lst ccp.bin ccp.lst bdos.bin bdos.lst bios.bin bios.lst
#all: cpm22.bin boot.lst ccp.lst bdos.lst bios.lst

all: blink.hex

blink.hex : blink.asm
	/opt/asm48/asm48 -f hex blink.asm

clean:
	rm *.hex
