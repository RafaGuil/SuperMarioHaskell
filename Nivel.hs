
module Nivel where

import Test.QuickCheck


-- Tarea 1

-- Ejercicios 1,2,3


-- Declaraciones de tipo

-- Punto o Vector 2D
type Vector2 = (Double,Double)

-- Cajas de colision
type Caja = (Double,Double,Double,Double)

--Lado de colision
data Lado = Arriba | Abajo | Izquierda | Derecha
    deriving Show


-- Subtarea 1: Vectores 2D

-- Suma componente a componente dos vectores/puntos 2D.

sumaVectores :: Vector2 -> Vector2 -> Vector2
sumaVectores (x1,y1) (x2,y2) = (x1 + x2, y1 + y2)

-- Multiplica un vector/punto 2D por un factor escalar.

escalarVector :: Double -> Vector2 -> Vector2
escalarVector n (x,y) = (n*x,n*y)

-- Calcula la distancia euclídea entre dos puntos 2D.

distancia :: Vector2 -> Vector2 -> Double
distancia (x1,y1) (x2,y2) = sqrt((x2-x1)**2 + (y2-y1)**2)

-- Subtarea 2: Cajas de colision

-- Las Cajas tienen unas cordenadas x,y, un ancho y un alto
-- Dos cajas se solapan si se pisan a la vez en x y en y
-- Se solapan si el primero empieza antes de que acabe el segundo y el segundo empieza antes de que de que acabe el primero
-- En el eje x: caja(x---w) 
-- En el eje y: caja(y---h)


solapan :: Caja -> Caja -> Bool
solapan (x1,y1,w1,h1) (x2,y2,w2,h2) = solapaX && solapaY
    where
        solapaX = x1 < x2 + w2 && x2 < x1 + w1
        solapaY = y1 < y2 + h2 && y2 < y1 + h1

-- Subtarea 3: Lado de colision

--Dadas dos cajas que ya colisionan, se pide determinar por qué lado es más superficial el solape (ese es el lado por el que efectivamente se produjo el contacto).

-- Calculamos por cordenadas cada lado

-- Lado izquierdo --> (x1 + w1) - x2
-- Lado derecho --> (x2 + w2) - x1 
-- Lado inferior --> (y1 + h1) - y2
-- Lado superior --> (y2 + h2) - y1 

ladoColision :: Caja -> Caja -> Lado
ladoColision (x1,y1,w1,h1) (x2,y2,w2,h2)
    | menor == solapeArriba = Arriba
    | menor == solapeAbajo = Abajo
    | menor == solapeDerecha = Derecha
    | otherwise = Izquierda



    where
        solapeArriba = (y2 + h2) - y1 -- Cuando la primera se hunde en la cara superior de la segunda
        solapeAbajo = (y1 + h1) - y2 -- Cuando la primera se hunde en la cara inferior de la segunda
        solapeDerecha = (x2 + w2) - x1 -- Cuando la primera se hunde en la cara derecha de la segunda
        solapeIzquierda = (x1 + w1) - x2 -- Cuando la primera se hunde en la cara izquierda de la segunda
        menor = minimum [solapeArriba,solapeAbajo,solapeDerecha,solapeIzquierda] -- Para hacer mas corto el codigo definimos una variable que nos de el minimo de todos los solapamientos



-- Ej4. Utilidades de listas y cadenas
-- Función: splitOn. Divide una cadena en trozos cada vez que aparece un carácter separador dado.
-- DISCLAIMER: Al testearlo, cuidado con copiar y pegar del pdf que se copian mal las comillas del Char, poner esto: ''
splitOn :: Char -> String -> [String]
splitOn separador cadena = lines ([if c == separador then '\n' else c | c <- cadena])


