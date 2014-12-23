local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
display.fps = 200

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local upWall, leftWall, downWall, rightWall,ball,currentScore,score,downWallCollision,drawLine,scoreBoard,paddleCounter
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
    

    local sceneGroup = self.view
        physics.start( )
        physics.setGravity( 0, 0 )
        physics.pause( )
        currentScore = 0
        paddleCounter = 0
        -- CREATE WALLS
        upWall = display.newLine( sceneGroup, 0, 100, display.contentWidth, 100 )
        downWall = display.newLine( sceneGroup, 0, display.contentHeight, display.contentWidth, display.contentHeight )
        leftWall = display.newLine( sceneGroup, 0, 0, 0, display.contentHeight )
        rightWall = display.newLine( sceneGroup, display.contentWidth, 0, display.contentWidth, display.contentHeight )

        physics.addBody( upWall, "static", {density=1000, friction=0, bounce=0.5 } )
        physics.addBody( downWall, "static", {density=1000, friction=0, bounce=0 } )
        physics.addBody( rightWall, "static", {density=1000, friction=0, bounce=0 } )
        physics.addBody( leftWall, "static", {density=1000, friction=0, bounce=0 } )
        
        -- CREATE THE SCOREBOARD
        scoreBoard = display.newText({text ="SCORE = ".. 0,x = display.contentWidth/2, y =40})
        sceneGroup:insert(scoreBoard)
        -- CREATHE THE BALL
        ball = display.newCircle(sceneGroup, 200,  200 , 20)
        physics.addBody( ball, "dynamic", {density=0, friction=0, bounce=1 } )
        ball.isFixedRotation = true
        ball.isBullet= true
        ball:setLinearVelocity(400,400)

        local speed =0
        
         function score(event)
            local vx,vy  = ball:getLinearVelocity()
            local speed = math.sqrt(vx*vx+vy*vy)
            ball:setFillColor(speed/2000,0,0)
            currentScore = currentScore +math.round(speed/400)
            scoreBoard.text = currentScore
        end
       

        function downWallCollision( event )
            if(event.phase == "ended") then
                ball:setLinearVelocity(0,-1000)
                ball.x,ball.y = 200,200
                --physics.pause( )
                print("downWallCollision")
                Runtime:removeEventListener("enterFrame",score )
                downWall:removeEventListener("collision",downWallCollision)
                composer.gotoScene("menuScn")
            end
        end
        
        local function getBallSpeed()
          if(ball) then
     --get the direction and set the speed
                
                 local vx,vy  = ball:getLinearVelocity()
                 local direction = math.atan2(vy,vx)
                 print(math.cos(direction)*speed, math.sin(direction)*speed)
         end
        end
        

       function drawLine( event )
            if ( event.phase == "ended" and paddleCounter<2) then
            paddleCounter = paddleCounter +1
            local paddle
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
                paddle.alpha = 0.2
                paddle.strokeWidth = 5
                physics.addBody( paddle, "static", {density=1, friction=0, bounce=1 } )
                paddle.isBullet = true
                local function onCollision(event)
                    local multiplier = 0
                    local vx,vy  = ball:getLinearVelocity()
                    local direction = math.atan2(vy,vx)
                        if (event.phase == "began") then                           
                            speed = math.sqrt(vx*vx+vy*vy)
                            print("bg paddle alpha :"..paddle.alpha.."speed:  "..speed)
                        end
                        if (event.phase=="ended") then
                            multiplier= (paddle.alpha + 0.5)*(paddle.alpha + 0.5)
                           if(multiplier* speed)<400 then
                                speed=400
                            elseif(multiplier*speed>2000) then
                                speed=2000
                            else
                                speed=speed*multiplier
                            end
                            ball:setLinearVelocity(math.cos(direction)*speed, math.sin(direction)*speed)
                            print("end paddle alpha :"..paddle.alpha.." multiplier :  "..multiplier.. " speed:  "..speed)
                            local multiplierText = display.newText( { text  = "x"..math.round(multiplier*100)/100, x = display.contentWidth/2 , y= display.contentHeight/2 } )
                            multiplierText:setFillColor( 1,0,0 )
                            transition.scaleBy( multiplierText, {xScale = 10,yScale = 10, time = 500, onStart = function ( )
                            transition.fadeOut( multiplierText, {time = 500, onComplete = function ()
                                multiplierText:removeSelf( )
                            end} )
                        end} )
                        end
                        
                        


                end
                transition.fadeIn( paddle, {time = 400, onComplete = function ()
                    transition.fadeOut( paddle, {time =400 , onComplete = function ()
                        physics.removeBody( paddle )
                        paddle:removeSelf( )
                        paddleCounter = paddleCounter -1
                        
                    end})
                    
                    

                end} )
                paddle:addEventListener( "collision", onCollision )
            end
        end



    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
       ball:setLinearVelocity(400,400)
        Runtime:addEventListener("enterFrame",score)
        downWall:addEventListener("collision",downWallCollision)
        Runtime:addEventListener("touch",drawLine)
    elseif ( phase == "did" ) then
        physics.start( )
        currentScore = 0
        
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
        Runtime:removeEventListener("enterFrame",score)
        --downWall:removeEventListener("collision",downWallCollision)
        Runtime:removeEventListener("touch",drawLine)
        composer.setVariable("lastScore",currentScore)
        print("score was :"..currentScore)    
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