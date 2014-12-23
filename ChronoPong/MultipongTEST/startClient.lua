local composer = require( "composer" )

local client=require("Client")
local physics=require("physics")
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
    print "should be connected to server"

    function drawLine( event )
        if ( event.phase == "ended") then
            
            local paddle,paddleImage
            local xEnd,yEnd=event.x,event.y
            local maxLength=display.contentWidth*0.4
            if(((event.xStart-xEnd)^2+(event.yStart-yEnd)^2)^0.5>maxLength) then
               
                local angle=math.abs(math.atan( (event.yStart-yEnd)/(event.xStart-xEnd) ))
                if xEnd>event.xStart then
                    xEnd=event.xStart+maxLength*math.cos(angle)
                else
                    xEnd=event.xStart-maxLength*math.cos(angle)
                end
                
                if yEnd>event.yStart then
                    yEnd=event.yStart+maxLength*math.sin(angle)
                else
                     yEnd=event.yStart-maxLength*math.sin(angle)
                end
            end

            paddle = display.newLine( event.xStart, event.yStart, xEnd, yEnd)
            paddle.alpha = 0
            paddle.strokeWidth = 10
            physics.addBody( paddle, "static", {density=1, friction=0, bounce=1 } )
            paddle.isBullet = true
            transition.fadeOut( paddle, {time =800 , onComplete = function ()
                physics.removeBody( paddle )
                paddle:removeSelf( )
            --paddleCounter = paddleCounter -1
            end})
               -- end})
                 
            paddleImage = display.newImageRect(sceneGroup, "paddle.png", ((event.xStart-xEnd)^2+(event.yStart-yEnd)^2)^0.5, 20 )
            paddleImage.alpha=0.2
            paddleImage.rotation=(360/(2*math.pi))*(math.atan((yEnd-event.yStart)/(xEnd-event.xStart)))
            paddleImage.x = (event.xStart+xEnd)*0.5
            paddleImage.y = (event.yStart+yEnd)*0.5  

            transition.fadeIn( paddleImage, {time = 400, onComplete = function ()
                transition.fadeOut( paddleImage, {time =400 , onComplete = function ()
                    paddleImage:removeSelf( )
                    paddleImage=nil                       
                end})  
            end} )

            -----------send line to other player-----------
            local function getLineState()
                local state={}
                state[1]=1 --protocol id
                state[2]={event.xStart,event.yStart,xEnd,yEnd}
                return state
            end

            client:send(getLineState())
        end
    end
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local function autolanPlayerJoined(event)
        print("client object: ", event.client) --this represents the connection to the client. you can use this to send messages and files to the client. You should save this in a table somewhere.
        print("autolanPlayerJoined") 
    end
   

    local function autolanPlayerDropped(event)
        print("client object ", event.client) --this is the reference to the client object you use to send messages to the client, you can use this to findout who dropped and react accordingly
        print("dropped b/c ," ,event.message) --this is the user defined broadcast recieved from the server, it tells us about the server state.
        print("autolanPlayerDropped")
    end
   

    local function autolanReceived(event)
        print("broadcast", event.client) --this is the object representing the connection. This is the same object given during the playerJoined event and you can use this to find out which client this is coming from
        print("message," ,event.message) --this is the message from the client. You must use event.client to find out who it came from.
        print("autolanReceived")
        local x1,y1,x2,y2=event.message[2][1],event.message[2][2],event.message[2][3],event.message[2][4]
        if (event.message[1]==1) then
            print("line received")
            local paddleImage
            paddleImage = display.newImageRect(sceneGroup, "paddle.png", ((x1-x2)^2+(y1-y2)^2)^0.5, 20 )
            paddleImage.alpha=0.2
            paddleImage.rotation=(360/(2*math.pi))*(math.atan((y2-y1)/(x2-x1)))
            paddleImage.x = (x1+x2)*0.5
            paddleImage.y = (y1+y2)*0.5  

            transition.fadeIn( paddleImage, {time = 400, onComplete = function ()
                transition.fadeOut( paddleImage, {time =400 , onComplete = function ()
                    paddleImage:removeSelf( )
                    paddleImage=nil                       
                end})  
            end} )

        end    

    end
   

    local function autolanFileReceived(event)
        print("filename = ", event.filename) --this is the filename in the system.documents directory
        print("autolanFileReceived")

    end
    Runtime:addEventListener("autolanPlayerJoined", autolanPlayerJoined) 
    Runtime:addEventListener("autolanPlayerDropped", autolanPlayerDropped)  
    Runtime:addEventListener("autolanReceived", autolanReceived)
    Runtime:addEventListener("autolanFileReceived", autolanFileReceived)


end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        Runtime:addEventListener("touch",drawLine)
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        physics.start( )

  
        composer.removeScene("MultiPlayerScreen")

    end
end


     ----------------------------------------------------------------------------------------------------------
----------------------------Server Specific Listeners-----------------------------------------------------
----------------------------------------------------------------------------------------------------------


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

