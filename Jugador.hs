module Jugador
  ( Jugador
  , posJugador
  , velJugador
  , vidas
  , puntuacion
  , faseAnim
  , mirandoDcha
  , agachado
  , crearJugador
  , reaparecer
  , mover
  , perderVida
  , sumarPuntos
  , conVelocidad
  , moverJugador
  , estadoSiguiente
  , dimensionesJugador
  , gravedad
  , aplicarGravedad
  , estaEnSuelo
  , moverYResolver
  , resolverCaida
  , tocaMeta
  , correr
  , pararX
  , saltar
  , agachar
  , levantar
  , elegirAccion
  , resolverColisionEnemigos
  ) where

import Tipos (Vector2, BoundingBox, EstadoJuego(..), Accion(..), sumaVectores, escalarVector)
import Objeto
  ( Objeto(..)
  , Plataforma(..)
  , Meta(..)
  , Enemigo(..)
  , colisionaCon
  , colisionaConAlguno
  , ladoColision
  , LadoColision(..)
  , vivo
  , enemigosVivos
  )
import qualified Data.Map as Map

-- Registro que representa el estado del Jugador (el constructor no se exporta)
data Jugador = Jugador
  { posJugador  :: Vector2 -- Centro del jugador
  , velJugador  :: Vector2 -- Velocidad (vx, vy)
  , vidas       :: Int
  , puntuacion  :: Int
  , faseAnim    :: Float   -- Selecciona el fotograma de animación
  , mirandoDcha :: Bool
  , agachado    :: Bool
  } deriving (Eq, Show)

-- Crea un jugador inicial
crearJugador :: Vector2 -> Int -> Int -> Jugador
crearJugador pos v pts = Jugador
  { posJugador  = pos
  , velJugador  = (0.0, 0.0)
  , vidas       = v
  , puntuacion  = pts
  , faseAnim    = 0.0
  , mirandoDcha = True
  , agachado    = False
  }

-- Reaparece al jugador en una nueva posición
reaparecer :: Vector2 -> Jugador -> Jugador
reaparecer pos j = j { posJugador = pos, velJugador = (0.0, 0.0), agachado = False }

-- Mueve la posición sumando un desplazamiento
mover :: Float -> Float -> Jugador -> Jugador
mover dx dy j = j { posJugador = (x + dx, y + dy) }
  where
    (x, y) = posJugador j

-- Resta una vida (mínimo 0)
perderVida :: Jugador -> Jugador
perderVida j = j { vidas = max 0 (vidas j - 1) }

-- Suma puntos
sumarPuntos :: Int -> Jugador -> Jugador
sumarPuntos pts j = j { puntuacion = puntuacion j + pts }

-- Asigna velocidad
conVelocidad :: Vector2 -> Jugador -> Jugador
conVelocidad vel j = j { velJugador = vel }

-- Mueve al jugador de forma continua
moverJugador :: Float -> Jugador -> Jugador
moverJugador dt j = j { posJugador = posJugador j `sumaVectores` escalarVector dt (velJugador j) }

-- Tamaño de la caja de colisión del jugador según su acción
dimensionesJugador :: Accion -> Vector2
dimensionesJugador SaltarSubiendo = (40.0, 90.0)
dimensionesJugador SaltarCayendo  = (40.0, 90.0)
dimensionesJugador Agachar        = (40.0, 90.0)
dimensionesJugador _              = (60.0, 90.0) -- Caminar o Parado

-- Estado del juego tras el frame
estadoSiguiente :: Jugador -> Bool -> Bool -> EstadoJuego
estadoSiguiente j recibioDaño tocaMeta
  | vidas j <= 0 = GameOver
  | recibioDaño  = PierdeVida
  | tocaMeta     = NivelCompletado
  | otherwise    = Jugando

instance Objeto Jugador where
  posicion = posJugador
  boundingBox j = (x - w / 2.0, y - h / 2.0, w, h)
    where
      (x, y) = posJugador j
      (w, h) = dimensionesJugador (elegirAccion j)

-- Subtarea 6: Física y Movimiento
gravedad :: Float
gravedad = -400.0

-- vy := vy + gravedad * dt
aplicarGravedad :: Float -> Jugador -> Jugador
aplicarGravedad dt j = j { velJugador = (vx, vy + gravedad * dt) }
  where
    (vx, vy) = velJugador j

-- Franja de 2 unidades de alto justo debajo de los pies
estaEnSuelo :: [Plataforma] -> Jugador -> Bool
estaEnSuelo ps j = colisionaConAlguno franjaPies ps
  where
    (x, y) = posJugador j
    (w, h) = dimensionesJugador (elegirAccion j)
    franjaPies = Plataforma (x - w / 2.0, y - h / 2.0 - 2.0, w, 2.0)

-- Resuelve el avance en dos pasos independientes (Eje X y Eje Y)
moverYResolver :: Float -> Jugador -> [Plataforma] -> Jugador
moverYResolver dt j ps = jFinal
  where
    (vx0, vy0) = velJugador j
    (px0, py0) = posJugador j

    -- 1. Eje X
    jX    = j { posJugador = (px0 + vx0 * dt, py0) }
    jXRes = resolverEjeX jX ps

    -- 2. Eje Y
    (px1, py1) = posJugador jXRes
    (_, vyX)   = velJugador jXRes
    jY         = jXRes { posJugador = (px1, py1 + vyX * dt) }
    jYRes      = resolverEjeY jY ps

    -- 3. Actualización de orientación y animación
    mirando = if vx0 > 0 then True else if vx0 < 0 then False else mirandoDcha j
    accion  = elegirAccion jYRes
    fase    = actualizarFaseAnim accion (faseAnim jYRes)

    jFinal  = jYRes { mirandoDcha = mirando, faseAnim = fase }

