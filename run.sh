#!/bin/bash
set -xe

# 커널 빌드
clang -std=c11 -O2 -g3 -Wall -Wextra \
  --target=riscv32-unknown-elf \
  -ffreestanding -nostdlib \
  -fno-stack-protector -fuse-ld=lld \
  -Wl,-Tkernel.ld -Wl,-Map=kernel.map \
  -o kernel.elf \
  kernel.c common.c shell.bin.o shell.c

# QEMU 실행 (OpenSBI 펌웨어 사용)
qemu-system-riscv32 -machine virt \
  -bios opensbi/build/platform/generic/firmware/fw_dynamic.bin \
  -nographic -serial mon:stdio --no-reboot \
  -kernel kernel.elf
