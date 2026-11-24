module Ficheros
    ( ficheroPartida
    , ficheroLeaderboard
    , rutaNivel
    , leerLineas
    , cargarNivel
    , resumenNivel
    , guardarPartida
    , cargarPartida
    , leerLeaderboard
    , registrarPuntuacion
    ) where

import Control.Exception (catch, IOException)
import Data.Maybe (fromMaybe)

import Matriz (dimensiones, posicionesDe, metaAlcanzable)
import Nivel (ErrorNivel(..), NivelData(..), parsearNivelCompleto)
import Partida (Partida, Entrada, serializarPartida, parsearPartida, parsearLeaderboard, serializarEntrada)
import Ranking (mejorPorJugador, ranking)
import Tipos (esSolido, esEnemigo)

-- Fichero donde se guarda la partida.
ficheroPartida :: FilePath
ficheroPartida = "partida.txt"

-- Fichero de la tabla de puntuaciones.
ficheroLeaderboard :: FilePath
ficheroLeaderboard = "leaderboard.txt"

-- Ruta del fichero del nivel n.
rutaNivel :: Int -> FilePath
rutaNivel n = "levels/" ++ show n ++ "/nivel.txt"

-- Líneas del fichero sin '\r' (lectura forzada), o el mensaje de la IOException.
leerLineas :: FilePath -> IO (Either String [String])
leerLineas ruta = leer `catch` manejar
  where
    leer = do
        contenido <- readFile ruta
        length contenido `seq` return (Right (map (filter (/= '\r')) (lines contenido)))
    manejar :: IOException -> IO (Either String [String])
    manejar e = return (Left (show e))

-- Lee un nivel y lo interpreta; un fallo de lectura es ErrorFichero.
cargarNivel :: FilePath -> IO (Either ErrorNivel NivelData)
cargarNivel ruta = either (Left . ErrorFichero) parsearNivelCompleto <$> leerLineas ruta

-- Imprime un resumen de 5 líneas del nivel, o "Error: " y el error.
resumenNivel :: FilePath -> IO ()
resumenNivel ruta = do
    r <- cargarNivel ruta
    case r of
        Left e   -> putStrLn ("Error: " ++ show e)
        Right nd -> do
            let m      = matrizNivel nd
                (f, c) = dimensiones m
            putStrLn ("Nivel: " ++ nombreNivel nd)
            putStrLn ("Tamaño: " ++ show f ++ " filas x " ++ show c ++ " columnas")
            putStrLn ("Celdas sólidas: " ++ show (length (posicionesDe esSolido m)))
            putStrLn ("Enemigos: " ++ show (length (posicionesDe esEnemigo m))
                      ++ " (tipos: " ++ unwords (tiposEnemigo nd) ++ ")")
            putStrLn ("Meta alcanzable desde (0,0): " ++ show (metaAlcanzable m (0, 0)))

-- Escribe la partida en el fichero.
guardarPartida :: FilePath -> Partida -> IO ()
guardarPartida ruta p = writeFile ruta (unlines (serializarPartida p))

-- Lee la partida guardada; Nothing si no existe o es inválida.
cargarPartida :: FilePath -> IO (Maybe Partida)
cargarPartida ruta = either (const Nothing) parsearPartida <$> leerLineas ruta

-- Lee la tabla de puntuaciones; [] si no existe o es inválida.
leerLeaderboard :: FilePath -> IO [Entrada]
leerLeaderboard ruta = either (const []) (fromMaybe [] . parsearLeaderboard) <$> leerLineas ruta

-- Añade una entrada, deja la mejor de cada jugador y las 10 mejores, reescribe el fichero y devuelve la tabla.
registrarPuntuacion :: FilePath -> Entrada -> IO [Entrada]
registrarPuntuacion ruta e = do
    es <- leerLeaderboard ruta
    let tabla = ranking 10 (mejorPorJugador (e : es))
    writeFile ruta (unlines (map serializarEntrada tabla))
    return tabla
