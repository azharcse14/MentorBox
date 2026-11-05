# Course: Computer Peripherals & Interfacing  (level id "deep-cse-3-8", lesson ids "deep-cse-3-8-01".."-25")
Builds on Digital Logic Design (deep-cse-2-3), Electronic Devices & Circuits (deep-cse-2-4), Computer Architecture (deep-cse-3-2)
and Microprocessors & Assembly (deep-cse-3-3). The 8086 pins, the 8255/8253/8259/8237/8251 chips, address decoding and
INT 21h programming are covered in deep-cse-3-3 and only mentioned here. Focus: the real devices around a computer, how they
work inside, the buses and ports that connect them (PCIe, USB, SATA, SPI, I2C, UART), and hooking sensors/motors to a microcontroller.
01 What peripherals and interfacing are: input/output/storage/communication devices, the four mismatches (speed, voltage, data format, timing), port, controller, driver, course map
02 The I/O system: I/O ports, memory-mapped vs port-mapped (brief recap), device controller registers (status, control, data), device drivers and the OS layers, what happens when you press a key
03 Data transfer methods: programmed I/O and polling, interrupt-driven I/O, DMA; cost comparison worked with numbers; handshaking (strobe/acknowledge), synchronous vs asynchronous transfer
04 Buses and system interconnect: address/data/control lines recap, bus width and clock, bandwidth calculation, bus arbitration, bus hierarchy (front-side bus, northbridge/southbridge, modern PCH), ISA
05 PCI and PCI Express: PCI shared parallel bus (32-bit, 33 MHz, 133 MB/s), configuration space and plug and play, PCIe serial lanes (x1/x4/x8/x16), generations and encoding, what goes in which slot
06 Serial vs parallel communication: why serial won (skew, crosstalk, pins), bit rate vs baud, simplex/half/full duplex, asynchronous UART frame (start, data, parity, stop) worked timing, synchronous serial
07 RS-232 and legacy ports: RS-232 voltage levels, DB-9 pins, RTS/CTS flow control, null modem, MAX232 level shifter, USB-to-serial today, Centronics parallel printer port, PS/2
08 USB part 1: why USB, host/hub/device tiered star, 127 devices, connectors (A, B, mini, micro, C), speeds by version, power (5 V, 500/900 mA, USB Power Delivery), hot plugging
09 USB part 2: differential pair D+/D-, enumeration step by step, descriptors, VID/PID, device classes (HID, mass storage, audio, CDC), endpoints and the four transfer types, host polling
10 SPI, I2C and 1-Wire: on-board chip buses, SPI wires and full duplex, chip select, I2C SDA/SCL with pull-ups, 7-bit address, start/stop/ACK worked transaction, comparison table
11 Keyboard: key matrix and scanning, debouncing (RC and software), ghosting and diodes, N-key rollover, scan codes (make/break), keyboard controller, PS/2 vs USB HID, membrane vs mechanical
12 Mouse, touchpad and touch screen: ball mouse, optical mouse (LED, tiny camera, DSP, DPI), relative vs absolute position, resistive vs capacitive touch, multi-touch, stylus
13 Display fundamentals: pixels, resolution, RGB and colour depth, frame buffer size worked, refresh rate, CRT raster scan idea, aspect ratio, pixel density
14 Display technologies: LCD (backlight, polarisers, liquid crystal, TFT), IPS/TN/VA brief, LED-backlit, OLED, e-paper, response time, comparison
15 Display interfaces and the GPU: VGA (analog, HSync/VSync), DVI, HDMI, DisplayPort, bandwidth worked, GPU and video memory, double buffering
16 Small displays on a microcontroller: LED with resistor calculation, 7-segment (common anode/cathode), multiplexing and persistence of vision, 16x2 character LCD (HD44780) pins and 4-bit mode
17 Printers: dot matrix, inkjet (thermal and piezo), laser printer steps, thermal receipt printer, DPI and PPM, printer drivers and page description languages, 3D printing brief
18 Scanners, cameras and other input: flatbed scanner, CCD vs CMOS image sensors, OCR, barcode and QR scanners, fingerprint readers, microphones
19 Magnetic hard disk: platters, heads, tracks, sectors, cylinders, RPM, seek time, rotational latency, transfer time, access time worked, capacity calculation, CHS vs LBA
20 Storage interfaces and solid state: PATA/IDE, SATA, SAS, NVMe over PCIe, SSD (NAND, pages, blocks, wear levelling, TRIM), flash drives and SD cards, optical discs, RAID brief
21 ADC and DAC: analog vs digital, sampling and Nyquist, resolution and step size, quantisation error, DAC (weighted and R-2R), ADC types (flash, successive approximation) worked, PWM as a cheap DAC
22 Sensors and signal conditioning: transducers, temperature (LM35, thermistor), LDR with voltage divider, ultrasonic distance worked, PIR, gas, accelerometer, amplify/filter/level, noise
23 Actuators and driving loads: why a GPIO pin cannot drive a motor, transistor switch, relay and flyback diode, optocoupler, DC motor with H-bridge and PWM, servo pulses, stepper motor steps
24 Microcontroller-based interfacing: GPIO, pull-up/pull-down, 3.3 V vs 5 V and level shifting, timers and interrupts on an MCU, Arduino-style pseudo-code, full project (smart irrigation)
25 Network, wireless, power and wrap-up: NIC and MAC address, Ethernet, Wi-Fi, Bluetooth, NFC, power supply (SMPS, ATX rails), UPS/IPS for load shedding, ESD and surge, course recap, what next
