# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel
os-image: boot_sect.bin kernel.bin
	cat boot_sect.bin kernel.bin > os-image		

kernel.bin : kernel_entry.o kernel.o
	ld -melf_i386 -o kernel.bin -Ttext 0x1000 $^ --oformat binary
# Build our kernel object file .
kernel.o : kernel.c
	gcc -m32 -fno-pic -ffreestanding -c $< -o $@
# Build our kernel entry object file .
kernel_entry.o : kernel_entry.nasm
	nasm $< -f elf -o $@
# Assemble the boot sector to raw machine code
# The -I options tells nasm where to find our useful assembly
# routines that we include in boot_sect . asm
boot_sect.bin : boot_sect.nasm
	nasm $< -f bin -o $@
# Clear away all generated files .
clean :
	rm -fr *.bin *.dis *.o os-image *.map
# Disassemble our kernel - might be useful for debugging .
kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@