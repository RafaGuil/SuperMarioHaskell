module Nivel where


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


