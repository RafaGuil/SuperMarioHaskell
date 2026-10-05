--------------------------------------------------------------------------------
-- SUBTAREA 5: PARSEO DEL NIVEL
--------------------------------------------------------------------------------

-- APARTADO 1: Tipos sinónimo
-- Hemos creado un alias de tipos para que el código sea más legible y sepamos qué representa cada cosa.
type Celda = Char     -- Cada casilla del nivel es un carácter individual ('#', 'M', '.', 'X'...)
type Grid  = [String] -- El mapa completo es una lista de filas de texto (matriz 2D de caracteres)

-- APARTADO 2: Parseo del nivel
-- Convierte la lista de líneas leídas del archivo de texto en nuestro tipo Grid.
-- Como Grid ya está definido como [String], devolvemos las líneas tal cual.
parsearNivel :: [String] -> Grid
parsearNivel lineas = lineas

-- APARTADO 3: Funciones de clasificación con Pattern Matching
-- Hemos usado coincidencia de patrones sobre el carácter para saber qué hay en la celda:
-- La primera línea comprueba el carácter concreto y la segunda (_) captura cualquier otro.

-- Indica si la casilla es un bloque sólido / plataforma
esSolido :: Celda -> Bool
esSolido '#' = True  -- Si es '#', es una plataforma
esSolido _   = False -- Para cualquier otro caracter devuelve False

-- Indica si la casilla es la meta del nivel
esMeta :: Celda -> Bool
esMeta 'M' = True -- Si es 'M', es la meta 
esMeta _ = False -- Para el resto devuelve False

-- Indica si la casilla está vacía
esVacio :: Celda -> Bool
esVacio '.' = True -- Si es '.', la casilla esta vacia 
esVacio _ = False -- Para el resto devuelve False

-- APARTADO 4: Detección de enemigos (reutilizando funciones anteriores)
-- Un enemigo es cualquier carácter que no sea pared ('#'), ni meta ('M'), ni suelo vacío ('.').
-- Reutilizamos las tres funciones anteriores para no repetir lógica.
esEnemigo :: Celda -> Bool
esEnemigo c = not (esSolido c || esMeta c || esVacio c)

-- APARTADO 5: Búsqueda de posiciones con listas por comprensión anidadas

-- Devuelve las coordenadas (fila, columna) donde aparece la meta 'M'.
-- 1. zip [0..] grid asigna a cada fila su número de índice 'f' -> (0, "fila0"), (1, "fila1")...
-- 2. zip [0..] fila asigna a cada carácter de esa fila su índice de columna 'c' -> (0, '.'), (1, 'M')...
-- 3. esMeta celda actúa como filtro (guarda) para quedarse solo con la casilla de la meta.
posicionesMeta :: Grid -> [(Int, Int)] 
posicionesMeta grid = 
    [ (f, c) 
    | (f, fila) <- zip [0..] grid -- zip [0..] le asigna numero de fila 'f' (0, 1, 2...) 
    , (c, celda) <- zip [0..] fila -- zip [0..] le asigna numero de columna 'c' (0, 1, 2...) 
    , esMeta celda -- Filtro: solo se guarda si la celda es la meta 
    ]
