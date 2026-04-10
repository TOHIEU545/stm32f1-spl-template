# VSCode Configuration

## Purpose
This folder contains configuration files for Visual Studio Code to support STM32 development on WSL with ARM toolchain.

## Files

### c_cpp_properties.json
- IntelliSense configuration
- Include paths for project headers
- Defines for STM32 SPL build
- ARM GCC compiler settings

### launch.json
- Debug configuration using Cortex-Debug
- OpenOCD + ST-Link interface
- Used to debug STM32 firmware via GDB

## Toolchain Used

- Compiler: arm-none-eabi-gcc
- Debugger: gdb-multiarch
- Debug Server: OpenOCD (ST-Link)

## Key Rule

- Do NOT commit machine-specific paths if sharing project
- Ensure build path matches `executable` in launch.json
- Keep includePath synced with project structure