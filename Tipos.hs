module Tipos 
    ( Vector2
    , BoundingBox
    , Celda(..)
    , Grid
    , TipoEnemigo(..)
    , EstadoJuego(..)
    , parsearCelda
    , parsearGrid
    , celdaAChar
    , esSolido
    , esMeta
    , esEnemigo
    , sumaVectores
    , escalarVector
    ) where

type Vector2 = (Double, Double)
type Grid    = [[Celda]]

data Celda = Solido 
           | Vacio 
           | META 
           | InicioEnemigo String 
           deriving (Eq, Show)

data TipoEnemigo = Patrulla | Perseguidor deriving (Eq, Show)

data EstadoJuego = Jugando | PierdeVida | GameOver | NivelCompletado deriving (Eq, Show)

parsearCelda :: Char -> Celda
parsearCelda '#' = Solido
parsearCelda '.' = Vacio
parsearCelda 'M' = META
parsearCelda c   = InicioEnemigo [c]

parsearGrid :: [String] -> Grid
parsearGrid = map (map parsearCelda)

celdaAChar :: Celda -> Char
celdaAChar Solido = '#'
celdaAChar Vacio = '.'
celdaAChar META = 'M'
celdaAChar (InicioEnemigo (c:_)) = c
celdaAChar (InicioEnemigo []) = 'A'

esSolido :: Celda -> Bool
esSolido Solido = True
esSolido _ = False

esMeta :: Celda -> Bool
esMeta META = True
esMeta _ = False

esEnemigo :: Celda -> Bool
esEnemigo (InicioEnemigo _) = True
esEnemigo _ = False

-- Utilidades de vectores

sumaVectores :: Vector2 -> Vector2 -> Vector2
sumaVectores (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

escalarVector :: Double -> Vector2 -> Vector2
escalarVector n (x, y) = (n * x, n * y)
