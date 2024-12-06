    -- Estado del juego
    local estado = "lenguaje"  -- Estados posibles: "menu", "intro", "nivel1", "nivel2", et

    -- Tabla para almacenar los niveles
    local niveles = {}

    nivel_sprites = {
        [1] = 111,
        [2] = 62,
        [3] = 95,
        [4] = 79,
        [5] = 78, 
        [6] = 94,
        [7] = 63
    }
    
    lang_flag = false

    totalScore = 0  -- Puntaje acumulado global


    local last_click_time = 0  -- Para llevar un control del último clic
    local click_delay = 300  -- Número de ciclos entre clics para evitar que se registre demasiado rápido
    mx, my, left, middle, right = mouse()
    px, py = 110, 26
    angle = math.atan2(my - py, mx - px)

    -- Diccionario de traducciones para las categorías
    local categoriasTraducidas = {
        months = {spanish = "Meses", english = "Months"},
        dias_semana = {spanish = "Dias de la Semana", english = "Days of the Week"},
        colors = {spanish = "Colores", english = "Colors"},
        numbers = {spanish = "Numeros", english = "Numbers"},
        body = {spanish = "Partes del Cuerpo", english = "Body Parts"},
        words = {spanish = "Palabras", english = "Words"}
    }

    -- Función para traducir los títulos de las categorías
    function obtenerTituloCategoria(categoria)
        return not lang_flag and categoriasTraducidas[categoria].english or categoriasTraducidas[categoria].spanish
    end

    glosarioScroll = {
        categorias = {"months", "dias_semana", "colors", "numbers", "body", "words"},
        indiceCategoria = 1, -- Categoría seleccionada actualmente
        offset = 0,          -- Desplazamiento vertical en la lista
        maxPorPagina = 8     -- Número máximo de elementos visibles por página
    }

    function mostrarGlosario()
        local categoriaActual = glosarioScroll.categorias[glosarioScroll.indiceCategoria]

        local lista = _G[categoriaActual] -- Accede a la tabla de palabras correspondiente
    
        -- Validar si la lista existe y es válida
        if not lista or type(lista) ~= "table" then
            print("Categoría inválida: " .. tostring(categoriaActual), 10, 10, 8)
            return
        end
    
        local y = 30 -- Coordenada Y inicial para dibujar
    
        -- Traducir y mostrar el título de la categoría
        local tituloCategoria = obtenerTituloCategoria(categoriaActual)
        print(string.upper(tituloCategoria), 24, 10, 12) -- Centrado en la parte superior

    
        -- Mostrar las palabras dentro del rango del desplazamiento
        for i = glosarioScroll.offset + 1, math.min(#lista, glosarioScroll.offset + glosarioScroll.maxPorPagina) do
            local palabra = lista[i]
    
            -- Validar si la palabra existe
            if palabra and type(palabra) == "table" then
                -- Selecciona el idioma dependiendo de la bandera
                local izquierda = not lang_flag and palabra.english or palabra.spanish -- Inglés o Español
                local derecha = palabra.mapudungun -- Siempre Mapudungun
    
                -- Dibuja las palabras en la posición correspondiente
                print(izquierda, 25, y, 7) -- Columna izquierda
                print(derecha, 140, y, 7) -- Columna derecha (ajusta 190 según el ancho de la pantalla)
                y = y + 10 -- Incrementa Y para la siguiente palabra
            else
            end
        end
    
        -- Indicadores de navegación
        if glosarioScroll.offset > 0 then
            if not lang_flag then
                print("^ Scroll Up", 30, 115, 6)
            else   
                print("^ Subir", 80, 115, 6)
            end
        end
        if glosarioScroll.offset + glosarioScroll.maxPorPagina < #lista then
            if not lang_flag then
                print("v Scroll Down", 140, 115, 6)
            else
                print("v Bajar", 175, 115, 6)
            end
        end
    end
    
    
    

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
        inicial_x = 75 
        inicial_y = 60 
        
        if not lang_flag then
            print("Select a level...", inicial_x, inicial_y, 12)
        else
            print("Selecciona un nivel", inicial_x, inicial_y, 12)
        end
        puntos_x = inicial_x + 35 
        puntos_y = inicial_y + 10
        
        -- Dibujar flechas izquierda y derecha
        spr(381, puntos_x - 18, puntos_y + 8 , 0)
        spr(381, puntos_x - 18, puntos_y + 16, 0, 1, 2)
        spr(381, puntos_x + 40, puntos_y + 8, 0, 1, 1)
        spr(381, puntos_x + 40, puntos_y + 16, 0, 1, 3) 
        
        -- Dibujar el sprite del nivel seleccionado
        local sprite = nivel_sprites[opcion_seleccionada]
        if sprite then
            spr(sprite, puntos_x, puntos_y, 0,4 ) -- Dibujar el sprite del nivel
        else
            print("Nivel " .. opcion_seleccionada, puntos_x, puntos_y, 12) -- En caso de error
        end
        
        -- Dibujar botón de iniciar
        rectb(inicial_x - 10, inicial_y + 48, 120, 20, 14)
        if not lang_flag then
            print(" START", inicial_x - 7, inicial_y + 50, 12, false, 3)
        else
            print("INICIAR", inicial_x - 7, inicial_y + 50, 12, false, 3)
        end
        
        -- Detectar clics en las flechas
        x, y, left, middle, right, scrollX, scrollY = mouse()
        if left and (time() - last_click_time > click_delay) then
            last_click_time = time()
            if (x >= 92 and x <= 100) and (y >= 78 and y <= 94) then
                opcion_seleccionada = opcion_seleccionada - 1
                if opcion_seleccionada == 0 then
                    opcion_seleccionada = 7
                end
            elseif (x >= 150 and x <= 158) and (y >= 78 and y <= 94) then
                opcion_seleccionada = opcion_seleccionada + 1
                if opcion_seleccionada == 8 then
                    opcion_seleccionada = 1
                end
            end
        end
    end
    

    function actualizarMenu(opcion_seleccionada)
        x, y, left, middle, right, scrollX, scrollY = mouse()
        if (x > 65 and x < 184) and (y > 108 and y < 127) then
            rect(inicial_x-10,inicial_y+48,120,20,14+t%60//10)
            if not lang_flag then
                print(" START", inicial_x-7, inicial_y+50,12, false, 3)
            else
                print("INICIAR", inicial_x-7, inicial_y+50,12, false, 3)
            end 
            if left then
                if opcion_seleccionada == 1 then
                    cambiarNivel("nivel1") 
                elseif opcion_seleccionada == 2 then
                    cambiarNivel("nivel2")
                elseif opcion_seleccionada == 3  then
                    cambiarNivel("nivel3")
                elseif opcion_seleccionada == 4 then
                    cambiarNivel("nivel4")
                elseif opcion_seleccionada == 5 then
                    cambiarNivel("nivel5")
                elseif opcion_seleccionada == 6 then
                    cambiarNivel("nivel6")
                elseif opcion_seleccionada == 7 then
                    cambiarNivel("glosario")
                elseif opcion_seleccionada == 0 then
                    cambiarNivel("intro")
                elseif opcion_seleccionada == 8 then
                    cambiarNivel("creditos")
                end
            end
        else
            rect(inicial_x-10,inicial_y+48,120,20,14)
            if not lang_flag then
                print(" START", inicial_x-7, inicial_y+50,12, false, 3)
            else
                print("INICIAR", inicial_x-7, inicial_y+50,12, false, 3)
            end
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

    local history = {
        "in a time of darkness a.",
        "young warrior named KallfUB",
        "finds himself trapped in chaosZ",
        "",
        "an attack on his village forces him to",
        "fleeB getting lost within that",
        "deep forestZ",
        "",
        "but in the darkness he finds a",
        "sanctuaryB a cave<",
        "",
        "inside, an old woman awaits him.",
        "The Machi, healer and protector",
        "of spiritsZ",
        "",
        "the portal has been openedB",
        "she saysZ",
        "",
        "your mission is written in the.",
        "starsZ Kallfü receives a.",
        "amulet, the PUllU,",
        "a mystical artifact with a",
        "purposeZ",
        "",
        "through the portal, you will face",
        "trials that will challenge your mind",
        "and spiritZ",
        "",
        "the pillars of your culture must",
        "be rebornZ",
        "",
        "numbersZZZ",
        "",
        "colorsZZZ",
        "",
        "cycles of timeZZZ",
        "",
        "and when all seems lostZZZ",
        "",
        "you will remember who you areZZZ",
        "",
        "and where",
        "",
        "you come fromZZZ\""
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
                cambiarNivel("menu") --FALTA IMPLEMENTAR
            end
        end
        
        rect(225,5,10,10,14+t%60//10)      

        spr(175, 226, 6)  
    end

    function seleccionarES()
        rect(40, 67, 80, 30, 14)
        --Uga Buga
        spr(77, 80,72,0)
        spr(93, 80,80,0)
        spr(109, 80,88,0)
        spr(45, 88,88,0)
        spr(45, 94,88,0)
        spr(61, 102,88,0)
        spr(177, 88,72)
        spr(177, 94,72)
        spr(177, 102,72)
        spr(193, 88,80)
        spr(193, 94,80)
        spr(193, 102,80)
        --Spain
        spr(77, 40,72,0)
        spr(93, 40,80,0)
        spr(109, 40,88,0)
        spr(45, 48,88,0)
        spr(45, 56,88,0)
        spr(61, 63,88,0)
        spr(176, 48,72)
        spr(176, 56,72)
        spr(176, 62,72)
        spr(192, 48,80)
        spr(192, 56,80)
        spr(192, 62,80)
        mx, my, left, middle, right = mouse()
        if (mx>=40 and mx < 120) and (my>=67 and my <=97) then
            rect(40, 67, 80, 30, 14+t%60//10)
                --Uga Buga
            spr(77, 80,72,0)
            spr(93, 80,80,0)
            spr(109, 80,88,0)
            spr(45, 88,88,0)
            spr(45, 94,88,0)
            spr(61, 102,88,0)
            spr(177, 88,72)
            spr(177, 94,72)
            spr(177, 102,72)
            spr(193, 88,80)
            spr(193, 94,80)
            spr(193, 102,80)
            --Spain
            spr(77, 40,72,0)
            spr(93, 40,80,0)
            spr(109, 40,88,0)
            spr(45, 48,88,0)
            spr(45, 56,88,0)
            spr(61, 63,88,0)
            spr(176, 48,72)
            spr(176, 56,72)
            spr(176, 62,72)
            spr(192, 48,80)
            spr(192, 56,80)
            spr(192, 62,80)
            if left then
                
                lang_flag = true
                cambiarNivel("intro")
            end
        end
    end

    function seleccionarEN()
            rect(130, 67, 80, 30, 14)
            
            spr(77, 168,72,0)
            spr(93, 168,80,0)
            spr(109, 168,88,0)
            spr(45, 176,88,0)
            spr(45, 184,88,0)
            spr(61, 192,88,0)
            --Mapuzungun
            spr(177, 176,72)
            spr(177, 184,72)
            spr(177, 192,72)
            spr(193, 176,80)
            spr(193, 184,80)
            spr(193, 192,80)

            
            spr(77, 128,72,0)
            spr(93, 128,80,0)
            spr(109, 128,88,0)
            spr(45, 136,88,0)
            spr(45, 144,88,0)
            spr(61, 152,88,0)
            --Gringo
            spr(178, 136,72)
            spr(194, 144,72)
            spr(194, 152,72)
            spr(194, 136,80)
            spr(194, 144,80)
            spr(194, 152,80)
        mx, my, left, middle, right = mouse()
        if (mx>=130 and mx < 210) and (my>=67 and my <=104) then
            rect(130, 67, 80, 30, 14+t%60//10)
            --Mapuzungun
            spr(77, 168,72,0)
            spr(93, 168,80,0)
            spr(109, 168,88,0)
            spr(45, 176,88,0)
            spr(45, 184,88,0)
            spr(61, 192,88,0)
            spr(177, 176,72)
            spr(177, 184,72)
            spr(177, 192,72)
            spr(193, 176,80)
            spr(193, 184,80)
            spr(193, 192,80)

            
            spr(77, 128,72,0)
            spr(93, 128,80,0)
            spr(109, 128,88,0)
            spr(45, 136,88,0)
            spr(45, 144,88,0)
            spr(61, 152,88,0)
            --Gringo
            spr(178, 136,72)
            spr(194, 144,72)
            spr(194, 152,72)
            spr(194, 136,80)
            spr(194, 144,80)
            spr(194, 152,80)
            if left then
                lang_flag = false
                cambiarNivel("intro")
            end
        end
    end

    function siguienteNivel(nivelActual)

        map(0, 34, 30, 47)

        mx, my, left, middle, right = mouse()
        --print("Posicion del mouse: ("..mx..", "..my..")", 10, 10, 12+t%60//20)
        rect(107,66,27,35,3+t%60//20)    
        spr(381, 112, 70, 0, 2, 1)
        spr(381, 112, 82, 0, 2, 3)  
        
        if not lang_flag then
            print("Next Level", 40, 44,12, false, 2)
        else
            print("Siguiente Nivel", 40, 44,12, false, 2)
        end
        if (mx>=107 and mx < 132) and (my>=66 and my <=101) then
            if left then
                if nivelActual == 1 then
                    cambiarNivel("nivel2")
                elseif nivelActual == 2 then
                    cambiarNivel("nivel3")
                elseif nivelActual == 3 then
                    cambiarNivel("nivel4")
                elseif nivelActual == 4 then
                    cambiarNivel("nivel5")
                elseif nivelActual == 5 then
                    cambiarNivel("nivel6")
                elseif nivelActual == 6 then
                    cambiarNivel("creditos")
                end
            end
        end
        
    end

    -- Función para dibujar la historia del juego con escritura letra por letra
    function dibujarHistoria()
        map(0, 119, 30, 135)
        rect(180,40,37,8,14+t%60//10)
       
        if not lang_flag then
            print("SKIP", 181, 41,12, false, 1)
        else
            print("SALTAR", 181, 41,12, false, 1)
        end

        mx, my, left, middle, right = mouse()
        if (mx>=180 and mx < 215) and (my>=40 and my <=50) then
            if left then
                    mostrarHistoria = false
            end
        end
        --print("Posicion del mouse: ("..mx..", "..my..")", 10, 10, 12+t%60//20)
        -- Incrementa el contador de tiempo
        tiempo = tiempo + 1

        if not lang_flag then
            historia = history
        end

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

    months = {
        {spanish = "enero", mapudungun = "eneru", english = "january"},
        {spanish = "febrero", mapudungun = "fewreru", english = "february"},
        {spanish = "marzo", mapudungun = "marsu", english = "march"},
        {spanish = "abril", mapudungun = "afril", english = "april"},
        {spanish = "mayo", mapudungun = "mayu", english = "may"},
        {spanish = "junio", mapudungun = "kuniu", english = "june"},
        {spanish = "julio", mapudungun = "kuliu", english = "july"},
        {spanish = "agosto", mapudungun = "akostu", english = "august"},
        {spanish = "septiembre", mapudungun = "setiempUre", english = "september"},
        {spanish = "octubre", mapudungun = "oktufUre", english = "october"},
        {spanish = "noviembre", mapudungun = "nofiempUre", english = "november"},
        {spanish = "diciembre", mapudungun = "disempUre", english = "december"}
    }

    dias_semana = {
        {spanish = "lunes", mapudungun = "pANi", english = "monday"},
        {spanish = "martes", mapudungun = "afilUl", english = "tuesday"},
        {spanish = "miercoles", mapudungun = "wenU", english = "wednesday"},
        {spanish = "jueves", mapudungun = "trengUn", english = "thursday"},
        {spanish = "viernes", mapudungun = "antU", english = "friday"},
        {spanish = "sabado", mapudungun = "NamUn", english = "saturday"},
        {spanish = "domingo", mapudungun = "kUnUn", english = "sunday"}
    }

    colors = {
        {spanish = "rojo", mapudungun = "kelU", english = "red"},
        {spanish = "negro", mapudungun = "kurU", english = "black"},
        {spanish = "morado", mapudungun = "koNoll", english = "purple"},
        {spanish = "verde", mapudungun = "karU", english = "green"},
        {spanish = "gris", mapudungun = "kadU", english = "gray"},
        {spanish = "azul", mapudungun = "kallfU", english = "blue"},
        {spanish = "amarillo", mapudungun = "lig", english = "yellow"},
        {spanish = "blanco", mapudungun = "kollU", english = "white"},
        {spanish = "marron", mapudungun = "kelUchod", english = "brown"},
        {spanish = "naranja", mapudungun = "chod", english = "orange"},
        {spanish = "rosado", mapudungun = "rosaw", english = "pink"},
        {spanish = "beige", mapudungun = "kollU", english = "beige"}
    }

    numbers = {
        {spanish = "uno", mapudungun = "kiNe", english = "one"},
        {spanish = "dos", mapudungun = "epu", english = "two"},
        {spanish = "tres", mapudungun = "kUla", english = "three"},
        {spanish = "cuatro", mapudungun = "meli", english = "four"},
        {spanish = "cinco", mapudungun = "kechu", english = "five"},
        {spanish = "seis", mapudungun = "kayu", english = "six"},
        {spanish = "siete", mapudungun = "regle", english = "seven"},
        {spanish = "ocho", mapudungun = "pura", english = "eight"},
        {spanish = "nueve", mapudungun = "aylla", english = "nine"},
        {spanish = "diez", mapudungun = "mari", english = "ten"},
        {spanish = "once", mapudungun = "mari kiNe", english = "eleven"},
        {spanish = "doce", mapudungun = "mari epu", english = "twelve"},
        {spanish = "trece", mapudungun = "mari küla", english = "thirteen"},
        {spanish = "catorce", mapudungun = "mari meli", english = "fourteen"},
        {spanish = "quince", mapudungun = "mari kechu", english = "fifteen"},
        {spanish = "diecisEis", mapudungun = "mari kayu", english = "sixteen"},
        {spanish = "diecisiete", mapudungun = "mari regle", english = "seventeen"},
        {spanish = "dieciocho", mapudungun = "mari pura", english = "eighteen"},
        {spanish = "diecinueve", mapudungun = "mari aylla", english = "nineteen"},
        {spanish = "veinte", mapudungun = "epu mari", english = "twenty"}
    }
    
    body = {
        {spanish = "manos", mapudungun = "kuwU", english = "hands"},
        {spanish = "ojos", mapudungun = "nge", english = "eyes"},
        {spanish = "brazos", mapudungun = "lipang", english = "arms"},
        {spanish = "piernas", mapudungun = "chang", english = "legs"},
        {spanish = "cabeza", mapudungun = "lonco", english = "head"},
        {spanish = "oreja", mapudungun = "pilun", english = "ear"},
        {spanish = "nariz", mapudungun = "yu", english = "nose"},
        {spanish = "boca", mapudungun = "wUn", english = "mouth"},
        {spanish = "estomago", mapudungun = "guata", english = "stomach"}
    }
    
    words = {
        {spanish = "reunion", mapudungun = "cahuin", english = "meeting"},
        {spanish = "gente", mapudungun = "che", english = "people"},
        {spanish = "novio", mapudungun = "pololo", english = "boyfriend"},
        {spanish = "novia", mapudungun = "polola", english = "girlfriend"},
        {spanish = "tierra", mapudungun = "mapu", english = "land"},
        {spanish = "hola", mapudungun = "mari mari", english = "hello"},
        {spanish = "gracias", mapudungun = "chaltumay", english = "thank you"},
        {spanish = "despedida", mapudungun = "pewkallal", english = "farewell"},
        {spanish = "te quiero", mapudungun = "poyenieyu", english = "I love you"},
        {spanish = "por favor", mapudungun = "fvreneaen", english = "please"}
    }

    
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
                if lang_flag then
                    table.insert(memorama, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
                else
                    table.insert(memorama, {text = par.english, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama, {text = par.mapudungun, match = par.english, flipped = true, matched = false})
                end
            end
            shuffle(memorama)
            matchesFound = 0
            firstCard, secondCard = nil, nil

            score = 0
            streak = 0
            attempts = 0
            revealTimer = 120  

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
                music(3)
                volverMenu()
                siguienteNivel(1)

                if not lang_flag then 
                    print("You Win! You found all the pairs", 20, 120, 12)
                    print("\nFinal score: " .. totalScore, 10, 5, 12)
                    print("Attempts: " .. attempts, 10, 20, 12)
                    print("Streak: " .. streak, 10, 30, 12)
                else                    
                    print("Ganaste! Encontraste todos los pares.", 20, 120, 12)
                    print("\nPuntaje final: " .. totalScore, 10, 5, 12)
                    print("Intentos: " .. attempts, 10, 20, 12)
                    print("Racha: " .. streak, 10, 30, 12)
                end

            end
        end
    }

    niveles["nivel2"] = {
        inicializar = function()
            changeColors(2)
            memorama2 = {}
            local paresSeleccionados2 = seleccionarPares(dias_semana, 5)
            for _, par in ipairs(paresSeleccionados2) do
                if lang_flag then
                    table.insert(memorama2, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama2, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
                else
                    table.insert(memorama2, {text = par.english, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama2, {text = par.mapudungun, match = par.english, flipped = true, matched = false})
                end
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
                music(3) 
                siguienteNivel(2)

                if not lang_flag then 
                    print("You Win! You found all the pairs", 20, 120, 12)
                    print("\nFinal score: " .. totalScore, 10, 5, 12)
                    print("Attempts: " .. attempts, 10, 20, 12)
                    print("Streak: " .. streak, 10, 30, 12)
                else                    
                    print("Ganaste! Encontraste todos los pares.", 20, 120, 12)
                    print("\nPuntaje final: " .. totalScore, 10, 5, 12)
                    print("Intentos: " .. attempts, 10, 20, 12)
                    print("Racha: " .. streak, 10, 30, 12)
                end
            end
        end
    }
    

    niveles["nivel3"] = {
        inicializar = function()
            changeColors(3)
            memorama3 = {}
            local paresSeleccionados3 = seleccionarPares(colors, 5)
            for _, par in ipairs(paresSeleccionados3) do
                if lang_flag then
                    table.insert(memorama3, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama3, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
                else
                    table.insert(memorama3, {text = par.english, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama3, {text = par.mapudungun, match = par.english, flipped = true, matched = false})
                end
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

                if not lang_flag then 
                    print("You Win! You found all the pairs", 20, 120, 12)
                    print("\nFinal score: " .. totalScore, 10, 5, 12)
                    print("Attempts: " .. attempts, 10, 20, 12)
                    print("Streak: " .. streak, 10, 30, 12)
                else                    
                    print("Ganaste! Encontraste todos los pares.", 20, 120, 12)
                    print("\nPuntaje final: " .. totalScore, 10, 5, 12)
                    print("Intentos: " .. attempts, 10, 20, 12)
                    print("Racha: " .. streak, 10, 30, 12)
                end
            end
        end
    }

    niveles["nivel4"] = {
        inicializar = function()
            changeColors(4)
            memorama4 = {}
            local paresSeleccionados4 = seleccionarPares(numbers, 5)
            for _, par in ipairs(paresSeleccionados4) do
                if lang_flag then
                    table.insert(memorama4, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama4, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
                else
                    table.insert(memorama4, {text = par.english, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama4, {text = par.mapudungun, match = par.english, flipped = true, matched = false})
                end
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

                if not lang_flag then 
                    print("You Win! You found all the pairs", 20, 120, 12)
                    print("\nFinal score: " .. totalScore, 10, 5, 12)
                    print("Attempts: " .. attempts, 10, 20, 12)
                    print("Streak: " .. streak, 10, 30, 12)
                else                    
                    print("Ganaste! Encontraste todos los pares.", 20, 120, 12)
                    print("\nPuntaje final: " .. totalScore, 10, 5, 12)
                    print("Intentos: " .. attempts, 10, 20, 12)
                    print("Racha: " .. streak, 10, 30, 12)
                end
            end
        end
    }

    niveles["nivel5"] = {
        inicializar = function()
            changeColors(5)
            memorama5 = {}
            local paresSeleccionados5 = seleccionarPares(body, 5)
            for _, par in ipairs(paresSeleccionados5) do
                if lang_flag then
                    table.insert(memorama5, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama5, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
                else
                    table.insert(memorama5, {text = par.english, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama5, {text = par.mapudungun, match = par.english, flipped = true, matched = false})
                end
            end
            shuffle(memorama5)
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
                    for _, carta in ipairs(memorama5) do
                        carta.flipped = false  -- Oculta las cartas después del período de revelación
                    end
                end
            else
                mx, my, left, middle, right = mouse()
                angle = math.atan2(my - py, mx - px)
                manejarClick(memorama5)  -- Permite al jugador interactuar
                verificarPares()
            end
        end,
        dibujar = function()
            cls(0)
            map(0, 0, 30, 17)  -- Dibujar el mapa
            volverMenu()
            actualizarParpadeo()
            dibujarOjos(px, py, angle)
            dibujarMemorama(memorama5)
    
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
                siguienteNivel(5)

                if not lang_flag then 
                    print("You Win! You found all the pairs", 20, 120, 12)
                    print("\nFinal score: " .. totalScore, 10, 5, 12)
                    print("Attempts: " .. attempts, 10, 20, 12)
                    print("Streak: " .. streak, 10, 30, 12)
                else                    
                    print("Ganaste! Encontraste todos los pares.", 20, 120, 12)
                    print("\nPuntaje final: " .. totalScore, 10, 5, 12)
                    print("Intentos: " .. attempts, 10, 20, 12)
                    print("Racha: " .. streak, 10, 30, 12)
                end

            end
        end
    }

    niveles["nivel6"] = {
        inicializar = function()
            changeColors(6)
            memorama6 = {}
            local paresSeleccionados6 = seleccionarPares(words, 5)
            for _, par in ipairs(paresSeleccionados6) do
                if lang_flag then
                    table.insert(memorama6, {text = par.spanish, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama6, {text = par.mapudungun, match = par.spanish, flipped = true, matched = false})
                else
                    table.insert(memorama6, {text = par.english, match = par.mapudungun, flipped = true, matched = false})
                    table.insert(memorama6, {text = par.mapudungun, match = par.english, flipped = true, matched = false})
                end
            end
            shuffle(memorama6)
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
                    for _, carta in ipairs(memorama6) do
                        carta.flipped = false  -- Oculta las cartas después del período de revelación
                    end
                end
            else
                mx, my, left, middle, right = mouse()
                angle = math.atan2(my - py, mx - px)
                manejarClick(memorama6)  -- Permite al jugador interactuar
                verificarPares()
            end
        end,
        dibujar = function()
            cls(0)
            map(0, 0, 30, 17)  -- Dibujar el mapa
            volverMenu()
            actualizarParpadeo()
            dibujarOjos(px, py, angle)
            dibujarMemorama(memorama6)
    
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
                siguienteNivel(6)

                if not lang_flag then 
                    print("You Win! You found all the pairs", 20, 120, 12)
                    print("\nFinal score: " .. totalScore, 10, 5, 12)
                    print("Attempts: " .. attempts, 10, 20, 12)
                    print("Streak: " .. streak, 10, 30, 12)
                else                    
                    print("Ganaste! Encontraste todos los pares.", 20, 120, 12)
                    print("\nPuntaje final: " .. totalScore, 10, 5, 12)
                    print("Intentos: " .. attempts, 10, 20, 12)
                    print("Racha: " .. streak, 10, 30, 12)
                end

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

            -- Teclas para cambiar entre categorías
            if btnp(2) then -- Flecha izquierda
                glosarioScroll.indiceCategoria = glosarioScroll.indiceCategoria - 1
                if glosarioScroll.indiceCategoria < 1 then
                    glosarioScroll.indiceCategoria = #glosarioScroll.categorias
                end
                glosarioScroll.offset = 0 -- Reinicia el desplazamiento
            end
            if btnp(3) then -- Flecha derecha
                glosarioScroll.indiceCategoria = glosarioScroll.indiceCategoria + 1
                if glosarioScroll.indiceCategoria > #glosarioScroll.categorias then
                    glosarioScroll.indiceCategoria = 1
                end
                glosarioScroll.offset = 0 -- Reinicia el desplazamiento
            end

            -- Teclas para desplazamiento vertical
            local categoriaActual = glosarioScroll.categorias[glosarioScroll.indiceCategoria]
            local lista = _G[categoriaActual] -- Accede a la tabla actual

            if btnp(0) then -- Flecha arriba
                glosarioScroll.offset = math.max(0, glosarioScroll.offset - 1)
            end
            if btnp(1) then -- Flecha abajo
                glosarioScroll.offset = math.min(#lista - glosarioScroll.maxPorPagina, glosarioScroll.offset + 1)
            end
        end,
        dibujar = function()
            cls(0)  -- Limpia la pantalla con color de fondo 0
            map(0, 85, 30, 100)  -- Dibujar el mapa, si lo necesitas
    
            -- Mostrar el mensaje "Hola Mundo"
            
            if not lang_flag then
                print("English", 25, 20, 0)  
            else
                print("Castellano", 25, 20, 0)  
            end

            print("Mapuzungun", 140, 20, 0)  
            mostrarGlosario() -- Muestra el contenido del glosario
            volverNivel()  -- Llama la función para dibujar el botón de "volver al nivel"
        end
    }

    niveles["creditos"] = {
        inicializar = function()
            -- Puedes agregar aquí cualquier inicialización necesaria para el glosario
        end,
        actualizar = function()
            if not musicStarted then
                music(3)  -- Reproduce la música en el track 3
                musicStarted = true
            end
        end,
        dibujar = function()
            cls(0)  
            map(0, 68, 30, 84)  
    
            print("Creditos", 90, 20, 7) 
            print("Devs: Diego Ruan y Boris Herrera", 30, 50, 7)
            print("Art: Diego Ruan", 30, 60, 7)
            print("Music: Boris Herrera", 30, 70, 7)
            print("Gracias por jugar!", 75, 90, 7)

            print("UgabuGames 2024", 80, 100, 7)

            volverMenu()  
        end
    }

    niveles["lenguaje"] = {
        inicializar = function()
        end,
        actualizar = function()
            
            if not musicStarted then
                music(0)  
                musicStarted = true
            end
        end,
        dibujar = function()
            cls(0)  
            map(0, 102, 30, 118)  
          
            seleccionarES()
            seleccionarEN()
            mx, my, left, middle, right = mouse()
            
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

