-- Variables globales para el ancho y alto de las cartas
w = 66
h = 10
-- Variables para la posición del personaje
px, py = 110, 26  -- Posición inicial del personaje

-- Posiciones relativas de los ojos desde la posición del personaje
eye_offset_x_left, eye_offset_y = 4, 5  -- Posición del ojo izquierdo
eye_offset_x_right = 14  -- Posición del ojo derecho
eye_distance_x = 2  -- Desplazamiento máximo horizontal de la pupila
eye_distance_y = 1  -- Desplazamiento máximo vertical de la pupila

-- Función para dibujar las pupilas mirando hacia el cursor
function dibujarOjos(px, py, angle)
    -- Calcular el desplazamiento de las pupilas en la dirección del cursor
    local eye_x_offset = math.cos(angle) * eye_distance_x
    local eye_y_offset = math.sin(angle) * eye_distance_y

    -- Dibujar el punto del ojo izquierdo
    pix(px + eye_offset_x_left + eye_x_offset, py + eye_offset_y + eye_y_offset, 0)  
    -- Dibujar el punto del ojo derecho
    pix(px + eye_offset_x_right + eye_x_offset, py + eye_offset_y + eye_y_offset, 0)  
end

function TIC()
    cls(0)  -- Limpia la pantalla
    map(0, 0, 30, 17)  -- Dibuja el mapa
    
    if not musicStarted then
        music(0)  -- Reproduce la música en el track 0
        musicStarted = true
    end

    -- Obtener la posición del mouse
    local mx, my, left, middle, right = mouse()

    -- Calcular el ángulo hacia el mouse
    local angle = math.atan2(my - py, mx - px)

    -- Dibujar el personaje (ajusta `spr` para la posición actual)
    spr(255, px, py, 0)  -- El sprite No. 255 es un sprite vacio

    -- Llamar a la función para dibujar los ojos mirando hacia el cursor
    dibujarOjos(px, py, angle)

    -- Otros elementos del juego
    dibujarMemorama()
    manejarClick()
    verificarPares()

    -- Mostrar mensaje si el jugador ha encontrado todos los pares
    if matchesFound == 5 then
        cls(0)
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

-- Definición de las posiciones de las cartas
loc = {
    {x = 17, y = 17},
    {x = 161, y = 17},
    {x = 17, y = 41},
    {x = 161, y = 41},
    {x = 17, y = 65},
    {x = 161, y = 65},
    {x = 17, y = 89},
    {x = 161, y = 89},
    {x = 17, y = 113},
    {x = 161, y = 113}
}

-- Valores de letras
local letterValues = {
    a = 336, b = 337, c = 338, d = 339, e = 340, f = 341,
    g = 342, h = 343, i = 344, j = 345, k = 346, l = 347,
    m = 348, n = 349, o = 350, p = 351, q = 352, r = 353,
    s = 354, t = 355, u = 356, v = 357, w = 358, x = 359,
    y = 360, z = 361, N = 362, U = 363
}

function drawLetter(letter, x, y)
    local spriteIndex = letterValues[letter]
    if spriteIndex then
        spr(spriteIndex, x, y, 0)
    end
end

function drawWord(word, startX, startY)
    local letterSpacing = 6
    for i = 1, #word do
        local letter = word:sub(i, i)  -- Extrae la letra en la posición i
        drawLetter(letter, startX + (i - 1) * letterSpacing, startY)  -- Dibuja cada letra con un desplazamiento en X
    end
end

-- Variables de control
firstCard, secondCard = nil, nil
matchesFound = 0
