local composer = require( "composer" )
local physics = require("physics")
local scoreLib=require("lib.scoreLib")
local scene = composer.newScene()
physics.start()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
--variables
local sceneGlobal, ball, upWall, leftWall, downWall, rightWall,currentScore,score,paddleCount,trail1ball,trail2ball,seconds,minutes,timeInSeconds,secondTimer, transitionSecondIn,transitionSecondOut
local bombs,powerUps={false,false,false},{false,false,false}
--Functions
--Paddle functions
local makePaddleImage,makePaddleLine,makePaddle,multiplierText
--Wall functions
local makeWalls,setUpWallColor,upWallCollision,gameOverListener
--Event functions
local makeObstacle,score
--Ball functions
local makeBall,makeTrail,getBallSpeed
--Spiral functions
local makeSpiral,spiralListener,turnLineToGraphic

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view
    sceneGlobal = sceneGroup
    ball=makeBall()
    upWall,downWall,leftWall,rightWall,upWall=makeWalls()
    makeSpiral()

    sceneGroup:insert(upWall)
    sceneGroup:insert(downWall)
    sceneGroup:insert(leftWall)
    sceneGroup:insert(rightWall)
    sceneGroup:insert(upWall)
    sceneGroup:insert(ball)

    physics.setGravity( 0, 0 )
  
    physics.addBody( upWall, "static", {density=1000, friction=0, bounce=0.5 } )
    physics.addBody( downWall, "static", {density=1000, friction=0, bounce=0 } )
    physics.addBody( rightWall, "static", {density=1000, friction=0, bounce=0 } )
    physics.addBody( leftWall, "static", {density=1000, friction=0, bounce=0 } )

    physics.addBody( ball, { density = 0, friction = 0, bounce = 1, radius = 20 } )
    ball.isFixedRotation = true
    ball.isBullet= true
    ball:setLinearVelocity(400,400)
    
    scoreBoard = display.newText({text ="SCORE = ".. 0,x = display.contentWidth/2, y =40,fontSize= 20})
    sceneGroup:insert(scoreBoard)   
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        physics.start()
        timeInSeconds = 0
        currentScore = 0
        paddleCount = 0
        ball:setLinearVelocity(400,400)
        ball.x,ball.y = 200,200
        upWall:setStrokeColor(0,0,1)

        Runtime:addEventListener("enterFrame",score)
        Runtime:addEventListener("enterFrame", spiralListener)
        downWall:addEventListener("collision",gameOverListener)
        upWall:addEventListener("collision",upWallCollision)
        Runtime:addEventListener("touch",makePaddle)

    elseif ( phase == "did" ) then

        --[[for i=1,#seconds do
            seconds[i].img.alpha=0
        end
        secondTimer=timer.performWithDelay(1000,transitionSecondIn,0) ]]  
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
        downWall:removeEventListener("collision",gameOverListener)
        upWall:removeEventListener("collision",upWallCollision)
        Runtime:removeEventListener("touch",makePaddle)
        composer.setVariable("lastScore",currentScore)
        physics.pause()
		
		local highscore = scoreLib.load()
        if tonumber(currentScore)>(tonumber(highscore) or 0) then
            scoreLib.set(currentScore)
            scoreLib.save()
        end
		
        print("score was :"..currentScore)    
        for i=1,#bombs do
            bombs[i]=false
        end
        --timer.cancel(secondTimer)
        --transition.cancel("secondsTransition")
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

------------------------------------------PADDLE CODE------------------------------------------------

--Making a paddle consists of producing its image and a line which will be the actual physical body acting.



function makePaddleImage(event)
    local paddleImage = display.newImageRect("resources/icons/paddle.png", ((event.xStart-event.x)^2+(event.yStart-event.y)^2)^0.5, 20 )
    paddleImage.alpha=0.2
    paddleImage.rotation=(360/(2*math.pi))*(math.atan((event.y-event.yStart)/(event.x-event.xStart)))
    paddleImage.x = (event.xStart+event.x)*0.5
    paddleImage.y = (event.yStart+event.y)*0.5
    return paddleImage
end

