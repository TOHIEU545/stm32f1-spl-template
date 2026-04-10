# BSP (Board Support Package)

## Purpose
This folder contains board-specific drivers and hardware abstraction for this project.

It is built on top of the SPL (drivers) layer.

## What goes into BSP?
- LED control
- Button input
- UART debug interface
- Board initialization
- Simple hardware wrappers.....

## Key Characteristics
- Board-specific (STM32F103 board only)
- Uses SPL drivers internally
- Provides simple APIs for application layer

## Key Rule
- Must NOT contain application logic
- Must NOT include middleware (FreeRTOS, etc.)
- Must only wrap hardware functions