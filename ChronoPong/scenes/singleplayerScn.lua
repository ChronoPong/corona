local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
-- local forward references should go here

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view
    local title,menuBtn,blueprint
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local function menuGoto()

         composer.gotoScene("menuScn")
    
    end




    title = display.newText( {x=320, y = 50, text  = "Single Player", fontSize = 80} )
    menuBtn = display.newText( {x=320,y=200, text = "Main Menu",fontSize = 45 } )

    blueprint = display.newImageRect( sceneGroup, "singleplayerBlueprint.png", display.contentWidth, display.contentHeight )
    blueprint:translate( 320, 480 )
    menuBtn:addEventListener( "tap", menuGoto)
    sceneGroup:insert( title )
    sceneGroup:insert(menuBtn)
    

end


-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then


-- Show alert with two buttons
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