-- Función: trim. Elimina los espacios en blanco (espacios, tabuladores, saltos de línea) al principio y al final de una cadena.
trim :: String -> String
trim cadena
  | null posiciones = ""
  | otherwise = drop (head posiciones) (take (last posiciones + 1) cadena) -- take los n=(ultimo numero calculado en posiciones) de la cadena para eliminar el ultimo hueco y luego drop los n=(primer numero calculado en posiciones)
  where
    posiciones = [i | (c, i) <- zip cadena [0..], not (esBlanco c)] -- Se saca lista como este ejemplo [('h',1),('o',2),('l',3),('a',4)] quedandote al fianl solo con las i [1,2,3,4]
                                                                                                    --take las 4+1 primeras posiciones " hola"
                                                                                                    --drop a la 1 posicion del imput "hola"
esBlanco :: Char -> Bool
esBlanco ' ' = True
esBlanco '\t' = True
esBlanco '\n' = True
esBlanco _  = False

-- Función: contarSiCumple. Cuenta cuántos elementos de una lista cumplen una condición dada.
contarSiCumple :: (a -> Bool) -> [a] -> Int
contarSiCumple condicion xs = length [x | x <- xs, condicion x]


-- Función: list2Vector2. Convierte una lista de dos (o más) números en un vector/punto 2D; lanza un error si la lista no tiene al menos dos elementos.
list2Vector2 :: [Double] -> Vector2
list2Vector2 [_]     = error "Falta un elemento en la lista para convertir en Vector2"
list2Vector2 []      = error "Lista vacia no posible convertir en Vector2"
list2Vector2 (x:y:_) = (x, y)

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

-- Ejercicio 5:

-- Función posicionesEnemigos:
-- La función recibe un nivel y devuelve una lista de tuplas que contiene el número de la fila y la columna seguido del enemigo
-- Usamos zip para asignarle una posición tanto a filas como a columnas y los recorremos, además utilizamos "esEnemigo" para filtrarlas

posicionesEnemigos :: Grid -> [(Int,Int,String)]
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

-- ---------------------------------------------------------------------
-- 6. Bonus: propiedades con QuickCheck                (hasta +1 punto)
-- ---------------------------------------------------------------------
-- Criterio general para elegir las propiedades:
--   * Que digan algo del juego (movimiento, colisiones, lectura del
--     nivel), no propiedades matemáticas porque sí.
--   * Que se cumplan para CUALQUIER entrada que genere QuickCheck, sin
--     tener que construir casos especiales a mano.
--   * Solo funciones que no lanzan error y se pueden comparar con ==.


-- Sumar dos vectores da lo mismo en cualquier orden.
-- Por qué: en el juego la nueva posición es posición + velocidad. Da igual
-- si se escribe sumaVectores pos vel o sumaVectores vel pos; si no fuera
-- conmutativa, Mario se movería distinto según cómo se escriba la llamada.
prop_suma_conmutativa :: Vector2 -> Vector2 -> Bool
prop_suma_conmutativa a b = sumaVectores a b == sumaVectores b a
-- ghci> quickCheck prop_suma_conmutativa
-- +++ OK, passed 100 tests.


-- Escalar un vector por 1 lo deja igual.
-- Por qué: escalarVector se usa para multiplicadores de velocidad
-- (power-ups, frenar, etc.). Con factor 1 (sin power-up) Mario no puede
-- cambiar de velocidad. Elijo el 1 y no otro factor porque es el único
-- caso en que se sabe exactamente el resultado sin hacer la cuenta.
prop_escalar_neutro :: Vector2 -> Bool
prop_escalar_neutro v = escalarVector 1 v == v
-- ghci> quickCheck prop_escalar_neutro
-- +++ OK, passed 100 tests.


-- La distancia de a a b es igual que de b a a.
-- Por qué: la distancia se usa, por ejemplo, para saber si un enemigo está
-- cerca de Mario. La distancia Mario-enemigo tiene que ser la misma que la
-- enemigo-Mario; si no, el enemigo podría "ver" a Mario sin que Mario
-- esté cerca de él. Comprueba también que el orden de las restas
-- (x2 - x1 o x1 - x2) no afecta, porque se elevan al cuadrado.
prop_distancia_simetrica :: Vector2 -> Vector2 -> Bool
prop_distancia_simetrica a b = distancia a b == distancia b a
-- ghci> quickCheck prop_distancia_simetrica
-- +++ OK, passed 100 tests.


