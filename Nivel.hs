
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

-- Cuenta cuántos elementos de una lista cumplen una condición
--contarSiCumple :: (a -> Bool) -> [a] -> Int


-- Convierte una lista de al menos dos números en un Vector2
--list2Vector2 :: [Double] -> Vector2
