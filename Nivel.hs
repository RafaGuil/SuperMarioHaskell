--------------------------------------------------------------------------------
-- SUBTAREA 5: PARSEO DEL NIVEL
--------------------------------------------------------------------------------

-- APARTADO 1: Tipos sinónimo
type Celda = Char    
type Grid  = [String]

-- APARTADO 2: Parseo del nivel
parsearNivel :: [String] -> Grid
parsearNivel lineas = lineas

-- APARTADO 3: Funciones de clasificación con Pattern Matching

-- Indica si la casilla es un bloque sólido / plataforma
esSolido :: Celda -> Bool
esSolido '#' = True  
esSolido _   = False 

-- Indica si la casilla es la meta del nivel
esMeta :: Celda -> Bool
esMeta 'M' = True  
esMeta _ = False 

-- Indica si la casilla está vacía
esVacio :: Celda -> Bool
esVacio '.' = True 
esVacio _ = False 

-- APARTADO 4: Detección de enemigos (reutilizando funciones anteriores)
esEnemigo :: Celda -> Bool
esEnemigo c = not (esSolido c || esMeta c || esVacio c)

-- APARTADO 5: Búsqueda de posiciones con listas por comprensión anidadas
posicionesMeta :: Grid -> [(Int, Int)] 
posicionesMeta grid = 
    [ (f, c) 
    | (f, fila) <- zip [0..] grid -- zip [0..] le asigna numero de fila 'f' (0, 1, 2...) 
    , (c, celda) <- zip [0..] fila -- zip [0..] le asigna numero de columna 'c' (0, 1, 2...) 
    , esMeta celda -- Filtro: solo se guarda si la celda es la meta 
    ]
