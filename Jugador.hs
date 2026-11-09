module Jugador 
    ( Jugador
    , posJugador
    , velJugador
    , vidas
    , puntuacion
    , crearJugador
    , perderVida
    , sumarPuntos
    , conVelocidad
    , moverJugador
    , estadoSiguiente
    ) where

import Tipos (Vector2, BoundingBox, EstadoJuego(..), sumaVectores, escalarVector)
import Objeto (Objeto(..))

data Jugador = Jugador
    { posJugador :: Vector2
    , velJugador :: Vector2
    , vidas      :: Int
    , puntuacion :: Int
    } deriving (Eq, Show)

crearJugador :: Vector2 -> Jugador
crearJugador pos = Jugador
    { posJugador = pos
    , velJugador = (0.0, 0.0)
    , vidas      = 3
    , puntuacion = 0
    }

perderVida :: Jugador -> Jugador
perderVida j = j { vidas = max 0 (vidas j - 1) }

sumarPuntos :: Int -> Jugador -> Jugador
sumarPuntos pts j = j { puntuacion = puntuacion j + pts }

conVelocidad :: Vector2 -> Jugador -> Jugador
conVelocidad vel j = j { velJugador = vel }

moverJugador :: Float -> Jugador -> Jugador
moverJugador dt j = j 
    { posJugador = sumaVectores (posJugador j) (escalarVector (realToFrac dt) (velJugador j)) }

estadoSiguiente :: Jugador -> Bool -> Bool -> EstadoJuego
estadoSiguiente j recibioDaño tocaMeta
    | vidas j <= 0 = GameOver
    | recibioDaño = PierdeVida
    | tocaMeta = NivelCompletado
    | otherwise = Jugando

instance Objeto Jugador where
    posicion j = posJugador j
    boundingBox j = 
        let (x, y) = posJugador j
        in (x - 30, y, 60, 90)
