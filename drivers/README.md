# Drivers (SPL - Standard Peripheral Library)

## Purpose
This folder contains the STM32 Standard Peripheral Library (SPL).

It provides low-level peripheral control APIs for STM32F1, without using HAL or LL.

## What is inside?
This layer includes ST’s official SPL drivers such as:

- GPIO driver (GPIO_Init, GPIO_SetBits, ...)
- RCC driver (clock control)
- USART driver
- SPI driver
- I2C driver
- ADC driver
- TIM driver
- NVIC / Interrupt configuration.....

## Role in Architecture
Application
↓
Middleware
↓
BSP
↓
SPL Drivers (this folder)
↓
CMSIS / Core
↓
Hardware (STM32F103)

## Key Characteristics
- Based on STM32 Standard Peripheral Library (SPL)
- No HAL / no LL used
- Hardware-specific (STM32F1 only)
- Provides register-level abstraction (but not full HAL abstraction)
- Used as foundation for BSP layer

## When to use SPL drivers?
Use this layer when you need:
- Peripheral initialization (UART, SPI, GPIO, etc.)
- Clock configuration (RCC)
- Interrupt setup (NVIC)
- Low-level STM32F1 peripheral control