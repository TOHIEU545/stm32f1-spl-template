# Application (app)

## Purpose
This folder contains the main application logic of the project.

It is the highest layer in the firmware architecture.

## Contents
- main.c → entry point of the application
- inc/ → application header files
- src/ → application source code

## Key Characteristics
- Contains business logic
- Uses BSP and Middleware APIs
- Hardware independent (no direct register access)

## Key Rule
- Do NOT access hardware directly
- Do NOT write driver code here
- Only use BSP / Middleware interfaces