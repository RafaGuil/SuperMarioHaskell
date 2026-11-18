-- Pila.hs
-- El TAD de las pilas mediante tipos de datos algebraicos.
-- Departamento de Ciencias de la Computación e I.A.
-- Universidad de Sevilla
-- =====================================================================

module Pila
  (Pila,
   vacia,      -- Pila a
   apila,      -- a -> Pila a -> Pila a
   cima,       -- Pila a -> a
   desapila,   -- Pila a -> Pila a
   esVacia     -- Pila a -> Bool
  ) where

data Pila a = Vacia
            | P a (Pila a)
  deriving Eq

instance Show a => Show (Pila a) where
  show Vacia   = "-"
  show (P x p) = show x ++ "|" ++ show p

vacia :: Pila a
vacia = Vacia

apila :: a -> Pila a -> Pila a
apila x p = P x p

cima :: Pila a -> a
cima Vacia   = error "cima: pila vacia"
cima (P x _) = x

desapila :: Pila a -> Pila a
desapila Vacia   = error "desapila: pila vacia"
desapila (P _ p) = p

esVacia :: Pila a -> Bool
esVacia Vacia = True
esVacia _     = False
