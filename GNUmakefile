# SDOS - IBM PC 5150 (1981 Spec)
# Target: Intel 8088 @ 4.77 MHz, 64KiB RAM, 160KiB 5.25" Floppy

ASM      := nasm
EMU      := 86Box

ASMFLAGS := -f bin
BUILD_DIR := build
TARGET   := $(BUILD_DIR)/sdos.img

.PHONY: all run clean

all: $(TARGET)

$(TARGET): boot/boot.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) boot/boot.asm -o $(BUILD_DIR)/boot.bin
	dd if=/dev/zero of=$(TARGET) bs=512 count=320 status=none
	dd if=$(BUILD_DIR)/boot.bin of=$(TARGET) conv=notrunc status=none

run: all
	$(EMU) -P .

clean:
	rm -rf $(BUILD_DIR)