local composer = require( "composer" )
local scene = composer.newScene()
local widget  = require("widget")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
-- local forward references should go here


-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view
  	local title,menuBtn, blueprint,usernameBtn,colorPicker
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local function menuGoto()
        composer.gotoScene("menuScn")
        
    end


    local function alertBox()
      
            composer.gotoScene("alertBoxScn",{params={background=display.captureScreen()}})
        
    end
    local color = {
        { 
        align = "right",
        width = 150,
        startIndex = 2,
        labels ={"Red", "Green", "Blue"}
    }
     }
    title = display.newText( {x=320, y = 50, text  = "Settings", fontSize = 80} )
    menuBtn = display.newText( {x=320,y=200, text = "Main Menu",fontSize = 45 } )
    usernameBtn = display.newText( {x=320,y=300, text = ">",fontSize = 45 } )
    --blueprint = display.newImageRect( sceneGroup, "mainSettingsBlueprint.png", display.contentWidth, display.contentHeight )
    --blueprint:translate( 320, 480 )
    local colorPicker = widget.newPickerWheel( {top = 340 , columns = color} )
    menuBtn:addEventListener( "tap", menuGoto)
    usernameBtn:addEventListener( "tap", alertBox )
    sceneGroup:insert( title )
    sceneGroup:insert(menuBtn)
    sceneGroup:insert( usernameBtn)
    sceneGroup:insert(colorPicker)



end


-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    
    elseif ( phase == "did" ) then



        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end



-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
    --title ,singleplayerBtn,multiplayerBtn = nil , nil ,nil
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene