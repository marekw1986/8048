# Example Makefile for CP/M 2.2 bdos and ccp using Macro Assembler AS

#all: boot.bin boot.lst ccp.bin ccp.lst bdos.bin bdos.lst bios.bin bios.lst
#all: cpm22.bin boot.lst ccp.lst bdos.lst bios.lst

all: text1.asm text2.asm text3.asm text4.asm ascii.hex

text1.asm: text1.txt
	echo -n "$'\t .db " > text1.asm
	cat text1.txt | perl -lne 'print join ", ", unpack("C*")' >> text1.asm
	
text2.asm: text2.txt
	echo -n "$'\t .db " > text2.asm
	cat text2.txt | perl -lne 'print join ", ", unpack("C*")' >> text2.asm
	
text3.asm: text3.txt
	echo -n "$'\t .db " > text3.asm
	cat text3.txt | perl -lne 'print join ", ", unpack("C*")' >> text3.asm
	
text4.asm: text4.txt
	echo -n "$'\t .db " > text4.asm
	cat text4.txt | perl -lne 'print join ", ", unpack("C*")' >> text4.asm
	
ascii.hex : ascii.asm
	/opt/asm48/asm48 -f hex ascii.asm

clean:
	rm *.hex text*.asm
