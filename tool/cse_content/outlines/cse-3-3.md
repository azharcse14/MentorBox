# Course: Microprocessors & Assembly Language  (level id "deep-cse-3-3", lesson ids "deep-cse-3-3-01".."-25")
Builds on Digital Logic Design (deep-cse-2-3) and Computer Architecture & Organization (deep-cse-3-2): number systems, gates, flip-flops,
general CPU/memory/cache/pipeline theory are assumed and only recapped. Focus: Intel 8086 (x86 real mode), assembly in MASM/TASM/emu8086
syntax with DOS INT 21h, and interfacing with 8259, 8255, 8253/8254, 8237, 8251.
01 What a microprocessor is: CPU on one chip, microprocessor vs microcontroller, fetch-decode-execute recap, machine code vs assembly vs high-level, why learn assembly today, course map
02 History and families: 4004, 8008, 8080/8085, 8086/8088, 80286, 80386, 80486, Pentium, x86-64; word size, bus widths, clock; x86 and ARM today
03 Buses and the system around the CPU: address/data/control buses, memory size from address lines (2^n), read/write idea, tri-state, I/O space, the 8086 system block
04 8086 internal architecture: BIU and EU, 6-byte instruction queue (prefetch), ALU, control, why the split helps, when the queue is flushed
05 8086 registers: AX/BX/CX/DX and 8-bit halves, SI/DI/BP/SP, segment registers, IP, flags register (CF, PF, AF, ZF, SF, OF, TF, IF, DF) with worked flag examples
06 Memory segmentation: segment:offset, physical address = segment x 16 + offset, 64 KB segments, overlapping, default segment pairs, segment override, little endian storage
07 8086 pins and bus cycles: multiplexed AD0-AD15, ALE and address latching, BHE, minimum vs maximum mode, read/write bus cycle T1-T4, READY and wait states, 8284 clock, 8088 difference
08 First assembly program: assembler and linker, .MODEL/.STACK/.DATA/.CODE, labels, comments, DB/DW/DD, EQU, DUP, loading DS, INT 21h exit, assemble-link-run flow, .COM vs .EXE, emu8086/DOSBox
09 Addressing modes: immediate, register, direct, register indirect, based, indexed, based-indexed, with displacement; effective address and physical address worked examples; BYTE PTR/WORD PTR
10 Data transfer instructions: MOV and its rules, XCHG, LEA vs MOV OFFSET, LDS/LES, XLAT lookup tables, LAHF/SAHF, PUSH/POP and IN/OUT previewed
11 Arithmetic instructions: ADD/ADC/SUB/SBB/INC/DEC/NEG/CMP and flags, MUL/IMUL/DIV/IDIV with AX/DX, CBW/CWD, divide error, 32-bit addition with ADC
12 BCD and ASCII arithmetic: packed/unpacked BCD, DAA/DAS, AAA/AAS/AAM/AAD, ASCII digit conversion, worked examples
13 Logic, shift and rotate: AND/OR/XOR/NOT/TEST, masking, SHL/SHR/SAL/SAR, ROL/ROR/RCL/RCR, fast multiply/divide by 2, counting 1 bits, printing binary
14 Flow control: JMP short/near/far, CMP + conditional jumps, unsigned (JA/JB) vs signed (JG/JL), translating if/else, while and do-while into assembly
15 Loops and arrays: LOOP/LOOPE/LOOPNE/JCXZ, nested loops, sum of array, max/min, counting, bubble sort in assembly
16 The stack: SS:SP, PUSH/POP step by step, LIFO, PUSHF/POPF, saving registers, reversing a string, stack overflow/underflow
17 Procedures and macros: CALL/RET near and far, what goes on the stack, parameters in registers and on the stack with BP, RET n, local variables, recursion (factorial), MACRO vs PROC
18 String instructions: MOVS, CMPS, SCAS, LODS, STOS, DF with CLD/STD, REP/REPE/REPNE, copy, compare, search and fill examples
19 DOS and BIOS services: INT 21h functions 01h, 02h, 09h, 0Ah, 4Ch; BIOS INT 10h and 16h; reading and printing multi-digit decimal numbers
20 Interrupts I: polling vs interrupts, hardware/software/exceptions, interrupt vector table (256 x 4 bytes at 0000:0000), types 0-4, INTR/NMI, CPU response step by step, IRET
21 Interrupts II and the 8259 PIC: why a controller, IRR/ISR/IMR, priority, cascading to 64 levels, ICW/OCW idea, EOI, writing a safe ISR
22 Memory interfacing: ROM/RAM chips, address decoding (full vs partial), 74LS138 decoder, even/odd banks with A0 and BHE, worked address map
23 I/O interfacing and the 8255 PPI: isolated vs memory-mapped I/O, port addresses, 8255 ports A/B/C, control word, modes 0/1/2, BSR mode, LEDs, switches, 7-segment, keypad
24 Timers, DMA and serial: 8253/8254 timer (counters, modes, count = input clock / output frequency), 8237 DMA idea, 8251 USART serial, ADC/DAC interfacing brief
25 Beyond the 8086 and wrap-up: 80386 protected mode and 32-bit registers, paging idea, x86-64, how C compiles to assembly, CISC vs RISC (x86 vs ARM) brief, debuggers, what next
