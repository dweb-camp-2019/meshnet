Production Network Setup
========================

![network-diagram](images/network-diagram.jpg?raw=true) 

TODO

## Router

The router is responsible for three things:

1. Distribute IP addresses to wired and wireless client devices on the LAN
1. Distribute routes to its LAN across the mesh network using Babel
1. Route IP packets across the mesh network using Babel

It is the central point of each node where all other devices are connected to.

### ESPRESSObin SBUD102 V5

We will configure the ESPRESSObin board so `wan` is used to connect point-to-point mesh radios, and `lan0` and `lan1` are bridged as `lan` for the local wired and wireless network:

```
    +-ESPRESSOBIN---------+P+-+
    |                      O  |
    |                      W  |
    |                      E  |
    |      L     L     W   R  |
    |      A     A     A      |
    |    +-N-+ +-N-+ +-N-+    |
    +----| 1 |-| 0 |-|   |----+
         +---+ +---+ +---+
```

1. Flash SD card with [Armbian for ESPRESSObin](https://www.armbian.com/espressobin/), then insert it into the ESPRESSObin with Internet access through one of its ethernet ports, then power on (never connect two ESPRESSObin devices to the same network until after you run this install script, the ethernet interface on all devices have the same MAC address and it will packet storm your network, nobody wants that)

1. [Connect via serial interface](http://wiki.espressobin.net/tiki-index.php?page=Serial+connection+-+Linux) to the ESPRESSObin's micro-USB port and run something like `minicom` on your computer to update the boot script (you probably need to paste a few lines at a time and make sure there are no spaces before and after each line):

    ```
    env default -a
    setenv fdt_addr 0x6000000
    setenv kernel_addr 0x7000000
    setenv loadaddr 0x8000000
    setenv initrd_size 0x2000000
    setenv initrd_addr 0x1100000
    setenv scriptaddr 0x6d00000
    setenv initrd_image uInitrd
    setenv boot_targets 'usb sata mmc1 mmc0'
    setenv boot_prefixes '/ /boot/'
    setenv bootcmd_mmc0 'setenv devnum 0; setenv boot_interface mmc; run scan_dev_for_boot;'
    setenv bootcmd_mmc1 'setenv devnum 1; setenv boot_interface mmc; run scan_dev_for_boot;'
    setenv bootcmd_sata 'setenv devnum 0; scsi scan; scsi dev 0; setenv boot_interface scsi; run scan_dev_for_boot;'
    setenv bootcmd_usb 'setenv devnum 0; usb start;setenv boot_interface usb; run scan_dev_for_boot;'
    setenv bootcmd 'for target in ${boot_targets}; do run bootcmd_${target}; done'
    setenv scan_dev_for_boot 'for prefix in ${boot_prefixes}; do echo ${prefix};run boot_a_script; done'
    setenv boot_a_script 'ext4load ${boot_interface} ${devnum}:1 ${scriptaddr} ${prefix}boot.scr;source ${scriptaddr};'
    saveenv
    ```
    
    then run `boot` to boot into the SD card

1. Login as `root` / `1234` then run [espressobin/install](espressobin/install):

    ```
    # wget https://raw.githubusercontent.com/dweb-camp-2019/meshnet/master/prodnet/espressobin/install && chmod +x install && ./install
    ```

1. If this is an _Edge Node_, one that has only one single _Point-to-point Mesh Radio_, change these lines in **/etc/babeld.conf** to just a single line of `interface wan` to disable VLAN interfaces:

    ```
    interface wan.1
    interface wan.2
    interface wan.3
    interface wan.4
   ```

1. If this is an _Internet Gateway_, a node that bridges the local network to the Internet, change **/etc/network/interfaces.d/wan.4** to:

    ```
    auto wan.4
    allow-hotplug wan.4
        iface wan.4 inet dhcp
    ```

    or:

    ```
    auto wan.4
    allow-hotplug wan.4
    iface wan.4 inet static
        address ADDRESS
        netmask NETMASK
        network NETWORK
        broadcast BROADCAST
        gateway GATEWAY
    ```

    reboot, then run these commands where `ADDRESS` is your Internet router's address which you can find by running `ip route | grep default`:

    ```
    sudo ip route del default via ADDRESS dev wan.4
    sudo ip route add 0.0.0.0/0 via ADDRESS dev wan.4 proto static
    sudo iptables -t nat -A POSTROUTING -o wan.4 -j MASQUERADE
    echo 'redistribute ip 0.0.0.0/0 metric 128' | sudo tee --append /etc/babeld.conf
    systemctl restart babeld
    ```

### NETGEAR GS305E Gigabit Managed Switch

We configured the ESPRESSObin to have only one `wan` port. Babel needs to distinguish different network interfaces in order to compute route metrics between the different links and make routing decisions accordingly. So we will make virtual interfaces by tagged each mesh radio with a different VLAN ID, essentially multiplexing differently tagged packets into `wan` which then seperates them out on `wan.1` `wan.2` `wan.3` and `wan.4` on the ESPRESSObin, and what Babel sees are seperate network interfaces as if the ESPRESSObin has 4 `wan` ports.

1. Connect to the GS305E default IP and login to the admin interface

1. Enable `Basic 802.1Q VLAN Status` then configure the following VLAN ID settings:

    | port    | 1 | 2 | 3 | 4 | 5 |
    |:--------|:-:|:-:|:-:|:-:|:-:|
    | VLAN ID | 1 | 2 | 3 | 4 |all|

1. Connect `port 5` to the ESPRESSObin `wan` port, and use the VLAN tagged ports for point-to-point radios or ethernet cables that are connect mesh nodes

1. If this is an Internet Gatway node, connect your Internet backhaul to `port 4` (since we have `wan.4` configured to be the Internet route for Internet Gateway ESPRESSObins)

## Point-to-Point Mesh Radios

Directional radios that make a point-to-point link are put into bridge mode to serve as a wireless replacement of an ethernet cable. These high gain radios need to be aligned carefully to be pointed at one another within about 20 degrees to get optimal speeds.

### MikroTik SXTsq 5 ac (5 GHz)

1. Download the latest release of [RouterOS for the SXTsq 5 ac](https://mikrotik.com/product/sxtsq_5_ac) (`v6.44.3 (stable)` is the version used)

1. Connect to `192.168.88.1` and login to the web interface as `admin` without password, upload the `.npk` file and reboot the device, then verify RouterOS is upgraded to the latest

1. Ensure the device has fresh configurations, run `/system reset-configuration` as needed

1. SSH into the first device with `ssh admin@192.168.88.1`, then run [sxtsq/sxtsq-ap.rsc](sxtsq/sxtsq-ap.rsc), then reboot the device with `/system reboot` and it will acquire the new IP address `192.168.88.2`

1. Upgrade and SSH into the second device, then run [sxtsq/sxtsq-client.rsc](sxtsq/sxtsq-client.rsc), then reboot the device with `/system reboot` and it will acquire the n
ew IP address `192.168.88.3`

### MikroTik Wireless Wire (60 GHz)

These are pre-configured devices that operate at 60 GHz to form a gigabit wireless link at distances ~100 m. They between 700-900 Mbps even when alignment is a little off and have LEDs to indicate link quality. The pair has management IP addresses of `192.168.88.2` and `192.168.88.3`, when can be accessed via the ESPRESSObin via SSH as `admin` user, but this usually isn't necessary as they should "just work" as if it is an actual ethernet cable.

### Ethernet Cable

Yes. If distances allow, you can just use an ethernet cable to link two nodes. Remember the maximum distance for ethernet cables to work reliably is 100 m. I have run into trouble at smaller distances when also doing PoE.

## Access Point Radios

We use three models of radios depending on whether we need wireless coverage all around the antenna (omnidirectional) or an area within a 120 degree cone (sector).

### MikroTik OmniTIK 5 PoE ac (Outdoor Omnidirectional)

TODO

### MikroTik mANTBox 15s (Outdoor Sector)

TODO

### MikroTik cAP ac (Indoor Omnidirectional)

TODO

## Client PoE Switches

![network-switch](images/network-switch.jpg?raw=true)

Two models of Linksys PoE switches are used, SRW208P (8-port) and SRW224P (24-port), with 10/100 ports and two gigabit ports on each. 802.3af PoE splitters of 5V (micro-USB) and 12V (barrel-jack) are used to provide power and 10/100 networking to client devices, such as Raspberry Pis and laptops. They are on the same `10.X.0.0/24` LAN as client devices that are wirelessly connected through Access Points.

## Credits

This network is designed with contributions by members of [Toronto Mesh](https://tomesh.net), [People's Open](https://peoplesopen.net), and [Althea](https://althea.org), and draws from MikroTik radio documentations published by [NYC Mesh](https://nycmesh.net).
