local angle=-90
local seconds={}
local current=1
local mins=0
local rotTime = 6000
while angle<270+720 do
	local ind = ((angle+90)/6)+1
	local x1,y1,second
	x1=320+250*math.cos(angle*2*math.pi/360)
	y1=480+250*math.sin(angle*2*math.pi/360)

	--seconds[((angle+90)/6)+1]=display.newText((angle+90)/6,x1,y1,native.systemFont, 20)
	seconds[ind]=display.newRect(x1,y1,40, 5)
	seconds[ind].rotation = angle
	seconds[ind]:setFillColor(0,0,1)
	seconds[ind].alpha = 0.5
	angle=angle+6
end

for i=1 ,180 do
	transitionpar = {time = rotTime, x = 640/2, y = 960/2,alpha = 0, iterations = 0,delay = i * rotTime/180}
	transition.to(seconds[i],transitionpar)
end
