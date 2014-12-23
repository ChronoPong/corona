local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
-- local forward references should go here
local background
-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.

    background = display.newImage( "slo.png" )
    background:translate( 320, 480 )
    background.alpha = 0
    sceneGroup:insert( background )
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

        function gotoMenu()
            local options =
                {
                    effect = "fade",                 
                }
             composer.gotoScene ("menuScn",options)
       end
       
       function startOut( event )
          transition.fadeOut( background)
          timer2 = timer.performWithDelay(1000,gotoMenu)
        end

        timer1 = timer.performWithDelay( 2000, startOut)  -- wait 2 seconds
        transition.fadeIn( background, {time = 1000} )
        --transition.fadeOut( background, {time = 1000} )
       
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.views
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
    
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene


