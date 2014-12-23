local composer = require( "composer" )
local scene = composer.newScene()
local scoreLib=require("lib.scoreLib")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
-- local forward references should go here

local title,multiplayerBtn,singleplayerBtn,settingsBtn,menuButtons,username,lastScore,scoreText,highscore
local scoreDisplay,scoresLabel, scoresLabelHighest, scoresLabelLast
local username,paddleColour



-- -------------------------------------------------------------------------------
  
function scene:create( event )
    local sceneGroup = self.view  
    
    local function createBackground()
        title = display.newText( {x=320, y = 50, text  = "ChronoPong", fontSize = 80} )
        sceneGroup:insert(title)
    end
   
    local function createHighscoreUsername()
        scoreText = scoreLib.init({
            fontSize = 30,
            --font = "Helvetica",
            x = display.contentCenterX,
            y = 720,
            maxDigits = 7,
            leadingZeros = true,
            filename = "scorefile.txt",
        })
        composer.setVariable("username","User1")
        username = display.newText( {x=50, y = display.contentHeight-50, text  = composer.getVariable("username"), fontSize = 35} )
        sceneGroup:insert( username)
        sceneGroup:insert(scoreText)
    end

    local function createButtons()
        playBtn = display.newText( {x=320,y=500, text = "Single Player",fontSize = 45 } )
        settingsBtn =   display.newText( {x=320,y=700, text = "Settings",fontSize = 45 } )
        
        sceneGroup:insert(playBtn)
        sceneGroup:insert(settingsBtn)

        playBtn:addEventListener( "tap", function() composer.gotoScene("playScn") end)
        settingsBtn:addEventListener( "tap", function() composer.gotoScene("mainSettingsScn") end)
    end
 
    composer.removeScene("splashScn")
    createBackground()
    createHighscoreUsername()
    createButtons()
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		highscore = scoreLib.load()
        scoreText.text=highscore
    elseif ( phase == "did" ) then
        username.text=composer.getVariable("username")
    end
end


function scene:hide( event )
    local sceneGroup = self.views
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

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene