module Objeto (
    BoundingBox,
    Plataforma(..),
    Meta(..),
    Objeto(..),
    solapan,
    colisionaCon,
    colisionaConAlguno
) where

import Tipos (Vector2, sumaVectores, escalarVector, Jugador, Enemigo)

-- Representa una caja de colisión con el formato (x_izq, y_inf, ancho, alto).
type BoundingBox = (Double, Double, Double, Double)

-- Representa una plataforma estática en el mundo mediante su caja de colisión.
data Plataforma = Plataforma BoundingBox deriving (Eq, Show)

-- Representa la meta del nivel indicando su posición central.
data Meta = Meta { posMeta :: Vector2 } deriving (Eq, Show)

-- Clase de tipos para unificar los objetos físicos del juego.
class Objeto a where
    -- Devuelve la posición central del objeto.
    posicion    :: a -> Vector2
    -- Devuelve la caja de colisión del objeto.
    boundingBox :: a -> BoundingBox
    -- Actualiza el estado del objeto en función del tiempo transcurrido dt (por defecto no hace nada).
    animar      :: Float -> a -> a
    animar _ = id

-- Instancia de Objeto para Plataforma: calcula su centro y devuelve su propia caja.
instance Objeto Plataforma where
    posicion (Plataforma (x, y, w, h)) = (x + w/2, y + h/2)
    boundingBox (Plataforma caja) = caja

-- Instancia de Objeto para Meta: su caja tiene un tamaño fijo de 70x80 centrada en su posMeta.
instance Objeto Meta where
    posicion = posMeta
    boundingBox m = let (x, y) = posMeta m in (x, y, 70, 80)

-- Instancia de Objeto para Jugador: su caja es de 60x90 desplazada -30 en X para centrarla.
instance Objeto Jugador where
    posicion = posJugador
    boundingBox j = let (x, y) = posJugador j in (x - 30, y, 60, 90)

-- Instancia de Objeto para Enemigo: su caja usa sus dimensiones y 'animar' actualiza su posición con su velocidad.
instance Objeto Enemigo where
    posicion = posEnemigo
    boundingBox e = 
        let (x, y) = posEnemigo e
            (w, h) = dimEnemigo e
        in (x - w/2, y - h/2, w, h)
    animar dt e = e { posEnemigo = sumaVectores (posEnemigo e) (escalarVector (realToFrac dt) (velEnemigo e)) }

-- Comprueba si dos cajas de colisión se solapan simultáneamente en ambos ejes.
solapan :: BoundingBox -> BoundingBox -> Bool
solapan (x1, y1, w1, h1) (x2, y2, w2, h2) =
  let solapeX = x1 < x2 + w2 && x1 + w1 > x2
      solapeY = y1 < y2 + h2 && y1 + h1 > y2
  in solapeX && solapeY

-- Determina si dos objetos cualesquiera del mundo están colisionando usando sus respectivas cajas envolventes.
colisionaCon :: (Objeto a, Objeto b) => a -> b -> Bool
colisionaCon objA objB = solapan (boundingBox objA) (boundingBox objB)

-- Comprueba si un objeto determinado colisiona con al menos un elemento de una lista de objetos.
colisionaConAlguno :: (Objeto a, Objeto b) => a -> [b] -> Bool
colisionaConAlguno obj = any (colisionaCon obj)