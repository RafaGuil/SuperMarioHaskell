module Dic
  ( Dic
  , vacio
  , inserta
  , busca
  , borra
  , esVacio
  , claves
  , aLista
  , deLista
  ) where

import Data.List (intercalate)

-- Árbol binario de búsqueda: las claves del subárbol izquierdo son menores
-- que la raíz y las del subárbol derecho son mayores.
data Dic k v = H | N (Dic k v) k v (Dic k v)

-- Compara dos diccionarios según sus pares clave-valor ordenados.
instance (Eq k, Eq v) => Eq (Dic k v) where
  d1 == d2 = aLista d1 == aLista d2

-- Muestra el diccionario con el formato {clave1:valor1, clave2:valor2}.
instance (Show k, Show v) => Show (Dic k v) where
  show d = "{" ++ intercalate ", " [show k ++ ":" ++ show v | (k, v) <- aLista d] ++ "}"

-- Devuelve un diccionario vacío.
vacio :: Dic k v
vacio = H

-- Comprueba si un diccionario no contiene elementos.
esVacio :: Dic k v -> Bool
esVacio H = True
esVacio _ = False

-- Inserta un par clave-valor en el diccionario; si la clave existe, actualiza su valor.
inserta :: Ord k => k -> v -> Dic k v -> Dic k v
inserta x y H = N H x y H
inserta x y (N i k v d)
  | x < k     = N (inserta x y i) k v d
  | x > k     = N i k v (inserta x y d)
  | otherwise = N i k y d

-- Busca el valor asociado a una clave en el diccionario.
busca :: Ord k => k -> Dic k v -> Maybe v
busca _ H = Nothing
busca x (N i k v d)
  | x < k     = busca x i
  | x > k     = busca x d
  | otherwise = Just v

-- Elimina una clave y su valor del diccionario; si no está, lo deja sin cambios.
borra :: Ord k => k -> Dic k v -> Dic k v
borra _ H = H
borra x (N i k v d)
  | x < k     = N (borra x i) k v d
  | x > k     = N i k v (borra x d)
  | otherwise = une i d

-- Une dos subárboles de búsqueda sustituyendo la raíz borrada por el mínimo derecho.
une :: Dic k v -> Dic k v -> Dic k v
une H d = d
une i H = i
une i d = N i km vm (borraMin d)
  where
    (km, vm) = minimo d

-- Obtiene el par clave-valor con menor clave de un diccionario no vacío.
minimo :: Dic k v -> (k, v)
minimo (N H k v _) = (k, v)
minimo (N i _ _ _) = minimo i
minimo H           = error "minimo: diccionario vacio"

-- Elimina el nodo con menor clave de un diccionario.
borraMin :: Dic k v -> Dic k v
borraMin (N H _ _ d) = d
borraMin (N i k v d) = N (borraMin i) k v d
borraMin H           = H

-- Devuelve una lista con las claves del diccionario en orden creciente.
claves :: Dic k v -> [k]
claves = map fst . aLista

-- Devuelve los pares clave-valor del diccionario ordenados crecientemente por clave.
aLista :: Dic k v -> [(k, v)]
aLista H           = []
aLista (N i k v d) = aLista i ++ [(k, v)] ++ aLista d

-- Construye un diccionario a partir de una lista de pares, prevaleciendo el último si hay claves repetidas.
deLista :: Ord k => [(k, v)] -> Dic k v
deLista = foldl (\acc (k, v) -> inserta k v acc) vacio