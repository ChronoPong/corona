local angle=-90
local seconds={}
local current=1
local mins=0
minsLbl=display.newText(mins,300,500,native.systemFont, 150)
while angle<270 do
	
	local x1,y1,second
	x1=300+250*math.cos(angle*2*math.pi/360)
	--if(angle<180) then
	
		y1=500+250*math.sin(angle*2*math.pi/360)
	
	--else
		--y1=200+(300+200*math.sin(angle))
	--	y1=0
		
	--end
		
	seconds[((angle+90)/6)+1]=display.newText((angle+90)/6,x1,y1,native.systemFont, 20)
	angle=angle+6
end

for i=1,60 do
	seconds[i].alpha=0
end

local listener = {}
function listener:timer( event )
    print( "listener called" )
	for i=1,60 do
		seconds[i].alpha=seconds[i].alpha-0.03
	end
	seconds[(current%60)+1].alpha=1
	current=current+1
	mins=math.floor(current/60)
	minsLbl.text=mins
end

timer.performWithDelay( 1000/60, listener,0 )