-- Kod dziala laczy sie z serwerem www i pobiera json
p1 = 0
p2 = 1
p3 = 2
p4 = 3

gpio.mode(p1, gpio.OUTPUT)
gpio.mode(p2, gpio.OUTPUT)
gpio.mode(p3, gpio.OUTPUT)
gpio.mode(p4, gpio.OUTPUT)

--Ustawiamy piny GPIO modułu NodeMCU / ESP w trybie niskim/wysokim
gpio.write(0,gpio.LOW)
gpio.write(1,gpio.LOW)
gpio.write(2,gpio.LOW)
gpio.write(3,gpio.LOW)

gpio.write(0,gpio.HIGH)
gpio.write(1,gpio.HIGH)
gpio.write(2,gpio.HIGH)
gpio.write(3,gpio.HIGH)

wifi.setmode(wifi.STATION)
wifi.sta.config("WALKIRIA","WALKIRIA_123")
wifi.sta.connect()
zmienna1="wartosc_zmiennej_1"
zmienna2="wartosc_zmiennej_2"
plik="plik_request.php"

function readTSfield()
conn = nil
conn = net.createConnection(net.TCP, 0)

conn:on("receive", function(conn, payload)success = true 

	payload_zmodyfikowany = string.sub(payload,string.find(payload,"Connection: close")+57,string.len(payload))--To dziala wycina z response serwera odpowiednia ilosc znakow
	--print("odpowiedz z serwera "..payload) 
	print("odpowiedz z serwera payload_zmodyfikowany: "..payload_zmodyfikowany) 
	--local t = cjson.encode(payload_zmodyfikowany)
	--print(t)
	
	 local tabela = cjson.decode(payload_zmodyfikowany)
    --local tabela1 = json.decode(payload_zmodyfikowany)
    --local tabela2 = json:encode (payload_zmodyfikowany)
    
	print("Zarzadzanie przekaznikami:")
	print(tabela["zarzadzenie_przekaznikami"])

	local tabelac = (tabela["zarzadzenie_przekaznikami"])
	print(tabelac["wylacz_wszystkie"])
	if tabelac["wylacz_wszystkie"] == 1 then
		gpio.write(0,gpio.HIGH)
		gpio.write(1,gpio.HIGH)
		gpio.write(2,gpio.HIGH)
		gpio.write(3,gpio.HIGH)
	else
		gpio.write(0,gpio.LOW)
		gpio.write(1,gpio.LOW)
		gpio.write(2,gpio.LOW)
		gpio.write(3,gpio.LOW)
	end
	if tabelac["wlacz_1"] == 1 then
		gpio.write(0,gpio.LOW)
	end
	if tabelac["wlacz_2"] == 1 then
		gpio.write(1,gpio.LOW)
	end
	
	-- gpio.write(led0, gpio.LOW); -- tu ni emozna zwraca blad

end)
conn:on("connection",
	function(conn, payload)
	print("Connected TS")
	--conn:send("GET /?wartosc1=")
	--conn:send('GET /'..plik_jaki_wywolujemy..'?zmienna1='..zmienna..'')
	conn:send('GET /'..plik..'/?key='..zmienna1..'')
	--conn:send("aaaaa")
	conn:send(" HTTP/1.0\r\n")
	conn:send("Accept: */*\r\n")
	conn:send("User-Agent: Mozilla/4.0 (compatible; ESP8266;)\r\n")
	--conn:send("Content-Type: application/json\r\n\r\n")--Nie wiadomo czy tak mozna
	conn:send("\r\n")
end)
conn:on("disconnection", function(conn, payload) print('Disconnected') end)
conn:connect(80,'192.168.1.101')
end
tmr.alarm(0, 3000, 1, function() readTSfield() end)


-- ###########################################
-- Poniżej przyklad z uzyciem zmiennych do przekazania sciezki na serwerze jaka wywolujemy / pliku jaki wywolujemy

WRITEKEY="YOUR_WRITE_KEY" -- set your thingspeak.com keys
READKEY="YOUR_READ_KEY"
CHANNEL="YOUR_CHANNEL_ID"
wifi.setmode(wifi.STATION)
--wifi.sta.config("yourSSID","yourPASSWORD")
wifi.sta.connect()
tmr.delay(1000000)

function readTSfield()
conn = nil
conn = net.createConnection(net.TCP, 0)
conn:on("receive", function(conn, payload)success = true print("received "..payload) end)
conn:on("connection",
function(conn, payload)
print("Connected TS")
conn:send('GET /channels/'..CHANNEL..'/fields/1/last?key='..READKEY..'')
end)
conn:on("disconnection", function(conn, payload) print('Disconnected') end)
conn:connect(80,'192.168.1.101')
end
tmr.alarm(0, 5000, 1, function() readTSfield() end)
HTH, Dave
