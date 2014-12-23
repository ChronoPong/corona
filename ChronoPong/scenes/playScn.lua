local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
local scoreLib=require("scoreLib")
display.fps = 200

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local upWall, leftWall, downWall, rightWall,ball,currentScore,score,gameOverListener,drawLine,scoreBoard,paddleCounter,trail1ball,trail2ball
local makeObstacle,ballImage,paddleColorRect
local bombs,powerUps={false,false,false},{false,false,false}
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
    

    local sceneGroup = self.view
        physics.start( )
        physics.setGravity( 0, 0 )
        --physics.pause( )
        currentScore = 0
        paddleCounter = 0
        -- CREATE WALLS
        paddleColorRect = display.newRoundedRect( display.contentWidth/2, 50, display.contentWidth-5, 95, 10 )
        paddleColorRect:setFillColor( 0,0,0 )
        paddleColorRect.alpha = 0.4
        sceneGroup:insert( paddleColorRect)
        upWall = display.newLine( sceneGroup, 0, 100, display.contentWidth, 100 )
        upWall.StrokeWidth = 3
        downWall = display.newLine( sceneGroup, 0, display.contentHeight, display.contentWidth, display.contentHeight )
        leftWall = display.newLine( sceneGroup, 0, 0, 0, display.contentHeight )
        rightWall = display.newLine( sceneGroup, display.contentWidth, 0, display.contentWidth, display.contentHeight )

        physics.addBody( upWall, "static", {density=1000, friction=0, bounce=0.5 } )
        physics.addBody( downWall, "static", {density=1000, friction=0, bounce=0 } )
        physics.addBody( rightWall, "static", {density=1000, friction=0, bounce=0 } )
        physics.addBody( leftWall, "static", {density=1000, friction=0, bounce=0 } )
        


        -- CREATE THE SCOREBOARD
        scoreBoard = display.newText({text ="SCORE = ".. 0,x = display.contentWidth/2, y =40,fontSize= 20})
        sceneGroup:insert(scoreBoard)
        -- CREATHE THE BALL
        ball = display.newCircle(sceneGroup, 200,  200 , 20)
        physics.addBody( ball, "dynamic", {density=0, friction=0, bounce=1 } )
        ball.isFixedRotation = true
        ball.isBullet= true
        ball:setLinearVelocity(400,400)
        ballImage = display.newImage( "face.png" , ball.x, ball.y  )
        ballImage:scale(0.15,0.15)
       
        

        function makeTrail (r,g,b)
            local trail = display.newCircle( ball.x, ball.y, 18 )
            trail:setFillColor(r,g,b )
            transition.scaleTo( trail, {time = 200, xScale = 0.2, yScale= 0.2, onStart = function ()
                transition.fadeOut(trail, {time = 180, onComplete = function ( )
                    trail:removeSelf( )
                end})
                end} )

        end
        
        function makeObstacle(x,y)
            --local obstacle=display.newRect(sceneGroup,x,y,80,80)
            local obstacle = display.newImage( "mine.png" ,x,y)
            obstacle:scale( 0.5,0.5)
            obstacle.alpha=0.2
                           transition.fadeIn( obstacle, {time = 1000, onComplete = function ()
                    transition.fadeOut( obstacle, {time =1000 , onComplete = function ()
                        physics.removeBody( obstacle )
                        obstacle:removeSelf( )end})end})
            --transition.scaleTo( obstacle, {time = 2000, xScale = 3, yScale= 3})
            physics.addBody(obstacle,"static", {density=1000, friction=0, bounce=1,radius = 50  })
        end
        --leftWall:addEventListener("collision",makeObstacle)
        local speed =0
        
         function score(event)
            local vx,vy  = ball:getLinearVelocity()
            local speed = math.sqrt(vx*vx+vy*vy)
            ballImage.x, ballImage.y = ball.x, ball.y
            ball:setFillColor((speed-100)/2000,600/speed,0)
            currentScore = currentScore +math.round(speed/400)
            scoreBoard.text = "SCORE = ".. currentScore
            --makeTrail((speed-100)/2000,600/speed,0)
            if (paddleCounter == 0) then
                paddleColorRect:setFillColor(0,0,1 )
            elseif(paddleCounter == 1) then
                paddleColorRect:setFillColor(0,1,0 )
            else
                paddleColorRect:setFillColor(1,0,0 )
            end

            if(currentScore>500 and not bombs[1])then
                makeObstacle(300,300)
                bombs[1]=true
                
            end
            --trail1ball.x,trail1ball.y = ball.x,ball.y
            --trail1touchJoint:setTarget( ball.x, ball.y )
            --trail2ball.touchJoint:setTarget( ball.x, ball.y )
        end
        function upWallCollision( event )
                if (event.phase =="began") then
                    --upWall:setColor(0,1,0 )
                elseif(event.phase=="ended") then
                    paddleCounter = 0
                     --upWall:setColor(1,1,1 )
                   -- body
               end       
        end
        function gameOverListener( event )
            if(event.phase == "ended") then
                ball:setLinearVelocity(0,-1000)
                
                --physics.pause( )
                print("gameOverListener")
                Runtime:removeEventListener("enterFrame",score )
                downWall:removeEventListener("collision",gameOverListener)
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
                local function onCollision(event)
                    local multiplier = 0
                    local vx,vy  = ball:getLinearVelocity()
                    local direction = math.atan2(vy,vx)
                        if (event.phase == "began") then                           
                            speed = math.sqrt(vx*vx+vy*vy)
                            print("bg paddle alpha :"..paddleImage.alpha.."speed:  "..speed)
                        end
                        if (event.phase=="ended") then
                            multiplier= (paddleImage.alpha + 0.5)*(paddleImage.alpha + 0.5)
                           if(multiplier* speed)<400 then
                                speed=400
                            elseif(multiplier*speed>2000) then
                                speed=2000
                            else
                                speed=speed*multiplier
                            end
                            ball:setLinearVelocity(math.cos(direction)*speed, math.sin(direction)*speed)
                            print("end paddle alpha :"..paddleImage.alpha.." multiplier :  "..multiplier.. " speed:  "..speed)
                            local multiplierText = display.newText( { text  = "x"..math.round(multiplier*100)/100, x = display.contentWidth/2 , y= display.contentHeight/2 } )
                            multiplierText:setFillColor( 1,0,0 )
                            transition.scaleBy( multiplierText, {xScale = 10,yScale = 10, time = 500, onStart = function ( )
                            transition.fadeOut( multiplierText, {time = 500, onComplete = function ()
                                multiplierText:removeSelf( )
                            end} )
                        end} )
                        end
                        
                        


                end
               -- transition.fadeIn( paddle, {time = 400, onComplete = function ()
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
        currentScore = 0
       ball:setLinearVelocity(400,400)
       ball.x,ball.y = 200,200
       paddleCounter = 0
        Runtime:addEventListener("enterFrame",score)
        downWall:addEventListener("collision",gameOverListener)
        upWall:addEventListener("collision",upWallCollision)
        Runtime:addEventListener("touch",drawLine)
        

    elseif ( phase == "did" ) then
        physics.start( )
        --timer.performWithDelay( 4000, function () makeObstacle(300,600) end,0)
        
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
        --downWall:removeEventListener("collision",gameOverListener)
        Runtime:removeEventListener("touch",drawLine)
        composer.setVariable("lastScore",currentScore)
		
		local highscore = scoreLib.load()
        if tonumber(currentScore)>(tonumber(highscore) or 0) then
            scoreLib.set(currentScore)
            scoreLib.save()
        end
		
        print("score was :"..currentScore)    
        for i=1,#bombs do
            bombs[i]=false
        end
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