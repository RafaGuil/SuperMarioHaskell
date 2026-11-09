-- Dibujo del mundo con Gloss (funciones puras que devuelven Picture).
module Render
  ( dibujarObjeto, dibujarHUD, mensajeEstado, dibujarMundo
  ) where

import Graphics.Gloss

-- Jugador es un tipo abstracto: importamos el nombre del tipo sin cualificar y sus selectores
-- cualificados con J., para que se vea que solo usamos la interfaz pública del módulo Jugador.
import Jugador (Jugador)
import qualified Jugador as J
import Mundo (Mundo(..))
import Objeto (Objeto(boundingBox))
import Tipos (EstadoJuego(..))

-- Rectángulo sólido del color dado con el tamaño y posición de la caja del objeto.
dibujarObjeto :: Objeto a => Color -> a -> Picture
dibujarObjeto col o = translate (x + w / 2) (y + h / 2) (color col (rectangleSolid w h))
  where (x, y, w, h) = boundingBox o

-- Texto fijo con las vidas y los puntos del jugador.
dibujarHUD :: Jugador -> Picture
dibujarHUD j = translate (-380) 270 (scale 0.15 0.15 (text txt))
  where txt = "Vidas: " ++ show (J.vidas j) ++ "   Puntos: " ++ show (J.puntuacion j)

-- Mensaje a mostrar según el estado (Nothing si se está jugando).
mensajeEstado :: EstadoJuego -> Maybe String
mensajeEstado Jugando         = Nothing
mensajeEstado PierdeVida      = Just "PIERDE VIDA (R para reiniciar)"
mensajeEstado GameOver        = Just "GAME OVER"
mensajeEstado NivelCompletado = Just "NIVEL COMPLETADO"

-- Escena con cámara que sigue al jugador, HUD fijo y mensaje de estado.
dibujarMundo :: Mundo -> Picture
dibujarMundo m = Pictures ([escena, dibujarHUD j] ++ mensaje)
  where
    j        = jugadorM m
    (px, py) = J.posJugador j
    escena   = translate (-px) (-py) $ Pictures $
                 map (dibujarObjeto (greyN 0.5)) (plataformasM m)
              ++ map (dibujarObjeto green) (metasM m)
              ++ map (dibujarObjeto red) (enemigosM m)
              ++ [dibujarObjeto blue j]
    mensaje  = maybe [] (\msg -> [translate (-250) 0 (scale 0.3 0.3 (color black (text msg)))])
                        (mensajeEstado (estadoM m))