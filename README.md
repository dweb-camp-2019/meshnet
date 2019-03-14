Meshnet @ DWeb Camp 2019
========================

The 2019 Decentralized Web ~Summit~ Camp will take place at a beautiful piece of coastal land 40 minutes west of San Jose from July 18 to 21.
This area currently has very minimal network infrastructure and Internet connectivity.
Let's use this opportunity to build, test, and use our decentralized systems together,
in a connectivity environment that more closely resembles large parts of the world,
and co-imagine the social processes and local technologies that will help us organize day-to-day,
and make inclusive spaces to learn from each other and build capacity around human-empowering technologies.

![access-point-positions](images/access-point-positions.png?raw=true)

## Goals

This document is the proposal to build a local mesh network with the following goals in mind:

- Reliable local network with 802.11ac speeds
- Access points in key areas for client devices (e.g. phones and laptops) to connect
- Allow Camp participants to extend or run locally-hosted services on the network
- Carry traffic to Internet gateway for client devices to access the Internet with limited bandwidth and reliability
- Document setup and learnings for future events or other groups

## Hardware

The diagram above is the area map, with preliminary positions of _mesh nodes_ that together form the local mesh network.
Each node has a 100 m radius circle around it, representing the region where client devices are expected to form a good connection with the node's access point.
There is a larger 150 m radius circle around where devices may be able to connect. The green dotted lines represent point-to-point links between nodes that together form the local mesh network.

Each node is an aggregate of multiple pieces of equipment, which may include:

- Radio for directional link
- Radio for access point
- Network switch, router, and application server
- Power equipment, mounts, and cables

Some nodes will have interfaces that allow other devices to be plugged in to offer locally-hosted services on the network. 
One or more nodes will also serve as the Internet gateway for this local network.

### Radio for directional link

Each green dotted line represents a directional link formed by a pair of [MikroTik SXTsq 5 ac](https://mikrotik.com/product/sxtsq_5_ac), [used in NYC Mesh](https://docs.nycmesh.net/hardware/sxtsqg5acd/), supporting link speeds at 800+ Mbps.
These devices will run stock firmware.
Where possible, we can also link two nodes with a long ethernet cable.

One alternative option is the 60 GHz [MikroTik Wireless Wire](https://mikrotik.com/product/wireless_wire) or [MikroTik Wireless Wire Dish](https://mikrotik.com/product/wireless_wire_dish), but we will start with the SXTsq 5 ac devices at lower costs.

### Radio for access point

Omnidirectional access points are what client devices will connect to, we will use a [MikroTik OmniTIK 5 PoE ac](https://mikrotik.com/product/rbomnitikpg_5hacd), [used in NYC Mesh](https://docs.nycmesh.net/hardware/mikrotikomnitik5ac/), as the standard device to connect 50+ clients at a time and deliver 800+ Mbps aggregate speeds.
These devices will run stock firmware.

An alternative device we can use as access point is the [MikroTik mANTBox 15s](https://mikrotik.com/product/RB921GS-5HPacD-15S) sector, in areas where only one side of the mount point needs service.

### Network switch, router, and application server

The [SolidRun ClearFog Pro](https://www.solid-run.com/product/SRM6828S00D01GE000P01CE/) will be used as gigabit network switch and router.
It has 7 gigabit ports, used to connect with the directional and access point radios, Internet gateways, as well as devices offering local services to the network (e.g. Raspberry Pi running a [Scuttlebutt](https://www.scuttlebutt.nz) Pub Server, or devices running [Dat](https://datproject.org) and [IPFS](https://ipfs.io) to provide the network with distributed storage capacity).
In the case that more ports are needed, Internet Archive has Ubiquiti ToughSwitch and other 48-port switches to provide.
The ClearFog Pro has a 1.6 GHz ARM processor and 1 GB RAM, so we can run some applications directly on the board that are traditionally unable to run on routers.

We also hope to connect [LibreRouter](https://librerouter.org) devices to the network.
It is a 802.11n device and does not have the same application processing power, but it includes two 5 GHz directional radios and a 2.4 GHz access point, and it is an all-in-one and open-source device perfect for the environment we are working with.

### Power equipment, mounts, and cables

Some areas may not have a source of power.
These areas will have to be identified when we survey the site, then we can plan for alternatives.
If no high point is available, we may have to install 5-6 m tall poles to mount the wireless equipment.
We will also bring large spools of ethernet cables, and tools to make them so everyone can participate in building from basic components.

## Prototype

We will create a prototype setup over April and May to validate the devices we chose, and try running various mesh routing software on them.

### Equipment list

| Device                                                                              | Quantity  |
|:------------------------------------------------------------------------------------|:---------:|
| [MikroTik SXTsq 5 ac](https://mikrotik.com/product/sxtsq_5_ac)                      | 2         |
| [MikroTik OmniTIK 5 PoE ac](https://mikrotik.com/product/rbomnitikpg_5hacd)         | 1         |
| [MikroTik mANTBox 15s](https://mikrotik.com/product/RB921GS-5HPacD-15S)             | 1         |
| [SolidRun ClearFog Pro](https://www.solid-run.com/product/SRM6828S00D01GE000P01CE/) | 2         |
| [LibreRouter](https://librerouter.org)                                              | 3         |
| Ubiquiti ToughSwitch                                                                | available | 
| Raspberry Pi 3B+                                                                    | available |
| Orange Pi Zero                                                                      | available |

### Routing protocol

We will start with [Althea's flavour of Babel](https://github.com/althea-mesh/babeld) (with [WireGuard](https://www.wireguard.com/)).
There are other mesh protocols such as [batman-adv](https://www.kernel.org/doc/html/v4.15/networking/batman-adv.html) and [BMX6](https://bmx6.net/projects/bmx6) that may also be tested.
Other more experimental protocols such as [cjdns](https://github.com/cjdelisle/cjdns) and [Yggdrasil](https://yggdrasil-network.github.io/) may be run in parallel to or in parts of the network.
