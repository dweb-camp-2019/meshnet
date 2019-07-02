# Set the SXT AP identity
/system identity
set name="SXT PTP AP"

# Create WiFi security profile
/interface wireless security-profiles
set [ find default=yes ] \
authentication-types=wpa2-psk \
management-protection=allowed \
management-protection-key=f384fekfj3f34f34 \
mode=dynamic-keys \
wpa2-pre-shared-key=3hf34ihfc44ohjvw \
supplicant-identity="SXT PTP AP"

# Configure wlan1 as AP
/interface wireless
set [ find default-name=wlan1 ] \
disabled=no \
country="united states3" \
band=5ghz-a/n/ac \
channel-width=20/40/80mhz-Ceee \
frequency=auto \
wireless-protocol=802.11 \
mode=bridge \
tx-power-mode=all-rates-fixed \
tx-power=17 \
ssid=sxt-ptp-ap \
security-profile=default

# Disable NAT
/ip firewall nat
set numbers=0 disabled=yes

# Disable firewall filters
/ip firewall filter
set numbers=1 disabled=yes
set numbers=2 disabled=yes
set numbers=3 disabled=yes
set numbers=4 disabled=yes
set numbers=5 disabled=yes
set numbers=6 disabled=yes
set numbers=7 disabled=yes
set numbers=8 disabled=yes
set numbers=9 disabled=yes
set numbers=10 disabled=yes

# Configure DHCP on interfaces
/ip dhcp-client
set [ find interface=wlan1 ] disabled=yes
/ip dhcp-server
set [ find interface=ether1 ] disabled=yes

# Bridge ether1 and wlan1
/interface bridge
add name=br1
/interface bridge port
add bridge=br1 interface=ether1
add bridge=br1 interface=wlan1

# Disable unused services
/ip service
set api disabled=yes
set api-ssl disabled=yes
set ftp disabled=yes
set telnet disabled=yes

# Change management IP address of ether1 to avoid conflict with Client
/ip address
set [ find interface=ether1 ] address=192.168.88.2/24
