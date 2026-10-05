-- =====================================================================
-- Tarea 1: Lógica pura del motor de niveles y colisiones
-- Programación Declarativa — Curso 2026/2027
-- Autor: José Manuel Mesonero
-- Parte: Subtarea 6 — Bonus: propiedades con QuickCheck
-- =====================================================================
--
-- Criterio general para elegir las propiedades:
--   * Que digan algo del juego (movimiento, colisiones, lectura del
--     nivel), no propiedades matemáticas porque sí.
--   * Que se cumplan para CUALQUIER entrada que genere QuickCheck, sin
--     tener que construir casos especiales a mano.
--   * Solo funciones que no lanzan error y se pueden comparar con ==.
-- =====================================================================

module Nivel where

import Test.QuickCheck

-- ---------------------------------------------------------------------
-- 6. Bonus: propiedades con QuickCheck                (hasta +1 punto)
-- ---------------------------------------------------------------------

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
-- +++ OK, passed 100 tests.


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
