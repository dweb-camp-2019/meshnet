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

1. Login as `root` / `1234` then run [espressobin/install](espressobin/install) and go through the first-run menus.

1. Figure out what type of node this will be:

    | Type    | Description                                                                        |
    |:--------|:-----------------------------------------------------------------------------------|
    |`edge`   | Node with only one _Point-to-point Mesh Radio_                                     |
    |`relay`  | Node with multiple _Point-to-point Mesh Radios_ and relays traffic for other nodes |
    |`gateway`| Node that routes the local network to the Internet                                 |
 
    then run with a `TYPE` from above and a `NODE_ID` between 0 to 99:

    ```
    # wget https://raw.githubusercontent.com/dweb-camp-2019/meshnet/master/prodnet/espressobin/install
    # chmod +x install
    # ./install TYPE NODE_ID
    ```

### NETGEAR GS305E Gigabit Managed Switch

This device is only necessary for `relay` and `gateway` nodes.

We configured the ESPRESSObin to have only one `wan` port. Babel needs to distinguish different network interfaces in order to compute route metrics between the different links and make routing decisions accordingly. So we will make virtual interfaces by tagged each mesh radio with a different VLAN ID, essentially multiplexing differently tagged packets into `wan` which then seperates them out on `wan.1` `wan.2` `wan.3` and `wan.4` on the ESPRESSObin, and what Babel sees are seperate network interfaces as if the ESPRESSObin has 4 `wan` ports.

1. Connect to the GS305E default IP and login to the admin interface

1. Enable `Basic 802.1Q VLAN Status` then configure the following VLAN ID settings:

    | port    | 1 | 2 | 3 | 4 | 5 |
    |:--------|:-:|:-:|:-:|:-:|:-:|
    | VLAN ID | 1 | 2 | 3 | 4 |all|

1. Apply the configurations, then wait 30 seconds to ensure the changes are saved

1. Connect `port 5` to the ESPRESSObin `wan` port, and use the VLAN tagged ports for point-to-point radios or ethernet cables that are connect mesh nodes

1. If this is an Internet Gatway node, connect your Internet backhaul to `port 4` (since we have `wan.4` configured to be the Internet route for Internet Gateway ESPRESSObins)

## Point-to-Point Mesh Radios

Directional radios that make a point-to-point link are put into bridge mode to serve as a wireless replacement of an ethernet cable. These high gain radios need to be aligned carefully to be pointed at one another within about 20 degrees to get optimal speeds.

### MikroTik SXTsq 5 ac (5 GHz)

