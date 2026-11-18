module Dic
  ( Dic
  ) where

-- Árbol binario de búsqueda, con el invariante «las claves del hijo izquierdo son menores que la raíz y las del derecho, mayores».
data Dic k v = H | N (Dic k v) k v (Dic k v)
