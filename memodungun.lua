-- Variables globales para el ancho y alto de las cartas
w = 66
h=10

-- Función TIC-80 para dibujar en pantalla y gestionar la lógica
function TIC()
    cls(0)  -- Limpia la pantalla con el color negro
    map(0,0,30,17)
    t = time()//10
				-- Iniciar la música del track 0 al iniciar el juego
				if t == 0 then
 				music(0)
    end
    -- Dibujar el tablero de memorama
    dibujarMemorama()

    -- Detección de clic
    manejarClick()

    -- Verificar si las cartas seleccionadas hacen un par
    verificarPares()
				moveSelection()
    -- Mostrar mensaje si el jugador ha encontrado todos los pares
    if matchesFound == 5 then
        print("¡Ganaste! Encontraste todos los pares.", 20, 100, 12)
    end
end

-- Definición de los meses
months = {
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

-- Función para seleccionar 5 pares únicos al azar
function seleccionarPares(meses, num_pares)
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

-- Función para mezclar las cartas
function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- Función para dibujar el memorama
function dibujarMemorama()
    for i, card in ipairs(memorama) do
        local x = loc[i].x
        local y = loc[i].y
        
        -- Mostrar carta si está volteada o emparejada
        if card.flipped or card.matched then
        				drawWord(card.text, x, y)
        else
            rect(x-2, y-2, w, h, 2)  -- Dibuja el reverso de la carta con ancho w y alto h
        end
    end
end

-- Función para manejar el clic del ratón
function manejarClick()
	 local mx, my, left, right = mouse()
    if left  then
        local mx, my = mouse()
        
        for i, card in ipairs(memorama) do
            local x = loc[i].x
            local y = loc[i].y
            
            -- Verificar si se hace clic en una carta
            if mx > x and mx < x + w and my > y and my < y + h then
                -- Asegurarse de que la carta no esté ya emparejada
                if not card.matched then
                    if not firstCard then
                        firstCard = card
                    elseif not secondCard and card ~= firstCard then
                        secondCard = card
                    end
                    card.flipped = true
                end
                break
            end
        end
    end
end

-- Función para verificar si las cartas seleccionadas hacen un par
function verificarPares()
    if firstCard and secondCard then
        if firstCard.match == secondCard.text then
            matchesFound = matchesFound + 1
            -- Marcar las cartas como emparejadas
            firstCard.matched = true
            secondCard.matched = true
        else
            firstCard.flipped = false
            secondCard.flipped = false
        end
        firstCard, secondCard = nil, nil
    end
end

-- Inicialización
memorama = {}
local paresSeleccionados = seleccionarPares(months, 5)
for _, par in ipairs(paresSeleccionados) do
    table.insert(memorama, {text = par.spanish, match = par.mapudungun, flipped = false, matched = false})
    table.insert(memorama, {text = par.mapudungun, match = par.spanish, flipped = false, matched = false})
end
shuffle(memorama)

-- Definición de las posiciones de las cartas (sin w y h)
loc = {
    {x = 73, y = 17},
    {x = 161, y = 17},
    {x = 73, y = 41},
    {x = 161, y = 41},
    {x = 73, y = 65},
    {x = 161, y = 65},
    {x = 73, y = 89},
    {x = 161, y = 89},
    {x = 73, y = 113},
    {x = 161, y = 113}
}
--VALORES LETRAS
local letterValues = {
    a = 336, b = 337, c = 338, d = 339, e = 340, f = 341,
    g = 342, h = 343, i = 344, j = 345, k = 346, l = 347,
    m = 348, n = 349, o = 350, p = 351, q = 352, r = 353,
    s = 354, t = 355, u = 356, v = 357, w = 358, x = 359,
    y = 360, z = 361, N = 362, U = 363
}--VALORES LETRAS


function moveSelection()
    -- Obtener posición del mouse
    x, y, left, middle, right, scrollX, scrollY = mouse()
    
    -- Mostrar posición del cursor
    print("Posicion del mouse: ("..x..", "..y..")", 10, 10, 12)
    
    -- Comprobaciones específicas para cada ubicación en `loc` con los ajustes solicitados
    if (x > loc[1].x - 10 and x < loc[1].x + w + 5) and (y > loc[1].y - 10 and y < loc[1].y + h + 5) then
        rectb(loc[1].x - 10, loc[1].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[2].x - 10 and x < loc[2].x + w + 5) and (y > loc[2].y - 10 and y < loc[2].y + h + 5) then
        rectb(loc[2].x - 10, loc[2].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[3].x - 10 and x < loc[3].x + w + 5) and (y > loc[3].y - 10 and y < loc[3].y + h + 5) then
        rectb(loc[3].x - 10, loc[3].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[4].x - 10 and x < loc[4].x + w + 5) and (y > loc[4].y - 10 and y < loc[4].y + h + 5) then
        rectb(loc[4].x - 10, loc[4].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[5].x - 10 and x < loc[5].x + w + 5) and (y > loc[5].y - 10 and y < loc[5].y + h + 5) then
        rectb(loc[5].x - 10, loc[5].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[6].x - 10 and x < loc[6].x + w + 5) and (y > loc[6].y - 10 and y < loc[6].y + h + 5) then
        rectb(loc[6].x - 10, loc[6].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[7].x - 10 and x < loc[7].x + w + 5) and (y > loc[7].y - 10 and y < loc[7].y + h + 5) then
        rectb(loc[7].x - 10, loc[7].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[8].x - 10 and x < loc[8].x + w + 5) and (y > loc[8].y - 10 and y < loc[8].y + h + 5) then
        rectb(loc[8].x - 10, loc[8].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[9].x - 10 and x < loc[9].x + w + 5) and (y > loc[9].y - 10 and y < loc[9].y + h + 5) then
        rectb(loc[9].x - 10, loc[9].y - 10, w + 15, h + 15, 12)
    elseif (x > loc[10].x - 10 and x < loc[10].x + w + 5) and (y > loc[10].y - 10 and y < loc[10].y + h + 5) then
        rectb(loc[10].x - 10, loc[10].y - 10, w + 15, h + 15, 12)
    end
end

function drawLetter(letter, x, y)
    local spriteIndex = letterValues[letter]
    if spriteIndex then
        spr(spriteIndex, x, y,0)
    end
end--drawLetter

function drawWord(word, startX, startY)
    local letterSpacing = 6--es mejor 7 que 8 porque si
    for i = 1, #word do
        local letter = word:sub(i, i)  -- Extrae la letra en la posición i
        drawLetter(letter, startX + (i - 1) * letterSpacing, startY)  -- Dibuja cada letra con un desplazamiento en X
    end
end--drawWord


-- Variables de control
firstCard, secondCard = nil, nil
matchesFound = 0
