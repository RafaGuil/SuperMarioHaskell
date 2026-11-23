{-# LANGUAGE ViewPatterns #-}

module Clientes
  ( cimaSegura
  , elementos
  , vistaPila
  , invierte
  , evaluaRPN
  , vistaCola
  , longitud
  , concatena
  ) where

import qualified Pila as P
import qualified Cola as C
import Text.Read (readMaybe)

-- Subtarea 1:

-- Descompone una pila en su cima y el resto, o Nothing si está vacía.
vistaPila :: P.Pila a -> Maybe (a, P.Pila a)
vistaPila p
  | P.esVacia p = Nothing
  | otherwise   = Just (P.cima p, P.desapila p)

-- Devuelve la cima de la pila envuelta en Just, o Nothing si está vacía.
cimaSegura :: P.Pila a -> Maybe a
cimaSegura (vistaPila -> Just (x, _)) = Just x
cimaSegura _                          = Nothing

-- Extrae los elementos de una pila en una lista desde la cima hasta el fondo.
elementos :: P.Pila a -> [a]
elementos (vistaPila -> Just (x, p)) = x : elementos p
elementos _                          = []

-- Invierte el orden de los elementos de una pila usando patrones de vista.
invierte :: P.Pila a -> P.Pila a
invierte = aux P.vacia
  where
    aux :: P.Pila a -> P.Pila a -> P.Pila a
    aux acc (vistaPila -> Just (x, p)) = aux (P.apila x acc) p
    aux acc _                          = acc

-- Evalúa una expresión aritmética con case of
evaluaRPN :: String -> Maybe Int
evaluaRPN expr = procesar P.vacia (words expr)
  where
    procesar :: P.Pila Int -> [String] -> Maybe Int
    procesar (vistaPila -> Just (res, resto)) []
      | P.esVacia resto = Just res
      | otherwise       = Nothing
    procesar _ [] = Nothing
    procesar p (tok:toks) = case tok of
      "+" -> aplicaOp (+) p toks
      "-" -> aplicaOp (-) p toks
      "*" -> aplicaOp (*) p toks
      _   -> case readMaybe tok of
               Just n  -> procesar (P.apila n p) toks
               Nothing -> Nothing

    aplicaOp :: (Int -> Int -> Int) -> P.Pila Int -> [String] -> Maybe Int
    aplicaOp op (vistaPila -> Just (y, vistaPila -> Just (x, resto))) toks =
      procesar (P.apila (op x y) resto) toks
    aplicaOp _ _ _ = Nothing

-- Subtarea 2

-- Descompone una cola en su primer elemento y el resto, o Nothing si está vacía.
vistaCola :: C.Cola a -> Maybe (a, C.Cola a)
vistaCola c
  | C.esVacia c = Nothing
  | otherwise   = Just (C.primero c, C.resto c)

-- Calcula el número de elementos almacenados en una cola.
longitud :: C.Cola a -> Int
longitud (vistaCola -> Just (_, c)) = 1 + longitud c
longitud _                          = 0

-- Concatena dos colas dejando los elementos de la primera seguidos de los de la segunda.
concatena :: C.Cola a -> C.Cola a -> C.Cola a
concatena c1 (vistaCola -> Just (x, c2)) = concatena (C.inserta x c1) c2
concatena c1 _                           = c1