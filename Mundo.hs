-- Estado del mundo del juego y su paso de simulación.
module Mundo
  ( Mundo(..)
  , mundoInicial, actualizarMundo, manejarEvento
  ) where

import qualified Data.Map as Map
import Graphics.Gloss.Interface.IO.Game (Event(..), Key(..), KeyState(..), SpecialKey(..))

import Jugador (Jugador, conVelocidad, moverJugador, perderVida, estadoSiguiente, velJugador)
import Nivel (NivelData(..))
import Objeto (Enemigo, Meta, Plataforma, animar, colisionaConAlguno)
import qualified Pila as P
import Sprites (Sprites)
import Tipos (EstadoJuego(..), Vector2)

-- Todo lo que existe en el mundo en un instante.
data Mundo = Mundo
  { jugadorM     :: Jugador
  , enemigosM    :: Map.Map Int Enemigo
  , plataformasM :: [Plataforma]
  , metasM       :: [Meta]
  , tiempoM      :: Float
  , estadoM      :: EstadoJuego
  , esperaM      :: Maybe Float       -- instante en que se perdió la última vida
  , nivelNum     :: Int
  , nivelM       :: NivelData
  , spritesM     :: Sprites
  , historialM   :: P.Pila Vector2    -- posiciones anteriores (para deshacer)
  , registradaM  :: Bool              -- ¿ya se anotó la puntuación final?
  } deriving (Eq, Show)

-- Mundo de partida para un nivel dado.
mundoInicial :: NivelData -> Mundo
mundoInicial = undefined

-- Avanza dt segundos: mueve jugador y enemigos, detecta daño y meta, y actualiza el estado.
actualizarMundo :: Float -> Mundo -> Mundo
actualizarMundo dt m
  | estadoM m /= Jugando = m
  | otherwise = m { jugadorM = jugador', enemigosM = enemigos', estadoM = estadoSiguiente jugador' dano toca }
  where
    movido     = moverJugador dt (jugadorM m)
    enemigos'  = Map.map (animar dt) (enemigosM m)
    dano       = colisionaConAlguno movido (Map.elems enemigos')
    toca       = colisionaConAlguno movido (metasM m)
    jugador'   = if dano then perderVida movido else movido

-- Aplica una función a la velocidad del jugador.
modificarVelocidad :: (Vector2 -> Vector2) -> Mundo -> Mundo
modificarVelocidad f m = m { jugadorM = conVelocidad (f (velJugador j)) j }
  where j = jugadorM m

-- Reacciona al teclado: flechas fijan/anulan la velocidad, 'r' reinicia el nivel.
manejarEvento :: Event -> Mundo -> Mundo
manejarEvento (EventKey (SpecialKey KeyLeft)  Down _ _) = modificarVelocidad (\(_, vy) -> (-100, vy))
manejarEvento (EventKey (SpecialKey KeyRight) Down _ _) = modificarVelocidad (\(_, vy) -> (100, vy))
manejarEvento (EventKey (SpecialKey KeyUp)    Down _ _) = modificarVelocidad (\(vx, _) -> (vx, 100))
manejarEvento (EventKey (SpecialKey KeyDown)  Down _ _) = modificarVelocidad (\(vx, _) -> (vx, -100))
manejarEvento (EventKey (SpecialKey KeyLeft)  Up   _ _) = modificarVelocidad (\(_, vy) -> (0, vy))
manejarEvento (EventKey (SpecialKey KeyRight) Up   _ _) = modificarVelocidad (\(_, vy) -> (0, vy))
manejarEvento (EventKey (SpecialKey KeyUp)    Up   _ _) = modificarVelocidad (\(vx, _) -> (vx, 0))
manejarEvento (EventKey (SpecialKey KeyDown)  Up   _ _) = modificarVelocidad (\(vx, _) -> (vx, 0))
manejarEvento (EventKey (Char 'r') Down _ _)            = \m -> mundoInicial (nivelM m)
manejarEvento _                                         = id
