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





# 0. PRJ CONFIGURATION 
TARGET = main         # Output name: main.elf, main.hex, main.bin 
DEBUG = 1			  # 1 = debug mode, 0 = release mode
OPT = -Og			  # Optimization level (-Og for debug)

# 1. BUILD FOLDERS
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/objects    # object (.o)

# 2. SOURCE FILES (.c và .s)
# Automatically include all C source files from project modules
C_SOURCES = $(wildcard app/src/*.c) \
            $(wildcard bsp/src/*.c) \
            $(wildcard lib/**/*.c) \
            $(wildcard core/src/*.c)

# Driver layer (auto include all drivers)
C_SOURCES += $(wildcard drivers/src/*.c)

# Startup assembly file
ASM_SOURCES = core/startup/startup_stm32f103xb.s

# 3. TOOLCHAIN (GNU ARM Embedded GCC)
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

# 4. CPU SETTINGS + COMPILER FLAGS
# CPU & Arch
CPU = -mcpu=cortex-m3
MCU = $(CPU) -mthumb

# STM32 standard peripheral library macros
C_DEFS = -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER

# Include directories
C_INCLUDES = \
-Iapp/inc \
-Ibsp/inc \
-Icore/inc \
-Icmsis/inc \
-Idrivers/inc \
-Ilib

# Compile flags
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

# Enable debug symbols if DEBUG=1
ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency files (.d) for incremental build
CFLAGS += -MMD -MP -MF"$(OBJ_DIR)/$(notdir $(@:%.o=%.d))"

# 5. LINKER SETTINGS
LDSCRIPT = linker/STM32F103C8Tx_FLASH.ld

LIBS = -lc -lm -lnosys 

LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBS) \
          -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref \
          -Wl,--gc-sections 

# 6. BUILD PROCESS
# Default target
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

# Convert all .c files into .o
OBJECTS = $(addprefix $(OBJ_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
# Search paths for C files
vpath %.c $(sort $(dir $(C_SOURCES)))

# Convert assembly files into .o
OBJECTS += $(addprefix $(OBJ_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

# Compile C files
$(OBJ_DIR)/%.o: %.c Makefile | $(OBJ_DIR) 
	@echo "CC $<"
	@$(CC) -c $(CFLAGS) $< -o $@

# Compile asm files
$(OBJ_DIR)/%.o: %.s Makefile | $(OBJ_DIR)
	@echo "AS $<"
	@$(AS) -c $(CFLAGS) $< -o $@

# Linking -> elf
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS)
	@echo "LINKING $@"
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@$(SZ) $@

# Generate .hex
$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	@echo "GEN HEX $@"
	@$(HEX) $< $@

# Generate .bin (flash to mcu)
$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	@echo "GEN BIN $@"
	@$(BIN) $< $@	

# Create build directory
$(OBJ_DIR):
	mkdir -p $@

# 7. CLEAN & FLASH
clean:
	rm -fR $(BUILD_DIR)

# Flash firmware to STM32 via ST-Link
flash: all
	st-flash write $(BUILD_DIR)/$(TARGET).bin 0x08000000

.PHONY: all clean flash

# Read the dependency file to find out which files need to be rebuilt.
-include $(wildcard $(OBJ_DIR)/*.d)