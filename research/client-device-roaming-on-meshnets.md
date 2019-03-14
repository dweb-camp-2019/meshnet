Client Device Roaming on Meshnets
=================================

## Discussion on `matrix/#software:tomesh.net`

### Summary

- Roaming -- client device keeps the same IP across the mesh and in-flight packets get re-routed as the device moves from one access point (AP) to another
- Symmetric path mode > asymmetric path mode
    - Routers don't like when forward and return paths are different
    - Use symmetric mode to avoid problems
- Roaming on Layer 3 requires an underlying Layer 2 (mesh) network because routers need to share information over Layer 2
- **babel**
    - Layer 3
    - Unless the client device also runs Babel, trying to make it roam would be misguided (a lot of work for very broken results)
- **batman-adv**
    - Layer 2
    - Project has put a lot of work into roaming support for client devices without batman-adv installed
    - Should be the mesh protocol to use for roaming
- LibreMesh uses both batman-adv (Layer 2) and bmx6 (Layer 3)
    - We think devices can only roam across batman-adv regions, but not across bmx6 boundaries
    - [ ] Confirm with LibreMesh
- There are protocols that try to address these problems, but they are experimental
- Why bother roaming?
    - HLS video stream would probably play smoothly across AP boundaries
    - RTMP and SIP would have problems
    - Large file downloads would break across AP boundaries
    - Roaming experience depends on client device handover as well

### Chat logs

Feb 19, 2019

