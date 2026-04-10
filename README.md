# STM32F1 Firmware Template (SPL)

## Overview
This project is a fully IDE-independent STM32 firmware template.
It is designed to give full control over the build system, file structure, and toolchain without relying on any vendor IDE (such as STM32CubeIDE or Keil).
The project uses a Makefile-based build system and standard ARM GNU toolchain, allowing full transparency of the compilation, linking, and flashing process.

## Development Environment Setup (WSL + VSCode)
This project is developed in a fully IDE-independent environment using:
- Windows + WSL (Ubuntu)
- VSCode (Remote WSL)
- GNU Arm Embedded Toolchain
- OpenOCD / ST-Link for debugging

## Setup Guide
### 1. Install WSL
wsl --install
wsl --install -d Ubuntu

### 2. VSCode Setup
- Install the WSL extension in VSCode
- Press F1 -> Select Remote-WSL: Reopen Folder in WSL.

### 3. Toolchain (GNU Arm embedded toolchain)
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch make

### 4. Config VSCode IntelliSense and Launch(Debug)

### 5. USB Passthrough (For ST-Link on WSL)
#### Ubuntu
- sudo apt install usbutils linux-tools-generic hwdata libusb-1.0-0-dev
#### Windows:
- usbipd list
- usbipd bind --busid <busid>

### 6. Install Flashing Tools
- sudo apt install stlink-tools openocd
- usbipd attach --wsl --busid <busid>

## Project Structure
project/
├── app/          # Application layer
├── bsp/          # Board support package
├── middleware/   # RTOS, FS, networking
├── lib/          # Utility libraries
├── drivers/      # SPL drivers
├── core/         # System + startup
├── cmsis/        # ARM core definitions
├── linker/       # Linker script
├── build/        # Output (elf, hex, bin)
└── Makefile      # Build rules
