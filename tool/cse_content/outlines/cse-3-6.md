# Course: Data Communication  (level id "deep-cse-3-6", lesson ids "deep-cse-3-6-01".."-25")
Stays at the physical and data-link layers. IP, TCP, routing and the full protocol stack belong to Computer Networks (deep-cse-4-3): mention and move on.
Fourier series/transform and LTI-system math belong to Signals & Systems (deep-cse-3-7) and Math III (deep-cse-2-7): recap only the idea that a signal is a sum of sine waves.
Builds on Electrical Circuits (deep-cse-1-5) and Digital Logic Design (deep-cse-2-3): voltage, frequency, XOR and binary are assumed.
01 What data communication is: the five-part model (source, transmitter, medium, receiver, destination), message/protocol, delivery-accuracy-timeliness-jitter, simplex/half-duplex/full-duplex, point-to-point vs multipoint, topologies, course map
02 Layered thinking: why layers, the OSI 7 layers and TCP/IP 4/5 layers in one page, encapsulation and headers, where this course lives (physical + data link), PDU names
03 Analog and digital signals: amplitude, frequency, period, phase, wavelength, sine wave math, composite signals as sums of sines (brief Fourier recap), time vs frequency domain
04 Bandwidth and digital signal properties: bandwidth in Hz vs bit rate in bps, bit interval, baud vs bit rate, harmonics of a square wave, baseband vs broadband (passband) transmission
05 Data rate limits: Nyquist for a noiseless channel (2B log2 L), Shannon capacity B log2(1+SNR), SNR and decibels, worked examples, using both together to pick L
06 Transmission impairments and performance: attenuation and dB, distortion, noise types (thermal, induced, crosstalk, impulse), throughput, latency (propagation, transmission, queuing, processing), bandwidth-delay product, jitter
07 Line coding I: self-synchronisation, DC component, baseline wander; unipolar NRZ, polar NRZ-L and NRZ-I, RZ, Manchester and differential Manchester, worked bit patterns
08 Line coding II and block coding: bipolar AMI and pseudoternary, multilevel 2B1Q, MLT-3, block coding 4B/5B and 8B/10B, scrambling B8ZS and HDB3
09 Analog-to-digital: PCM: sampling theorem (fs >= 2 fmax), aliasing, quantization levels, quantization error and SQNR (6.02n + 1.76 dB), encoding, PCM bit rate (voice 8000 x 8 = 64 kbps), companding (mu-law/A-law idea)
10 Delta modulation and transmission modes: DM, slope overload and granular noise, adaptive DM, DPCM idea; parallel vs serial, asynchronous (start/stop bits, efficiency), synchronous, isochronous
11 Digital-to-analog I: carrier signals, ASK and OOK, FSK, BFSK bandwidth, bandwidth formulas with d factor, PSK and BPSK
12 Digital-to-analog II: QPSK, constellation diagrams, QAM (16-QAM, 64-QAM), bits per symbol, bit rate vs baud worked examples, why Wi-Fi/4G change QAM order with signal quality
13 Analog-to-analog: why modulate, AM (bandwidth 2B, modulation index), FM (Carson's rule 2(delta f + B)), PM, the AM/FM radio bands, Radio Today style examples
14 Multiplexing I: FDM (guard bands, voice channel example), WDM in fibre, synchronous TDM (frames, framing bits, data rate math), statistical TDM
15 Multiplexing II and the digital hierarchy: interleaving, pulse stuffing, T1 (24 x 64 kbps + framing = 1.544 Mbps) and E1 (32 x 64 = 2.048 Mbps), DSL/ADSL and cable sharing the line
16 Spread spectrum: why spread, FHSS (hop sets, Bluetooth example), DSSS (chips, Barker code, 802.11b), CDMA idea with orthogonal Walsh codes worked example
17 Guided media: twisted pair (UTP/STP, categories, why twisting), coaxial cable, optical fibre (total internal reflection, single-mode vs multimode, why the submarine cable SEA-ME-WE matters to Bangladesh)
18 Unguided media: electromagnetic spectrum, radio waves, microwaves (line of sight, terrestrial and satellite, Bangabandhu-1 satellite), infrared, antennas, propagation modes
19 Switching: circuit switching (setup, data transfer, teardown), packet switching (datagram vs virtual circuit), message switching, delay comparison worked example, telephone network overview
20 Error detection: types of errors (single-bit, burst), redundancy, Hamming distance and d_min rules, parity (simple and 2D), Internet checksum (one's complement) worked example
21 CRC: polynomial view, modulo-2 division worked example, generator choice, what CRC catches, CRC-32 in Ethernet
22 Error correction: Hamming code (7,4) placement of parity bits, encoding and syndrome decoding worked example, forward error correction vs retransmission, a peek at Reed-Solomon (QR codes, CDs)
23 Data link control: framing (character and bit stuffing), flow control, stop-and-wait (efficiency, a = Tp/Tt), ARQ, Go-Back-N and Selective Repeat (window size limits 2^m - 1 and 2^(m-1)), piggybacking
24 HDLC and PPP: HDLC stations and modes, frame format, I/S/U frames, flag 01111110 and bit stuffing; PPP frame, byte stuffing, LCP/authentication (PAP, CHAP) and NCP phases, PPPoE for home broadband
25 Multiple access, Ethernet and wireless LANs: pure ALOHA (S = G e^-2G, max 18.4%), slotted ALOHA (S = G e^-G, max 36.8%), CSMA persistence, CSMA/CD and minimum frame size, binary exponential backoff, CSMA/CA, Ethernet frame and MAC address, Fast/Gigabit Ethernet, 802.11 basics, controlled access and channelization recap, course wrap-up
