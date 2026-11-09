-- Dibujo del mundo con Gloss (funciones puras que devuelven Picture).
module Render
  ( dibujarObjeto, dibujarHUD, mensajeEstado, dibujarMundo
  ) where

import Graphics.Gloss

import Jugador (Jugador, posJugador, puntuacion, vidas)
import Mundo (Mundo(..))
import Objeto (Objeto(boundingBox))
import Tipos (EstadoJuego(..))

-- Rectángulo sólido del color dado con el tamaño y posición de la caja del objeto.
dibujarObjeto :: Objeto a => Color -> a -> Picture
dibujarObjeto col o = translate (x + w / 2) (y + h / 2) (color col (rectangleSolid w h))
  where (x0, y0, w0, h0) = boundingBox o
        (x, y, w, h) = (realToFrac x0, realToFrac y0, realToFrac w0, realToFrac h0)

-- Texto fijo con las vidas y los puntos del jugador.
dibujarHUD :: Jugador -> Picture
dibujarHUD j = translate (-380) 270 (scale 0.15 0.15 (text txt))
  where txt = "Vidas: " ++ show (vidas j) ++ "   Puntos: " ++ show (puntuacion j)

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
    (px0, py0) = posJugador j
    (px, py) = (realToFrac px0, realToFrac py0)
    escena   = translate (-px) (-py) $ Pictures $
                 map (dibujarObjeto (greyN 0.5)) (plataformasM m)
              ++ map (dibujarObjeto green) (metasM m)
              ++ map (dibujarObjeto red) (enemigosM m)
              ++ [dibujarObjeto blue j]
    mensaje  = maybe [] (\msg -> [translate (-250) 0 (scale 0.3 0.3 (color black (text msg)))])
                        (mensajeEstado (estadoM m))