



wifi.setmode(wifi.STATION)
wifi.sta.config("nowa_siec","12345678")
 
cfgip={}
cfgip.ip="192.168.1.8";
cfgip.netmask="255.255.255.0";
cfgip.gateway="192.168.1.1";
wifi.sta.setip(cfgip);
 
print("Przypisany adres IP: "..wifi.sta.getip())