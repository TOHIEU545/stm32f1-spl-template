# Middleware Directory

## Purpose
This folder contains middleware libraries used on top of the BSP and drivers layer.

Middleware provides reusable system-level features and is independent of the specific hardware board.

## What is Middleware?
Middleware = software components between application and hardware layers.

It does NOT control hardware directly.

## Examples
Common middleware used in STM32 projects:
- FreeRTOS → Real-time operating system
- FatFS → File system (SD card, USB storage)
- LWIP → TCP/IP networking stack
- USB Stack → USB device/host communication
- mbedTLS → Encryption and security

## Structure
middleware/
├── freertos/
├── fatfs/
├── lwip/
├── usb/

## How to add a middleware
Example: FreeRTOS
1. Copy source into: middleware/freertos/
2. Add to Makefile:
C_SOURCES += $(wildcard middleware/freertos/src/*.c)
C_INCLUDES += -Imiddleware/freertos/inc