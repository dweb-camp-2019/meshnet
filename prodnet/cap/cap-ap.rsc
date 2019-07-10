# Configure users
/user set 0 name=admin password=ADMIN_PASSWORD
/user add name=me group=read

# Set the cAP identity
/system identity
set name="cAP"

# Configure time
/system clock
set time-zone-name=America/Los_Angeles

# Configure hardware button
/system routerboard mode-button
set enabled=yes on-event=dark-mode

/system script
add dont-require-permissions=no \
name=dark-mode \
owner=*sys \
policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
source="\r\
    \n   :if ([system leds settings get all-leds-off] = \"never\") do={\r\
    \n     /system leds settings set all-leds-off=immediate \r\
    \n   } else={\r\
    \n     /system leds settings set all-leds-off=never \r\
    \n   }\r\
    \n "

# Configure bridge
/interface bridge
add name=bridge

/interface bridge port
add bridge=bridge interface=ether1
add bridge=bridge interface=ether2
add bridge=bridge interface=wlan1
add bridge=bridge interface=wlan2

# Configure DHCP
/ip dhcp-client
add dhcp-options=hostname,clientid \
disabled=no \
interface=bridge

# Configure wireless access point
/interface wireless security-profiles
set [ find default=yes ] \
authentication-types=wpa2-psk \
mode=dynamic-keys \
supplicant-identity="cAP" \
wpa-pre-shared-key=dwebcamp \
wpa2-pre-shared-key=dwebcamp

/interface wireless
set [ find default-name=wlan1 ] \
disabled=no \
country="united states3" \
band=2ghz-b/g/n \
channel-width=20/40mhz-XX \
frequency=auto \
wireless-protocol=802.11 \
distance=indoors \
mode=ap-bridge \
ssid="dwebcamp 2.4G" \
security-profile=default

/interface wireless
set [ find default-name=wlan2 ] \
disabled=no \
country="united states3" \
band=5ghz-a/n/ac \
channel-width=20/40/80mhz-XXXX \
frequency=auto \
wireless-protocol=802.11 \
distance=indoors \
mode=ap-bridge \
ssid="dwebcamp" \
security-profile=default
