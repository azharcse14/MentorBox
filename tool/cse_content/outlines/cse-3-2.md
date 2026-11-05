# Course: Computer Architecture & Organization  (level id "deep-cse-3-2", lesson ids "deep-cse-3-2-01".."-25")
Builds on Digital Logic Design (deep-cse-2-3): gates, adders, MUX/decoders, flip-flops, registers, counters are assumed, only recapped.
Assembly programming, 8086 specifics and peripheral chips belong to Microprocessors (cse-3-3); here we stay at the design level.
01 What computer architecture and organization are: architecture vs organization, levels of abstraction (app -> OS -> ISA -> microarchitecture -> logic -> transistors), course map
02 The stored-program computer: von Neumann model, Harvard and modified Harvard, the five classic components, von Neumann bottleneck, history in brief
03 Performance: clock rate, cycle time, CPI, CPU time equation, MIPS and why it misleads, benchmarks (SPEC idea), Amdahl's law, power wall
04 Data representation for hardware: unsigned and 2's complement recap, sign extension, fixed point, IEEE 754 single/double, special values, endianness
05 The ALU and integer addition: ALU as a circuit, ripple carry recap, carry lookahead, overflow and status flags (Z, N, C, V), shifters
06 Multiplication and division: shift-and-add multiplier, Booth's algorithm, restoring and non-restoring division, hardware cost
07 Floating-point arithmetic: add/subtract steps (align, add, normalise, round), multiply, guard/round/sticky bits, rounding modes, precision traps
08 Instruction set architecture: what an instruction is, opcode and operands, 0/1/2/3-address machines (stack, accumulator, register), instruction types, instruction formats and length
09 Addressing modes: immediate, register, direct, indirect, register indirect, displacement/based/indexed, PC-relative, auto-increment, effective address calculation
10 RISC vs CISC and a real ISA: design philosophies, load/store, MIPS R/I/J formats with encoding examples, x86 and ARM in practice
11 Register transfer and micro-operations: RTL notation, register/arithmetic/logic/shift micro-ops, common bus with MUX, simple basic computer organisation
12 Building a datapath: single-cycle MIPS datapath, PC, instruction memory, register file, ALU, data memory, how lw/sw/add/beq flow through it
13 Hardwired control: control signals, main control and ALU control, truth tables, timing with a sequence counter, pros and cons
14 Microprogrammed control: control memory, microinstructions, microprogram sequencer, horizontal vs vertical, hardwired vs microprogrammed
15 Multi-cycle execution and the instruction cycle: why single-cycle is wasteful, multi-cycle states, full instruction cycle with indirect and interrupt phases
16 Pipelining basics: laundry analogy, 5-stage pipeline (IF, ID, EX, MEM, WB), pipeline registers, speedup and throughput math, ideal vs real
17 Pipeline hazards: structural, data (RAW/WAR/WAW), stalls, forwarding, load-use hazard, control hazards, branch delay, worked timing diagrams
18 Branch prediction and instruction-level parallelism: static and dynamic prediction, 1-bit and 2-bit predictors, BTB, superscalar, out-of-order execution and register renaming idea
19 Memory hierarchy and locality: why a hierarchy, temporal/spatial locality, SRAM vs DRAM vs flash vs disk, hit, miss, hit ratio, average access time
20 Cache memory I, mapping: blocks and lines, direct mapped, fully associative, set associative, tag/index/offset breakdown with worked addresses
21 Cache memory II, policies and performance: replacement (LRU, FIFO, random), write-through vs write-back, write allocate, 3 Cs of misses, multilevel caches, AMAT
22 Main memory organisation: DRAM cells, rows/columns, refresh, building bigger memory from chips, address decoding, interleaving, ROM types brief, DDR idea
23 Virtual memory: why, pages and frames, page table, address translation, page faults, TLB, page replacement idea, protection
24 Input/output organisation: buses (address/data/control), synchronous vs asynchronous, I/O interface, programmed I/O, interrupt-driven I/O, DMA, priority and daisy chain, storage and RAID brief
25 Parallel processors and recap: Flynn's taxonomy, multicore and shared memory, cache coherence (MESI idea), SIMD and GPUs, Amdahl again, course recap and what next
