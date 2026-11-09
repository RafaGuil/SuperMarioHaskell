module Tipos 
    ( Vector2
    , BoundingBox
    , Celda(..)
    , Grid
    , TipoEnemigo(..)
    , Enemigo(..)
    , EstadoJuego(..)
    , parsearCelda
    , parsearGrid
    , celdaAChar
    , esSolido
    , esMeta
    , esEnemigo
    , sumaVectores
    , escalarVector
    ) where

-- | Vector o punto 2D en coordenadas de pantalla.
type Vector2 = (Float, Float)

-- | Caja delimitadora para colisiones: (x, y, ancho, alto).
type BoundingBox = (Float, Float, Float, Float)

-- | Rejilla o matriz que compone el nivel del juego.
type Grid = [[Celda]]

-- | Tipo algebraico que representa los distintos elementos de una celda del mapa.
data Celda = Solido 
           | Vacio 
           | META 
           | InicioEnemigo String 
           deriving (Eq, Show)

-- | Comportamientos o dinámicas posibles para los enemigos.
data TipoEnemigo = Patrulla | Perseguidor deriving (Eq, Show)

-- | Registro que define la estructura y propiedades de un enemigo.
data Enemigo = Enemigo
    { idEnemigo :: String
    , posEnemigo :: Vector2
    , velEnemigo :: Vector2
    , dimEnemigo :: Vector2
    , tipoEnemigo :: TipoEnemigo
    } deriving (Eq, Show)

-- | Estados posibles del bucle del juego.
data EstadoJuego = Jugando | PierdeVida | GameOver | NivelCompletado deriving (Eq, Show)

-- | Convierte un carácter individual del mapa al tipo Celda correspondiente.
parsearCelda :: Char -> Celda
parsearCelda '#' = Solido
parsearCelda '.' = Vacio
parsearCelda 'M' = META
parsearCelda c = InicioEnemigo [c]

-- | Convierte una lista de cadenas de texto en una rejilla completa de celdas.
parsearGrid :: [String] -> Grid
parsearGrid = map (map parsearCelda)

-- | Operación inversa: convierte una Celda de vuelta a su carácter representativo.
celdaAChar :: Celda -> Char
celdaAChar Solido                = '#'
celdaAChar Vacio                 = '.'
celdaAChar META                  = 'M'
celdaAChar (InicioEnemigo (c:_)) = c
celdaAChar (InicioEnemigo [])    = 'A'

-- | Comprueba si una celda es un bloque sólido.
esSolido :: Celda -> Bool
esSolido Solido = True
esSolido _ = False

-- | Comprueba si una celda es la meta del nivel.
esMeta :: Celda -> Bool
esMeta META = True
esMeta _ = False

-- | Comprueba si una celda corresponde al punto de inicio de un enemigo.
esEnemigo :: Celda -> Bool
esEnemigo (InicioEnemigo _) = True
esEnemigo _ = False

-- Utilidades de vectores

-- | Suma componente a componente dos vectores o puntos 2D.
sumaVectores :: Vector2 -> Vector2 -> Vector2
sumaVectores (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- | Multiplica un vector o punto 2D por un factor escalar.
escalarVector :: Float -> Vector2 -> Vector2
escalarVector n (x, y) = (n * x, n * y)