1. Download the latest release of [RouterOS for the SXTsq 5 ac](https://mikrotik.com/product/sxtsq_5_ac) (`v6.44.3 (stable)` is the version used)

1. Connect your computer to the ethernet port of the MikroTik device and configure the static IP `192.168.88.100` on the local network interface

1. Connect to `192.168.88.1` and login to the web interface as `admin` without password, upload the `.npk` file and reboot the device, then verify RouterOS is upgraded to the latest

1. SSH into the device with `ssh admin@192.168.88.1`

1. Ensure the device has fresh configurations, run `/system reset-configuration` if needed

1. Run [sxtsq/sxtsq-ap.rsc](sxtsq/sxtsq-ap.rsc)

1. Reboot the device with `/system reboot` and it will acquire the new IP address `192.168.88.2`

1. Repeat the above steps for the second (client) device, then run [sxtsq/sxtsq-client.rsc](sxtsq/sxtsq-client.rsc), and it will acquire the new IP address `192.168.88.3` after reboot

### MikroTik Wireless Wire (60 GHz)

These are pre-configured devices that operate at 60 GHz to form a gigabit wireless link at distances ~100 m. They between 700-900 Mbps even when alignment is a little off and have LEDs to indicate link quality. The pair has management IP addresses of `192.168.88.2` and `192.168.88.3`, when can be accessed via the ESPRESSObin via SSH as `admin` user, but this usually isn't necessary as they should "just work" as if it is an actual ethernet cable.

### Ethernet Cable

Yes. If distances allow, you can just use an ethernet cable to link two nodes. Remember the maximum distance for ethernet cables to work reliably is 100 m. I have run into trouble at smaller distances when also doing PoE.

## Access Point Radios

We use three models of radios depending on whether we need wireless coverage all around the antenna (omnidirectional) or an area within a 120 degree cone (sector). We will configure each radio to provide a 5 GHz-only network with:

```
SSID:     dwebcamp
Password: dwebcamp
```

There will be two users: `admin` with `ADMIN_PASSWORD`, and `me` with no password and read-only access to the access point web UI.

### MikroTik OmniTIK 5 PoE ac (Outdoor Omnidirectional)

1. Connect your computer to one of the LAN ethernet ports of the MikroTik device and configure the static IP `192.168.88.100` on the local network interface

1. SSH into the device with `ssh admin@192.168.88.1`

1. Ensure the device has fresh configurations, run `/system reset-configuration` if needed

1. Run [omnitik/omnitik-ap.rsc](omnitik/omnitik-ap.rsc) after replacing the `ADMIN_PASSWORD`

### MikroTik mANTBox 15s (Outdoor Sector)

1. Connect the MikroTik device to a router with a DHCP server

1. Connect your computer to the router (not to the access point of the MikroTik device, otherwise configuration scripts will not fully execute whenever a command resets the access point)

1. Scan for the IP address of the MikroTik device with a tool like `nmap` or `arp-scan`

1. SSH into the device with `ssh admin@IP_ADDRESS`

1. Ensure the device has fresh configurations, run `/system reset-configuration` if needed

1. Run [mant15s/mant15s-ap.rsc](mant15s/mant15s-ap.rsc) after replacing the `ADMIN_PASSWORD`

### MikroTik cAP ac (Indoor Dual-band Omnidirectional)

1. Connect the MikroTik device to a router with a DHCP server

1. Connect your computer to the router (not to the access point of the MikroTik device, otherwise configuration scripts will not fully execute whenever a command resets the access point)

1. Scan for the IP address of the MikroTik device with a tool like `nmap` or `arp-scan`

1. SSH into the device with `ssh admin@IP_ADDRESS`

1. Ensure the device has fresh configurations, run `/system reset-configuration` if needed

1. Run [cap/cap-ap.rsc](cap/cap-ap.rsc) after replacing the `ADMIN_PASSWORD`

### MikroTik wAP ac 3x3 (Indoor Dual-band Omnidirectional)

1. Connect the MikroTik device to a router with a DHCP server

1. Connect your computer directly to the MikroTik device using wireless (not ethernet). There should be 2 new SSIDs for it.

1. Scan for the IP address of the MikroTik device with a tool like `nmap` or `arp-scan`

1. SSH into the device with `ssh admin@IP_ADDRESS`

1. Run the commands in [wap/wap-ap.rsc](wap/wap-ap.rsc) in stages:
    1. Run the first command after replacing the `ADMIN_PASSWORD`.
    1. Run the next commands upto and including line 54, this will change the password and break your admin connection.
    1. Reconnect with the wAP using the new password from line 54
	1. Run `nmap` again to get device's new IP
	1. SSH into the device again with it's new IP. (`ssh admin@IP_ADDRESS`)
    1. Continue running the rest of the commands in [wap/wap-ap.rsc](wap/wap-ap.rsc). depending on whether you connected to the 5GHz or 2.4GHz SSID you might break the admin connection one more time, or you will complete the last command and then it will break the connection. (Commands 56-67 are for 2.4GHz, 69-80 are for 5GHz). Keep reconnecting until you've run all of the commands.

## Client PoE Switches

![network-switch](images/network-switch.jpg?raw=true)

Two models of Linksys PoE switches are used, SRW208P (8-port) and SRW224P (24-port), with 10/100 ports and two gigabit ports on each. 802.3af PoE splitters of 5V (micro-USB) and 12V (barrel-jack) are used to provide power and 10/100 networking to client devices, such as Raspberry Pis and laptops. They are on the same `10.X.0.0/24` LAN as client devices that are wirelessly connected through Access Points.

## Credits

This network is designed with contributions by members of [Toronto Mesh](https://tomesh.net), [People's Open](https://peoplesopen.net), and [Althea](https://althea.org), and draws from MikroTik radio documentations published by [NYC Mesh](https://nycmesh.net).
