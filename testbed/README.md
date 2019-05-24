Testbed for DWeb Camp Applications
==================================

This uses two Raspberry Pi 3B or 3B+ to emulate the network environment from the perspective of a device plugged into the local mesh network.

After running the installation script and when you power the Raspberry Pi back on, it will use its wireless interface to mesh with another similarly configured Raspberry Pi, and any device plugged into the ethernet port will receive an IP address in the `10.[random].0.0/16` subnet. Your device will behave as if it is plugged into the DWeb Camp network, assigned an IP address unique within the local network and reachable by any device connected to the network because Babel is redistributing routes to all devices. It is probably a good idea to unplug the Raspberry Pi from your home router before powering on to avoid having two DHCP servers on your home network.

## Installation

You will need two Raspberry Pi 3B or 3B+ with SD cards, and probably ethernet cables to connect devices (e.g. laptops) to the Raspberry Pi local network.

1. Flash the SD card with [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/).

1. Create an empty file named **ssh** to enable SSH when the Pi boots:

    ```
    $ touch /path/to/sd/boot/ssh
    ```

1. Plug the SD card into the Pi.

1. Plug the Pi into your router so it has connectivity to the Internet. SSH into the Pi with `ssh pi@raspberrypi.local` and password **raspberry**.

    **Optional:** There are other ways to connect, such as connecting the Pi to your computer and sharing Internet to it. If you have multiple Pi's connected to your router, find th
eir IPs with `nmap -sn 192.168.X.0/24` (where 192.168.X is your subnet) and SSH to the local IP assigned to the Pi you want to address `ssh pi@192.168.X.Y`.

1. Run the following, then let the installation complete. After installtion the Pi will power off:

    ```
    $ wget https://raw.githubusercontent.com/dweb-camp-2019/meshnet/master/testbed/install && chmod +x install && ./install
    ```
