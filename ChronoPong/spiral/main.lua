local angle=-90
local seconds={}
local current=1
local mins=0
local rotTime = 3000
while angle<270 do
	
	local x1,y1,second
	x1=320+250*math.cos(angle*2*math.pi/360)
	--if(angle<180) then
	
		y1=480+250*math.sin(angle*2*math.pi/360)
	
	--else
		--y1=200+(300+200*math.sin(angle))
	--	y1=0
		
	--end
		
	seconds[((angle+90)/6)+1]=display.newText((angle+90)/6,x1,y1,native.systemFont, 20)
	angle=angle+6
end

transitionpar = {time = rotTime, x = 640/2, y = 960/2,alpha = 0, iterations = 0,}
for i=1 ,60 do
	transitionpar = {time = rotTime, x = 640/2, y = 960/2,alpha = 0, iterations = 0,delay = i * rotTime/60}
	transition.to(seconds[i],transitionpar)
end
