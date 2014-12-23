local composer = require( "composer" )
local server = require("Server")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    composer.removeScene("MultiPlayerScreen")
    print "server should be running"
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then


    server:start()
    composer.removeScene("MultiPlayerScreen")




     ----------------------------------------------------------------------------------------------------------
----------------------------Server Specific Listeners-----------------------------------------------------
----------------------------------------------------------------------------------------------------------
local function autolanPlayerJoined(event)
    print("client object: ", event.client) --this represents the connection to the client. you can use this to send messages and files to the client. You should save this in a table somewhere.
    print("autolanPlayerJoined") 
end
Runtime:addEventListener("autolanPlayerJoined", autolanPlayerJoined)

local function autolanPlayerDropped(event)
    print("client object ", event.client) --this is the reference to the client object you use to send messages to the client, you can use this to findout who dropped and react accordingly
    print("dropped b/c ," ,event.message) --this is the user defined broadcast recieved from the server, it tells us about the server state.
    print("autolanPlayerDropped")
end
Runtime:addEventListener("autolanPlayerDropped", autolanPlayerDropped)

local function autolanReceived(event)
    print("broadcast", event.client) --this is the object representing the connection. This is the same object given during the playerJoined event and you can use this to find out which client this is coming from
    print("message," ,event.message) --this is the message from the client. You must use event.client to find out who it came from.
    print("autolanReceived")
end
Runtime:addEventListener("autolanReceived", autolanReceived)

local function autolanFileReceived(event)
    print("filename = ", event.filename) --this is the filename in the system.documents directory
    print("autolanFileReceived")
end
Runtime:addEventListener("autolanFileReceived", autolanFileReceived)










    
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene

