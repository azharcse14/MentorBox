# Course: Microprocessors & Assembly Language  (level id "deep-cse-3-3", lesson ids "deep-cse-3-3-01".."-26")
Builds on Digital Logic Design (deep-cse-2-3): number systems, gates, decoders, flip-flops are assumed, only recapped.
Computer Architecture & Organization (deep-cse-3-2) covers pipelining, caches and virtual memory in depth: here only mention them.
Main chips: Intel 8085 (8-bit) and 8086 (16-bit), with x86 assembly in MASM/TASM/emu8086 style syntax.
01 What a microprocessor is: CPU on a chip, microprocessor vs microcontroller vs microcomputer, fetch-decode-execute, buses, word size and clock, history 4004 to Pentium, course map
02 Data for assembly programmers: binary and hex fast, two's complement signed numbers, BCD, ASCII, byte/word/doubleword, little-endian byte order
03 8085 architecture: block diagram, registers A B C D E H L and pairs, flags S Z AC P CY, PC and SP, multiplexed AD0-AD7 and ALE, key pins
04 8085 instruction set and addressing modes: immediate, register, direct, register indirect, implied; MVI MOV LDA STA LXI ADD SUB INR DCR JMP JZ JNZ CALL RET HLT; 1/2/3 byte instructions
05 8085 programming and timing: adding numbers, counters and loops, largest in a block, block move, T-states, machine cycles, opcode fetch, delay loop calculation
06 8086 architecture: BIU and EU, 6-byte prefetch queue, 16-bit data and 20-bit address (1 MB), minimum and maximum mode (overview), 8086 vs 8088
07 8086 registers and segmentation: AX BX CX DX with high/low halves, SI DI BP SP, CS DS SS ES, IP, physical address = segment x 16 + offset, worked examples, default segment pairs
08 The 8086 flags register: CF PF AF ZF SF OF and TF IF DF, how ADD/SUB/CMP set them, signed vs unsigned overflow worked examples
09 8086 addressing modes: immediate, register, direct, register indirect, based, indexed, based-indexed with displacement, effective address calculation, segment override
10 Instruction format and machine code: opcode, D and W bits, MOD REG R/M byte, displacement and immediate bytes, hand-encoding a few MOV/ADD instructions
11 Assembler and program structure: source to object to executable, MASM/TASM/NASM/emu8086, directives (.MODEL .STACK .DATA .CODE DB DW DUP EQU PROC ENDP END), first program with INT 21h
12 Data transfer instructions: MOV rules, XCHG, LEA, LDS/LES, XLAT, IN/OUT basics, PUSH/POP preview
13 Arithmetic instructions: ADD ADC SUB SBB INC DEC NEG CMP, MUL IMUL DIV IDIV with operand sizes, CBW CWD, multiword addition, BCD adjust idea (DAA)
14 Logic, shift and rotate: AND OR XOR NOT TEST, masks, SHL SHR SAR ROL ROR RCL RCR, fast multiply/divide by 2, counting ones
15 Branching and loops: JMP short/near/far, conditional jumps signed (JG JL) vs unsigned (JA JB), LOOP LOOPE LOOPNE JCXZ, translating if/else, while and for
16 Input and output with DOS: INT 21h functions 01h 02h 09h 0Ah 4Ch, reading and printing a multi-digit number, case conversion
17 Arrays and string instructions: indexed access, sum and max of an array, MOVSB/W CMPSB SCASB LODSB STOSB, REP REPE REPNE, DF with CLD/STD
18 The stack: SS:SP, PUSH and POP step by step, PUSHF/POPF, LIFO uses, reversing a string, stack overflow and underflow
19 Procedures and macros: CALL/RET near and far, what gets pushed, parameters in registers and on the stack, BP frames, RET n, recursion (factorial), macro vs procedure
20 8086 interrupts: hardware vs software, NMI and INTR, INT n, interrupt vector table (256 x 4 bytes at 00000h-003FFh), response sequence, IRET, types 0-4, writing an ISR
21 8085 interrupts and the 8259A PIC: TRAP RST7.5 RST6.5 RST5.5 INTR, vectored vs non-vectored, 8259A IRR ISR IMR and priority resolver, ICW/OCW, EOI, cascading
22 Memory interfacing: ROM/RAM chips, address decoding (full vs partial), 74LS138 decoder, memory map calculation, 8086 even/odd banks with BHE and A0
23 I/O interfacing and the 8255 PPI: I/O-mapped vs memory-mapped I/O, port addresses, 8255 ports A B C, modes 0/1/2, BSR mode, control word worked examples, LED/switch example
24 The 8253/8254 programmable interval timer: three 16-bit counters, control word, six modes, square wave count calculation, 8254 differences
25 Data transfer schemes, 8237 DMA and 8251 USART: programmed vs interrupt-driven vs DMA, DMA handshake HOLD/HLDA, serial vs parallel, asynchronous frame, baud rate, 8251 overview
26 From 8086 to modern x86 + wrap-up: 80286 protected mode, 80386 32-bit registers (EAX...), x86-64 (RAX), real vs protected mode, where assembly is used today, cheat-sheet, what next
