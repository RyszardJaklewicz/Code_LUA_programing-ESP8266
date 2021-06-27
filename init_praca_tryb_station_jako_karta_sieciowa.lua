
-- Praca w trybie STATION laczenie z istniejace siecia wifi
-- siec wifi:
-- nazwa sieci: WALKIRIA
-- haslo sieci: WALKIRIA_123

--wifi.setmode(wifi.STATIONAP)
--serial.begin(115200)
--wifi.begin("WALKIRIA", "WALKIRIA_123")


local wifiConfig = {}
local ESP_IP = '192.168.11.1'

wifiConfig.mode = wifi.STATIONAP --wifi.STATIONAP --wifi.STATION --wifi.SOFTAP

if wifiConfig.mode == wifi.SOFTAP or wifiConfig.mode == wifi.STATIONAP then
    wifiConfig.accessPointConfig = {}
    wifiConfig.accessPointConfig.ssid = "WALKIRIA"
    wifiConfig.accessPointConfig.pwd =  "WALKIRIA_123"

    wifiConfig.accessPointIpConfig = {}
    wifiConfig.accessPointIpConfig.ip = ESP_IP
    wifiConfig.accessPointIpConfig.netmask = "255.255.255.0"
    wifiConfig.accessPointIpConfig.gateway = ESP_IP
end

if wifiConfig.mode == wifi.STATION or wifiConfig.mode == wifi.STATIONAP then
    wifiConfig.stationConfig = {}
    wifiConfig.stationConfig.ssid = YOUR_WIFI_NETWORK_NAME
    wifiConfig.stationConfig.pwd =  YOUR_WIFI_NETWORK_PASSWORD
end

wifi.setmode(wifiConfig.mode)

if wifiConfig.mode == wifi.SOFTAP or wifiConfig.mode == wifi.STATIONAP then
    print('AP MAC: ' .. wifi.ap.getmac())
    print('AP IP: ' .. ESP_IP)
    wifi.ap.config(wifiConfig.accessPointConfig)
    wifi.ap.setip(wifiConfig.accessPointIpConfig)
    wifi.ap.dhcp.start()
    wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T)
        print("New client connecting to the ESP...")
    end)
    print("HttpServer will be available at http://" .. wifi.ap.getip() .. "/ once you connect to the '" .. ESP_WIFI_NETWORK_NAME .. "' WiFi.")
end

if wifiConfig.mode == wifi.STATION or wifiConfig.mode == wifi.STATIONAP then
    print('Client MAC: ' .. wifi.sta.getmac())
    wifi.sta.config(wifiConfig.stationConfig.ssid, wifiConfig.stationConfig.pwd, 1)

    wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() print("The password for " .. YOUR_WIFI_NETWORK_NAME .. " is incorrect.") end)
    wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() print("Couldn't find " .. YOUR_WIFI_NETWORK_NAME .. ".") end)
    wifi.sta.eventMonReg(wifi.STA_FAIL, function() print("Failed to connect to " .. YOUR_WIFI_NETWORK_NAME .. ".") end)
    wifi.sta.eventMonReg(wifi.STA_GOTIP, function() 
        print("Successfully connected to " .. YOUR_WIFI_NETWORK_NAME .. ".")
        print("Client IP: " .. wifi.sta.getip())
        print("HttpServer will be available at http://" .. wifi.sta.getip() .. "/ if you are in the '" .. YOUR_WIFI_NETWORK_NAME .. "' network.")
    end)
end

wifi.sta.eventMonStart()




