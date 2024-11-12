-- Definicion de los meses
local months = {
    {spanish = "enero", mapudungun = "eneru"},
    {spanish = "febrero", mapudungun = "fewreru"},
    {spanish = "marzo", mapudungun = "marsu"},
    {spanish = "abril", mapudungun = "afril"},
    {spanish = "mayo", mapudungun = "mayu"},
    {spanish = "junio", mapudungun = "kuniu"},
    {spanish = "julio", mapudungun = "kuliu"},
    {spanish = "agosto", mapudungun = "akostu"},
    {spanish = "septiembre", mapudungun = "setiempUre"},
    {spanish = "octubre", mapudungun = "oktufUre"},
    {spanish = "noviembre", mapudungun = "nofiempUre"},
    {spanish = "diciembre", mapudungun = "disempUre"}
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
	{x = 72, y = 16, bx = 64, by = 8,  w=87, h=23}, 	
	{x = 161,y = 16 , w=87, h=23},	
	{x = 72, y = 40,  w=87, h=23}, 	
	{x = 161,y = 40 , w=87, h=23},
	{x = 72, y = 64,  w=87, h=23}, 	
	{x = 161,y = 64 , w=87, h=23},
	{x = 72, y = 88,  w=87, h=23}, 	
	{x = 161,y = 88 , w=87, h=23},
	{x = 72, y = 112, w=87, h=23},	 
	{x = 161,y = 112, w=87, h=23},
}--posiciones iniciales de las 10 palabras

--Ancho y Alto de los cuadraos
w = 67
h=11


-- Función para seleccionar 5 pares únicos al azar
local function seleccionar_pares(meses, num_pares)
    local pares = {}
    local indices_usados = {}
    
    while #pares < num_pares do
        local indice = math.random(#meses)
        if not indices_usados[indice] then
            table.insert(pares, meses[indice])
            indices_usados[indice] = true
        end
    end
    
    return pares
end

-- Crear una lista de pares duplicados y mezclarlos
local memorama = {}
local pares_seleccionados = seleccionar_pares(months, 5)
for _, par in ipairs(pares_seleccionados) do
    table.insert(memorama, {text = par.spanish, match = par.mapudungun, flipped = false})
    table.insert(memorama, {text = par.mapudungun, match = par.spanish, flipped = false})
end

-- Función para mezclar las cartas
local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- Mezclar el tablero
shuffle(memorama)

-- Variables de control
local firstCard, secondCard = nil, nil
local matchesFound = 0

-- Función TIC-80 para dibujar en pantalla y gestionar la lógica
function TIC()
    cls(0)  -- Limpia la pantalla con el color negro
    map(0,0,30,17)
    t = time()//10
				-- Iniciar la música del track 0 al iniciar el juego
				if t == 0 then
 				music(0)
    end
				drawTable()
   	clickDetection()
				moveSelection()
end


function drawLetter(letter, x, y)
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



function moveSelection()
		x, y, left, middle, right, scrollX, scrollY = mouse()
  -- Mostrar posición del cursor
  print("Posicion del mouse: ("..x..", "..y..")", 10, 10, 12+t%60//20)
  if (x > loc[1].bx and x< loc[1].bx + w) and (y>loc[1].by and y<loc[1].by+h) then
			rectb(loc[1].bx,loc[1].by,w,h,12+t%60//20) 	
  end

end


function drawTable()
	local x = 1
	local y = 1
	for i, card in ipairs(memorama) do
		-- Mostrar carta si está volteada
		if card.flipped or card == firstCard or card == secondCard then
			drawWord(card.text,loc[x].x,loc[y].y, 12)
			--print(card.text, x, y, 12)
		else
			rect(loc[x].x,loc[y].y, w-3, h-3, 9)  -- Dibuja el reverso de la carta
		end
		x = x+1
		y = y+1
 end
end


function clickDetection()
	-- Detección de clic
	local mx,my, left, middle, right, scrollX, scrollY = mouse()
 if left then
  local x = 1
  local y = 1
  for i, card in ipairs(memorama) do            
   -- Verificar si se hace clic en una carta
   if mx > loc[x].x and mx < loc[x].x + 40 and my > loc[y].y and my < loc[y].y + 20 then
    if not firstCard then
     firstCard = card
    elseif not secondCard and card ~= firstCard then
     secondCard = card
  		end              
				card.flipped = true
   	break
  	end
 	 x = x+1
  	y = y+1
 	end
	end
end


function cardsCheck()
	-- Verificar si las cartas seleccionadas hacen un par
 if firstCard and secondCard then
 	if firstCard.match == secondCard.text then
			matchesFound = matchesFound + 1
		else
			firstCard.flipped = false
			secondCard.flipped = false
		end
		firstCard, secondCard = nil, nil
	end
	-- Mostrar mensaje si el jugador ha encontrado todos los pares
	if matchesFound == 5 then
		print("¡Ganaste! Encontraste todos los pares.", 20, 100, 12)
	end
end