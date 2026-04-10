# Core

## Purpose
This folder contains CMSIS system files, startup code, and interrupt handlers for STM32F103 using SPL.

It is the lowest software layer above hardware.

## Contents

### ⚙️ System files
- system_stm32f10x.c / .h
  → System clock configuration and MCU initialization

### ⚡ Interrupt handlers
- stm32f10x_it.c / .h
  → Interrupt service routines (USART, EXTI, SysTick, etc.)

### 🚀 Startup file
- startup_stm32f103xb.s
  → Vector table and reset handler (entry point of firmware)

### ⚙️ SPL config
- stm32f10x_conf.h
  → Enables and configures SPL peripheral modules

## Key Characteristics
- MCU-specific (STM32F103 only)
- Required for system boot
- Contains interrupt and startup logic
- Based on CMSIS + SPL standard structure

## Key Rule
- Do NOT put application logic here
- Do NOT modify startup unless necessary
- Only system-level MCU configuration is allowed