# Configure users
/user set 0 name=admin password=ADMIN_PASSWORD
/user add name=me group=read

# Set the mANT 15s identity
/system identity
set name="mANT 15s"

# Configure time
/system clock
set time-zone-name=America/Los_Angeles

# Configure bridge
/interface list
add name=WAN
add name=LAN

/interface list member
add interface=ether1 list=WAN
add interface=sfp1 list=LAN
add interface=wlan1 list=LAN

/interface bridge
add name=bridge comment=defconf

/interface bridge port
add bridge=bridge interface=ether1
add bridge=bridge interface=sfp1
add bridge=bridge interface=wlan1

# Configure DHCP
/ip dhcp-client
add comment=defconf \
dhcp-options=hostname,clientid \
disabled=no \
interface=bridge

# Configure wireless access point
/interface wireless security-profiles
set [ find default=yes ] \
authentication-types=wpa2-psk \
mode=dynamic-keys \
supplicant-identity="mANT 15s" \
wpa-pre-shared-key=dwebcamp \
wpa2-pre-shared-key=dwebcamp

/interface wireless
set [ find default-name=wlan1 ] \
disabled=no \
country="united states3" \
band=5ghz-a/n/ac \
channel-width=20/40/80mhz-Ceee \
frequency=auto \
wireless-protocol=802.11 \
mode=ap-bridge \
ssid=dwebcamp \
security-profile=default
