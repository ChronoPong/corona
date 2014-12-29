local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
-- local forward references should go here

-- -------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view

    -- Set the background image.
    background = display.newImage( "resources/icons/splashScreenImg.jpg" )
    background:translate( 320, 400 )
    sceneGroup:insert( background )

    -- Set ChronoPong caption
    title = display.newText( {x=320, y = 650, text  = "ChronoPong", fontSize = 80} )
    sceneGroup:insert(title)

    blackRectangle = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
    sceneGroup:insert(blackRectangle)
    blackRectangle:setFillColor(0,0,0)
    blackRectangle.alpha=0

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    --After 2s, goes to menuScn
    local function startOut( event )
        timer.performWithDelay( 1300, 
            function()
                transition.fadeIn(blackRectangle,{time=700})
            end
        )
        timer.performWithDelay( 2000,
            function() 
                composer.gotoScene("scenes.menuScn",{effect="fade",time=700})
            end
        )
    end

    if ( phase == "will" ) then
        -- Do nothing
    elseif ( phase == "did" ) then
        -- Call startOut() to start the animation of the splashscreen.
       startOut(event)
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Do nothing
    elseif ( phase == "did" ) then
        -- Do nothing
    end
end

function scene:destroy( event )
    local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

----------------------------------------------------------------------------------

return scene


