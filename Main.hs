module Main (main) where

import Graphics.Gloss
import Nivel
import Mundo
import Render

-- Texto del nivel que se carga al arrancar (lo único que se puede modificar para probar otros mapas).
nivel1Lineas :: [String]
nivel1Lineas =
  [ "NOMBRE: Colinas"
  , "FONDOS: 1,2,3"
  , "---"
  , "..................M"
  , "..........A........"
  , "####.....####.#####"
  ]

-- Ventana de 800x600 en la que se dibuja el juego.
ventana :: Display
ventana = InWindow "Plataformas" (800, 600) (100, 100)

-- Interpreta el nivel y lanza el juego, o muestra el error si el nivel está mal formado.
main :: IO ()
main = case parsearNivelCompleto nivel1Lineas of
  Left err -> display ventana white (scale 0.2 0.2 (text (show err)))
  Right nd -> play ventana white 60 (mundoInicial nd) dibujarMundo manejarEvento actualizarMundo