resolverEjeX :: Jugador -> [Plataforma] -> Jugador
resolverEjeX j ps = case filter (colisionaCon j) ps of
  [] -> j
  (Plataforma (xP, _, wP, _):_) ->
    let (vx, vy) = velJugador j
        (_, py)  = posJugador j
        (wJ, _)  = dimensionesJugador (elegirAccion j)
        nuevoX   = if vx > 0 then xP - wJ / 2.0 else xP + wP + wJ / 2.0
    in j { posJugador = (nuevoX, py), velJugador = (0.0, vy) }

resolverEjeY :: Jugador -> [Plataforma] -> Jugador
resolverEjeY j ps = case filter (colisionaCon j) ps of
  [] -> j
  (Plataforma (_, yP, _, hP):_) ->
    let (vx, vy) = velJugador j
        (px, _)  = posJugador j
        (_, hJ)  = dimensionesJugador (elegirAccion j)
        nuevoY   = if vy <= 0
                   then yP + hP + hJ / 2.0  -- Aterriza
                   else yP - hJ / 2.0       -- Golpea el techo
    in j { posJugador = (px, nuevoY), velJugador = (vx, 0.0) }

actualizarFaseAnim :: Accion -> Float -> Float
actualizarFaseAnim SaltarSubiendo f = if f < 2.0 then f + 0.1 else f
actualizarFaseAnim SaltarCayendo  f = if f < 5.0 then f + 0.1 else f
actualizarFaseAnim Caminar        f = f + 0.2
actualizarFaseAnim _              _ = 0.0

-- Caída al vacío (y < -1000)
resolverCaida :: Jugador -> (Jugador, Bool)
resolverCaida j
  | snd (posJugador j) < -1000.0 = (perderVida j, True)
  | otherwise                    = (j, False)

-- ¿Colisiona con alguna meta?
tocaMeta :: Jugador -> [Meta] -> Bool
tocaMeta j metas = colisionaConAlguno j metas

-- Modifica velocidad horizontal y orientación
correr :: Float -> Jugador -> Jugador
correr vx j = j
  { velJugador  = (vx, vy)
  , mirandoDcha = if vx > 0 then True else if vx < 0 then False else mirandoDcha j
  , agachado    = False
  }
  where
    (_, vy) = velJugador j

-- Detiene el movimiento horizontal
pararX :: Jugador -> Jugador
pararX j = j { velJugador = (0.0, vy) }
  where
    (_, vy) = velJugador j

-- Salto (vy := 300) sólo si está en el suelo
saltar :: [Plataforma] -> Jugador -> Jugador
saltar ps j
  | estaEnSuelo ps j = j { velJugador = (vx, 300.0), faseAnim = 0.0, agachado = False }
  | otherwise        = j
  where
    (vx, _) = velJugador j

-- Agachar sólo si está en el suelo
agachar :: [Plataforma] -> Jugador -> Jugador
agachar ps j
  | estaEnSuelo ps j = j { velJugador = (0.0, 0.0), agachado = True }
  | otherwise        = j

-- Levantarse
levantar :: Jugador -> Jugador
levantar j = j { agachado = False, faseAnim = 0.0 }

-- Selecciona la acción según estado de velocidades y postura
elegirAccion :: Jugador -> Accion
elegirAccion j
  | vy > 0.0   = SaltarSubiendo
  | vy < 0.0   = SaltarCayendo
  | agachado j = Agachar
  | vx == 0.0  = Parado
  | otherwise  = Caminar
  where
    (vx, vy) = velJugador j

-- Subtarea 7: Resolución de Enemigos
-- Procesa los contactos con enemigos vivos
resolverColisionEnemigos :: Float -> Jugador -> Map.Map Int Enemigo -> (Jugador, Map.Map Int Enemigo, Bool)
resolverColisionEnemigos t j enemigos = case Map.keys colisionados of
  []    -> (j, enemigos, False)
  (k:_) ->
    let e    = enemigos Map.! k
        lado = ladoColision (boundingBox j) (boundingBox e)
    in if lado == Arriba && puedeMorir e
       then -- Elimina enemigo (+100 pts, vy := 200, no sufre daño)
         let eMuerto   = e { tiempoMuerte = Just t }
             enemigos' = Map.insert k eMuerto enemigos
             (vx, _)   = velJugador j
             jRebote   = (sumarPuntos 100 j) { velJugador = (vx, 200.0) }
         in (jRebote, enemigos', False)
       else -- El enemigo daña al jugador (pierde vida y sale despedido)
         let (xj, _) = posJugador j
             (xe, _) = posEnemigo e
             dx      = xj - xe
             dirX    = signum dx * 150.0
             jDañado = (perderVida j) { velJugador = (dirX, 100.0) }
         in (jDañado, enemigos, True)
  where
    vivosMap     = enemigosVivos enemigos
    colisionados = Map.filter (colisionaCon j) vivosMap