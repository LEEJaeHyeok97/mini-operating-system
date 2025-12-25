#!/bin/bash
set -e

CC=clang
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra \
--target=riscv32-unknown-elf \
-ffreestanding -nostdlib -fno-stack-protector \
-fuse-ld=lld"

OBJCOPY=llvm-objcopy
# 또는: OBJCOPY=riscv64-unknown-elf-objcopy

# Build the shell (application)
$CC $CFLAGS -Wl,-Tuser.ld -Wl,-Map=shell.map \
    -o shell.elf shell.c user.c common.c

$OBJCOPY --set-section-flags .bss=alloc,contents \
    -O binary shell.elf shell.bin

$OBJCOPY -I binary -O elf32-littleriscv \
    shell.bin shell.bin.o

# Build the kernel
$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map \
    -o kernel.elf kernel.c common.c shell.bin.o