```
14:19 < benhylau[m]> Do you know if Babel can handle roaming? I found a really old thread with juul (people's open) on it. Maybe ttk2 knows about roaming on Babel networks?
14:23 < DarkDrgn2k[m]> only Layer 2 can roam
14:23 < DarkDrgn2k[m]> cause its not even a ACCESS POINT thing
14:23 < DarkDrgn2k[m]> its a CLIENT thing
14:24 < DarkDrgn2k[m]> ttk2:  if im not mistaken Babel is layer 3 so WIFI roaming would not work
14:26 < DarkDrgn2k[m]> i tried running openvpn across cjdns hoping to create a layer 2 vpn tunnel but TUN devices didnt want to bridge
14:27 < DarkDrgn2k[m]> for many applications roaming wont be an issue either. only things that need a solid connections all the time
14:29 < DarkDrgn2k[m]> i guess you could create a layer 2 vpn running on top of the cjdns tunnle but that tunnle inside  a tunnel inside a tunnel :P
14:30 < DarkDrgn2k[m]> but thats why libremesh rusn to mesh networks
14:30 < DarkDrgn2k[m]> one for local meshing the other for outside meshing
14:31 < DarkDrgn2k[m]> ive just never been clear when its local when its outside and how it decides
14:31 < DarkDrgn2k[m]> > https://github.com/tomeshnet/prototype-cjdns-pi/issues/278
14:31 < DarkDrgn2k[m]> HeavyMetal  can you see if that patch fixes things for you?
14:37 < benhylau[m]> <DarkDrgn2k[m] "for many applications roaming wo"> Right, I also wonder what is the value of roaming. I imagine streaming rtmp would break, but if you are streaming hls I think it can cross WiFi AP boundaries without roaming?
14:38 < makeworld> Roaming can happen if the networks have the same name, on android at least
14:38 < DarkDrgn2k[m]> <makeworld "Roaming can happen if the networ"> That is a requirement but there is also Network considerations
14:39 < benhylau[m]> <makeworld "Roaming can happen if the networ"> For example, if you go to two APs and they assign you s different IP, it will break your session
14:39 < DarkDrgn2k[m]> <benhylau[m] "Right, I also wonder what is the"> Rate hls is stateless rtmp would be going to the wrong IP address
14:39 < DarkDrgn2k[m]> Same issue with SIP
14:39 < makeworld> <benhylau[m] "For example, if you go to two AP"> Ah I see yeah
14:40 < makeworld> Running mesh routers on your device is supposed to fix this
14:40 < makeworld> But yeah
14:40 < ttk2[m]> benhylau:  DarkDrgn2k  yes bablel roaming is not very good, use Batman-adv for wifi roaming. 
14:40 < benhylau[m]> Roaming has the APs talking among themselves to forward traffic around, keep client IPs, etc
14:40 < ttk2[m]> for devices running babel it's ok ish, for dumb wifi devices that aren't mesh aware it's not going to really work at all. 
14:40 < DarkDrgn2k[m]> <ttk2[m] "benhylau:  DarkDrgn2k  yes bable"> Not very good or non-existent
14:40 < ttk2[m]> batman-adv has put a lot more work into this. 
14:41 < ttk2[m]> DarkDrgn2k:  well there's some nuance there, there's client roaming and then device running the mesh software roaming 
14:41 < DarkDrgn2k[m]> <ttk2[m] "batman-adv has put a lot more wo"> babel is notayer 2
14:41 < ttk2[m]> batman-adv put a lot of effort into roaming for dumb wifi clients and it shows, it's seamlessy when setup properly. 
14:42 < ttk2[m]> babel roaming for example works if you're moving slowly enough or if you don't care about latency spikes 
14:42 < benhylau[m]> I think it's not non-existent bc I see it discussed on threads, but the terminology isn't ones I am familiar, and support what ttk2 says :D
14:42 < ttk2[m]> I mean it's not like babel just stops working while you you walk around, it tires 
14:42 < DarkDrgn2k[m]> ttk2: im not talking about babel running on the end device
14:42 < DarkDrgn2k[m]> im talking about Access poitn connected to a babel network
14:42 < DarkDrgn2k[m]> so the device does not run babel
14:42 < ttk2[m]> it's just not proactive about routing in flight traffic to the new destination, so you see starts and stutters. 
14:42 < DarkDrgn2k[m]> so when you hope from Router A to Router B you woul dnot have the same ip address right?
14:43 < ttk2[m]> access points are worse, becuase more latency, once again doable, but onlyf or like video streaming or downloads, anything real time will suffer too much to be usable. 
14:43 < ttk2[m]> I'm assuming you setup some non-babl structure to ensure they always get the same ip
14:43 < DarkDrgn2k[m]> ok ... bebel is NOT layer 2 right?
14:43 < ttk2[m]> if you don't yes no roaming. But babel doesn't take it upon itself to track that stuff, is it a missing feature or out of scope? who decides?
14:44 < ttk2[m]> yes babel is not layer 2, but it's not like you can't roam on layer 3, you just make your tcp connections unhappy 
14:44 < DarkDrgn2k[m]> no you cannot
14:44 < DarkDrgn2k[m]> wifi roaming is a CLIENT feature not a ACCESS POINT one.
14:44 < ttk2[m]> I think we have different definitions of roaming. 
14:44 < benhylau[m]> We should define roaming as being able to re-route in-flight traffic right?
14:44 < DarkDrgn2k[m]> access point just needs to be on the SAME network so you can have the SAME ip
14:45 < DarkDrgn2k[m]> im specificaly talkinga bout the user expriance. so WIFI roaming
14:45 < DarkDrgn2k[m]> as far as i know only batman-adv can acomplish this
14:45 < DarkDrgn2k[m]> becasue with any other routing protocol you end up with differn tip address which break both TCP and UDP connections and they are required to be re-established
14:46 < ttk2[m]> and I'm talking about theory, in theory you could get pretty close to what batman does, in reality batman is a complete package and constructing an eqivalent with babel would be quite a lot of effort for an inferior result. 
14:46 < ttk2[m]> I mean there's no reason you can't have babel hand out a dhcp server and there's one global dhcp server for the whole babel network. 
14:46 < ttk2[m]> and thus all the nodes and clietns keep their ip's 
14:47 < DarkDrgn2k[m]> but that would make it a layer 2 protocl not layer 3
14:47 < DarkDrgn2k[m]> dhcp needs broadcasts to work
14:47 < ttk2[m]> to autoconfigure, it's not like you can't contact a remote dhcp server 
14:47 < DarkDrgn2k[m]> well sorry thats not the probem
14:47 < DarkDrgn2k[m]> problem is bable would not be able to hand out ips to non bable devices
14:47 < DarkDrgn2k[m]> that woul dhave to be a seperate network
14:48 < ttk2[m]> although that only really works with ipv6 due to addressing issues 
14:48 < ttk2[m]> seperate program, not really network, babel just doesn't take it upon itself to do anything but setup routing tables. 
14:48 < DarkDrgn2k[m]> you could not (for example) brdige babel with an access point
14:48 < ttk2[m]> there's a lot of nuance here, but if you want client roaming today go batman-adv everything else sucks so bad it's not even worth talking about. 
14:49 < DarkDrgn2k[m]> but im talkinga bout client roaming without having the protocol installed on the device
14:49 < ttk2[m]> why not? I mean it might not work out of the box, but you can get anything to work if you try hard enough, this is an argument about the distribution of responsibilities
14:49 < DarkDrgn2k[m]> ttk2: does babel create an interface?
14:50 < ttk2[m]> batman-adv takes more responsibility for making things work, babel is like an old fashioned unix tool it does one thing does it well and doesn't do jack shit outside of that. 
14:50 < benhylau[m]> This thread https://alioth-lists.debian.net/pipermail/babel-users/2015-August/002105.html
14:50 < ttk2[m]> it's like saying grep is useless because it doesn't make files containing your results automatically 
14:50 < DarkDrgn2k[m]> ok two roaming definitions we may be getting confused
14:50 < ttk2[m]> it's a difference in design philosophy. 
14:50 < DarkDrgn2k[m]>  - BABEL client roming - meaning a node running babled position in the network changes, so routing tables need to be adjusted
14:51 < DarkDrgn2k[m]> - WIFI client roaming - when multiple wifi access points are on the same layer 2 network allowing your device to hop one with a better signal strength and retain your identity on the lan
14:52 < DarkDrgn2k[m]> in home networks this is not a problem because the home network is not routed, there fore on the same LAN
14:52 < DarkDrgn2k[m]> in mesh you must pass the signal over the MESH  so you loose the LAN support
14:52 < DarkDrgn2k[m]> Client---AP--BABLE ROUTER------BABELROUTER---AP----CLEINT
14:52 < DarkDrgn2k[m]> can both clients be on the same LAN
14:53 < ttk2[m]> * batman-adv by virtue of being layer 2 can hide a lot of the internals of keeping identities and roaming 
14:53 < ttk2[m]> * babel being layer 3 can't hide them, but there's no reason you can't run a series of carefully configure daemons that assign the same lan id to the client as they roam and have it work mostly the same, is it stupid when batman-adv exists? Sure, is it possible? Yes.
14:54 < DarkDrgn2k[m]> ttk2:  but now you have to find a way to route those ips to the right access point
14:54 < DarkDrgn2k[m]> so
14:54 < DarkDrgn2k[m]> q1) can bable assign clients ip addresses in its own network
14:54 < ttk2[m]> babel does not assign ip's but you can run another daemon that does on top of it
14:54 < DarkDrgn2k[m]> ok let me rephrase
14:54 < DarkDrgn2k[m]> can BABLE route non-babel ip addresses
14:55 < ttk2[m]> that's all babel does
14:55 < ttk2[m]> no such thing as a babel ip address
14:55 < DarkDrgn2k[m]> q2 - does bable create an interface on your router
14:55 < ttk2[m]> it just looks at the routing table on the machine and propogages that to the rest of the babel network, a system route is a babel route, a babel route is a system route, it's very closely tied to the kernel routing table. 
14:56 < DarkDrgn2k[m]> so if i traceroute trhough babble i will see all the hops it goes through?
14:57 < DarkDrgn2k[m]> or will it be 1 hop
14:57 < ttk2[m]> no babel does not create an interface, but you could have each babel node run a dhcp node that's slaved to a master dhcp node, then a client shows up, is assigned the same ip by the local dhcp which consults the master and then finally babel propogates a route to that client 
14:57 < ttk2[m]> yes you will see the hops. 
14:57 < ttk2[m]> you would have to modify the dhcp server to be very aggressive and add /32 routes rather than a prefix but eh you could make it work. 
14:57 < ttk2[m]> it's just not somthing anyone actually wants to do. 
14:57 < DarkDrgn2k[m]> each hop is a seperate lan..
14:58 < DarkDrgn2k[m]> so unless your proxying arp on EACH node your sol for wifi roamning 😓
14:58 < ttk2[m]> just because it's inadvisable doesn't mean it's impossible! 
14:58 < DarkDrgn2k[m]> because two babel clients cant advertise the same subnet then
14:58 < DarkDrgn2k[m]> ehhhh.. i mean i GUESS you could od that.. /32
14:58 < ttk2[m]> I'm not saying this is a good idea
14:58 < ttk2[m]> I'm mostly being contrarian about system design. 
14:59 < DarkDrgn2k[m]> i mean you could mary an ip address to a mac and any time the access point sees the mac address arrive it would assign it its ip addres and push the route through the network
14:59 < DarkDrgn2k[m]> but from what your saying, it wouldnt be any faster then just getting a new ip address thats already announced.
14:59 < ttk2[m]> it would mostly be to keep tcp connections from flipping out 
14:59 < ttk2[m]> most people don't have multipath tcp enabled 
14:59 < ttk2[m]> maybe quic will get that. 
15:00 < DarkDrgn2k[m]> thast such a dirty solution:P
15:00 < ttk2[m]> https://blog.cloudflare.com/the-road-to-quic/
15:00 < DarkDrgn2k[m]> but your right in theory it MAY work
15:00 < ttk2[m]> I mean that's why quic exists, because building giant layer 2's for roaming isn't doable so you need a good way to roam on layer 3 
15:01 < DarkDrgn2k[m]> i think i need to take a shower... reanouncing /32 made me feel dirty!
15:02 < DarkDrgn2k[m]> ttk2:  you never astound my by the cockamany ideas you have. still waiting for the Anti-Internet to start up :P UBER drivers with harddrives in their trunk moving data around the city!
15:03 < ttk2[m]> DarkDrgn2k:  in order to have many good ideas you must first have an order of magnitude more bad ones. 
15:03 < DarkDrgn2k[m]> ohh im full of bad ideas :) dont you worry
15:04 < benhylau[m]> My understanding is this is what happens already, in roamed networks that support symmetric roaming (no multipaths bc yes clients flip out), that a master DHCP server will assign all the IPs, except that information is shared across a layer 2 network. So the only change here in this theoretical layer 3 roamed mesh is that some magical protocol does that sharing of information on layer 3 instead
15:04 -!- yangm97 [yangm97mat@gateway/shell/matrix.org/x-bqtwzdfyibsxlksk] has joined #tomesh-software
15:05 < DarkDrgn2k[m]> basically what ttk2  proposed is basically changing ip routes of a single ip address  to accomodate that non babel entry from moving around the network.
15:06 < DarkDrgn2k[m]> but you think the intenet has big routing tables when yoou annouce /24  imagine annoucing that in /32
15:06 < DarkDrgn2k[m]> i wonder if you would have more management traffic the actual traffic on the mesh :P
15:07 < ttk2[m]> I think there's an experimental patch out there for route aggregation 
15:07 < ttk2[m]> but yes it's not a good idea 
15:07 < benhylau[m]> <DarkDrgn2k[m] "basically what ttk2  proposed is"> Does that mean the client IP will change? Just that the route will change accordingly?
15:08 < DarkDrgn2k[m]> well the idea is not to change the client ip
15:08 < DarkDrgn2k[m]> so teh network would need to figure out where the client is and make sure traffic gets to him/her
15:08 < DarkDrgn2k[m]> which also means a dealy of some sort to propegate the new route each time it roams
15:08 < benhylau[m]> I still don't understand how this is different from layer 2 roam, except ARP is now happening on some layer 3 sharing mechanism
15:09 < ttk2[m]> it's not 
15:09 < ttk2[m]> it's just worse 
15:09 < DarkDrgn2k[m]> arp isnt happening on layer 3
15:09 < ttk2[m]> :P
15:09 < ttk2[m]> there's no arp but there's some series of other layer 3 protocols you 've setup to perform similar functions 
15:10 < DarkDrgn2k[m]> its a question of does layer 2 babbel shtuttle packets where they should be (which it does inherently)
15:10 < DarkDrgn2k[m]> Or does layer 3 chanage the route of the destianation (which nothing does at the moment)
15:10 < benhylau[m]> I am saying this is how roaming works currently, except info contained in ARP now need to be routed through a layer 3 so routers can talk with each other so each AP can be a decision about client IPs
15:10 < benhylau[m]> <ttk2[m] "there's no arp but there's some "> Exactly my point
15:11 < ttk2[m]> I'm just being contrarian, for all intents and purposes babel has no client roaming and you should never do it. 
15:12 < benhylau[m]> Yes I am not planning to write layer 3 ARP equivalent so people can walk around while they download a file
15:12 < DarkDrgn2k[m]> if successful it may not be any better then not having roaming at the end of the day anyway
15:13 < benhylau[m]> <DarkDrgn2k[m] "if successful it may not be any "> This too, it will be shitty, we will be routing a lot of traffic across the network needlessly and even the static people will get impacted by this
15:14 < DarkDrgn2k[m]> libremesh's solution is probably the best one atm
15:14 < DarkDrgn2k[m]> even though i dont know how it really work fully :P
15:14 < benhylau[m]> Can I record the previous conversation into some shared pad to persist? I think it's a good summary
15:14 < DarkDrgn2k[m]> sure
15:15 < DarkDrgn2k[m]> probably could be written more co-herintly into somethign thats actually readable..
15:15 < DarkDrgn2k[m]> LOL
15:15 < benhylau[m]> Yes but that's a next step, after I ask Nico about the libremesh layer 2+3 thing where they run both batman-adv and bmx
15:15 < DarkDrgn2k[m]> i asked him i never got an aswer
15:16  * DarkDrgn2k[m] uploaded an image: image.png (42KB) < https://matrix.org/_matrix/media/v1/download/tomesh.net/oWEmnuJoJdVYpLILirEwqJnW >
15:16 < DarkDrgn2k[m]> thast basically the answer i got
15:16 < benhylau[m]> Okay I think he can at least put me thru to someone who can
15:16 < DarkDrgn2k[m]> my quetion (to put is simply) is HOW does it decide what is red what is green
15:17 < benhylau[m]> The phones run batman-adv ?!
15:17 < DarkDrgn2k[m]> i asked in the libremesh chat room too.. to no avail
15:17 < DarkDrgn2k[m]> benhylau:  no but they are brdiged with the node that does
15:17 < benhylau[m]> I think roaming across red lines only?
15:17 < DarkDrgn2k[m]> correct
15:18 < benhylau[m]> So if I want roaming across an entire region basically just do adv haha
15:18 < DarkDrgn2k[m]> pritty much
15:18 < DarkDrgn2k[m]> right @felix
15:18 < DarkDrgn2k[m]> dam hes not in the room :P
15:18 < DarkDrgn2k[m]> thast what he did in his german home town for that reason
15:19 < benhylau[m]> Yes I think for a small enough network (what I am asking) adv is easiest
15:20 < DarkDrgn2k[m]> yes.
15:20 < DarkDrgn2k[m]> so bring yggdrasil  into a community and then just run batman-adv to hadn out yggdrasil ip addresses on all the access points
15:20 < DarkDrgn2k[m]> 1 yggdrasill node per LAN that exists traffic to yggdrasil
15:21 < DarkDrgn2k[m]> or you could do multiple ones for that matter.. donono how the os picks wich one it uses :P
15:22 < ttk2[m]> DarkDrgn2k:  https://named-data.net/project/execsummary/
15:23 < ttk2[m]> think that's the best current project for the sneaker internet, as it's one protocol where an address can be either a chunk of content (a la ipfs) or a destianton (a la tcp-ip) 
16:32 < DarkDrgn2k[m]> i drew pictures....
16:32  * DarkDrgn2k[m] uploaded an image: image.png (54KB) < https://matrix.org/_matrix/media/v1/download/tomesh.net/uBoIlQeVEIvHQzotDsdWQHGX >
~~16:32  * DarkDrgn2k[m] uploaded an image: image.png (66KB) < https://matrix.org/_matrix/media/v1/download/tomesh.net/YKgaxCioGsLBtPcfhLpdSlLZ >~~
~~16:33  * DarkDrgn2k[m] uploaded an image: image.png (68KB) < https://matrix.org/_matrix/media/v1/download/tomesh.net/XYkptAobThmOxbXCqUPjhRQV >~~
16:33  * DarkDrgn2k[m] uploaded an image: image.png (59KB) < https://matrix.org/_matrix/media/v1/download/tomesh.net/QgZTXEHXVBGIDVPKTuicEhVI >
16:34  * DarkDrgn2k[m] uploaded an image: image.png (64KB) < https://matrix.org/_matrix/media/v1/download/tomesh.net/UwbrAZTunKFZoUyiezAbbJgp >
16:37 < DarkDrgn2k[m]> hmm guess i should add that exit node router on the rest of the drawings to make it more symetrical
16:43  * DarkDrgn2k[m] uploaded an image: image.png (59KB) < https://matrix.org/_matrix/media/v1/download/tomesh.net/TwzIPedSvDppyVtnDZWkboSx >
```

## Resources

- [Layer 3 WLAN Roaming](https://hackmd.io/mz0RV_shQVSqouaQpycggQ#)
