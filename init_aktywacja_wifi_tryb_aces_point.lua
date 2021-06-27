
cfg={}						-- tworzymy array na konfiguracje
cfg.ssid="Nazwa_SSID"		-- ustawiamy nazwe sieci  
cfg.pwd="Haslo"				-- ustawiamy haslo do sieci
wifi.ap.config(cfg)			-- nadajemy sieci powyzsze ustawienia

wifi.setmode(wifi.SOFTAP)	-- ustawiamy wifi jako dzialajace w trybie Access Point (https://nodemcu.readthedocs.io/en/master/en/modules/wifi/)

cfgip={}
cfgip.ip="192.168.1.1"
cfgip.netmask="255.255.255.0"
cfgip.gateway="192.168.1.1"
wifi.ap.setip(cfgip)

print("Uruchomiono: "..cfg.ssid)
print("Adres MAC: "..wifi.ap.getmac())
print("Adres IP: "..wifi.ap.getip())