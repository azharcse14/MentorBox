# Course: Computer Architecture & Organization  (level id "deep-cse-3-2", lesson ids "deep-cse-3-2-01".."-25")
Builds on Digital Logic Design (deep-cse-2-3): gates, adders, MUX/decoders, flip-flops, registers, counters and RAM/ROM chips are assumed, only recapped.
Microprocessors & Assembly (deep-cse-3-3) covers the 8086 in detail (its registers, segments, instructions, interrupts, assembly programs); here we stay general and only mention it.
01 What architecture and organization mean: architecture vs organization vs implementation, abstraction layers, stored-program idea, course map
02 Von Neumann and Harvard models: CPU, memory, I/O, buses, the von Neumann bottleneck, modified Harvard, a short history (ENIAC, EDVAC, IAS)
03 Measuring performance: clock rate, cycle time, CPI, the CPU time equation, MIPS and why it misleads, benchmarks (SPEC), power wall
04 Amdahl's law and design principles: speedup, the serial part limit, worked examples, make the common case fast, locality, parallelism
05 Data representation for the CPU: words, integer ranges, sign extension, endianness, alignment, IEEE 754 single/double precision layout
06 Computer arithmetic I: ALU design, adder recap, overflow and status flags, shift operations, multiplication (shift-add, Booth's algorithm)
07 Computer arithmetic II: restoring and non-restoring division, floating-point add/multiply steps, rounding, special values (infinity, NaN)
08 Instruction set architecture: what an ISA is, instruction formats and fields, opcode, operand count (0/1/2/3 address), fixed vs variable length
09 Addressing modes: immediate, register, direct, indirect, register indirect, displacement/base, indexed, PC-relative, auto-increment, worked examples
10 Kinds of instructions and procedure support: data transfer, arithmetic/logic, control flow, branches and condition codes, stack, call/return, stack frames
11 RISC vs CISC: design philosophies, load/store architecture, register count, examples (MIPS, ARM, RISC-V vs x86), modern convergence (micro-ops)
12 A MIPS-style ISA walk-through: R/I/J formats, register file, translating small C snippets, why fixed formats make hardware simple
13 Register transfer and micro-operations: RTL notation, bus and memory transfer, arithmetic/logic/shift micro-ops, a simple accumulator machine
14 The instruction cycle: fetch, decode, execute, write back, PC/IR/MAR/MDR roles, the cycle traced step by step, interrupts in the cycle
15 Single-cycle datapath: building blocks, datapath for R-type, load/store and branch, the critical path and why single-cycle is slow
16 Control unit design: control signals, hardwired control (from opcode to signals), microprogrammed control, control memory, horizontal vs vertical microcode
17 Multi-cycle datapath: splitting into steps, reusing units, finite state machine control, CPI per instruction class
18 Pipelining basics: laundry analogy, 5-stage pipeline (IF ID EX MEM WB), pipeline registers, ideal speedup, latency vs throughput
19 Pipeline hazards: structural, data (RAW, forwarding, load-use stall), control (branch penalty, prediction, delayed branch), worked timing diagrams
20 Instruction-level parallelism: superscalar, dynamic scheduling idea, out-of-order execution, register renaming, speculation, VLIW (concepts only)
21 Memory hierarchy: registers, cache, main memory, SSD/disk, speed/cost/size trade-off, temporal and spatial locality, hit/miss, average access time
22 Cache memory I: blocks, direct mapped, set associative, fully associative, address split into tag/index/offset, worked address examples
23 Cache memory II: replacement (LRU, FIFO, random), write-through vs write-back, write allocate, 3 C's of misses, multilevel caches, AMAT examples
24 Main memory and virtual memory: DRAM/SRAM, memory interleaving, pages, page tables, address translation, TLB, page faults, a worked translation
25 I/O and parallel processors + wrap-up: programmed I/O, interrupts, DMA, buses; Flynn's taxonomy, multicore, shared memory and cache coherence idea, GPUs, course recap
