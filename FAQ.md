Questions & Comments
====================

_This is the place to collect questions and comments that have come up in the planning stages.
If you want to learn more or contribute to the project, this is probably a good read after looking at the [README](README.md).
Feel free to add new questions or send comments to this page as pull requests._

>What is your WAN connection(s)?
>- Will there be a routed public IP block?
>- Or a single/few static IPs?
>- Will one node be the designated WAN egress/ingress point or will there be multiple gateways on the meshnet?

>Since the location is coastal (e.g. wind, moisture, dense fog, animals, etc.), what are the allowances for HA - high availability - radios, routers/switches
>- You can use simple STP for fail-over between radios
>- 900Mhz can be a useful--if quite slow--backup

>Be wary of using any 60Ghz PtP option as fog can really hinder link performance

>Is there power at each desired "node" location?
>- If not, what is planned?
>- POE beyond 100-150 feet is unreliable

>Services
>- Are any mesh services expecting to be reachable from the public internet?
>- Waterproof/moisture-proof cases for Pi-like devices is crucial

>LAN topology
>- Will the network be "flat", or will there be vlan-segmented networks?
>- Will these vlans need firewall policies between them?
>- Will there be QoS in place for WAN egress traffic like VOIP/video-calling?

>Is the group planning on collecting data and visualizing these metrics?
>- SNMP based monitoring platforms - LibreNMS, PRTG
>- Input data into InfluxDB for data retrieval
>- Dashboards like Grafana, Kabana, etc.