function makePaddleLine(event)
    local paddleLine = display.newLine( event.xStart, event.yStart, event.x, event.y)
    paddleLine.alpha = 0
    paddleLine.strokeWidth = 10
    return paddleLine
end

function makePaddle( event )
    if ( event.phase == "ended" and paddleCount<2) then
        paddleCount = paddleCount +1
 
        local maxLength=display.contentWidth*0.4
        if(((event.xStart-event.x)^2+(event.yStart-event.y)^2)^0.5>maxLength) then
       
            local angle=math.abs(math.atan( (event.yStart-event.y)/(event.xStart-event.x) ))
            if event.x>event.xStart then
                event.x=event.xStart+maxLength*math.cos(angle)
            else
                event.x=event.xStart-maxLength*math.cos(angle)
            end
            
            if event.y>event.yStart then
                event.y=event.yStart+maxLength*math.sin(angle)
            else
                 event.y=event.yStart-maxLength*math.sin(angle)
            end
        end

        --Make the paddle line a physical object
        local paddleLine,paddleImage = makePaddleLine(event),makePaddleImage(event)
        sceneGlobal:insert(paddleLine)
        sceneGlobal:insert(paddleImage)
        physics.addBody( paddleLine, "static", {density=1, friction=0, bounce=1 } )
        paddleLine.isBullet = true

        --Fade out the paddle line
        transition.fadeOut( paddleLine, {time =800 , onComplete = function ()
            physics.removeBody( paddleLine )
            paddleLine:removeSelf( )
            paddleLine=nil
        end})

        --Fade in the paddle image and when complete, fade it out
        transition.fadeIn( paddleImage, {time = 400, onComplete = function ()
            transition.fadeOut( paddleImage, {time =400 , onComplete = function ()
                paddleImage:removeSelf( ) 
                paddleImage=nil                    
            end})
        end})
        
        function paddleCollision(event)
            multiplier = 0
            local vx,vy  = ball:getLinearVelocity()
            local direction = math.atan2(vy,vx)
            
            if (event.phase == "began") then                           
                speed = math.sqrt(vx*vx+vy*vy)
                print("bg paddle alpha :"..paddleImage.alpha.."speed:  "..speed)
            elseif (event.phase=="ended") then
                multiplier= (paddleImage.alpha + 0.5)^2
                if(multiplier* speed)<400 then
                    speed=400
                elseif(multiplier*speed>2000) then
                    speed=2000
                else
                    speed=speed*multiplier
                end
                multiplierText()

                ball:setLinearVelocity(math.cos(direction)*speed, math.sin(direction)*speed)
                print("end paddle alpha :"..paddleImage.alpha.." multiplier :  "..multiplier.. " speed:  "..speed)
            end                
        end
        
        setUpWallColor()
        paddleLine:addEventListener( "collision", paddleCollision )
    end
end  

function multiplierText()
    local multiplierText = display.newText( { text  = "x"..math.round(multiplier*100)/100, x = display.contentWidth/2 , y= display.contentHeight/2 } )
    multiplierText:setFillColor( 1,0,0 )
    transition.scaleBy( multiplierText, {xScale = 10,yScale = 10, time = 500, onStart = function ( )
        transition.fadeOut( multiplierText, {time = 500, onComplete = function ()
            multiplierText:removeSelf( )
        end} )
    end} )
    return multiplierText
end

