local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
-- local forward references should go here
local background,box,usernameLbl,okBtn,cancelBtn,usernameFld,username
local width,height=display.contentWidth,display.contentHeight
-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    

    local function okPressed(event)
        
            composer.gotoScene("mainSettingsScn")
            composer.setVariable("username",username)
       
    end
    local function cancelPressed()
        composer.gotoScene("mainSettingsScn") 
    
    end
    
   

    box=display.newRoundedRect(width*0.5, height*0.5, width*0.75,height*0.3,20 )
    sceneGroup:insert(box)
 
    usernameLbl = display.newText({text="Username",fontSize = 80,x=box.x,y=box.y-100})
    sceneGroup:insert(usernameLbl)
    usernameLbl:setFillColor(1,0,0)

    okBtn = display.newText( {x=box.x-100,y=box.y+100, text = "OK",fontSize = 45 } )
    sceneGroup:insert(okBtn)
    okBtn:setFillColor(1,0,0)
    okBtn:addEventListener( "tap", okPressed )

    cancelBtn = display.newText( {x=box.x+100,y=box.y+100, text = "Cancel",fontSize = 45 } )
    sceneGroup:insert(cancelBtn)
    cancelBtn:setFillColor(1,0,0)
    cancelBtn:addEventListener( "tap", cancelPressed )

   

    -- Create text field


end


-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        if background then
            background:removeSelf( )
            background=nil
        end
        background=event.params.background
        sceneGroup:insert( 1,background )
        background.x,background.y=width*0.5,height*0.5
        background.alpha=0.5

        usernameFld = native.newTextField( box.x, box.y, box.width-40, 70 )
        username=composer.getVariable("username")
        usernameFld.text=username
        usernameFld:addEventListener( "userInput", textListener )

    elseif ( phase == "did" ) then


-- Show alert with two buttons
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end



-- "scene:destroy()"

-- -------------------------------------------------------------------------------
function scene:hide( event )

    local sceneGroup = self.views
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
       usernameFld:removeSelf( )
       usernameFld=nil
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
    
end
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------
 function textListener( event )

        if ( event.phase == "began" ) then

            -- user begins editing text field
            print( event.text )

        elseif ( event.phase == "ended" ) then

            -- text field loses focus

        elseif ( event.phase == "ended" or event.phase == "submitted" ) then

            -- do something with defaultField's text

        elseif ( event.phase == "editing" ) then

            print( event.newCharacters )
            print( event.oldText )
            print( event.startPosition )
            print( event.text )
            username=event.text

        end
end

return scene