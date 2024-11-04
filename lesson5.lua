-- title:   lesson5
-- author:  Omega
-- desc:    shoot_projectile
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

blobby = {
	x = 0,
	y = 0,
	speed = .5,
	vx = 0,
	vy = 0,
	costume = 272,
	direction = "right"
}

slime = {
	x = 0,
	y = 0,
	active = false,
	vx = 0,
	speed = 4,
	costume = 320
}

gravity = 0.2

function TIC()

	cls()
	t = time()//10
	
	moveBlobby()
	checkLimits()
	
	throwSlime()
	
	spr(blobby.costume + t%60//30 , blobby.x, blobby.y)
	
end

function moveBlobby()
	-- up=0, down=1, left=2, right=2
	
	--MOVE
	if btn(2) then --left
		blobby.vx = -1 * blobby.speed
		blobby.costume = 278
		blobby.direction = "left" 
	elseif btn(3) then --right
		blobby.vx = blobby.speed
		blobby.costume = 280
		blobby.direction = "right" 
	else --stop
		blobby.vx = 0
		if blobby.direction == "left" then
			blobby.costume = 272
		else
			blobby.costume = 282
		end
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
			spr(slime.costume + t%60//20, slime.x, slime.y)
		end
		
	--otherwise slime doesn't exist, create slime if 2 pressed
	elseif	btnp(4) then
			--mark slime as active
			slime.active = true
			if blobby.direction == "right" then
				slime.vx = slime.speed
				slime.x = blobby.x + 9
			else
				slime.vx = slime.speed * -1
				slime.x = blobby.x -9
					

			end
			
		 slime.y = blobby.y
			
			
	end
	print(slime.x)
end--throwSlime
