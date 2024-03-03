# Nerves Wifi AP Camera
An example setup of a picam with [nerves](https://nerves-project.org/) served over http using [vintagenetwifi](https://hexdocs.pm/vintage_net_wifi/VintageNetWiFi.html), the end result of [this medium article](https://medium.com/@skipday/b579ac96f6af).

Clone and run these commands to burn the firmware to a sdcard
```
mix deps.get
mix firmware
mix burn
```

Boot up your raspberry pi with this sdcard inserted, and connect to the wifi access point
```
SSID: v_net
PSK: ex.vnet.wifi
```

The camera feed is served over the endpoint `192.168.0.1:4001`.