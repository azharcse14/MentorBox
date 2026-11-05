# Course: Operating Systems  (level id "deep-cse-4-1", lesson ids "deep-cse-4-1-01".."-25")
Builds on Introduction to Computer Systems (deep-cse-1-1, lesson 17: what an OS is), Structured Programming in C (deep-cse-1-2),
Computer Architecture (deep-cse-3-2: cache, virtual memory idea, I/O organisation) and Microprocessors (deep-cse-3-3: interrupts).
Hardware details are only recapped; here the focus is how the OS manages processes, CPU time, memory, storage and files,
with worked scheduling, deadlock, paging, page replacement and disk scheduling problems (numbers checked with a script).
01 What an operating system is: OS as resource manager and extended machine, kernel, history (batch, multiprogramming, time-sharing, PC, mobile), types (batch, time-sharing, real-time, distributed, embedded), popular OSes, course map
02 OS services and structure: user and OS services, user interfaces (CLI, GUI), monolithic, layered, microkernel, modular and hybrid kernels (Linux, Windows, macOS, Android), booting (firmware, bootloader, kernel, init)
03 Dual mode, interrupts and system calls: user mode vs kernel mode, mode bit, privileged instructions, timer, interrupts and traps recap, system call flow step by step, system call table, API and C library, types of system calls, Linux examples
04 Processes: program vs process, memory layout (text, data, heap, stack), five process states and transitions, process control block, context switch and its cost, CPU-bound vs I/O-bound
05 Process creation and termination: process tree, PID, fork, exec, wait, exit, worked fork-counting examples (n forks give 2^n processes), zombie and orphan processes, Windows CreateProcess
06 Inter-process communication: independent vs cooperating, shared memory, message passing (direct/indirect, blocking/non-blocking, buffering), pipes, signals, sockets brief, producer-consumer bounded buffer
07 Threads and concurrency: thread vs process, what threads share, benefits, concurrency vs parallelism, Amdahl's law worked, user vs kernel threads, many-to-one, one-to-one, many-to-many, pthreads example, thread pools
08 CPU scheduling basics: CPU-I/O burst cycle, long/short/medium-term schedulers, dispatcher and dispatch latency, preemptive vs non-preemptive, criteria (CPU utilisation, throughput, turnaround, waiting, response time), Gantt charts
09 FCFS, SJF and SRTF: worked Gantt charts with arrival times, convoy effect, SJF optimal average waiting, predicting the next burst with exponential averaging, starvation
10 Priority and Round Robin scheduling: static/dynamic priority, starvation and aging, worked priority example, Round Robin with time quantum worked, choosing the quantum, comparing algorithms
11 Advanced scheduling: multilevel queue, multilevel feedback queue, multiprocessor scheduling (affinity, load balancing), real-time scheduling (rate monotonic bound, EDF), Linux CFS idea
12 Process synchronisation and the critical section problem: race condition with counter++ step by step, critical section, mutual exclusion, progress, bounded waiting, Peterson's solution and why it works
13 Hardware support and locks: disabling interrupts, test-and-set, compare-and-swap, atomic variables, mutex locks, spinlocks vs blocking, memory barriers idea, priority inversion
14 Semaphores and monitors: counting and binary semaphores, wait and signal, using semaphores for ordering and mutual exclusion, blocking implementation, common mistakes, monitors and condition variables
15 Classic synchronisation problems: bounded buffer with three semaphores, readers-writers (first and second versions), dining philosophers and deadlock-free solutions, sleeping barber idea
16 Deadlocks I: system model, four necessary conditions, resource allocation graphs (cycle with single and multiple instances), deadlock prevention by breaking each condition, lock ordering
17 Deadlocks II: avoidance, safe and unsafe states, resource-allocation-graph algorithm, banker's algorithm worked (need matrix, safety algorithm, resource request), detection with wait-for graph, recovery, ostrich approach
18 Memory management basics: address binding, logical vs physical addresses, MMU with base and limit / relocation registers, swapping, contiguous allocation, first/best/worst fit worked, external and internal fragmentation, compaction
19 Paging: pages and frames, page number and offset, address translation worked, page table, TLB and effective access time worked, protection bits, shared pages, page table size
20 Page table structures and segmentation: hierarchical (two-level) paging, hashed and inverted page tables, segmentation (segment table, base/limit), segmentation with paging, x86-64 four-level idea
21 Virtual memory and demand paging: why virtual memory, demand paging, valid-invalid bit, page fault handling step by step, effective access time with page faults worked, copy-on-write, memory-mapped files
22 Page replacement and thrashing: FIFO, optimal, LRU worked on a reference string, Belady's anomaly, LRU approximations (reference bit, second chance/clock), frame allocation, thrashing, working set, page fault frequency
23 Mass storage and disk scheduling: HDD geometry and access time, SSDs, disk scheduling FCFS, SSTF, SCAN, C-SCAN, LOOK, C-LOOK worked, RAID 0, 1, 5, 6, 10
24 File systems: file concept and attributes, access methods, directory structures, mounting, allocation (contiguous, linked, FAT, indexed, Unix inode) with max file size worked, free-space management, journaling
25 I/O systems, protection, security and virtualisation + wrap-up: I/O methods recap, device drivers, buffering, caching, spooling, protection (access matrix, ACL, capabilities, Unix rwx), security threats, virtual machines and containers, course recap and what next
