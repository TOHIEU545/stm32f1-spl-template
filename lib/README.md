# Library (lib)

## Purpose
This folder contains small, reusable utility libraries used across the project.

These libraries are not part of BSP or Middleware, but are used to support both application and lower layers.

## What goes into lib?
The `lib/` folder is used for **lightweight, reusable components**, such as:

### 🔧 Utility functions
- String helpers
- Math helpers
- Delay utilities
- Bit manipulation helpers

### 📦 Data structures
- Ring buffer
- Queue
- Stack
- Linked list

### 📡 Communication helpers
- CRC / checksum calculation
- Packet encoding / decoding
- UART parsing (simple protocol parser)

### 🧠 Algorithms
- PID controller
- Low-pass / high-pass filters
- Smoothing algorithms

### ⚙️ Small device helpers
- EEPROM read/write helpers
- Simple sensor drivers (non-complex)

## Folder Structure Example
lib/
├── utils/
├── data_structures/
├── communication/
├── algorithms/
└── sensors/

## Key Characteristics
- Lightweight and modular
- No direct hardware control (no GPIO, no registers)
- Reusable across different projects
- Can be used by APP, BSP, or Middleware

## When to use lib?
- Code reuse across multiple modules
- Pure logic processing (no hardware dependency)
- Small independent features that do not belong to BSP or Middleware