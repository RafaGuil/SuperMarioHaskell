-- Tipos Sinónimos:

-- Para el Ejercicio 5
type Celda = Char
type Nivel = [String]

-- Ejercicio 5:
-- Función posicionesEnemigos:
-- Necesitaremos hacer uso de la función "esEnemigo"

posicionesEnemigos :: Nivel -> [(Int,Int,Char)]
posicionesEnemigos nivel = [(f,c,[celda]) | (f, fila) <- zip [0..] nivel, (c, celda) <- zip[0..] fila, esEnemigo celda]


-- Función agruparRachas

