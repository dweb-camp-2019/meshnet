Mesh Network Equipment
======================

We are expecting to set up 6-8 _Mesh Nodes_ depending on the area of coverage, which we will not know until early-July when registration level will tell us how far out the camp sites will spread.

A Mesh Node consists of:

- A router
- One, or more, point-to-point (PTP) radios to reach other Mesh Nodes
- One, or more, access point (AP) that is an omnidirectional (indoor or outdoor) or sector antenna for client devices (e.g. phone or computers) to connect to

All routers are ESPRESSObin devices running [Babel](https://github.com/jech/babeld) and Mesh Nodes with more than one PTP radio will also need a managed switch to VLAN tag the traffic.

Three or more of the Mesh Nodes will also have a PoE switch where wired access to the network will be possible. Projects are expected to connect devices running local services (e.g. Matrix) to these switch ports.

The following is a listing of our equipment inventory.

## Inventory

| Item | Vendor | Price (USD) | Total Quantity (# of them borrowed) | On-hand Quantity |
|:-----|-------:|------------:|------------------------------------:|-----------------:|
| [MikroTik Wireless Wire](https://mikrotik.com/product/wireless_wire) (pair) | Streakwave | 170.00 | 5 | 2 |
| [MikroTik SXTsq 5 ac](https://mikrotik.com/product/sxtsq_5_ac) | Streakwave | 53.00 | 8 | 6 |
| [MikroTik mANTBox 15s](https://mikrotik.com/product/RB921GS-5HPacD-15S) | Streakwave | 117.00 | 4 | 4 |
| [MikroTik OmniTIK 5 PoE ac](https://mikrotik.com/product/rbomnitikpg_5hacd) | Streakwave | 109.00 | 4 | 4 |
| [MikroTik wAP ac 3x3 (black)](https://mikrotik.com/product/RBwAPG-5HacT2HnD-BE) | Streakwave | 73.00 | 3 | 0 |
| [MikroTik cAP ac](https://mikrotik.com/product/cap_ac) (return) | Streakwave | 56.50 | 1 | 1 |
| [MikroTik QMP mount](https://mikrotik.com/product/QMP) | Streakwave | 6.00 | 2 | 2 |
| Ubiquiti UBAM mount | Streakwave | 8.00 | 2 | 2 |
| Cat5e connectors (100 pcs) | Streakwave | 29.96 | 1 | 1 |
| [ESPRESSObin V5 64 Bit](https://www.amazon.com/ESPRESSObin-Single-Computer-Network-Switch/dp/B06Y3V2FBK/) | Amazon | 49.00 | 10 (2) | 6 |
| [ESPRESSObin V7 64 Bit](https://www.amazon.com/ESPRESSObin-Single-Computer-Network-Switch/dp/B07KTMBCS1/) | Amazon | 79.00 | 2 (1) | 1 |
[ESPRESSOBIN+ power supply](https://www.amazon.com/ESPRESSObin-Single-Computer-Network-Switch/dp/B07KTC9JVB/) | Amazon | 10.00 | 10 (2) | 6 |
| [NETGEAR 5-Port Gigabit Managed Switch](https://www.amazon.com/dp/B07PJ7XZ7X/) | Amazon | 36.99 | 5 | 1 |
| [Outdoor Junction Box](https://www.amazon.com/LeMotech-Dustproof-Waterproof-Electrical-200mmx155mmx80mm/dp/B075DHT7X2/) | Amazon | 29.99 | 6 | 1 |
| [UCTRONICS PoE Splitter (Gigabit 802.3af Micro-USB 5V)](https://www.amazon.com/UCTRONICS-PoE-Splitter-Gigabit-Raspberry/dp/B07CNKX14C/) | Amazon | 15.00 | 15 | 1 |
| PoE Splitter (10/100 802.3af Micro-USB 5V) | n/a | n/a | 2 (2) | 2 |
| PoE Splitter (10/100 802.3af Barrel 12V) | n/a | n/a | 2 (2) | 2 |
| SRW224P (10/100 24-port PoE switch) | n/a | n/a | 1 (1) | 1 |
| SRW208P (10/100 8-port PoE switch) | n/a | n/a | 2 (2) | 2 |
| Raspberry Pi 3B+ | n/a | n/a | 5 (5) | 5 |
| Ethernet cable spool (1000 ft) | n/a | n/a | 2 (2) | 2 |
| Ethernet cable crimper | n/a | n/a | 3 (3) | 3 |
| Ethernet cable tester | n/a | n/a | 1 (1) | 1 |
| SD card | n/a | n/a | 12 (12) | 12 |
| Hard drive | n/a | n/a | 1 (1) | 1 |

## Budget

| Category                        | Original Budget (USD) | Revised Budget (USD) |
|:--------------------------------|----------------------:|---------------------:|
| Meshnet equipment (prototype)   | ~~1500~~              |  500                 |
| Meshnet equipment (production)  | ~~5000~~              | 3000                 |
| Misc. hardware (SBCs, cables)   | ~~1500~~              |  500                 |
| Installation expenses           |    500                |  500                 |
| **Total**                       | ~~8500~~              | 4500                 |

## Orders

| Order                 | Total   | Status  |
|:----------------------|--------:|--------:|
| Streakwave #1         |  334.00 |`Shipped`|
| Amazon #1             |  336.16 |`Shipped`|
| Streakwave #2         | 1456.32 |`Shipped`|
| Amazon #2             |  837.00 |`Ordered`|
| Streakwave #3         |  901.09 |`Ordered`|
| Installation expenses |  500.00 |`Pending`|
| **Total**             | 4373.48 |         |
