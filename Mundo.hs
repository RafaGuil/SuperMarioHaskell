-- Estado del mundo del juego y su paso de simulación.
module Mundo
  ( Mundo(..)
  , mundoInicial, actualizarMundo, manejarEvento
  ) where

import Graphics.Gloss.Interface.Pure.Game (Event(..), Key(..), KeyState(..), SpecialKey(..))

import Jugador (Jugador, conVelocidad, crearJugador, moverJugador, perderVida, estadoSiguiente, velJugador)
import Nivel (NivelData(..), enemigosDesdeGrid, gridAPlataformas, metasDesdeGrid)
import Objeto (Enemigo, Meta, Plataforma, animar, colisionaConAlguno)
import Tipos (EstadoJuego(..), Vector2)

-- Todo lo que existe en el mundo en un instante.
data Mundo = Mundo
  { jugadorM     :: Jugador
  , enemigosM    :: [Enemigo]
  , plataformasM :: [Plataforma]
  , metasM       :: [Meta]
  , estadoM      :: EstadoJuego
  , nivelM       :: NivelData
  } deriving (Eq, Show)

-- Mundo de partida para un nivel dado.
mundoInicial :: NivelData -> Mundo
mundoInicial nd = Mundo
  { jugadorM     = crearJugador (60, 120)
  , enemigosM    = enemigosDesdeGrid g
  , plataformasM = gridAPlataformas g
  , metasM       = metasDesdeGrid g
  , estadoM      = Jugando
  , nivelM       = nd
  }
  where g = gridNivel nd

-- Avanza dt segundos: mueve jugador y enemigos, detecta daño y meta, y actualiza el estado.
actualizarMundo :: Float -> Mundo -> Mundo
actualizarMundo dt m
  | estadoM m /= Jugando = m
  | otherwise = m { jugadorM = jugador', enemigosM = enemigos', estadoM = estadoSiguiente jugador' dano toca }
  where
    movido     = moverJugador dt (jugadorM m)
    enemigos'  = map (animar dt) (enemigosM m)
    dano       = colisionaConAlguno movido enemigos'
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