-- La distancia entre dos puntos nunca es negativa.
-- Por qué: en el juego se compara la distancia con un radio
-- (distancia < radio => enemigo cerca). Una distancia negativa siempre
-- sería "cerca" y rompería esa lógica. Con QuickCheck se prueban también
-- coordenadas negativas, que en el nivel no salen a mano pero sí al moverse.
prop_distancia_no_negativa :: Vector2 -> Vector2 -> Bool
prop_distancia_no_negativa a b = distancia a b >= 0
-- ghci> quickCheck prop_distancia_no_negativa
-- +++ OK, passed 100 tests.


-- solapan a b es igual que solapan b a.
-- Por qué: es la propiedad más importante para las colisiones. Si Mario
-- choca con un Goomba, el Goomba tiene que chocar con Mario. Si no fuera
-- simétrica, el resultado dependería del orden de los argumentos y uno
-- de los dos "atravesaría" al otro.
prop_solapan_simetrica :: Caja -> Caja -> Bool
prop_solapan_simetrica a b = solapan a b == solapan b a
-- ghci> quickCheck prop_solapan_simetrica
-- +++ OK, passed 100 tests.


-- Aplicar trim dos veces da el mismo resultado que aplicarlo una vez.
-- Por qué: trim limpia las líneas del archivo del nivel antes de parsearlas.
-- Si una línea ya limpia se volviera a recortar, se perderían celdas del
-- mapa. La idempotencia asegura que limpiar de más no estropea nada.
-- Ojo: NO sirve comparar trim s == trim s, porque eso es siempre cierto
-- y no comprueba nada de la función.
prop_trim_idempotente :: String -> Bool
prop_trim_idempotente s = trim (trim s) == trim s
-- ghci> quickCheck prop_trim_idempotente
-- +++ OK, passed 100 tests.


-- Si el separador no aparece en la cadena, splitOn devuelve una lista con
-- un único elemento: la propia cadena.
-- Por qué: splitOn se usa para trocear datos del nivel (por ejemplo "3,4").
-- Si una línea no tiene separador no se debe perder ni inventar nada.
-- Uso ==> (y por eso devuelve Property) para descartar los casos en que
-- sep sí aparece en s, porque ahí la propiedad no tiene que cumplirse.
-- Incluye la cadena vacía: splitOn ',' "" debe dar [""] y no [].
prop_splitOn_sin_separador :: Char -> String -> Property
prop_splitOn_sin_separador sep s = not (elem sep s) ==> splitOn sep s == [s]
-- ghci> quickCheck prop_splitOn_sin_separador
-- *** Failed! Falsified (after 1 test and 1 shrink):
-- 'a'
-- ""
-- Falla con el splitOn de master (usa lines, y lines "" = []).
-- Se arregla añadiendo ++ "\n" antes de llamar a lines.


-- Sumar en un orden u otro da el mismo resultado: (a + b) + c == a + (b + c).
-- Por qué: en un frame se acumulan varias fuerzas (posición + velocidad +
-- gravedad), y el orden en que se suman no debería importar. La dejo aunque
-- falla, porque el fallo enseña algo importante para el motor del juego.
-- Resultado: QuickCheck la REFUTA (es una propiedad que no se cumple):
prop_suma_asociativa :: Vector2 -> Vector2 -> Vector2 -> Bool
prop_suma_asociativa a b c = sumaVectores (sumaVectores a b) c == sumaVectores a (sumaVectores b c)
-- ghci> quickCheck prop_suma_asociativa      (con Vector2 = (Float, Float))
-- *** Failed! Falsified (after 6 tests and 10 shrinks):
-- (2.0,0.0)
-- (2.0,0.0)
-- (0.603,0.0)
-- Falla por el redondeo de la coma flotante: (2+2)+0.603 = 4.603,
-- pero 2+(2+0.603) = 4.6029997. Con Double pasa lo mismo (solo cambia el
-- contraejemplo); con Int sí se cumpliría.
-- Conclusión para el juego: las posiciones no se deben comparar con ==,
-- sino con un margen de tolerancia.
