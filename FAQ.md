Questions & Comments
====================

_This is the place to collect questions and comments that have come up in the planning stages.
If you want to learn more or contribute to the project, this is probably a good read after looking at the [README](README.md).
Feel free to add new questions or send comments to this page as pull requests._

>What is your WAN connection(s)?
>- Will there be a routed public IP block?
>- Or a single/few static IPs?
>- Will one node be the designated WAN egress/ingress point or will there be multiple gateways on the meshnet?

@jonah-archive is working with the venue and local ISPs to pool together some internets. I am imagining the network to primarily operate without a WAN connection, but expect one or more more nodes as gateway depending on how the connectivity is sourced. If there is a line that pops out somewhere vs. two providers where one is satellite, we could have multiple gateways.

I don't expect static IPs would be needed as I don't expect to be hosting services to the outside world. Of course, if people run some distributed service with Internet peers, that is still possible.

>Since the location is coastal (e.g. wind, moisture, dense fog, animals, etc.), what are the allowances for HA - high availability - radios, routers/switches
>- You can use simple STP for fail-over between radios
>- 900Mhz can be a useful--if quite slow--backup
>- Be wary of using any 60Ghz PtP option as fog can really hinder link performance

We need the core areas to have redundancy against at least one radio failure, and have ways to monitor the overall link status of the network.

We should get some [disaster.radio](https://disaster.radio) distributed at key locations, perhaps as a separate network where people can connect to a camp-global chat.

Currently not using any 60 GHz equipment, but even if we do they'd be used (~ 250 m) at much smaller distances than specifications (1-2 km).

>Is there power at each desired "node" location?
>- If not, what is planned?
>- POE beyond 100-150 feet is unreliable

Not all locations have power. I believe the area with buildings and around the lake has power sources. At the end of March we will visit the site to identify power requirements. We also expect power build-out to complete before meshnet build-out.

>Services
>- Are any mesh services expecting to be reachable from the public internet?
>- Waterproof/moisture-proof cases for Pi-like devices is crucial

I don't expect services to be reachable automagically (as in our infrastructure will assign public IPs), but I fully expect people will manually peer stuff to their Internet peers and burn up our precious egress :cry:

>LAN topology
>- Will the network be "flat", or will there be vlan-segmented networks?
>- Will these vlans need firewall policies between them?
>- Will there be QoS in place for WAN egress traffic like VOIP/video-calling?

Inclined to start very simple, and add things as needed. In April there will be a call to describe the basic network and how communities can deploy services on there (thinking to run stuff on Raspberry Pis or boxes they bring in). If there are specific requirements we can discuss whether to modify the network topology to make things happen.

>Is the group planning on collecting data and visualizing these metrics?
>- SNMP based monitoring platforms - LibreNMS, PRTG
>- Input data into InfluxDB for data retrieval
>- Dashboards like Grafana, Kabana, etc.

I think this is an important piece we need to plan, not only as network operators but to also map it to physical topologies so participants of the Camp can discuss and map the digital world to a self-contained network we can visually see its infrastructures.
