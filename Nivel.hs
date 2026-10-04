
-- Tarea 1 - Rafael Guil Valero
module Nivel where

-- Tipos 
type Vector2 = (Double, Double)

-- Ej4. Utilidades de listas y cadenas
-- Función: splitOn. Divide una cadena en trozos cada vez que aparece un carácter separador dado.
-- DISCLAIMER: Al testearlo, cuidado con copiar y pegar del pdf que se copian mal las comillas del Char, poner esto: ''
splitOn :: Char -> String -> [String]
splitOn separador cadena = lines ([if c == separador then '\n' else c | c <- cadena])


-- Función: trim. Elimina los espacios en blanco (espacios, tabuladores, saltos de línea) al principio y al final de una cadena.
trim :: String -> String


-- Cuenta cuántos elementos de una lista cumplen una condición
contarSiCumple :: (a -> Bool) -> [a] -> Int


-- Convierte una lista de al menos dos números en un Vector2
list2Vector2 :: [Double] -> Vector2
