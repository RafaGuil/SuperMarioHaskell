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

import Tipos (Vector2, EstadoJuego(..), sumaVectores, escalarVector)
import Objeto (Objeto(..))

-- | Registro que modela el estado físico y de progresión del jugador.
data Jugador = Jugador
    { posJugador :: Vector2
    , velJugador :: Vector2
    , vidas      :: Int
    , puntuacion :: Int
    } deriving (Eq, Show)

-- | Crea un jugador inicial en la posición dada con velocidad nula, 3 vidas y 0 puntos.
crearJugador :: Vector2 -> Jugador
crearJugador pos = Jugador
    { posJugador = pos
    , velJugador = (0.0, 0.0)
    , vidas = 3
    , puntuacion = 0
    }

-- | Reduce en 1 las vidas del jugador mediante actualización de registro, asegurando que nunca bajen de 0.
perderVida :: Jugador -> Jugador
perderVida j = j { vidas = max 0 (vidas j - 1) }

-- | Suma una cantidad de puntos a la puntuación actual del jugador.
sumarPuntos :: Int -> Jugador -> Jugador
sumarPuntos pts j = j { puntuacion = puntuacion j + pts }

-- | Actualiza la velocidad del jugador mediante actualización de registro.
conVelocidad :: Vector2 -> Jugador -> Jugador
conVelocidad vel j = j { velJugador = vel }

-- | Mueve al jugador en función del tiempo transcurrido (dt) y su velocidad actual.
moverJugador :: Float -> Jugador -> Jugador
moverJugador dt j = j 
    { posJugador = sumaVectores (posJugador j) (escalarVector dt (velJugador j)) }

-- | Determina el estado siguiente del juego en función del jugador actualizado y los eventos del frame.
estadoSiguiente :: Jugador -> Bool -> Bool -> EstadoJuego
estadoSiguiente j recibioDaño tocaMeta
    | vidas j <= 0 = GameOver
    | recibioDaño = PierdeVida
    | tocaMeta = NivelCompletado
    | otherwise = Jugando

-- | Instancia de la clase Objeto para el Jugador, definiendo su posición y caja de colisión.
instance Objeto Jugador where
    posicion j = posJugador j
    boundingBox j = 
        let (x, y) = posJugador j
        in (x - 30, y, 60, 90)
