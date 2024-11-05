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

--VALORES LETRAS
local letterValues = {
    a = 336, b = 337, c = 338, d = 339, e = 340, f = 341,
    g = 342, h = 343, i = 344, j = 345, k = 346, l = 347,
    m = 348, n = 349, o = 350, p = 351, q = 352, r = 353,
    s = 354, t = 355, u = 356, v = 357, w = 358, x = 359,
    y = 360, z = 361, N = 362, U = 363
}--VALORES LETRAS

--posiciones iniciales de las 10 palabras
local loc = {
			p1 = {x = 72,y = 16, bx = 64, by = 8,  w=87, h=23}, 	p2  = {x = 161,y = 16 , w=87, h=23},	
			p3 = {x = 72,y = 40,  w=87, h=23}, 	p4  = {x = 161,y = 40 , w=87, h=23},
			p5 = {x = 72,y = 64,  w=87, h=23}, 	p6  = {x = 161,y = 64 , w=87, h=23},
			p7 = {x = 72,y = 88,  w=87, h=23}, 	p8  = {x = 161,y = 88 , w=87, h=23},
			p9 = {x = 72,y = 112, w=87, h=23},	 p10 = {x = 161,y = 112, w=87, h=23},
}--POSICIONES EN EL NIVEL

--FALTA IMPLEMENTAR EL DICCIONARIO DE PALABRAS
local languaje =
{
w1  = {spanish = "waos", english="weos", mapudungun = "uga buga"},
w2  = {spanish = "eo", english="io", mapudungun = "eso tilin"},
}--DICCIONARIO DE PALABRAS

local months = 
{
    w1  = {spanish = "enero", english = "january", mapudungun = "eneru"},
    w2  = {spanish = "febrero", english = "february", mapudungun = "fewreru"},
    w3  = {spanish = "marzo", english = "march", mapudungun = "marsu"},
    w4  = {spanish = "abril", english = "april", mapudungun = "afril"},
    w5  = {spanish = "mayo", english = "may", mapudungun = "mayu"},
    w6  = {spanish = "junio", english = "june", mapudungun = "kuniu"},
    w7  = {spanish = "julio", english = "july", mapudungun = "kuliu"},
    w8  = {spanish = "agosto", english = "august", mapudungun = "akostu"},
    w9  = {spanish = "septiembre", english = "september", mapudungun = "setiempUre"},
    w10 = {spanish = "octubre", english = "october", mapudungun = "oktufUre"},
    w11 = {spanish = "noviembre", english = "november", mapudungun = "nofiempUre"},
    w12 = {spanish = "diciembre", english = "december", mapudungun = "disempUre"}
}

gravity = 0.2

function TIC()

	cls()
	t = time()//10

	map(0,0,30,17)
	
	moveBlobby()
	checkLimits()
	
	throwSlime()
	
	spr(blobby.costume + t%60//30 , blobby.x, blobby.y,0)
	--EJEMPLO DE COMO IMPLEMENTAR LAS FUNCIONES CON POSICIONES
	--FALTA HACER UNA FUNCION QUE TOME AL AZAR 5 palabras y 
	--las cruce en sus versiones spanish-mapu o english-mapu
	drawWord(months.w1.spanish,    loc.p1.x,  loc.p1.y)
	drawWord(months.w2.mapudungun,    loc.p2.x,  loc.p2.y)
	drawWord("tres",   loc.p3.x,  loc.p3.y)
	drawWord("cuatro", loc.p4.x,  loc.p4.y)
	drawWord("cinco",  loc.p5.x,  loc.p5.y)
	drawWord("seis",   loc.p6.x,  loc.p6.y)
	drawWord("siete",  loc.p7.x,  loc.p7.y)
	drawWord("ocho",   loc.p8.x,  loc.p8.y)
	drawWord("nueve",  loc.p9.x,  loc.p9.y)
	drawWord("diez",   loc.p10.x, loc.p10.y)
	moveSelection()
end

function moveSelection()
		x, y, left, middle, right, scrollX, scrollY = mouse()
  -- Mostrar posición del cursor
  print("Posicion del mouse: ("..x..", "..y..")", 10, 10, 12+t%60//20)
  if (x > loc.p1.bx and x< loc.p1.bx + 87) and (y>loc.p1.by and y<loc.p1.by+23) then
			rectb(loc.p1.bx,loc.p1.by,loc.p1.w,loc.p1.h,12+t%60//20) 	
  end

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
end--throwSlime

function drawLetter(letter, x, y)
    letter = string.lower(letter)
    local spriteIndex = letterValues[letter]
    if spriteIndex then
        spr(spriteIndex, x, y,0)
    end
end--drawLetter

function drawWord(word, startX, startY)
    local letterSpacing = 7--es mejor 7 que 8 porque si
    for i = 1, #word do
        local letter = word:sub(i, i)  -- Extrae la letra en la posición i
        drawLetter(letter, startX + (i - 1) * letterSpacing, startY)  -- Dibuja cada letra con un desplazamiento en X
    end
end--drawWord