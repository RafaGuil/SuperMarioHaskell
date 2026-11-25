{-# OPTIONS_GHC -Wno-orphans #-}

module Functores () where

import qualified Pila as P
import qualified Cola as C
import qualified Dic as D

-- Instancia de Functor para Pila usando únicamente su interfaz pública.
instance Functor P.Pila where
  -- Aplica una función a cada elemento de una pila conservando su orden.
  fmap f p
    | P.esVacia p = P.vacia
    | otherwise   = P.apila (f (P.cima p)) (fmap f (P.desapila p))

-- Instancia de Functor para Cola usando únicamente su interfaz pública.
instance Functor C.Cola where
  -- Aplica una función a cada elemento de una cola manteniendo el orden FIFO.
  fmap f = aux f C.vacia
    where
      -- Recorre la cola original insertando cada elemento transformado en el acumulador.
      aux :: (a -> b) -> C.Cola b -> C.Cola a -> C.Cola b
      aux g acc c
        | C.esVacia c = acc
        | otherwise   = aux g (C.inserta (g (C.primero c)) acc) (C.resto c)

-- Instancia de Functor para Dic k transformando únicamente los valores asociados.
instance Ord k => Functor (D.Dic k) where
  -- Aplica una función a todos los valores del diccionario manteniendo sus claves.
  fmap f = D.deLista . map (\(k, v) -> (k, f v)) . D.aLista