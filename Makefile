######################################
# MAKEFILE USAGE
######################################

# Build project:
#   make

# Clean build files:
#   make clean

# Clean + build:
#   make clean && make

# Flash to STM32:
#   make flash

# Normal workflow:
#   make clean && make && make flash

# Output:
#   .elf = debug file
#   .hex / .bin = flash files

# Toolchain:
#   arm-none-eabi-gcc (GNU Arm Embedded Toolchain)
######################################





######################################
# 0. PROJECT CONFIG
######################################
TARGET = main
DEBUG = 1
OPT = -Og

######################################
# 1. BUILD DIR
######################################
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/objects

######################################
# 2. SOURCE FILES
######################################
C_SOURCES = $(wildcard app/src/*.c) \
            $(wildcard bsp/src/*.c) \
            $(wildcard core/src/*.c) \
            $(wildcard drivers/src/*.c) \
            $(wildcard lib/**/*.c)

ASM_SOURCES = core/startup/startup_stm32f103xb.s

######################################
# 3. TOOLCHAIN
######################################
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

######################################
# 4. MCU + FLAGS
######################################
CPU = -mcpu=cortex-m3
MCU = $(CPU) -mthumb

C_DEFS = -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER

C_INCLUDES = \
-Iapp/inc \
-Ibsp/inc \
-Icore/inc \
-Icmsis/inc \
-Idrivers/inc \
-Ilib

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall \
         -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Auto dependency
CFLAGS += -MMD -MP

######################################
# 5. LINKER
######################################
LDSCRIPT = linker/STM32F103C8Tx_FLASH.ld

LIBS = -lc -lm -lnosys

LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBS) \
          -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref \
          -Wl,--gc-sections

######################################
# 6. BUILD PROCESS
######################################

# Object files
OBJECTS = $(addprefix $(OBJ_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
OBJECTS += $(addprefix $(OBJ_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))

# Search paths
vpath %.c $(sort $(dir $(C_SOURCES)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

# Default target
all: $(BUILD_DIR)/$(TARGET).elf \
     $(BUILD_DIR)/$(TARGET).hex \
     $(BUILD_DIR)/$(TARGET).bin

# Compile C
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	@echo "CC $<"
	@$(CC) -c $(CFLAGS) $< -o $@

# Compile ASM
$(OBJ_DIR)/%.o: %.s | $(OBJ_DIR)
	@echo "AS $<"
	@$(AS) -c $(CFLAGS) $< -o $@

# Link
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) | $(BUILD_DIR)
	@echo "LINK $@"
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@$(SZ) $@

# HEX
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	@echo "HEX $@"
	@$(HEX) $< $@

# BIN
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf
	@echo "BIN $@"
	@$(BIN) $< $@

######################################
# 7. DIRECTORIES
######################################
$(BUILD_DIR):
	mkdir -p $@

$(OBJ_DIR): | $(BUILD_DIR)
	mkdir -p $@

######################################
# 8. CLEAN & FLASH
######################################
clean:
	rm -rf $(BUILD_DIR)

flash: all
	st-flash write $(BUILD_DIR)/$(TARGET).bin 0x08000000

######################################
# 9. DEPENDENCIES
######################################
-include $(wildcard $(OBJ_DIR)/*.d)

.PHONY: all clean flash