------------------------------------------PADDLE CODE------------------------------------------------
------------------------------------------CLOCK CODE------------------------------------------------
--[[clock.seconds={}
function clock.makeSeconds()
    local angle=-90 
    
    while angle<270 do
        clock.seconds[((angle+90)/6)+1]={
            text=(angle+90)/6,
            x=display.contentCenterX+250*math.cos(angle*2*math.pi/360),
            y=display.contentCenterY+250*math.sin(angle*2*math.pi/360),
            font=native.systemFont,
            fontSize=20
        }
        angle=angle+6
        --seconds[i].img=display.newText(seconds[i])
    end
    return clock.seconds
end

function clock.makeMinutes()
    local minutes={}
    for i=1,2 do
        minutes[i]={
            text=0,
            x=300,
            y=500,
            font=native.systemFont,
            fontSize=150
        }
    end
    return minutes
end

function transitionSecondIn()
    timeInSeconds=timeInSeconds+1
    seconds[timeInSeconds%60+1].transition=transition.to(seconds[timeInSeconds%60+1].img,{
        time=200,
        alpha=1,
        tag="secondsTransition",
        onComplete=transitionSecondOut}
    )
end

function transitionSecondOut()
    seconds[(timeInSeconds-1)%60+1].fadeOut=transition.to(seconds[(timeInSeconds-1)%60+1].img,{
        time=30000,
        alpha=0,
        tag="secondsTransition"}
    )
end

--Create the circle of seconds and add them to the sceneGroup
seconds=clock.makeSeconds()
for i=1,#seconds do
    seconds[i].img=display.newText(seconds[i])
    sceneGroup:insert(seconds[i].img)
end
minutes=clock.makeMinutes()
for i=1,#minutes do
    minutes[i].img=display.newText(minutes[i])
    sceneGroup:insert(minutes[i].img)
end    

--]]
------------------------------------------CLOCK CODE------------------------------------------------
------------------------------------------SPIRAL CODE ----------------------------------------------
function makeSpiral()
    local angle=4.5*math.pi/180
    local theta,x,y,dx,dy
    
    local lineLength=300
    local spiralWidth=50
    for i=0,179 do
        local line
        theta=i*angle+math.pi
        x=spiralWidth*theta*math.cos(theta)+display.contentWidth*0.5
        y=display.contentHeight-spiralWidth*theta*math.sin(theta)-display.contentHeight*0.5
        dyCalc=(spiralWidth*theta*math.sin(theta)-spiralWidth*math.cos(theta))/(spiralWidth*math.sin(theta)+spiralWidth*theta*math.cos(theta))
        dxCalc=1
        dyActual=dyCalc/(dyCalc^2+dxCalc^2)^0.5 * lineLength
        dxActual=dxCalc/(dyCalc^2+dxCalc^2)^0.5 * lineLength
        local  x1,y1,x2,y2=x-dxActual,y-dyActual,x+dxActual,y+dyActual
        line=display.newLine(x1,y1,x2,y2)
        turnLineToGraphic(x1,y1,x2,y2,0.3)
        line.alpha=0
        --line:setStrokeColor(0,0,1)
        sceneGlobal:insert(line)
        print(i,x,y,dyCalc,dxCalc,dyActual,dxActual)
    end

    --[[
    lineLength=30
    spiralWidth=18
    for i=0,179 do
        local line
        theta=i*angle+math.pi
        x=spiralWidth*theta*math.cos(theta)+display.contentWidth*0.5
        y=display.contentHeight-spiralWidth*theta*math.sin(theta)-display.contentHeight*0.5
        dyCalc=(spiralWidth*theta*math.sin(theta)-spiralWidth*math.cos(theta))/(spiralWidth*math.sin(theta)+spiralWidth*theta*math.cos(theta))
        dxCalc=1
        dyActual=dyCalc/(dyCalc^2+dxCalc^2)^0.5 * lineLength
        dxActual=dxCalc/(dyCalc^2+dxCalc^2)^0.5 * lineLength
        local x1,y1,x2,y2=x-dxActual,y+dyActual,x+dxActual,y-dyActual
        line=display.newLine(x1,y1,x2,y2)
        turnLineToGraphic(x1,y1,x2,y2,0.7)
        line.alpha=0
        sceneGlobal:insert(line)
        print(i,x,y,dyCalc,dxCalc,dyActual,dxActual)
    end
    --]]
end

function spiralListener()

end
function turnLineToGraphic(x1,y1,x2,y2,a)
    local lineGraphic = display.newImageRect("resources/icons/paddle.png", ((x1-x2)^2+(y1-y2)^2)^0.5, 20 )
    lineGraphic.alpha=a
    lineGraphic.rotation=(360/(2*math.pi))*(math.atan((y2-y1)/(x2-x1)))
    lineGraphic.x = (x1+x2)*0.5
    lineGraphic.y = (y1+y2)*0.5
    --lineGraphic:setFillColor(0,1,0)
    sceneGlobal:insert(lineGraphic)
end
------------------------------------------SPIRAL CODE ----------------------------------------------

