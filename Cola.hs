-- Cola.hs
-- El TAD de las colas mediante dos listas (misma interfaz que ColaL).
-- Departamento de Ciencias de la Computación e I.A.
-- Universidad de Sevilla
-- =====================================================================

module Cola
  (Cola,
   vacia,     -- Cola a
   inserta,   -- a -> Cola a -> Cola a
   primero,   -- Cola a -> a
   resto,     -- Cola a -> Cola a
   esVacia    -- Cola a -> Bool
  ) where

-- C fs ts representa la cola fs ++ reverse ts.
-- Invariante: si fs es vacía, entonces ts también lo es.
data Cola a = C [a] [a]

-- normaliza restablece el invariante (no se exporta).
normaliza :: [a] -> [a] -> Cola a
normaliza [] ts = C (reverse ts) []
normaliza fs ts = C fs ts

aLista :: Cola a -> [a]
aLista (C fs ts) = fs ++ reverse ts

-- La igualdad compara las colas, no sus representaciones.
instance Eq a => Eq (Cola a) where
  c1 == c2 = aLista c1 == aLista c2

instance Show a => Show (Cola a) where
  show c = "<" ++ concatMap (\x -> show x ++ "<") (aLista c)

vacia :: Cola a
vacia = C [] []

inserta :: a -> Cola a -> Cola a
inserta x (C fs ts) = normaliza fs (x:ts)

primero :: Cola a -> a
primero (C [] _)    = error "primero: cola vacia"
primero (C (x:_) _) = x

resto :: Cola a -> Cola a
resto (C [] _)      = error "resto: cola vacia"
resto (C (_:fs) ts) = normaliza fs ts

esVacia :: Cola a -> Bool
esVacia (C fs _) = null fs      -- por el invariante
