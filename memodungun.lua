    -- Estado del juego
    local estado = "intro"  -- Estados posibles: "menu", "intro", "nivel1", "nivel2", et

    -- Tabla para almacenar los niveles
    local niveles = {}

    totalScore = 0  -- Puntaje acumulado global


    local last_click_time = 0  -- Para llevar un control del último clic
    local click_delay = 300  -- Número de ciclos entre clics para evitar que se registre demasiado rápido
    mx, my, left, middle, right = mouse()
    px, py = 110, 26
    angle = math.atan2(my - py, mx - px)


    -- Funcion para cambiar de nivel
    function cambiarNivel(nuevoNivel)
        musicStarted=false
        if niveles[nuevoNivel] then
            estado = nuevoNivel
            niveles[nuevoNivel].inicializar()  -- Llama a la función de inicialización del nivel
        else
            print("El nivel no existe: " .. nuevoNivel)
        end
    end

    ------------- Menu principal
    function dibujarMenu(nivel)
        inicial_x = 70
        inicial_y = 65 
        
        print("Nivel seleccionado",inicial_x, inicial_y, 12)
        puntos_x = inicial_x + 25
        puntos_y = inicial_y + 10
        spr(381, puntos_x, puntos_y, 0)
        spr(381, puntos_x, puntos_y+8, 0, 1, 2)
        
        
        print(opcion_seleccionada, puntos_x+18, puntos_y, 12,false, 3)

        spr(381, puntos_x+40, puntos_y, 0, 1, 1)
        spr(381, puntos_x+40, puntos_y+8, 0, 1, 3) 
        
        rectb(inicial_x-13,inicial_y+38,120,20,14)
        print("INICIAR", inicial_x-10, inicial_y+40,12, false, 3)
        x, y, left, middle, right, scrollX, scrollY = mouse()
        --print("Posicion del mouse: ("..x..", "..y..")", 10, 10, 12+t%60//20)
        if left and (time() - last_click_time > click_delay) then
            last_click_time = time()  -- Actualizamos el tiempo del último clic
            if (x >= 95 and x <= 103) and (y >= 75 and y <= 96) then
                if left then
                    opcion_seleccionada = opcion_seleccionada - 1
                    if opcion_seleccionada == 0 then
                        opcion_seleccionada = 4
                    end
                end
            end

            if (x >= 135 and x <= 143) and (y >= 75 and y <= 96) then
                if left then
                    opcion_seleccionada = opcion_seleccionada + 1
                    if opcion_seleccionada == 5 then
                        opcion_seleccionada = 1
                    end
                end
            end
        end
        
    end

    function actualizarMenu(opcion_seleccionada)
        x, y, left, middle, right, scrollX, scrollY = mouse()
        if (x > 57 and x < 176) and (y > 98 and y < 117) then
            rect(inicial_x-13,inicial_y+38,120,20,14+t%60//10)
            print("INICIAR", inicial_x-10, inicial_y+40,12, false, 3)
            if left then
                if opcion_seleccionada == 1 then
                    cambiarNivel("nivel1") 
                elseif opcion_seleccionada == 2 then
                    cambiarNivel("nivel2")
                elseif opcion_seleccionada == 3  then
                    cambiarNivel("nivel3")
                elseif opcion_seleccionada == 4 then
                    cambiarNivel("nivel4")
                elseif opcion_seleccionada == 0 then
                    cambiarNivel("intro")
                elseif opcion_seleccionada == 5 then
                    cambiarNivel("creditos")
                end
            end
        else
            rect(inicial_x-13,inicial_y+38,120,20,14)
            print("INICIAR", inicial_x-10, inicial_y+40,12, false, 3)
        end
        
    

    end
    ------------ Menu principal



    -- Variables globales para el ancho y alto de las cartas
    w = 66
    h = 10
    -- Variables para la posición del personaje
    px, py = 110, 26  -- Posición inicial del personaje

    -- Variables para la musica
    musicStarted = false
    mostrarHistoria = true  -- Controla si se muestra la historia
    texto_mostrado = ""  -- Texto que se muestra en pantalla

    -- Historia del juego
    local historia = { 
        "_n un tiempo de oscuridad un ",
        "joven guerrero llamado KallfU,", 
        "se encuentra atrapado en el caosZ", 
        "",
        "Hn ataque a su aldea lo lleva a ", 
        "huirB perdiEndose dentro de aquel",
        "profundo bosqueZZZ", 
        "",
        "Pero en la oscuridad encuentra un", 
        "refugioZ Hna cuevaZ", 
        "",
        "DentroB una anciana lo esperaZ", 
        "La MachiB sanadora y protectora", 
        "de espIritusZ", 
        "",
        "_l portal ha sido abiertoZZZ", 
        "dice ellaZ", 
        "",
        "Tu misiOn estA escrita en las ", 
        "estrellasZ KallfU recibe un ",
        "amuletoZZZ el PUllUZ", 
        "Hn artefacto mIstico con un" ,
        "propOsitoZZZ", 
        "",
        "G travEs del portal,enfrentarAs", 
        "pruebas que desafiarAn su mente",
        "y espIrituZ", 
        "",
        "Los pilares de su cultura deben",
        "renacerZ", 
        "",
        "numerosZZZ",
        "",
        "coloresZZZ",
        "",
        "ciclos del tiempoZZZ", 
        "",
        "y cuando todo parezca perdidoZZZ", 
        "",
        "recordarAs quiEn eres",
        "",
        "y de dOnde",
        "",
        "vienesZZZ\""
    }

    local linea_actual = 1
    local char_index = 0
    local tiempo = 0
    local velocidad = 5  -- Velocidad de la escritura

    local texto_mostrado_lines = {}  -- Almacena las líneas de texto mostradas
    local scroll_speed = 1  -- Velocidad del scroll (aumenta para mover más rápido)
    local max_lines = 5  -- Número máximo de líneas visibles
    local opening_x = 80
    local opening_y = 50
    local direction = 1
    local skin = 9

    function volverMenu()
        
        mx, my, left, middle, right = mouse()
        if (mx>=225 and mx < 235) and (my>=5 and my <=14) then
            if left then
                cambiarNivel("menu")
            end
        end
        
        rect(225,5,10,10,14+t%60//10)      

        spr(47, 226, 6)  
    end

    function volverNivel()
        
        mx, my, left, middle, right = mouse()
        if (mx>=225 and mx < 235) and (my>=5 and my <=14) then
            if left then
                cambiarNivel("nivel1")
            end
        end
        
        rect(225,5,10,10,14+t%60//10)      

        spr(175, 226, 6)  
    end

    function revisarGlosario()
        
        mx, my, left, middle, right = mouse()
        if (mx>=5 and mx < 15) and (my>=5 and my <=14) then
            if left then
                cambiarNivel("glosario")
            end
        end
        
        rect(5,5,10,10,14+t%60//10)      

        spr(63, 6, 6)  
    end

    

    function siguienteNivel(nivelActual)
        mx, my, left, middle, right = mouse()
        --print("Posicion del mouse: ("..mx..", "..my..")", 10, 10, 12+t%60//20)
        rect(115,66,27,35,3+t%60//20)    
        spr(381, 120, 70, 0, 2, 1)
        spr(381, 120, 82, 0, 2, 3)  
        print("Siguiente Nivel", 40, 50,12, false, 2)
        if (mx>=115 and mx < 141) and (my>=66 and my <=101) then
            if left then
                if nivelActual == 1 then
                    cambiarNivel("nivel2")
                elseif nivelActual == 2 then
                    cambiarNivel("nivel3")
                elseif nivelActual == 3 then
                    cambiarNivel("nivel4")
                elseif nivelActual == 4 then
                    cambiarNivel("creditos")
                end
            end
        end
        
    end

    -- Función para dibujar la historia del juego con escritura letra por letra
    function dibujarHistoria()
        map(0, 119, 30, 135)
        rect(180,40,37,8,14+t%60//10)
       
        print("SALTAR", 181, 41,12, false, 1)
        mx, my, left, middle, right = mouse()
        if (mx>=180 and mx < 215) and (my>=40 and my <=50) then
            if left then
                    mostrarHistoria = false
            end
        end
        --print("Posicion del mouse: ("..mx..", "..my..")", 10, 10, 12+t%60//20)
        -- Incrementa el contador de tiempo
        tiempo = tiempo + 1

        -- Controla la velocidad de escritura
        if tiempo % velocidad == 0 then
            if linea_actual <= #historia then
                local linea = historia[linea_actual]
                if char_index < #linea then
                    -- Agrega el siguiente carácter al texto mostrado
                    char_index = char_index + 1
                    texto_mostrado = linea:sub(1, char_index)
                    sfx(63, "D-3", 10, 0, 5)  -- Efecto de sonido por cada letra
                else
                    -- Cuando se termine una línea, la agregamos al array de líneas mostradas
                    table.insert(texto_mostrado_lines, texto_mostrado)
                    -- Limitar el número de líneas visibles en pantalla
                    if #texto_mostrado_lines > max_lines then
                        table.remove(texto_mostrado_lines, 1)  -- Elimina la primera línea (scroll)
                    end
                    -- Pasa a la siguiente línea
                    linea_actual = linea_actual + 1
                    char_index = 0
                    texto_mostrado = ""  -- Resetea el texto temporal
                end
            else
                mostrarHistoria = false  -- Historia finalizada
            end
        end

        -- Dibujar las líneas de texto ya mostradas (scroll)
        local y_offset = 70  -- Desplazamiento vertical inicial
        for i = 1, #texto_mostrado_lines do
            drawWord(texto_mostrado_lines[i], 17, y_offset)
            y_offset = y_offset + 8  -- Aumenta el desplazamiento vertical para la siguiente línea
        end
        
        -- Dibujar la línea actual
        if mostrarHistoria then
            drawWord(texto_mostrado,17,y_offset)
            
            if opening_x <= 80 then
                direction = 1
                skin = 9
            elseif opening_x >= 120 then 
                direction = -1
                skin = 26
            end
            opening_x = opening_x + (t%60//20)/10*direction
            spr(skin+t%60//20, opening_x,opening_y, 0)
            spr(25, 130,40,0,2)--cueva
            spr(40+t%60//20, 130, 17 , 0, 2)--luna
            spr(57+t%60//20, 110, 20 , 0)--estrellas
            spr(57+t%60//20, 100, 30 , 0,1,2)--estrellas
            spr(57+t%60//20, 90, 15 , 0, 1, 3)--estrellas
        end
    end
    -- Posiciones relativas de los ojos desde la posición del personaje
    eye_offset_x_left, eye_offset_y = 4, 5  
    eye_offset_x_right = 14  
    eye_distance_x = 2  
    eye_distance_y = 1  

    -- Variables para el parpadeo
    local blink_timer = 0        -- Contador para el parpadeo
    local blink_duration = 10    -- Duración del parpadeo (en frames)
    local blink_interval = 120   -- Intervalo entre parpadeos (en frames)
    local is_blinking = false    -- Estado de parpadeo

    -- Función para dibujar los ojos (abiertos o cerrados)
    function dibujarOjos(px, py, angle)
        if is_blinking then
            -- Dibujar ojos cerrados
            line(px-2 + eye_offset_x_left, py + eye_offset_y, px + eye_offset_x_left + 1, py + eye_offset_y, 3)
            line(px-2 + eye_offset_x_right, py + eye_offset_y, px + eye_offset_x_right + 1, py + eye_offset_y, 3)

            line(px-3 + eye_offset_x_left, py + eye_offset_y - 1, px + eye_offset_x_left + 2, py + eye_offset_y - 1, 3)
            line(px-3 + eye_offset_x_right, py + eye_offset_y - 1, px + eye_offset_x_right + 2, py + eye_offset_y - 1, 3)

        else
            -- Calcular el desplazamiento de las pupilas en la dirección del cursor
            local eye_x_offset = math.cos(angle) * eye_distance_x
            local eye_y_offset = math.sin(angle) * eye_distance_y

            -- Dibujar el punto del ojo izquierdo
            pix(px + eye_offset_x_left + eye_x_offset, py + eye_offset_y + eye_y_offset, 0)
            -- Dibujar el punto del ojo derecho
            pix(px + eye_offset_x_right + eye_x_offset, py + eye_offset_y + eye_y_offset, 0)
        end
    end

    -- Actualizar el estado del parpadeo
    function actualizarParpadeo()
        blink_timer = blink_timer + 1
        if is_blinking then
            if blink_timer >= blink_duration then
                is_blinking = false
                blink_timer = 0
            end
        else
            if blink_timer >= blink_interval then
                is_blinking = true
                blink_timer = 0
            end
        end
    end

    function TIC()
        --cls(0)
        t = time()//10
        niveles[estado].actualizar()
        niveles[estado].dibujar()
    end

    -- Definicion de los meses
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

    dias_semana = {
        {spanish = "lunes", mapudungun = "pANi"},
        {spanish = "martes", mapudungun = "afilUl"},
        {spanish = "miercoles", mapudungun = "wenU"},
        {spanish = "jueves", mapudungun = "trengUn"},
        {spanish = "viernes", mapudungun = "antU"},
        {spanish = "sabado", mapudungun = "NamUn"},
        {spanish = "domingo", mapudungun = "kUnUn"}
    }

    colors = {
        {spanish = "rojo", mapudungun = "kelU"},
        {spanish = "negro", mapudungun = "kurU"},
        {spanish = "morado", mapudungun = "koNoll"},
        {spanish = "verde", mapudungun = "karU"},
        {spanish = "gris", mapudungun = "kadU"},
        {spanish = "azul", mapudungun = "kallfU"},
        {spanish = "amarillo", mapudungun = "lig"},
        {spanish = "blanco", mapudungun = "kollU"},
        {spanish = "marron", mapudungun = "kelUchod"},
        {spanish = "naranja", mapudungun = "chod"},
        {spanish = "rosado", mapudungun = "rosaw"},
        {spanish = "beige", mapudungun = "kollU"}
    }

    numbers = {
        {spanish = "uno", mapudungun = "kiNe"},
        {spanish = "dos", mapudungun = "epu"},
        {spanish = "tres", mapudungun = "kUla"},
        {spanish = "cuatro", mapudungun = "meli"},
        {spanish = "cinco", mapudungun = "kechu"},
        {spanish = "seis", mapudungun = "kayu"},
        {spanish = "siete", mapudungun = "regle"},
        {spanish = "ocho", mapudungun = "pura"},
        {spanish = "nueve", mapudungun = "aylla"},
        {spanish = "diez", mapudungun = "mari"},
        {spanish = "once", mapudungun = "mari kiNe"},
        {spanish = "doce", mapudungun = "mari epu"},
        {spanish = "trece", mapudungun = "mari küla"},
        {spanish = "catorce", mapudungun = "mari meli"},
        {spanish = "quince", mapudungun = "mari kechu"},
        {spanish = "diecisEis", mapudungun = "mari kayu"},
        {spanish = "diecisiete", mapudungun = "mari regle"},
        {spanish = "dieciocho", mapudungun = "mari pura"},
        {spanish = "diecinueve", mapudungun = "mari aylla"},
        {spanish = "veinte", mapudungun = "epu mari"}
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

    -- Funcion para dibujar el memorama
    function dibujarMemorama(memorize)
        for i, card in ipairs(memorize) do
            local x = loc[i].x
            local y = loc[i].y
            
            -- Mostrar carta si esat volteada o emparejada
            if card.flipped or card.matched then
                drawWord(card.text, x, y)
            else
                rect(x-2, y-2, w, h, 2)  -- Dibuja el reverso de la carta con ancho w y alto h
            end
        end
    end

    -- Función para manejar el clic del ratón
    function manejarClick(memorize)
        local mx, my, left, right = mouse()
        if left  then
            for i, card in ipairs(memorize) do
                local x = loc[i].x
                local y = loc[i].y
                
                -- Verificar si se hace clic en una carta
                if mx+5 > x and mx < x + w and my > y-5 and my < y + h then
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

    function verificarPares()
        if firstCard and secondCard then
            attempts = attempts + 1
            if firstCard.match == secondCard.text then
                matchesFound = matchesFound + 1
                firstCard.matched = true
                secondCard.matched = true
                score = score + 10 + (streak * 5)  -- Puntaje local del nivel
                totalScore = totalScore + 10 + (streak * 5)  -- Actualiza el puntaje global
                streak = streak + 1
            else
                firstCard.flipped = false
                secondCard.flipped = false      

            -- Disminuir el puntaje por error
            if score > 0 then
                score = score - 2
            end
            if totalScore > 0 then
                totalScore = totalScore - 2
            end

            -- Asegurarse de que los puntajes no sean negativos
            if score < 0 then
                score = 0
            end
            if totalScore < 0 then
                totalScore = 0
            end

                streak = 0 -- Racha de aciertos
            end
            firstCard, secondCard = nil, nil
        end
    end    

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
        y = 360, z = 361, N = 362, U = 363, I = 364, E = 365,
        O = 366, A = 367, K = 368, _ = 370, Z = 371, B = 372,
        L = 373, M = 374, C = 375, P = 376, S = 377, T = 378,
        D = 379, G = 380, H = 369,
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

    function changeColors(nivel)
        if nivel ==1 then
            local color_10 = {0xB1, 0x3E, 0x53}
            -- Nuevo color 11 (índice 10): #ef7d57
            local color_11 = {0xEF, 0x7D, 0x57}
            -- Nuevo color 12 (índice 11): #ffcd75
            local color_12 = {0xFF, 0xCD, 0x75}
            
            -- Dirección base para los colores 10, 11 y 12
            local palette_start = 0x3FC0
            
            -- Sobrescribir los valores RGB de los colores 10, 11 y 12
            -- Color 10 (índice 9) - memoria 0x3FCC, 0x3FCD, 0x3FCE
            poke(palette_start + 3 * 9, color_10[1])  -- Rojo
            poke(palette_start + 3 * 9 + 1, color_10[2])  -- Verde
            poke(palette_start + 3 * 9 + 2, color_10[3])  -- Azul
            
            -- Color 11 (índice 10) - memoria 0x3FCF, 0x3FD0, 0x3FD1
            poke(palette_start + 3 * 10, color_11[1])  -- Rojo
            poke(palette_start + 3 * 10 + 1, color_11[2])  -- Verde
            poke(palette_start + 3 * 10 + 2, color_11[3])  -- Azul
            
            -- Color 12 (índice 11) - memoria 0x3FD2, 0x3FD3, 0x3FD4
            poke(palette_start + 3 * 11, color_12[1])  -- Rojo
            poke(palette_start + 3 * 11 + 1, color_12[2])  -- Verde
            poke(palette_start + 3 * 11 + 2, color_12[3])  -- Azul
        end
        if nivel ==2 then
            -- Nuevos colores
            local color_10 = {0x25, 0x71, 0x79}  -- #257179
            local color_11 = {0x38, 0xB7, 0x64}  -- #38b764
            local color_12 = {0xA7, 0xF0, 0x70}  -- #a7f070
            
            -- Dirección base para los colores 10, 11 y 12
            local palette_start = 0x3FC0
            
            -- Sobrescribir los valores RGB de los colores 10, 11 y 12
            -- Color 10 (índice 9) - memoria 0x3FCC, 0x3FCD, 0x3FCE
            poke(palette_start + 3 * 9, color_10[1])  -- Rojo
            poke(palette_start + 3 * 9 + 1, color_10[2])  -- Verde
            poke(palette_start + 3 * 9 + 2, color_10[3])  -- Azul
            
            -- Color 11 (índice 10) - memoria 0x3FCF, 0x3FD0, 0x3FD1
            poke(palette_start + 3 * 10, color_11[1])  -- Rojo
            poke(palette_start + 3 * 10 + 1, color_11[2])  -- Verde
            poke(palette_start + 3 * 10 + 2, color_11[3])  -- Azul
            
            -- Color 12 (índice 11) - memoria 0x3FD2, 0x3FD3, 0x3FD4
            poke(palette_start + 3 * 11, color_12[1])  -- Rojo
            poke(palette_start + 3 * 11 + 1, color_12[2])  -- Verde
            poke(palette_start + 3 * 11 + 2, color_12[3])  -- Azul
        end

        if nivel ==4 then
            local color_10 = {0x33, 0x3C, 0x57}  -- #333c57
            local color_11 = {0x56, 0x6C, 0x86}  -- #566c86
            local color_12 = {0x94, 0xB0, 0xC2}  -- #94b0c2
            
            -- Dirección base para los colores 10, 11 y 12
            local palette_start = 0x3FC0
            
            -- Sobrescribir los valores RGB de los colores 10, 11 y 12
            -- Color 10 (índice 9) - memoria 0x3FCC, 0x3FCD, 0x3FCE
            poke(palette_start + 3 * 9, color_10[1])  -- Rojo
            poke(palette_start + 3 * 9 + 1, color_10[2])  -- Verde
            poke(palette_start + 3 * 9 + 2, color_10[3])  -- Azul
            
            -- Color 11 (índice 10) - memoria 0x3FCF, 0x3FD0, 0x3FD1
            poke(palette_start + 3 * 10, color_11[1])  -- Rojo
            poke(palette_start + 3 * 10 + 1, color_11[2])  -- Verde
            poke(palette_start + 3 * 10 + 2, color_11[3])  -- Azul
            
            -- Color 12 (índice 11) - memoria 0x3FD2, 0x3FD3, 0x3FD4
            poke(palette_start + 3 * 11, color_12[1])  -- Rojo
            poke(palette_start + 3 * 11 + 1, color_12[2])  -- Verde
            poke(palette_start + 3 * 11 + 2, color_12[3])  -- Azul
        end
    end

    niveles["intro"] = {
        inicializar = function()   
            
            mostrarHistoria = true
            texto_mostrado = ""
            linea_actual = 1
            char_index = 0
            tiempo = 0
            velocidad = 5
            texto_mostrado_lines={}
        end,
        actualizar = function()
            if mostrarHistoria then
                dibujarHistoria()
                if not musicStarted then
                    music(2)  -- Reproduce la música en el track 0
                    musicStarted = true
                end
                if btnp(4) then
                    if velocidad == 5 then
                        velocidad = 1
                    else
                        velocidad = 5
                    end
                end
                if btnp(5) then
                    mostrarHistoria = false
                end
            else
                musicStarted = false
                music(-1) 
                cambiarNivel("menu")
                
            end
        end,
        dibujar = function()
            
            cls(0)
            if mostrarHistoria then
                dibujarHistoria()
            end
        end
    }

    -- Define el nivel 1
    niveles["nivel1"] = {
        inicializar = function()
            changeColors(1)
            memorama = {}
            local paresSeleccionados = seleccionarPares(months, 5)
            for _, par in ipairs(paresSeleccionados) do
                table.insert(memorama, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})  -- Todas las cartas reveladas inicialmente
                table.insert(memorama, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
            end
            shuffle(memorama)
            matchesFound = 0
            firstCard, secondCard = nil, nil

            score = 0
            streak = 0
            attempts = 0
            revealTimer = 120  -- 2 segundos de revelación
        end,
        actualizar = function()
            if not musicStarted then
                music(0)  -- Reproduce la música en el track 0
                musicStarted = true
            end
    
            if revealTimer > 0 then
                revealTimer = revealTimer - 1
                if revealTimer == 0 then
                    for _, carta in ipairs(memorama) do
                        carta.flipped = false  -- Oculta las cartas después del período de revelación
                    end
                end
            else
                mx, my, left, middle, right = mouse()
                angle = math.atan2(my - py, mx - px)
                manejarClick(memorama)  -- Permite al jugador interactuar
                verificarPares()
            end
        end,
        dibujar = function()
            cls(0)
            map(0, 0, 30, 17)  -- Dibujar el mapa
            volverMenu()
            revisarGlosario()
            actualizarParpadeo()
            dibujarOjos(px, py, angle)
            dibujarMemorama(memorama)
    
            -- Mostrar puntaje acumulado 
            print(totalScore, 115, 90, 12)
            print(attempts, 115, 98, 12)

            if streak > 1 then
                print(streak, 115, 113, 12)
            end
    
            -- Mostrar mensaje si el jugador ha encontrado todos los pares
            if matchesFound == 5 then
                cls(0)
                music(-1)
                musicStarted = false
                volverMenu()
                siguienteNivel(1)
                print("¡Ganaste! Encontraste todos los pares.", 20, 110, 12)
                print("\nPuntaje final: " .. totalScore, 20, 120, 12)
                print("Intentos: " .. attempts, 10, 20, 12)
                print("Racha: " .. streak, 10, 30, 12)

            end
        end
    }

    niveles["nivel2"] = {
        inicializar = function()
            changeColors(2)
            memorama2 = {}
            local paresSeleccionados2 = seleccionarPares(dias_semana, 5)
            for _, par in ipairs(paresSeleccionados2) do
                table.insert(memorama2, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                table.insert(memorama2, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
            end
            shuffle(memorama2)      
            matchesFound = 0
            firstCard, secondCard = nil, nil

            score = 0  -- Reinicia el puntaje local
            attempts = 0  -- Contador de intentos
            streak = 0  -- Racha de aciertos consecutivos
            revealTimer = 120  -- 2 segundos de revelación

        end,
        actualizar = function()
            if not musicStarted then
                music(0)  -- Reproduce la música en el track 0
                musicStarted = true
            end
            
            if revealTimer > 0 then
                revealTimer = revealTimer - 1
                if revealTimer == 0 then
                    for _, carta in ipairs(memorama2) do
                        carta.flipped = false  -- Oculta las cartas después del período de revelación
                    end
                end
            else
                mx, my, left, middle, right = mouse()
                angle = math.atan2(my - py, mx - px)
                manejarClick(memorama2)  -- Permite al jugador interactuar
                verificarPares()
            end
        end,
        dibujar = function()
            cls()
            map(0, 0, 30, 17) 
            volverMenu()
            revisarGlosario()
            actualizarParpadeo()
            dibujarOjos(px, py, angle)
            dibujarMemorama(memorama2)
    
            -- Mostrar puntaje acumulado 
            print(totalScore, 115, 90, 12)
            print(attempts, 115, 98, 12)

            if streak > 1 then
                print(streak, 115, 113, 12)
            end
    
            if matchesFound == 5 then
                cls()
                music(-1) 
                musicStarted = false
                siguienteNivel(2)
                print("¡Ganaste! Encontraste todos los pares.", 20, 110, 12)
                print("Puntaje total: " .. totalScore, 20, 120, 12)
                print("Intentos: " .. attempts, 10, 20, 12)
                print("Racha: " .. streak, 10, 30, 12)
            end
        end
    }
    

    niveles["nivel3"] = {
        inicializar = function()
            changeColors(3)
            memorama3 = {}
            local paresSeleccionados3 = seleccionarPares(colors, 5)
            for _, par in ipairs(paresSeleccionados3) do
                table.insert(memorama3, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                table.insert(memorama3, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
            end
            shuffle(memorama3)      
            matchesFound = 0
            firstCard, secondCard = nil, nil

            score = 0  -- Reinicia el puntaje local
            attempts = 0  -- Contador de intentos
            streak = 0  -- Racha de aciertos consecutivos
            revealTimer = 120  -- 2 segundos de revelación

        end,
        actualizar = function()
            if not musicStarted then
                music(0)  -- Reproduce la música en el track 0
                musicStarted = true
            end

            if revealTimer > 0 then
                revealTimer = revealTimer - 1
                if revealTimer == 0 then
                    for _, carta in ipairs(memorama3) do
                        carta.flipped = false  -- Oculta las cartas después del período de revelación
                    end
                end
            else
                mx, my, left, middle, right = mouse()
                angle = math.atan2(my - py, mx - px)
                manejarClick(memorama3)  -- Permite al jugador interactuar
                verificarPares()
            end
        end,
        dibujar = function()
            cls(0)
            map(0, 0, 30, 17)  -- Dibujar el mapa
            volverMenu()
            revisarGlosario()
            actualizarParpadeo()
            dibujarOjos(px, py, angle)
            -- Otros elementos del juego
            dibujarMemorama(memorama3)
            
            -- Mostrar puntaje acumulado 
            print(totalScore, 115, 90, 12)
            print(attempts, 115, 98, 12)

            if streak > 1 then
                print(streak, 115, 113, 12)
            end
    
            if matchesFound == 5 then
                cls()
                music(-1) 
                musicStarted = false
                siguienteNivel(3)
                print("¡Ganaste! Encontraste todos los pares.", 20, 110, 12)
                print("Puntaje total: " .. totalScore, 20, 120, 12)
                print("Intentos: " .. attempts, 10, 20, 12)
                print("Racha: " .. streak, 10, 30, 12)
            end
        end
    }

    niveles["nivel4"] = {
        inicializar = function()
            changeColors(4)
            memorama4 = {}
            local paresSeleccionados4 = seleccionarPares(numbers, 5)
            for _, par in ipairs(paresSeleccionados4) do
                table.insert(memorama4, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                table.insert(memorama4, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
            end
            shuffle(memorama4)      
            matchesFound = 0
            firstCard, secondCard = nil, nil

            score = 0  -- Reinicia el puntaje local
            attempts = 0  -- Contador de intentos
            streak = 0  -- Racha de aciertos consecutivos
            revealTimer = 120  -- 2 segundos de revelación

        end,
        actualizar = function()
            if not musicStarted then
                music(0)  -- Reproduce la música en el track 0
                musicStarted = true
            end
            
            if revealTimer > 0 then
                revealTimer = revealTimer - 1
                if revealTimer == 0 then
                    for _, carta in ipairs(memorama4) do
                        carta.flipped = false  -- Oculta las cartas después del período de revelación
                    end
                end
            else
                mx, my, left, middle, right = mouse()
                angle = math.atan2(my - py, mx - px)
                manejarClick(memorama4)  -- Permite al jugador interactuar
                verificarPares()
            end
        end,
        dibujar = function()
            cls(0)
            map(0, 0, 30, 17)  -- Dibujar el mapa
            volverMenu()
            revisarGlosario()
            actualizarParpadeo()
            dibujarOjos(px, py, angle)
            -- Otros elementos del juego
            dibujarMemorama(memorama4)

            -- Mostrar puntaje acumulado 
            print(totalScore, 115, 90, 12)
            print(attempts, 115, 98, 12)

            if streak > 1 then
                print(streak, 115, 113, 12)
            end
    
            -- Mostrar mensaje si el jugador ha encontrado todos los pares
            if matchesFound == 5 then
                cls(0)
                music(-1) 
                musicStarted = false
                siguienteNivel(4)
                print("¡Ganaste! Encontraste todos los pares.", 20, 110, 12)
                print("Puntaje total: " .. totalScore, 20, 120, 12)
                print("Intentos: " .. attempts, 10, 20, 12)
                print("Racha: " .. streak, 10, 30, 12)
                print("Gracias por jugar", 20, 130, 12)
            end
        end
    }

    niveles["glosario"] = {
        inicializar = function()
            -- Puedes agregar aquí cualquier inicialización necesaria para el glosario
        end,
        actualizar = function()
            if not musicStarted then
                music(0)  -- Reproduce la música en el track 0
                musicStarted = true
            end
        end,
        dibujar = function()
            cls(0)  -- Limpia la pantalla con color de fondo 0
            map(0, 85, 30, 100)  -- Dibujar el mapa, si lo necesitas
    
            -- Mostrar el mensaje "Hola Mundo"
            print("Castellano", 30, 40, 7)  -- Dibuja el texto en la pantalla en (60, 60) con color 7 (blanco)
            print("Mapuzungun", 130, 40, 7)  -- Dibuja el texto en la pantalla en (60, 60) con color 7 (blanco)

            volverNivel()  -- Llama la función para dibujar el botón de "volver al nivel"
        end
    }

    niveles["creditos"] = {
        inicializar = function()
            -- Puedes agregar aquí cualquier inicialización necesaria para el glosario
        end,
        actualizar = function()
            if not musicStarted then
                music(0)  -- Reproduce la música en el track 0
                musicStarted = true
            end
        end,
        dibujar = function()
            cls(0)  -- Limpia la pantalla con color de fondo 0
            map(0, 68, 30, 84)  -- Dibujar el mapa, si lo necesitas
    
            -- Mostrar el mensaje "Hola Mundo"
            print("Hola mi gente", 60, 60, 7)  -- Dibuja el texto en la pantalla en (60, 60) con color 7 (blanco)
            
            volverMenu()  -- Llama la función para dibujar el botón de "volver al menú"
        end
    }

    niveles["lenguaje"] = {
        inicializar = function()
            -- Puedes agregar aquí cualquier inicialización necesaria para el glosario
        end,
        actualizar = function()
            if not musicStarted then
                music(0)  -- Reproduce la música en el track 0
                musicStarted = true
            end
        end,
        dibujar = function()
            cls(0)  -- Limpia la pantalla con color de fondo 0
            map(0, 102, 30, 118)  -- Dibujar el mapa, si lo necesitas
    
            -- Mostrar el mensaje "Hola Mundo"
            print("Lenguaje?", 60, 60, 7)  -- Dibuja el texto en la pantalla en (60, 60) con color 7 (blanco)
            
            volverMenu()  -- Llama la función para dibujar el botón de "volver al menú"
        end
    }
    
    niveles["menu"] = {
        inicializar = function()      
            opcion_seleccionada = 1
        end,
        actualizar = function()
            cls(4)
            map(0, 51, 30, 68)
            if not musicStarted then
                music(1)  -- Reproduce la música en el track 0
                musicStarted = true
            end
            totalScore = 0 -- Puntaje global vacío
            local start_x = 60  -- Posición inicial en el eje X
            local start_y = 10  -- Posición inicial en el eje Y
            local spacing = 14   -- Espaciado entre los sprites

            -- Dibujar los sprites del 84 al 92
            for i = 84, 92 do
                spr(i, start_x, start_y,0,2)  -- Dibuja el sprite en la posición (start_x, start_y)
                start_x = start_x + spacing  -- Mueve la posición X para el siguiente sprite
            end
            start_x = 60
            for i = 100, 108 do
                spr(i, start_x, start_y+14,0,2)  -- Dibuja el sprite en la posición (start_x, start_y)
                start_x = start_x + spacing  -- Mueve la posición X para el siguiente sprite
            end
            spr(116, 20,45, 0)
            spr(116, 220,45, 0,1,1)
            start_x = 28
            start_y = 45
            for i = 1, 24  do
           		spr(117,start_x, start_y,0)
                start_x = start_x + 8 	
            end
            actualizarMenu(opcion_seleccionada)
            if btnp(3) and opcion_seleccionada <=4 then
                opcion_seleccionada = opcion_seleccionada + 1
                if opcion_seleccionada ==5 then
                    opcion_seleccionada = 1
                end
            elseif btnp(2) and opcion_seleccionada >= 1 then
                opcion_seleccionada = opcion_seleccionada - 1
                if opcion_seleccionada == 0 then
                    opcion_seleccionada = 4
                end
            end
        end,
        dibujar = function()
            
            dibujarMenu(opcion_seleccionada)
        end
    }

