-- title:   lesson5
-- author:  Omega
-- desc:    shoot_projectile
-- site:    lero lero no tengo xd
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

blobby = {
	x = 0,
	y = 0,
	speed = .5,
	vx = 0,
	vy = 0
}

slime = {
	x = 0,
	y = 0,
	active = false,
	vx = 0
}

gravity = 0.2

function TIC()

	cls()
	
	moveBlobby()
	checkLimits()
	
	throwSlime()
	
	spr(256, blobby.x, blobby.y)
	
end

function moveBlobby()
	-- up=0, down=1, left=2, right=2
	
	--MOVE
	if btn(2) then --left
		blobby.vx = -1 * blobby.speed
	elseif btn(3) then --right
		blobby.vx = blobby.speed
	else --stop
		blobby.vx = 0
	end
	
	--JUMP if grpund and arrow pressed
	if blobby.vy == 0 and btnp(0) then
		blobby.vy = -2.5
	--STOP falling at grpund level
	elseif blobby.y > 120 then
		blobby.vy = 0
	--otherwise use GRAVITY
	else
		blobby.vy = blobby.vy + gravity
	end
	
	--update position
	blobby.x = blobby.x + blobby.vx
	blobby.y = blobby.y + blobby.vy
	
end--MOVE BLOBBY

--CHECK LIMITS
function checkLimits()
	if blobby.y < 0 then blobby.y = 128 end
	if blobby.y > 128 then blobby.y = 0 end
	if blobby.x < 0 then blobby.x = 232 end
	if blobby.x > 232 then blobby.x = 0 end

end--CHECK LIMITS



--Throw sprite
function throwSlime()
	
	--if slime exists,
	if slime.active then
		--make slime move
		slime.x = slime.x + slime.vx
		
		--check if slime reached edge of screen
		if slime.x < 0 or slime.x > 232 then
			slime.active = false
		else
			spr(320, slime.x, slime.y)
		end
		
	--otherwise slime doesn't exist, create slime if 2 pressed
	elseif	btnp(4) then
			--mark slime as active
			slime.active = true
			if blobby.vx == 0 then
				slime.vx = 2
			else
				slime.vx = blobby.vx * 1.5
			end 	
					
			--set starting position of slime
			if blobby.vx > 0 then
				slime.x = blobby.x + 9
			else
				slime.x = blobby.x -9
			end
			
		 slime.y = blobby.y
			
	end
	
end--throwSlime
