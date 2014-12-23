local serversFound,isServer,client,send,server,clients,numClients,serverButton,clientButton, startItUp,serverlist,showserversButton
local widget = require("widget")
serverlist = {}

local function  sendMessage(event)
	if (event.phase == "ended") then
	client:send("Doulefki to gamimeno")
	end
end

function makeServer()
	isServer = 1
	server = require "Server"
	--server:setCustomBroadcast("2ad")
	server:start( )
	clients = {}
	numClients = 0
	startItUp =widget.newButton( {label = "Start Server" , x = display.contentCenterX, y = 50 , fontSize = 100, onEvent = function()
		
		circle = display.newCircle( display.contentCenterX, display.contentCenterY, 200)
	end })
	display.newText( {text = socket.dns.toip(socket.dns.gethostname()) , x = display.contentCenterX , y = display.contentCenterY} )
	serverButton.isVisible = false
	clientButton.isVisible = false
end



function makeClient()
	serversFound = 0
	client = require("Client")
	client:start( )
	client:scanServers()
	--showserversbutton = widget.newButton( {fontSize = 55 ,x=display.contentCenterX,y = 55, label = "Scan for Servers", onEvent = populate})
	sendButton = widget.newButton( {fontSize = 90 ,x=display.contentCenterX,y = display.contentCenterY, label = "Send", onEvent = sendMessage})
	serverButton.isVisible = false
	clientButton.isVisible = false
end




serverButton = widget.newButton( {label = "Server" , x = display.contentCenterX, y = 150 , fontSize = 100, onEvent = function ()
		makeServer()
		end} )

clientButton = widget.newButton( {label = "Client" , x = display.contentCenterX, y = 350 , fontSize = 100, onEvent = function ()
		makeClient()
		end} )


----------------------------------------------------------------------------------------------------------
----------------------------Server Specific Listeners-----------------------------------------------------
----------------------------------------------------------------------------------------------------------
local function autolanPlayerJoined(event)
	local client = event.client
	--print("client object: ", client) --this represents the connection to the client. you can use this to send messages and files to the client. You should save this in a table somewhere.
	--now lets save the client object so we can use it in the future to send messages
	clients[client] = client --trick, we can use the table object itself as the key, this will make it easier to determine which client we received a message from
	numClients = numClients + 1
	client.myJoinTime = system.getTimer() --you can add whatever values you want to the table to retrieve it later in the receved listener
	client.myName = "Player "..numClients
	--we can begin using the client object to send messages now!
	--client:send("Hello Player!")
	print("autolanPlayerJoined") 
end
Runtime:addEventListener("autolanPlayerJoined", autolanPlayerJoined)

local function autolanPlayerDropped(event)
	local client = event.client
	print("client object ", client) --this is the reference to the client object you use to send messages to the client, you can use this to findout who dropped and react accordingly
	print("dropped b/c ," ,event.message) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	--now let us remove the client from our list
	print(clients[client].myName.." Dropped, connection was active for "..system.getTimer()-clients[client].myJoinTime)
	clients[client] = nil --clear references to prevent memory leaks
	numClients = numClients - 1	
end
Runtime:addEventListener("autolanPlayerDropped", autolanPlayerDropped)




----------------------------------------------------------------------------------------------------------
----------------------------Client Specific Listeners-----------------------------------------------------
----------------------------------------------------------------------------------------------------------
local function autolanConnected(event)
	print("broadcast", event.customBroadcast) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	print("serverIP," ,event.serverIP) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	--now that we have a connecton, let us just constantly send stuff to the server as an example
	local function sendStuff()
		--client:send("hello world, the time here is"..system.getTimer())
	end
	--Runtime:addEventListener("enterFrame", sendStuff)
	print("connection established")
end
Runtime:addEventListener("autolanConnected", autolanConnected)

local function autolanServerFound(event)
	print("broadcast", event.customBroadcast) --this is the user defined broadcast recieved from the server, it tells us about the server state.
	print("server name," ,event.serverName) --this is the name of the server device (from system.getInfo()). if you need more details just put whatever you need in the customBrodcast
	serverlist[#serverlist] = event.serverIP
	widget.newButton( {label = event.serverIP, fontSize = 35 , labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }, x = display.contentCenterX , y = 40*serversFound+100, onEvent = function () client:connect(event.serverIP) end })
	serversFound = serversFound +1
	print("server IP:", event.serverIP) --this is the server IP, you must store this in an external table to connect to it later
	print("autolanServerFound")
end
Runtime:addEventListener("autolanServerFound", autolanServerFound)

local function autolanDisconnected(event)
	print("disconnected b/c ", event.message) --this can be "closed", "timeout", or "user disonnect"
	print("serverIP ", event.serverIP) --this can be "closed", "timeout", or "user disonnect"
	print("autolanDisconnected") 
end
Runtime:addEventListener("autolanDisconnected", autolanDisconnected)


local function autolanConnectionFailed(event)
	print("serverIP = ", event.serverIP) --this indicates that the server went offline between discovery and connection. the serverIP is returned so you can remove it form your list
	print("autolanConnectionFailed")
end
Runtime:addEventListener("autolanConnectionFailed", autolanConnectionFailed)



----------------------------------------------------------------------------------------------------------
-------------------------------------------Common Code----------------------------------------------------
----------------------------------------------------------------------------------------------------------


local function autolanReceived(event)
	if (isServer == 1) then
		local client = event.client
		circle:setFillColor( math.random( ),math.random(),math.random() )
		print("Message :"..event.message.." from client: "..client.myName ) --myName is our own property set in the playerJoined event
		--we can use the client object here to react to the message
		--client:send("Recieved it!, thanks!")
	else
		print("message = ", event.message) --this is the message we recieved from the server
		print("autolanReceived")
	end
end
Runtime:addEventListener("autolanReceived", autolanReceived)

local function autolanFileReceived(event)
	print("filename = ", event.filename) --this is the filename in the system.documents directory
	print("autolanFileReceived")
end
Runtime:addEventListener("autolanFileReceived", autolanFileReceived)