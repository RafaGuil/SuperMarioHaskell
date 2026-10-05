-- Tipos Sinónimos:

type Celda = Char
type Nivel = [String]

-- Ejercicio 5:

-- Función posicionesEnemigos:
-- La función recibe un nivel y devuelve una lista de tuplas que contiene el número de la fila y la columna seguido del enemigo
-- Usamos zip para asignarle una posición tanto a filas como a columnas y los recorremos, además utilizamos "esEnemigo" para filtrarlas

posicionesEnemigos :: Nivel -> [(Int,Int,String)]
posicionesEnemigos nivel = [(f,c,[celda]) | (f, fila) <- zip [0..] nivel, (c, celda) <- zip[0..] fila, esEnemigo celda]

-- Funcion agruparRachas:
-- Resolvemos la función de forma recursiva con una función auxiliar y un acumulador. Tras recorrer una fila que tiene  como entrada,
-- agrupa en una tupla las veces que hay columnas sólidas de forma consecutiva, con el formato (PosicionInicio, longitud)

agruparRachas :: [Celda] -> [(Int, Int)]
agruparRachas fila = buscarRachasR fila 0
    where 
        buscarRachasR :: [Celda] -> Int -> [(Int, Int)]
        buscarRachasR [] _ = []
        buscarRachasR (x:xs) acum
            | esSolido x = (acum, racha) : buscarRachasR fila (acum + racha)
            | otherwise = buscarRachasR xs (acum + 1)
            
            where 
                racha = contarSolidos(x:xs)
                fila = drop racha (x:xs)
        
        contarSolidos :: [Celda] -> Int
        contarSolidos [] = 0
        contarSolidos (x:xs)
            | esSolido x = 1 + contarSolidos xs
            | otherwise = 0

