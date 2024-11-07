-- title:  Improved Mouse API
-- author: TylerDurden
-- desc:   An attempt to improve the mouse API by adding some useful functionalities.
-- script: lua
-- version: 1.0

--Improved Mouse minified version
mouse={m=mouse,x=0,y=0,px=0,py=0,lb=false,plb=false,mb=false,pmb=false,rb=false,prb=false,LEFT=1,MIDDLE=2,RIGHT=3}function mouse:__call()x,y,lb,mb,rb,sx,sy=self.m()self.px=self.x;self.py=self.y;self.x=x;self.y=y;self.plb=self.lb;self.lb=lb;self.pmb=self.mb;self.mb=mb;self.prb=self.rb;self.rb=rb;self.scroll=sy;return x,y,lb,mb,rb,sx,sy end;function mouse.is_locked()return peek(0x7FC3F,1)>0 and true or false end;function mouse.toggle_lock()poke(0x7FC3F,peek(0x7FC3F,1)>0 and 0 or 1,1)end;function mouse.in_bound(x,y,a,b)return mouse.x>=x and mouse.x<x+a and mouse.y>=y and mouse.y<y+b end;function mouse.clicked(c)c=c or 1;if c==1 then return mouse.lb and not mouse.plb elseif c==2 then return mouse.mb and not mouse.pmb elseif c==3 then return mouse.rb and not mouse.prb end end;function mouse.pressed(c)c=c or 1;if c==1 then return mouse.lb elseif c==2 then return mouse.mb elseif c==3 then return mouse.rb end end;function mouse.released(c)c=c or 1;if c==1 then return not mouse.lb and mouse.plb elseif c==2 then return not mouse.mb and mouse.pmb elseif c==3 then return not mouse.rb and mouse.prb end end;function mouse:__tostring()return string.format('(%s, %s)',self.x,self.y)end;setmetatable(mouse,mouse)
----------------------

-- Full Code
mouse={
	m=mouse,
	x=0,
	y=0,
	px=0,
	py=0,
	lb=false,
	plb=false,
	mb=false,
	pmb=false,
	rb=false,
	prb=false,
	LEFT=1,
	MIDDLE=2,
	RIGHT=3
}

function mouse:__call()
	x,y,lb,mb,rb,sx,sy=self.m()
	
	self.px=self.x
	self.py=self.y
	self.x=x
	self.y=y
	self.plb=self.lb
	self.lb=lb
	self.pmb=self.mb
	self.mb=mb
	self.prb=self.rb
	self.rb=rb
	self.scroll=sy
	
	return x,y,lb,mb,rb,sx,sy
end

function mouse.is_locked()
	return peek(0x7FC3F,1)>0 and true or false
end	

function mouse.toggle_lock()
	poke(0x7FC3F,(peek(0x7FC3F,1)>0 and 0 or 1),1)
end

function mouse.in_bound(x,y,w,h)
	return (mouse.x>=x and mouse.x<x+w and mouse.y>=y and mouse.y<y+h)
end

function mouse.clicked(bt)
	bt=bt or 1
	
	if bt==1 then
		return (mouse.lb and not mouse.plb)
	elseif bt==2 then
		return (mouse.mb and not mouse.pmb)
	elseif bt==3 then
		return (mouse.rb and not mouse.prb)
	end
end

function mouse.pressed(bt)
	bt=bt or 1
	
	if bt==1 then
		return mouse.lb
	elseif bt==2 then
		return mouse.mb
	elseif bt==3 then
		return mouse.rb
	end
end

function mouse.released(bt)
	bt=bt or 1
	
	if bt==1 then
		return (not mouse.lb and mouse.plb)
	elseif bt==2 then
		return (not mouse.mb and mouse.pmb)
	elseif bt==3 then
		return (not mouse.rb and mouse.prb)
	end
end

function mouse:__tostring()
	return string.format('(%s, %s)',self.x,self.y)
end

setmetatable(mouse,mouse)
-------------

color=14

function TIC()
	mouse()
	cls(15)

	if mouse.in_bound(190,10,43,10) then
		rect(190,10,43,10,13)
		rectb(190,10,43,10,14)
		
		if mouse.released(mouse.LEFT) then
			mouse.toggle_lock()
		end
	else
		rect(190,10,43,10,14)
		rectb(190,10,43,10,13)
	end

	print('lock mouse',192,12,12,1,1,1)
	
	color=color+mouse.scroll
	
	if not mouse.is_locked() then
		line(mouse.x,0,mouse.x,136,color)
		line(0,mouse.y,240,mouse.y,color)
	else
		line(120+mouse.x,68+mouse.y,120,68,color)
		
		print('Press \'Z\' to unlock',2,125,12,1,1,1)
		
		if btnp(4) then
			mouse.toggle_lock()
		end
	end

	print(mouse,2,2,12,1,1,1)
	
	spr(1,200,90,0,1,0,0,4,5)

	if mouse.pressed(1) then
		circb(209,98,2,9)
	end
	if mouse.clicked(1) or mouse.released(1) then
		circb(209,98,1,9)
	end
	
	if mouse.pressed(mouse.MIDDLE) then
		circb(215,98,2,2)
	end
	if mouse.clicked(mouse.MIDDLE) or mouse.released(mouse.MIDDLE) then
		circb(215,98,1,2)
	end
	
	if mouse.pressed(mouse.RIGHT) then
		circb(221,98,2,6)
	end
	if mouse.clicked(mouse.RIGHT) or mouse.released(mouse.RIGHT) then
		circb(221,98,1,6)
	end
	
	if mouse.scroll~=0 then
		if mouse.scroll>0 then
			spr(82,212,92,0)
		else
			spr(98,212,102,0)
		end
	end
end