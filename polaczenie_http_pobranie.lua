station_cfg={}
station_cfg.ssid="WALKIRIA"     -- Enter SSID here
station_cfg.pwd="WALKIRIA_123"  --Enter password here
server_link = "192.168.1.101/index.php" -- set server URL

wifi.setmode(wifi.STATION)  -- set wi-fi mode to station
wifi.sta.config(station_cfg)-- set ssid&pwd to config
wifi.sta.connect()          -- connect to router

function GetFromThingSpeak()-- callback function for get data
http.get(server_link,'',
function(code, data)
    if (code < 0) then
     print("HTTP request failed")
    else
     print(code, data)
    end
  end)
end
-- call get function after each 10 second
tmr.alarm(1, 10000, 1, function() GetFromThingSpeak() end)



-- wersja 1

http.get("http://192.168.1.101/index.php", nil, function(code, data)
	if (code < 0) then
		print("HTTP request failed")
	else
		print(code,data)
	end
end)

-- error:
-- stdin:1: attempt to index global 'http' (a nil value)
