local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local title, MultiButton , hostText, joinButton , joinText,singlePlayer,menuButtons
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    menuButtons = display.newGroup()
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    title = display.newText( {x=320, y = 50, text  = "MultiPong", fontSize = 80} )
    title.alpha = 0.1

    end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then

        function multiscene( event )
            composer.gotoScene("MultiPlayerScreen")
        end 

        function showButtons( )
            local menuheight = 200
            
            singlePlayer = display.newText( {x=320,y=menuheight +0, text = "Single Player",fontSize = 45 } )
            MultiButton =   display.newText( {x=320,y=menuheight+60, text = "MultiPlayer",fontSize = 45 } )
            menuButtons:insert(MultiButton)
            menuButtons:insert(singlePlayer)
            MultiButton:addEventListener( "tap", multiscene )

        end
        transition.fadeIn( title, {time = 500} )
        timer.performWithDelay( 400, showButtons())
        composer.removeScene("splash")
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
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
    menuButtons:removeSelf( )
    title:removeSelf( )
    
    --title ,singlePlayer,MultiButton = nil , nil ,nil
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