------------------------------------------WALL CODE------------------------------------------------

function makeWalls()
    upWall = display.newLine(0, 100, display.contentWidth, 100 )
    upWall.StrokeWidth = 3

    downWall = display.newLine(0, display.contentHeight, display.contentWidth, display.contentHeight )
    leftWall = display.newLine(0, 0, 0, display.contentHeight )
    rightWall = display.newLine(display.contentWidth, 0, display.contentWidth, display.contentHeight )
   
    upWallBlock = display.newRoundedRect( display.contentWidth/2, 50, display.contentWidth-5, 95, 10 )
    upWallBlock:setFillColor( 0,0,0 )
    upWallBlock.alpha = 0.6
    return upWall,downWall,leftWall,rightWall,upWallBlock
end

function setUpWallColor() 
    if (paddleCount == 0) then
        upWall:setStrokeColor(0,0,1 )
    elseif(paddleCount == 1) then
        upWall:setStrokeColor(0,1,0 )
    else
        upWall:setStrokeColor(1,0,0 )
    end
end

function upWallCollision( event )
        if (event.phase =="began") then
            paddleCount = 0
            setUpWallColor()        
        end       
end

function gameOverListener( event )
    if(event.phase == "ended") then
       -- ball:setLinearVelocity(0,-1000)
        --physics.pause( )
        print("gameOverListener")
        --Runtime:removeEventListener("enterFrame",score )
        --downWall:removeEventListener("collision",gameOverListener)
        composer.gotoScene("scenes.menuScn")
    end
end
------------------------------------------WALL CODE------------------------------------------------
------------------------------------------EVENT CODE------------------------------------------------
function makeObstacle(x,y)
    --local obstacle=display.newRect(sceneGroup,x,y,80,80)
    local obstacle = display.newImage( "resources/icons/mine.png" ,x,y)
    obstacle:scale( 0.5,0.5)
    obstacle.alpha=0.2
    transition.fadeIn( obstacle, {time = 1000, onComplete = function ()
        transition.fadeOut( obstacle, {time =1000 , onComplete = function ()
            physics.removeBody( obstacle )
            obstacle:removeSelf( )
        end})
    end})
    --transition.scaleTo( obstacle, {time = 2000, xScale = 3, yScale= 3})
    physics.addBody(obstacle,"static", {density=1000, friction=0, bounce=1,radius = 50  })
    sceneGlobal:insert(obstacle)
end

function score(event)
    local vx,vy  = ball:getLinearVelocity()
    local speed = math.sqrt(vx*vx+vy*vy)
    ball.x, ball.y = ball.x, ball.y
    ball:setFillColor((speed-100)/2000,600/speed,0)
    currentScore = currentScore +math.round(speed/400)
    scoreBoard.text = "SCORE = ".. currentScore
    --makeTrail((speed-100)/2000,600/speed,0)
   

   if(currentScore>500 and not bombs[1])then
        makeObstacle(300,300)
        bombs[1]=true
        
    end
    
    --trail1ball.x,trail1ball.y = ball.x,ball.y
    --trail1touchJoint:setTarget( ball.x, ball.y )
    --trail2ball.touchJoint:setTarget( ball.x, ball.y )
end

------------------------------------------EVENT CODE------------------------------------------------
------------------------------------------BALL CODE------------------------------------------------
function makeBall()
    local ball=display.newImage( "resources/icons/face.png")
    ball:scale(0.25,0.25)
    return ball
end



function makeTrail (r,g,b)
    local trail = display.newCircle( ball.x, ball.y, 18 )
    trail:setFillColor(r,g,b )
    transition.scaleTo( trail, {time = 200, xScale = 0.2, yScale= 0.2, onStart = function ()
        transition.fadeOut(trail, {time = 180, onComplete = function ( )
            trail:removeSelf( )
            end})
    end} )

end

function getBallSpeed()
    if(ball) then
   --get the direction and set the speed
              
        local vx,vy  = ball:getLinearVelocity()
        local direction = math.atan2(vy,vx)
        print(math.cos(direction)*speed, math.sin(direction)*speed)
    end
end
------------------------------------------BALL CODE------------------------------------------------

---------------------------------------Listener setup-----------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------


return scene