# LC-3 Verilog Processor

A modular implementation of a simple LC-3 (Little Computer 3) processor using Verilog HDL. This project simulates the behavior of a basic 16-bit processor capable of executing a subset of LC-3 instructions including `ADD`, `AND`, `NOT`, `LD`, `ST`, `BR`, `JMP`, and others.

Designed and tested using a clock-divided architecture, the processor includes a fully implemented control unit FSM, register file, ALU, memory components, and support for condition code logic.

---

## 🚀 Features

- **3-stage FSM control unit:** `FETCH`, `DECODE`, `EXECUTE`
- **Instruction support:**
  - Arithmetic: `ADD`, `AND`, `NOT`
  - Branching: `BR`, `JMP`
  - Memory access: `LD`, `ST`, `LEA`
- **Condition code logic (N, Z, P flags)**
- **Support for sign extension**
- **Modular architecture — easily extendable**
- **Clock divider for timing control**

---

## 🧠 Architecture Overview

```text
        +----------------+
        |  instr_mem.v   |
        +----------------+
                |
        +----------------+          +----------------+
        |  control_unit  |--------->|   cc_logic.v   |
        +----------------+          +----------------+
         |      |        |
         |      |        |                     +----------------+
         v      v        v                     |  data_mem.v     |
       muxes.v |       alu.v <---------------->|                |
         |      |          ^                   +----------------+
         |      |          |
         v      v          |
       regfile.v <---------+
```

---

## 📁 Modules Breakdown
| **Module**	| **Function** |
| top.v	| Connects all modules together |
| pc.v	| Program counter with reset and write-enable |
| instr_mem.v	| Instruction memory (preloaded with sample program) |
| regfile.v	8 | registers for data storage |
| alu.v	| Arithmetic/logic unit with ADD, AND, NOT, PASS |
| data_mem.v	| Memory used for load/store instructions |
| cc_logic.v	| Computes N/Z/P flags based on ALU result |
| muxes.v	| Multiplexers for PC source, ALU input, and register writeback |
| sign_extender.v	| Sign-extends immediate values |
| control_unit.v	| Finite state machine (FSM) handling decode and control signals |
| clock_divider.v	| Generates a slower clock for simulation |

---

## 💻 Usage
🛠 Requirements
Xilinx Vivado, ModelSim, or any Verilog simulator

Optional: FPGA board (e.g., Basys-3) if testing on hardware

---

## ▶️ Running the Simulation
Clone the repository:

git clone https://github.com/YOUR_USERNAME/LC3-Verilog-Processor.git
cd LC3-Verilog-Processor
Open in your simulator of choice and set top.v as the top module.

Initialize a simulation:

-Observe instruction execution via waveform viewer
-Watch register values (regfile.v) and condition flags (cc_logic.v)
-Reset signal initializes the PC to x3000 and starts fetching instructions from instr_mem.

---

## 🧪 Sample Program (in instr_mem.v)
```verilog
memory_array[16'h3000] = 16'b0101_000_000_1_00000; // AND R0, R0, #0
memory_array[16'h3001] = 16'b0001_001_001_1_00001; // ADD R1, R1, #1
memory_array[16'h3002] = 16'b0001_010_010_1_00001; // ADD R2, R2, #1
memory_array[16'h3003] = 16'b0001_011_001_010;     // ADD R3, R1, R2
memory_array[16'h3004] = 16'b0011_011_000000111;   // ST R3, #7
```

---

## 🧪 Data Memory (in data_mem.v)
```verilog
memory_array[16'h300C] = 16'h0000;  // VALSTR: .FILL x0000
memory_array[16'h300D] = 16'h000A;  // NEWVAL: .FILL #10
```

---

## 🔧 Design Notes

-Program Counter (PC) starts at x3000
-Instructions and data values are loaded directly in instr_mem.v and data_mem.v
-FSM ensures proper sequencing of FETCH → DECODE → EXECUTE
-Control signals reset after each instruction to prevent incorrect carryover
-Muxes handle routing of ALU input, register input, and PC source

---

## 📌 Future Enhancements

-Full LC-3 instruction set (JSR, JSRR, LDR, STR, LDI, STI, etc.)
-Microcode-based control design
-Assembly to binary instruction parser
-VGA or 7-segment output for visual debugging

---

## 📄 License
This project is licensed under the MIT License. See LICENSE for details.

---

## 🤝 Credits
Created by Praneeth Satishkumar
Implemented for FPGA processor design and simulation using Verilog HDL.

---
