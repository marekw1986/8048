# Example Makefile for CP/M 2.2 bdos and ccp using Macro Assembler AS

#all: boot.bin boot.lst ccp.bin ccp.lst bdos.bin bdos.lst bios.bin bios.lst
#all: cpm22.bin boot.lst ccp.lst bdos.lst bios.lst

all: ascii.hex

ascii.hex : ascii.asm
	/opt/asm48/asm48 -f hex ascii.asm

clean:
	rm *.hex
