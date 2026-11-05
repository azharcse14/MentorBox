# Course: Computer Networks  (level id "deep-cse-4-3", lesson ids "deep-cse-4-3-01".."-26")
Builds on Data Communication (deep-cse-3-6): signals, media, switching, OSI/TCP-IP layering, error detection (parity, CRC, checksum),
ARQ (Stop-and-Wait, Go-Back-N, Selective Repeat) and MAC protocols (ALOHA, CSMA/CD, CSMA/CA) are assumed and only recapped.
Operating Systems (deep-cse-4-1) covers processes and IPC; sockets are only previewed there. Top-down order (application -> transport
-> network -> link), Kurose & Ross / Forouzan style, always with small worked numbers (delays, RTTs, subnets, Dijkstra tables, cwnd).
01 What a computer network is: hosts, links, packets, routers; nuts-and-bolts vs services view; protocols; network of networks, ISP tiers, IXPs (BDIX), course map
02 Network edge, core and performance: access networks (DSL, cable, FTTH, mobile, Wi-Fi), packet vs circuit switching recap, four delays (processing, queuing, transmission L/R, propagation d/s) worked, traffic intensity, loss, throughput and bottleneck, traceroute
03 Layers and encapsulation: why layers, TCP/IP 5 layers vs OSI 7 (recap), message/segment/datagram/frame, headers, which device works at which layer, IETF and RFCs
04 Application layer principles: client-server vs P2P, processes and sockets, addressing with IP + port, what apps need from transport (reliability, throughput, timing, security), TCP vs UDP services, well-known ports
05 The Web and HTTP: URL, HTML objects, HTTP request/response messages, methods (GET, POST, PUT, DELETE, HEAD), status codes, non-persistent vs persistent connections with RTT math, stateless HTTP and cookies
06 Web caching and modern HTTP: proxy cache hit ratio worked, conditional GET (If-Modified-Since, 304), HTTP/1.1 head-of-line blocking, HTTP/2 streams, HTTP/3 over QUIC, HTTPS idea, CDNs
07 Email: user agents, mail servers, SMTP dialogue (HELO, MAIL FROM, RCPT TO, DATA, QUIT), push vs pull, POP3 vs IMAP, MIME attachments, webmail, spam and SPF/DKIM brief
08 DNS: why names, hierarchy (root, TLD, authoritative, .bd and .com.bd), local resolver, iterative vs recursive queries, caching and TTL, resource records (A, AAAA, NS, CNAME, MX), nslookup, DNS attacks brief
09 P2P and video streaming: P2P scalability worked (client-server vs P2P distribution time), BitTorrent (tracker, chunks, rarest first, tit-for-tat), video bit rates, DASH adaptive streaming, CDNs (enter deep vs bring home)
10 Socket programming: UDP and TCP sockets, Python UDP client/server, TCP welcome socket vs connection socket, bind/listen/accept/connect, a tiny uppercase server
11 Transport layer services: process-to-process delivery, multiplexing and demultiplexing, port ranges, UDP demux by (dest IP, dest port), TCP demux by 4-tuple, worked web server example
12 UDP: connectionless, 8-byte header (ports, length, checksum), checksum recap with a worked sum, why apps choose UDP (DNS, VoIP, games, streaming, QUIC), reliability in the app
13 Principles of reliable data transfer: rdt1.0, rdt2.0 (ACK/NAK), rdt2.1 sequence numbers, rdt2.2 NAK-free, rdt3.0 timers (alternating bit), stop-and-wait utilization worked, pipelining, GBN and SR recap with window rules
14 TCP basics: connection-oriented, segment structure (20-byte header, flags), byte-stream sequence and ACK numbers worked, cumulative ACKs, RTT estimation (EstimatedRTT, DevRTT, TimeoutInterval) worked, fast retransmit on 3 duplicate ACKs
15 TCP connection management and flow control: three-way handshake (SYN, SYN-ACK, ACK), ISN, closing with FIN, TIME_WAIT, TCP states, SYN flood and SYN cookies, receive window rwnd worked
16 TCP congestion control: causes and costs of congestion, AIMD, cwnd, slow start, ssthresh, congestion avoidance, fast recovery, Tahoe vs Reno trace worked, throughput and fairness, CUBIC and ECN brief
17 Network layer overview and routers: forwarding vs routing, data plane vs control plane, SDN idea, best-effort service, router architecture (input ports, switching fabric, output ports), queuing, HOL blocking, scheduling (FIFO, priority, round robin)
18 IPv4 datagram: header fields (version, IHL, total length, ID, flags, offset, TTL, protocol, checksum, addresses), MTU and fragmentation worked (4000-byte datagram on 1500 MTU), reassembly
19 IPv4 addressing and subnetting: dotted decimal, classful history, CIDR a.b.c.d/x, mask, network and broadcast address, hosts 2^h - 2, subnetting a /24 worked, VLSM idea, longest prefix match worked
20 DHCP, NAT and ICMP: DHCP DORA steps, private address ranges, NAT translation table worked, CGNAT at BD ISPs, ICMP messages, how ping and traceroute use ICMP
21 IPv6: address exhaustion, 128-bit addresses and shortening rules, 40-byte fixed header, no router fragmentation, no checksum, address types, transition (dual stack, tunneling, NAT64 idea)
22 Routing algorithms: graph view, least-cost path, link-state with Dijkstra worked table, distance-vector with Bellman-Ford worked, count-to-infinity, poisoned reverse, LS vs DV
23 Routing in the Internet: autonomous systems, intra-AS (RIP brief, OSPF areas), inter-AS BGP (eBGP/iBGP, AS-PATH, NEXT-HOP, policy, hot-potato), how BD ISPs reach the world, SDN controller brief
24 Link layer and LANs: link layer services recap, MAC addresses, ARP worked, Ethernet frame, hubs vs switches, switch self-learning table worked, VLANs, a day in the life of a web request
25 Wireless and mobile networks: wireless link features, 802.11 architecture (BSS, AP, SSID, beacon, association), CSMA/CA recap, hidden terminal and RTS/CTS, Wi-Fi generations, cellular 4G/5G basics, mobility and handover
26 Network security and wrap-up: confidentiality, integrity, authentication, symmetric vs public key, hash and digital signature, TLS handshake idea, firewalls, VPN, common attacks (DDoS, phishing, spoofing), course recap and what next
