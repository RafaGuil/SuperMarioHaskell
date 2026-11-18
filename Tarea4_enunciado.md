# Tarea 4 — El juego completo: TADs, matrices, entrada/salida y sprites

**Programación Declarativa — curso 2026/2027**

## Contexto y alcance

Esta es la **última tarea** y en ella el proyecto queda **terminado y jugable**: lo que habéis ido construyendo (tipos, mónadas, módulos, Gloss) se une con lo nuevo en un juego de plataformas completo.

1. **Tipos abstractos de datos** (`Pila`, `Cola`, `Dic`): módulos que exportan el tipo *sin sus constructores*. Los usaremos en el juego: una **pila** para «deshacer» el movimiento y una **cola** para el recorrido en anchura del mapa.
2. **Matrices** (`Data.Array`) y **diccionarios** (`Data.Map`): la rejilla del nivel pasa a ser una matriz, y los enemigos y los sprites se guardan en diccionarios.
3. **Estructuras de nivel completas**: ficheros de nivel con enemigos (patrones de movimiento, tamaños y cajas de impacto), meta y fondos; varios niveles encadenados.
4. **Física y enemigos**: gravedad, salto, colisiones con las plataformas, enemigos que patrullan y que se pueden pisar.
5. **Entrada/salida**: leer niveles, guardar y continuar partidas, tabla de puntuaciones, **carga de sprites** y el bucle de juego con `playIO`.

Es la tarea final y la más extensa, pero **no se os da código**: partís de **vuestro propio proyecto de la Tarea 3** (con vuestra organización de módulos), lo reutilizáis y lo ampliáis. Solo se os entregan los **recursos** (niveles y sprites): los módulos `Pila` y `Cola` ya los tenéis (los de clase). En **eval.cs.us.es** hay un **vídeo de ejemplo** del juego terminado. La tarea se reparte en cuatro bloques:

| Bloque | Tema | Puntos |
|---|---|---|
| 1 | Tipos abstractos de datos: clientes de `Pila` y `Cola`, y `Dic` | 2.4 |
| 2 | Matrices y estructuras de nivel | 2.7 |
| 3 | Física y enemigos | 1.5 |
| 4 | Entrada/salida, sprites y bucle de juego | 3.4 |
| | **Total** | **10.0** |
| Bonus | `Functor` sobre los TADs, carga de varios niveles y estética y dinámicas propias | hasta +1.5 |

> **Compatibilidad con la Tarea 3.** Los tipos `Celda`, `Grid`, `EstadoJuego` y la clase `Objeto` son los de la Tarea 3 (reutilizad los vuestros); `Partida`, `Entrada` y sus funciones de análisis (`parsearPartida`, `parsearLeaderboard`…) también. Cambia el modelo del nivel: `NivelData` guarda una **matriz** y los datos de los enemigos, y las celdas miden **140 × 40** (no 40 × 40).

> **Nombres repetidos.** `Pila`, `Cola` y `Dic` usan los mismos nombres de operación (`vacia`, `inserta`, `esVacia`…). Por eso se importan **cualificados** (`import qualified Pila as P`), como vimos en clase.

---

## Modo de trabajo

### 1. Planificación y reparto de tareas
El trabajo se realizará de manera colaborativa. Antes de comenzar a programar, los integrantes del grupo deberán coordinarse para analizar el problema, estructurar la solución global y **definir el reparto de módulos o funcionalidades** que asumirá cada miembro.

### 2. Desarrollo colaborativo en Git
Para garantizar la trazabilidad de las contribuciones y el trabajo en equipo, el desarrollo se organizará mediante ramas en el repositorio:

- **Asignación de ramas:** Cada miembro del grupo trabajará en su propia rama de desarrollo (`feature/feature-nombre` o `rama-alumno`), en la que implementará únicamente la parte del código acordada previamente.
- **Gestión de avances:** Se deberán realizar `commits` periódicos y descriptivos en la rama individual para reflejar la evolución del trabajo.

### 3. Integración y puesta en común (Rama `master`)
Una vez completadas las distintas partes, el grupo realizará la integración del código en la rama `master`:

- **Revisión de código y debate técnico:** La fusión de cada rama en `master` se realizará mediante la revisión conjunta del código de cada miembro. El equipo deberá discutir la adecuación de las soluciones planteadas, resolver posibles conflictos de integración y refinarlas si fuera necesario.
- **Cohesión del proyecto:** La versión final en la rama `master` debe ser un producto coherente, homogéneo y funcional que integre el trabajo de todo el equipo.

### 4. Entrega de la memoria e informe de contribución
Como parte de la evaluación, el grupo deberá entregar una **memoria de integración** que detalle:
1. La arquitectura global de la solución y el reparto de tareas inicial.
2. Un desglose del trabajo realizado por cada integrante (indicando las ramas y módulos correspondientes).
3. Una breve reflexión técnica sobre el proceso de integración en `master`, los conflictos surgidos y la justificación de las decisiones de diseño adoptadas durante la puesta en común.

### 5. Advertencia sobre el trabajo en equipo y el uso de Git
El correcto uso del repositorio Git forma parte de la evaluación del trabajo grupal. 

> **Nota importante:** El historial de commits y las ramas individuales del repositorio servirán para constatar la participación equitativa y continuada de los miembros del equipo. Repositorios que muestren subidas masivas de código sin historial de desarrollo, o en los que no se aprecie un reparto claro de responsabilidades, **serán evaluados negativamente**.

---
## Formato de entrega

- **Código fuente:** el proyecto completo (varios ficheros `.hs` más las carpetas `levels/` y `sprites/`), que compile sin errores ni avisos con `ghc -Wall` (todos los archivos comprimidos en un zip llamado codigo.zip).
  - Cada función que escribáis lleva su **firma de tipos explícita** y un comentario `--` de una línea describiendo qué calcula.
  - Importaciones permitidas: los módulos propios y, de la librería base, `Data.List`, `Data.Ord`, `Data.Maybe`, `Text.Read` (`readMaybe`), `Control.Monad`, `Control.Exception` (solo `catch` e `IOException`), `Data.Array`, `Data.Map` (siempre `qualified`), y, para el juego, `Graphics.Gloss` y `Graphics.Gloss.Interface.IO.Game`. Se permite la extensión `ViewPatterns`. Cualquier otra importación debe estar justificada en un comentario.
- **Código final seleccionado por el grupo**. Un zip denominado merge.zip que contenga la implementación final tras la reunión de grupo.
- **Reflexión individual sobre las decisiones grupales:** un informe individual (reflexion.txt) donde se detalle la postura personal frente a la elección de la solución final del grupo, justificando los puntos a favor o en contra de las decisiones tomadas.

---

## Organización del proyecto

Continuad con **vuestro proyecto de la Tarea 3**. Se os entregan solo los **recursos** (carpetas `levels/` con dos niveles y `sprites/` con las imágenes) y los módulos `Pila` y `Cola` **ya los tenéis** de las clases y presentaciones. El resto del código lo escribís vosotros. Podéis organizar los módulos como queráis **salvo** que las funciones puntuadas deben estar en los módulos indicados en cada subtarea (`Dic`, `Clientes`, `Matriz`, `Nivel`, `Objeto`, `Jugador`, `Ranking`, `Ficheros`, `Sprites`, `Mundo`, `Juego`) con los **nombres y tipos exactos** que se dan, porque se corregirán cargándolas en `ghci`. El resto (menú, dibujo, `Main`) lo diseñáis vosotros.

Dependencias: `gloss`, `JuicyPixels` y `vector` (en Debian/Ubuntu: `apt install libghc-gloss-dev libghc-juicypixels-dev libghc-vector-dev`).

### Piezas sin puntuación (necesarias para que el juego funcione)

Estas piezas no puntúan por sí solas, pero las subtareas las usan y el juego debe funcionar de extremo a extremo:

- **`Objeto`**: `class Objeto a where posicion :: a -> Vector2; boundingBox :: a -> BoundingBox; animar :: Float -> a -> a`; `solapan :: BoundingBox -> BoundingBox -> Bool` (solape estricto de rectángulos); `colisionaCon a b = solapan (boundingBox a) (boundingBox b)`; y `ladoColision :: BoundingBox -> BoundingBox -> LadoColision`: se calculan los cuatro solapes (`(xA+wA)-xB`, `(xB+wB)-xA`, `(yB+hB)-yA`, `(yA+hA)-yB`) y se devuelve el lado de **B** que corresponde al **menor** (empates, en este orden: `Abajo`, `Arriba`, `Izquierda`, `Derecha`; los lados son los de B por los que choca A, p. ej. «A cae sobre B» → `Arriba`). Instancias: `Plataforma` (su caja), `Meta` (con `(x,y) = posMeta`, caja `(x, y, anchoBaldosa/2, 2·altoBaldosa)`, es decir, 70 × 80), `Jugador` (centro `posJugador`, caja de `dimensionesJugador (elegirAccion j)`: `(60,90)` andando o parado, `(40,90)` saltando o agachado) y `Enemigo` (centro `posEnemigo`; con `(w,h) = dimEnemigo` y `(ox,oy,ow,oh) = hitOffset`: `(x - w/2 + w·ox, y - h/2 + h·oy, w·ow, h·oh)`).
- **`Jugador`**: `crearJugador :: Vector2 -> Int -> Int -> Jugador` (en reposo, mirando a la derecha, `faseAnim = 0`, sin agachar); `reaparecer :: Vector2 -> Jugador -> Jugador` (nueva posición y velocidad `(0,0)`); `mover :: Float -> Float -> Jugador -> Jugador` (desplaza la posición). El constructor de `Jugador` no se exporta.
- **`Sprites` y `Mundo`**: `cargarImagen`, `cargarSprites`, `posInicial`, `camaraX` (coordenada `x` del jugador) y `manejarEvento :: Event -> Mundo -> Mundo`. Con el teclado: flecha derecha/izquierda pulsadas → `correr 100` / `correr (-100)` **guardando antes la posición en el historial**; soltadas → `pararX`; flecha arriba → `saltar`; flecha abajo pulsada → `agachar`, soltada → `levantar`; tecla `u` → `deshacer`. Si el estado no es `Jugando`, no se hace nada. `cargarSprites n nd` carga, con `cargarSecuencia`: las cinco acciones del jugador con el tamaño de su caja (`dimensionesJugador`), la plataforma (160×60), los fondos (1000×600), la meta (100×60) y, por cada tipo de `tiposEnemigo nd`, su acción `Caminar` (100×100), según el árbol de carpetas de la Subtarea 9 (la entidad del jugador se llama `"jugador"`; las carpetas `jump_up`/`jump_down` usan el prefijo `jump`).
- **Dibujo y menú**: una función `dibujarMundo :: Mundo -> Picture` (fondos que se repiten cada 1000 unidades, plataformas, metas, enemigos vivos y jugador, con la cámara siguiendo al jugador; si faltan sprites se dibuja un rectángulo de color; cada enemigo se escala por `(ancho/100, alto/100)` de su `dimEnemigo` y se refleja según el signo de su velocidad horizontal; los fondos de `fondos nd` se eligen por índice módulo el número de imágenes cargadas; con el sprite del jugador reflejado según `mirandoDcha`; un HUD con nivel, vidas y puntos; y los textos de `PierdeVida`, `GameOver` y `NivelCompletado`) y un menú de consola con las opciones: 1 nueva partida (pide un nombre sin `;` y no vacío), 2 continuar la partida guardada, 3 ver el ranking, 4 resumen del nivel 1, 5 salir. La ventana se abre con `playIO` (60 fps) pasando `actualizarFrameIO nombre` como función de actualización.

### Cómo es un nivel

Cada nivel `N` está en `levels/N/nivel.txt` (los niveles se encadenan: al completar el 1 se carga el 2; cuando no existe el siguiente, el juego termina). Ejemplo, `levels/1/nivel.txt`:

```
NOMBRE: 1
FONDOS: 0, 1, 0, 1, 2, 1
META OFFSET: -20, 40
TIPOS DE ENEMIGO: lawnmower
ENEMIGO 1: 1 lawnmower 100 True (100, 90) (0.15,0,0.7,0.5) [(-50, 0), (50, 0)]
---
..............................
...........................##.
....1.#1...1.##.....1..1.##...
##.###.##.##.......##.###.....
................##...........1
...........................M##
...........................#..
```

- `NOMBRE`, `FONDOS` (índices de las imágenes de fondo a usar; pueden repetirse), `META OFFSET` (`x, y`, desplazamiento de la meta respecto a su celda) y `TIPOS DE ENEMIGO` (carpetas de sprites, separadas por comas) son obligatorias. Las líneas `ENEMIGO 1:`, `ENEMIGO 2:`… (consecutivas, hasta que falte una) declaran cada enemigo, con este formato:

  `id tipo periodo mortal (ancho,alto) (ox,oy,ow,oh) [(vx,vy),...]`

  `id`: el carácter que lo marca en el mapa · `tipo`: carpeta de sus sprites · `periodo`: fotogramas entre cambios de velocidad · `mortal`: `True`/`False` (si se puede matar saltando encima) · `(ancho,alto)`: tamaño de su sprite · `(ox,oy,ow,oh)`: su caja de impacto, en fracciones del sprite · lista de velocidades que repite cíclicamente (puede estar vacía: el enemigo no se mueve). Las tuplas y listas pueden llevar espacios (`(100, 90)`), y la línea puede terminar en espacios. Los valores de `FONDOS` y `META OFFSET` se separan por comas, con o sin espacios. El mismo `id` puede aparecer **varias veces** en el mapa (varios enemigos del mismo tipo).
- Tras la línea `---` va el mapa: `#` sólido, `.` vacío, `M` meta, cualquier otro carácter es el punto de inicio de un enemigo de ese `id`. El fichero puede terminar con **líneas en blanco**, que no forman parte del mapa, y las filas pueden tener longitudes distintas (las cortas se completan con celdas vacías).

### Mundo y coordenadas

Cada celda mide `anchoBaldosa × altoBaldosa` = 140 × 40. La fila `0` del mapa es la **más alta**, y el eje `y` del mundo crece hacia arriba; la fila inferior del mapa tiene su borde inferior en `yBaseNivel` = -225. Las constantes están en `Tipos`. Todas las cajas son `(x, y, ancho, alto)` con `(x, y)` en la **esquina inferior izquierda**, salvo el jugador y los enemigos, cuya posición es su **centro**.

### Tipos (resumen)

```haskell
data Jugador = Jugador                      -- en Jugador.hs (el constructor NO se exporta)
  { posJugador :: Vector2, velJugador :: Vector2          -- posición (centro) y velocidad
  , vidas :: Int, puntuacion :: Int
  , faseAnim :: Float                                     -- elige el fotograma de la animación
  , mirandoDcha :: Bool, agachado :: Bool } deriving (Eq, Show)

data Enemigo = Enemigo                      -- en Objeto.hs
  { idEnemigo :: String, posEnemigo :: Vector2, velEnemigo :: Vector2   -- posición = centro
  , dimEnemigo :: Vector2, hitOffset :: BoundingBox
  , patronMov :: [Vector2], periodoMov :: Int
  , contador :: Int, indicePatron :: Int                  -- estado del patrón de movimiento
  , tiempoMuerte :: Maybe Float, puedeMorir :: Bool } deriving (Eq, Show)

newtype Plataforma = Plataforma BoundingBox        newtype Meta = Meta { posMeta :: Vector2 }

data DatosEnemigo = DatosEnemigo               -- en Nivel.hs: lo declarado en la cabecera
  { idDatos :: String, tipoSprite :: String, periodoDatos :: Int, mortal :: Bool
  , tamEnemigo :: Vector2, offsetCaja :: BoundingBox, patronDatos :: [Vector2] }
data NivelData = NivelData
  { nombreNivel :: String, fondos :: [Int], matrizNivel :: Matriz, metaOffset :: Vector2
  , enemigosData :: Map.Map String DatosEnemigo, tiposEnemigo :: [String] }
data ErrorNivel = FormatoInvalido String | NivelSinMeta | NivelConVariasMetas Int
                | EnemigoDesconocido String | ErrorFichero String     deriving (Eq, Show)

data Mundo = Mundo                          -- en Mundo.hs
  { jugadorM :: Jugador, enemigosM :: Map.Map Int Enemigo, plataformasM :: [Plataforma]
  , metasM :: [Meta], tiempoM :: Float, estadoM :: EstadoJuego
  , esperaM :: Maybe Float                  -- instante en que se perdió la última vida
  , nivelNum :: Int, nivelM :: NivelData, spritesM :: Sprites
  , historialM :: P.Pila Vector2            -- posiciones anteriores (para deshacer)
  , registradaM :: Bool }                   -- ¿ya se anotó la puntuación final?

data Sprites = Sprites                      -- en Sprites.hs
  { acciones :: Map.Map String (Map.Map Accion [Picture])   -- entidad -> acción -> fotogramas
  , plataforma, fondo, meta :: [Picture] }
data Accion = Caminar | SaltarSubiendo | SaltarCayendo | Agachar | Parado      -- en Tipos.hs
```

En `Objeto.hs` están también `class Objeto` (`posicion`, `boundingBox`, `animar`), `solapan`, `colisionaCon` y `ladoColision :: BoundingBox -> BoundingBox -> LadoColision` (con `data LadoColision = Arriba | Abajo | Izquierda | Derecha`): el lado de la **segunda** caja por el que choca la primera.

---

# Bloque 1 — Tipos abstractos de datos (2.4 puntos)

Un TAD se define por **sus operaciones**, no por su representación. Los módulos `Pila` y `Cola` **ya los tenéis** (los vistos en clase, con su `Show` y su `Eq`): vosotros los **usáis** a través de su interfaz, sin conocer su representación, y escribís sus clientes. El módulo `Dic` sí lo implementáis vosotros: su lista de exportación contiene el tipo **sin constructores** (`Dic`, no `Dic(..)`) y las operaciones de la interfaz; las funciones auxiliares **no se exportan**.

## Subtarea 1 — Clientes de `Pila` (0.7 puntos)

**Módulo `Pila` (el de clase).** Interfaz de las pilas:

```haskell
vacia    :: Pila a
apila    :: a -> Pila a -> Pila a
cima     :: Pila a -> a            -- parcial: error si la pila es vacía
desapila :: Pila a -> Pila a       -- parcial: error si la pila es vacía
esVacia  :: Pila a -> Bool
```

`Pila` es una instancia de `Eq` y `Show`: la pila `1|2|3|-` tiene el `1` en la cima y `-` marca el fondo.

**Módulo `Clientes`** (solo puede usar la interfaz de `Pila`, importada cualificada):

```haskell
cimaSegura :: Pila a -> Maybe a
elementos  :: Pila a -> [a]                   -- de la cima al fondo
vistaPila  :: Pila a -> Maybe (a, Pila a)     -- función de vista (la de las presentaciones, no puntúa)
invierte   :: Pila a -> Pila a                -- usando vistaPila (ViewPatterns)
evaluaRPN  :: String -> Maybe Int             -- notación polaca inversa con +, - y *
```

`evaluaRPN` recorre los símbolos separados por espacios: un número se apila; un operador desapila dos operandos (el primero que sale es el operando **derecho**) y apila el resultado. Devuelve `Nothing` si falta algún operando, sobra alguno, o hay un símbolo que no es ni un número ni un operador.

| Función | Puntos | Criterio |
|---|---|---|
| `cimaSegura`, `elementos` | 0.15 | Solo usan la interfaz; `cimaSegura` es total |
| `invierte` | 0.25 | Definida con patrones de vista sobre `vistaPila` |
| `evaluaRPN` | 0.3 | Total: nunca falla, devuelve `Nothing` si la expresión es incorrecta |

**Ejemplos:**

```
> import qualified Pila as P
> let p = P.apila 1 (P.apila 2 (P.apila 3 P.vacia)) :: P.Pila Int
> p
1|2|3|-
> P.cima p
1
> P.desapila p
2|3|-
> cimaSegura p
Just 1
> cimaSegura (P.vacia :: P.Pila Int)
Nothing
> elementos p
[1,2,3]
> invierte p
3|2|1|-
> evaluaRPN "3 4 + 2 *"
Just 14
> evaluaRPN "5 1 2 + 4 * + 3 -"
Just 14
> evaluaRPN "3 +"
Nothing
> evaluaRPN "1 2"
Nothing
> evaluaRPN "2 x *"
Nothing
```

---

## Subtarea 2 — Clientes de `Cola` (0.5 puntos)

**Módulo `Cola` (el de clase).** Interfaz de las colas (el módulo las implementa con dos listas, de modo que `inserta`, `primero` y `resto` cuestan $O(1)$ amortizado):

```haskell
vacia   :: Cola a
inserta :: a -> Cola a -> Cola a    -- añade al final
primero :: Cola a -> a              -- parcial: error si la cola es vacía
resto   :: Cola a -> Cola a         -- parcial: error si la cola es vacía
esVacia :: Cola a -> Bool
```

`Cola` es una instancia de `Eq` y `Show`, que comparan y muestran la cola abstracta: `<1<2<3<4<5<`, con el primero a la izquierda.

**Módulo `Clientes`** (solo interfaz de `Cola`, importada cualificada):

```haskell
vistaCola :: Cola a -> Maybe (a, Cola a)    -- función de vista (la de las presentaciones, no puntúa)
longitud  :: Cola a -> Int
concatena :: Cola a -> Cola a -> Cola a     -- los elementos de la 1.ª y luego los de la 2.ª
```

| Función | Puntos | Criterio |
|---|---|---|
| `longitud` | 0.2 | Solo usa la interfaz (`vistaCola` o `esVacia`/`resto`) |
| `concatena` | 0.3 | Solo usa la interfaz; conserva el orden |

**Ejemplos:**

```
> import qualified Cola as C
> let c1 = foldl (flip C.inserta) C.vacia [1..5] :: C.Cola Int
> c1
<1<2<3<4<5<
> C.primero c1
1
> C.resto c1
<2<3<4<5<
> foldr C.inserta C.vacia [1..5] :: C.Cola Int
<5<4<3<2<1<
> longitud c1
5
> concatena c1 (foldl (flip C.inserta) C.vacia [6,7])
<1<2<3<4<5<6<7<
> C.resto (C.inserta 0 (C.resto c1)) == C.inserta 0 (C.resto (C.resto c1))
True
```

---

## Subtarea 3 — `Dic`: diccionarios con árboles de búsqueda (1.2 puntos)

**Módulo `Dic`.** Un diccionario asocia a cada clave, como máximo, un valor. Implementadlo con un **árbol binario de búsqueda** (`data Dic k v = H | N (Dic k v) k v (Dic k v)`), con el invariante «las claves del hijo izquierdo son menores que la raíz y las del derecho, mayores».

```haskell
vacio   :: Dic k v
inserta :: Ord k => k -> v -> Dic k v -> Dic k v   -- si la clave estaba, sustituye el valor
busca   :: Ord k => k -> Dic k v -> Maybe v
borra   :: Ord k => k -> Dic k v -> Dic k v        -- si no estaba, no hace nada
esVacio :: Dic k v -> Bool
claves  :: Dic k v -> [k]                          -- en orden creciente
aLista  :: Dic k v -> [(k, v)]                     -- en orden creciente de clave
deLista :: Ord k => [(k, v)] -> Dic k v            -- si una clave se repite, prevalece la última
```

`Show` muestra el diccionario como `{1:"a", 2:"b", 3:"c"}`. Para `borra` de un nodo con dos hijos, sustituid el nodo por el **mínimo del subárbol derecho** con funciones auxiliares (`une`, `minimo`, `borraMin`) **no exportadas**.

| Función | Puntos | Criterio |
|---|---|---|
| `vacio`, `esVacio`, `inserta`, `busca`, `borra` | 0.8 | Mantienen el invariante; `borra` correcto en hoja, un hijo y dos hijos |
| `claves`, `aLista`, `deLista`, `Show` | 0.4 | Orden creciente; formato indicado |

**Ejemplos:**

```
> import qualified Dic as D
> let d = D.deLista [(3,"c"),(1,"a"),(2,"b")]
> d
{1:"a", 2:"b", 3:"c"}
> D.busca 1 d
Just "a"
> D.busca 7 d
Nothing
> D.borra 2 d
{1:"a", 3:"c"}
> D.claves (D.inserta 0 "z" d)
[0,1,2,3]
> D.aLista (D.borra 1 (D.inserta 5 "e" d))
[(2,"b"),(3,"c"),(5,"e")]
> D.esVacio (D.vacio :: D.Dic Int Int)
True
```

---

# Bloque 2 — Matrices y estructuras de nivel (2.7 puntos)

## Subtarea 4 — La rejilla como `Data.Array` (1.2 puntos)

Una `Grid` (`[[Celda]]`) obliga a recorrer listas para llegar a una celda. Con `Data.Array` accedemos a cualquier celda directamente. **Módulo `Matriz`** (importa `Data.Array`, `Data.Map` cualificado como `M` y `Cola` cualificado como `C`):

```haskell
type Pos    = (Int, Int)            -- (fila, columna); la esquina superior izquierda es (0,0)   (definidlo así)
type Matriz = Array Pos Celda                                                                    (definidlo así)

gridAMatriz    :: Grid -> Matriz                  -- las filas cortas se completan con Vacio
matrizAGrid    :: Matriz -> Grid                  -- operación inversa
dimensiones    :: Matriz -> (Int, Int)            -- (filas, columnas)
celdaEn        :: Matriz -> Pos -> Maybe Celda    -- Nothing si está fuera
vecinos        :: Matriz -> Pos -> [Pos]          -- arriba, abajo, izquierda, derecha
posicionesDe   :: (Celda -> Bool) -> Matriz -> [Pos]
conteoPorFila  :: Matriz -> Array Int Int         -- celdas sólidas de cada fila (accumArray)
distancias     :: Matriz -> Pos -> M.Map Pos Int
metaAlcanzable :: Matriz -> Pos -> Bool
```

- `vecinos`: solo los que están dentro de la matriz y **no son sólidos**, en el orden `(i-1,j)`, `(i+1,j)`, `(i,j-1)`, `(i,j+1)`.
- `posicionesDe`: en el orden en que las devuelve `assocs` (por filas).
- `distancias m origen`: **recorrido en anchura** con una `Cola`. Devuelve, para cada celda alcanzable desde `origen` moviéndose por vecinos no sólidos, el número de pasos mínimo (el origen está a distancia 0). Si el origen está fuera o es sólido, el diccionario es vacío.
- `metaAlcanzable m origen`: ¿hay una celda meta entre las alcanzables desde `origen`?

| Función | Puntos | Criterio |
|---|---|---|
| `gridAMatriz` | 0.2 | `listArray` con límites `((0,0),(f-1,c-1))` |
| `matrizAGrid` | 0.1 | `matrizAGrid . gridAMatriz == id` |
| `dimensiones`, `celdaEn` | 0.15 | Usa `bounds`/`inRange`, sin `error` |
| `vecinos` | 0.2 | Orden y filtrado correctos |
| `posicionesDe` | 0.1 | Orden por filas |
| `conteoPorFila` | 0.1 | Con `accumArray` |
| `distancias` | 0.25 | BFS con `Cola`; no recorre dos veces una celda |
| `metaAlcanzable` | 0.1 | Reutiliza `distancias` |

**Ejemplos:**

```
> let g = parsearGrid ["..M", ".A.", "###"]
> let m = gridAMatriz g
> bounds m
((0,0),(2,2))
> dimensiones m
(3,3)
> m ! (0,2)
META
> celdaEn m (1,1)
Just (InicioEnemigo "A")
> celdaEn m (3,0)
Nothing
> matrizAGrid m == g
True
> vecinos m (1,1)
[(0,1),(1,0),(1,2)]
> vecinos m (2,0)
[(1,0)]
> posicionesDe esSolido m
[(2,0),(2,1),(2,2)]
> conteoPorFila m
array (0,2) [(0,0),(1,0),(2,3)]
> let m2 = gridAMatriz (parsearGrid ["...", "#.#", "M.#"])
> distancias m2 (0,0)
fromList [((0,0),0),((0,1),1),((0,2),2),((1,1),2),((2,0),4),((2,1),3)]
> metaAlcanzable m2 (0,0)
True
> metaAlcanzable (gridAMatriz (parsearGrid ["..#M"])) (0,0)
False
> distancias m2 (1,0)           -- (1,0) es sólida
fromList []
```

---

## Subtarea 5 — Del fichero de nivel a los objetos del mundo (1.5 puntos)

**Módulo `Nivel`.** Ampliad el análisis de la Tarea 3 con la cabecera completa y construid los objetos del mundo a partir de la matriz.

```haskell
parsearEnemigo       :: String -> Maybe DatosEnemigo
parsearFichero       :: [String] -> Either ErrorNivel NivelData
validarNivel         :: NivelData -> Either ErrorNivel NivelData
gridAPlataformas     :: Matriz -> [Plataforma]
metasDesdeMatriz     :: Vector2 -> Matriz -> [Meta]
enemigosDesdeMatriz  :: Map.Map String DatosEnemigo -> Matriz -> Map.Map Int Enemigo
posicionMundo        :: Matriz -> Pos -> Vector2          -- en el módulo Matriz
```

- `parsearEnemigo`: interpreta el texto que sigue a `ENEMIGO n: ` (ver el formato arriba). `Nothing` si algún campo no se puede leer. Cuidado: las tuplas llevan espacios y comas internas (os conviene una auxiliar que extraiga el contenido entre paréntesis).
- `parsearFichero`: como en la Tarea 3, pero ahora lee también `META OFFSET: x,y`, `TIPOS DE ENEMIGO: t1, t2` y todas las líneas `ENEMIGO k:`. Errores (`FormatoInvalido`): falta una clave obligatoria, `FONDOS` o `META OFFSET` no válidos, o un `ENEMIGO k` mal formado (mensaje `"ENEMIGO k mal formado"`).
- `validarNivel`: exactamente una meta (`NivelSinMeta`, `NivelConVariasMetas n`) y **todos los enemigos del mapa declarados** en la cabecera (`EnemigoDesconocido id`). Se comprueba primero la meta.
- `posicionMundo m (i, j)`: esquina inferior izquierda de la celda en el mundo: `(j · anchoBaldosa, (filas - 1 - i) · altoBaldosa + yBaseNivel)`.
- `gridAPlataformas`: una plataforma `(x, y, anchoBaldosa, altoBaldosa)` por cada celda sólida.
- `metasDesdeMatriz (xo, yo) m`: una meta por cada celda `META`, en `(x + anchoBaldosa / 2 + xo, y + yo)` siendo `(x, y)` la posición de la celda.
- `enemigosDesdeMatriz datos m`: un `Enemigo` por cada celda `InicioEnemigo id` cuyo `id` esté en `datos`, numerados desde `0` en el orden del mapa. Su centro está en `(x + anchoBaldosa / 2, y + alto / 2)` (`alto` = alto de su sprite); su velocidad inicial es la primera del patrón (o `(0,0)` si es vacío); `contador` e `indicePatron` a `0`; `tiempoMuerte` a `Nothing`; el resto, de sus datos.

| Función | Puntos | Criterio |
|---|---|---|
| `parsearEnemigo` | 0.4 | `Maybe` con `do`; tuplas con espacios; `readMaybe` |
| `parsearFichero` | 0.35 | `Either` con `do`; cabecera ampliada y enemigos consecutivos |
| `validarNivel` | 0.15 | Los tres errores, en el orden indicado |
| `posicionMundo` | 0.1 | Fila invertida y desplazamiento `yBaseNivel` |
| `gridAPlataformas` | 0.15 | Usa `posicionesDe` y `posicionMundo` |
| `metasDesdeMatriz` | 0.1 | Posición con el desplazamiento |
| `enemigosDesdeMatriz` | 0.25 | `Map` numerado; ignora ids desconocidos sin fallar |

**Ejemplos:**

```
> parsearEnemigo "1 lawnmower 100 True (100, 90) (0.15,0,0.7,0.5) [(-50, 0), (50, 0)]"
Just (DatosEnemigo {idDatos = "1", tipoSprite = "lawnmower", periodoDatos = 100, mortal = True, tamEnemigo = (100.0,90.0), offsetCaja = (0.15,0.0,0.7,0.5), patronDatos = [(-50.0,0.0),(50.0,0.0)]})
> parsearEnemigo "4 stapler 20 True (50, 45) (0.2,0.2,0.6,0.6) [(0, 400), (0, -400), (0, 0)] "
Just (DatosEnemigo {idDatos = "4", tipoSprite = "stapler", periodoDatos = 20, mortal = True, tamEnemigo = (50.0,45.0), offsetCaja = (0.2,0.2,0.6,0.6), patronDatos = [(0.0,400.0),(0.0,-400.0),(0.0,0.0)]})
> parsearEnemigo "5 paper rapido False (80, 75) (0.2,0.2,0.6,0.6) [(100, 0)]"
Nothing
> parsearEnemigo "6 bat 45 False (80, 60) (0,0,1,1) []"
Just (DatosEnemigo {idDatos = "6", tipoSprite = "bat", periodoDatos = 45, mortal = False, tamEnemigo = (80.0,60.0), offsetCaja = (0.0,0.0,1.0,1.0), patronDatos = []})
> Right nd <- cargarNivel "levels/1/nivel.txt"          -- (Subtarea 8)
> nombreNivel nd
"1"
> fondos nd
[0,1,0,1,2,1]
> metaOffset nd
(-20.0,40.0)
> tiposEnemigo nd
["lawnmower"]
> M.keys (enemigosData nd)
["1"]
> dimensiones (matrizNivel nd)
(7,30)
> posicionMundo (matrizNivel nd) (6,0)
(0.0,-225.0)
> posicionMundo (matrizNivel nd) (5,27)
(3780.0,-185.0)
> length (gridAPlataformas (matrizNivel nd))
26
> head (gridAPlataformas (matrizNivel nd))
Plataforma (3780.0,-25.0,140.0,40.0)
> metasDesdeMatriz (metaOffset nd) (matrizNivel nd)
[Meta {posMeta = (3830.0,-145.0)}]
> let es = enemigosDesdeMatriz (enemigosData nd) (matrizNivel nd)
> M.keys es
[0,1,2,3,4,5]
> es M.! 0
Enemigo {idEnemigo = "1", posEnemigo = (630.0,-20.0), velEnemigo = (-50.0,0.0), dimEnemigo = (100.0,90.0), hitOffset = (0.15,0.0,0.7,0.5), patronMov = [(-50.0,0.0),(50.0,0.0)], periodoMov = 100, contador = 0, indicePatron = 0, tiempoMuerte = Nothing, puedeMorir = True}
> M.map posEnemigo es
fromList [(0,(630.0,-20.0)),(1,(1050.0,-20.0)),(2,(1610.0,-20.0)),(3,(2870.0,-20.0)),(4,(3290.0,-20.0)),(5,(4130.0,-100.0))]
> parsearNivelCompleto ["NOMBRE: x","FONDOS: 0","META OFFSET: 0,0","TIPOS DE ENEMIGO: ","---","Z.M"]
Left (EnemigoDesconocido "Z")
> parsearNivelCompleto ["NOMBRE: x","FONDOS: 0","META OFFSET: 0","TIPOS DE ENEMIGO: ","---","..M"]
Left (FormatoInvalido "META OFFSET no valido")
> parsearNivelCompleto ["NOMBRE: x","FONDOS: 0","META OFFSET: 0,0","TIPOS DE ENEMIGO: ","ENEMIGO 1: roto","---","..M"]
Left (FormatoInvalido "ENEMIGO 1 mal formado")
> parsearNivelCompleto ["NOMBRE: x","FONDOS: 0","META OFFSET: 0,0","TIPOS DE ENEMIGO: ","---","..."]
Left NivelSinMeta
```

(El texto exacto de los mensajes de `FormatoInvalido` es libre salvo el de `ENEMIGO k mal formado`.)

---

# Bloque 3 — Física y enemigos (1.5 puntos)

En los ejemplos se usa el nivel 1: `ps = gridAPlataformas (matrizNivel nd)` y `j0 = crearJugador (90, 200) 3 0` (jugador en `(90,200)`, 3 vidas, 0 puntos).

## Subtarea 6 — El jugador y la física (0.75 puntos)

**Módulo `Jugador`.** Constante `gravedad = -400`.

```haskell
aplicarGravedad :: Float -> Jugador -> Jugador            -- vy := vy + gravedad * dt
estaEnSuelo     :: [Plataforma] -> Jugador -> Bool
moverYResolver  :: Float -> Jugador -> [Plataforma] -> Jugador
resolverCaida   :: Jugador -> (Jugador, Bool)
tocaMeta        :: Jugador -> [Meta] -> Bool
correr          :: Float -> Jugador -> Jugador            -- velocidad horizontal; deja de estar agachado
pararX          :: Jugador -> Jugador                     -- velocidad horizontal := 0
saltar          :: [Plataforma] -> Jugador -> Jugador     -- solo si está en el suelo
agachar         :: [Plataforma] -> Jugador -> Jugador     -- solo si está en el suelo
levantar        :: Jugador -> Jugador
```

- `estaEnSuelo`: ¿solapa alguna plataforma con una **franja de 2 unidades de alto justo debajo de la caja del jugador** (del mismo ancho que ella)?
- `moverYResolver dt j ps`, en **dos pasos independientes**:
  1. *Eje X*: se avanza `vx · dt`. Si el jugador colisiona con alguna plataforma (la primera de la lista que lo haga): con `vx > 0` se coloca pegado al lateral izquierdo de la plataforma (`x = xPlat - ancho/2`); con `vx < 0`, pegado al lateral derecho (`x = xPlat + anchoPlat + ancho/2`); en ambos casos `vx := 0`.
  2. *Eje Y*: se avanza `vy · dt` (con la `vy` actual). Si colisiona: con `vy <= 0` **aterriza** (`y = yPlat + altoPlat + alto/2`); con `vy > 0` **golpea el techo** (`y = yPlat - alto/2`); en ambos casos `vy := 0`.
  
  (`ancho` y `alto` son los de la caja de colisión del jugador). Después se actualiza la animación: `faseAnim` sube `0.1` si la acción resultante es `SaltarSubiendo` y la fase es `< 2`, sube `0.1` si es `SaltarCayendo` y la fase es `< 5`, y sube `0.2` si es `Caminar`; `mirandoDcha` pasa a `True` si la velocidad horizontal *antes* de resolver colisiones era positiva, a `False` si era negativa, y se conserva si era `0`.
- `resolverCaida`: si `y < -1000`, pierde una vida (nunca por debajo de 0) y devuelve `True`.
- `saltar`: en el suelo, `vy := 300`, `faseAnim := 0`, `agachado := False`. `agachar`: en el suelo, velocidad `(0,0)` y `agachado := True`. `levantar`: `agachado := False` y `faseAnim := 0`.

| Función | Puntos | Criterio |
|---|---|---|
| `aplicarGravedad` | 0.1 | |
| `estaEnSuelo` | 0.1 | Franja bajo los pies |
| `moverYResolver` | 0.35 | Ejes separados; auxiliares `resolverEjeX`/`resolverEjeY` no exportadas; animación |
| `resolverCaida`, `tocaMeta` | 0.1 | |
| `correr`, `pararX`, `saltar`, `agachar`, `levantar` | 0.1 | |

**Ejemplos:**

```
> aplicarGravedad 0.1 j0
Jugador {posJugador = (90.0,200.0), velJugador = (0.0,-40.0), vidas = 3, puntuacion = 0, faseAnim = 0.0, mirandoDcha = True, agachado = False}
> let caer n j = iterate (\x -> moverYResolver (1/60) (aplicarGravedad (1/60) x) ps) j !! n
> let j1 = caer 120 j0                  -- tras 2 segundos cayendo
> posJugador j1
(90.0,-20.0)
> velJugador j1
(0.0,0.0)
> estaEnSuelo ps j1
True
> estaEnSuelo ps j0
False
> boundingBox j1
(60.0,-65.0,60.0,90.0)
> velJugador (saltar ps j1)
(0.0,300.0)
> velJugador (saltar ps j0)             -- en el aire no salta
(0.0,0.0)
> velJugador (agachar ps j1)
(0.0,0.0)
> posJugador (iterate (\x -> moverYResolver (1/60) (aplicarGravedad (1/60) x) ps) (correr 100 j1) !! 40)
(156.6667,-20.0)
> resolverCaida (reaparecer (0,-1500) j0)
(Jugador {posJugador = (0.0,-1500.0), velJugador = (0.0,0.0), vidas = 2, puntuacion = 0, faseAnim = 0.0, mirandoDcha = True, agachado = False},True)
> tocaMeta (reaparecer (3850, -105) j0) [Meta (3830,-145)]
True
> tocaMeta j0 [Meta (3830,-145)]
False
```

---

## Subtarea 7 — Enemigos (0.75 puntos)

**Módulos `Objeto` y `Jugador`.**

```haskell
animar                   :: Float -> Enemigo -> Enemigo            -- método de la clase Objeto
vivo                     :: Enemigo -> Bool
enemigosVivos            :: Map.Map Int Enemigo -> Map.Map Int Enemigo
resolverColisionEnemigos :: Float -> Jugador -> Map.Map Int Enemigo -> (Jugador, Map.Map Int Enemigo, Bool)
```

- `animar dt e` (se llama **una vez por fotograma**): si el patrón es vacío, no hace nada. Si `contador >= periodoMov`, pasa al **siguiente** elemento del patrón (cíclicamente): actualiza `indicePatron`, la velocidad, y avanza la posición con la velocidad **nueva** (`pos + dt · vel`), y pone `contador := 0`. Si no, avanza la posición con la velocidad actual y suma `1` a `contador`.
- `vivo`: un enemigo está vivo si **no puede morir** o si todavía no tiene `tiempoMuerte`.
- `resolverColisionEnemigos t j es`: mira solo los enemigos **vivos** que colisionan con el jugador (si hay varios, el de menor clave). Según `ladoColision (boundingBox j) (boundingBox e)`:
  - **`Arriba` y el enemigo puede morir**: el jugador lo mata (`tiempoMuerte := Just t`) y rebota (`vy := 200`, `vx` igual), `+100` puntos. El tercer resultado es `False` (no hay daño).
  - **Cualquier otro caso** (otro lado, o enemigo que no puede morir): el jugador pierde una vida (nunca por debajo de 0) y sale despedido, con velocidad `(signum dx · 150, 100)` siendo `dx` la diferencia de `x` entre jugador y enemigo. Los enemigos no cambian y el tercer resultado es `True`.
  - Sin colisión: todo igual y `False`.

| Función | Puntos | Criterio |
|---|---|---|
| `animar` de `Enemigo` | 0.25 | Total, también con patrón vacío |
| `vivo`, `enemigosVivos` | 0.1 | `Map.filter` |
| `resolverColisionEnemigos` | 0.4 | Los tres casos; `Map.adjust` para matar |

**Ejemplos:** (`e0` = primer enemigo del nivel 1, `es` = todos)

```
> boundingBox e0
(595.0,-65.0,70.0,45.0)
> (posEnemigo e0, posEnemigo (iterate (animar (1/60)) e0 !! 30))
((630.0,-20.0),(605.0006,-20.0))
> velEnemigo (iterate (animar (1/60)) e0 !! 61)        -- tras 100 fotogramas cambia al 2.º del patrón
(50.0,0.0)
> (indicePatron (iterate (animar (1/60)) e0 !! 61), contador (iterate (animar (1/60)) e0 !! 61))
(1,0)
> (vivo e0, vivo (e0 { tiempoMuerte = Just 5 }), vivo (e0 { tiempoMuerte = Just 5, puedeMorir = False }))
(True,False,True)
> let jEnc = reaparecer (fst (posEnemigo e0), 20) j0      -- cae encima
> let (ja, esa, da) = resolverColisionEnemigos 5 jEnc es
> (puntuacion ja, da, velJugador ja)
(100,False,(0.0,200.0))
> (fmap tiempoMuerte (M.lookup 0 esa), M.keys (enemigosVivos esa))
(Just (Just 5.0),[1,2,3,4,5])
> let jLado = reaparecer (fst (posEnemigo e0) - 55, snd (posEnemigo e0)) j0      -- choca de lado
> let (jb, esb, db) = resolverColisionEnemigos 5 jLado es
> (vidas jb, db, velJugador jb, M.keys (enemigosVivos esb))
(2,True,(-150.0,100.0),[0,1,2,3,4,5])
```

---

# Bloque 4 — Entrada/salida, sprites y bucle de juego (3.4 puntos)

Hasta ahora, todo era puro. Las únicas partes con `IO` son `Ficheros`, `Sprites` (carga de imágenes), `Juego` y `Menu`: la lógica (parsear, validar, ordenar, simular) sigue en las funciones puras y las acciones `IO` solo las conectan con el exterior.

## Subtarea 8 — Ficheros: niveles, partidas y puntuaciones (1.0 puntos)

**Módulos `Ficheros` y `Ranking`.** Dadas: `ficheroPartida = "partida.txt"`, `ficheroLeaderboard = "leaderboard.txt"` y `rutaNivel n = "levels/" ++ show n ++ "/nivel.txt"`.

```haskell
leerLineas          :: FilePath -> IO (Either String [String])
cargarNivel         :: FilePath -> IO (Either ErrorNivel NivelData)
resumenNivel        :: FilePath -> IO ()
guardarPartida      :: FilePath -> Partida -> IO ()
cargarPartida       :: FilePath -> IO (Maybe Partida)
leerLeaderboard     :: FilePath -> IO [Entrada]
registrarPuntuacion :: FilePath -> Entrada -> IO [Entrada]
-- Ranking
mejorPorJugador     :: [Entrada] -> M.Map String Int
ranking             :: Int -> M.Map String Int -> [Entrada]
```

- `leerLineas`: devuelve las líneas del fichero **sin `'\r'`** (ficheros de Windows); si no se puede leer, `Left` con `show` de la `IOException` (`catch`).
- `cargarNivel`: lee el fichero y lo pasa por `parsearNivelCompleto`; un fallo de lectura es `ErrorFichero` con el mensaje.
- `resumenNivel`: imprime 5 líneas (ver el ejemplo) o `Error: ` y el error.
- `guardarPartida`: escribe `serializarPartida`; `cargarPartida`: `Nothing` si el fichero no existe o es inválido; `leerLeaderboard`: `[]` si no existe o es inválido.
- `registrarPuntuacion ruta e`: lee la tabla, añade `e`, conserva la **mejor puntuación de cada jugador** y las **10 mejores**, reescribe el fichero con `serializarEntrada` y devuelve la tabla.
- `mejorPorJugador`: el máximo de cada jugador (`M.insertWith max`). `ranking n m`: las `n` primeras entradas por **más puntos**, y a igualdad de puntos, por **nombre**.

> **Pista — `readFile` es perezoso.** `readFile` no lee el fichero hasta que se usa su contenido y lo deja «abierto» hasta entonces: si luego escribís en el mismo fichero (`registrarPuntuacion`) obtendréis `resource busy (file is locked)`. Forzad la lectura completa antes de seguir, por ejemplo con ``length contenido `seq` return ...``.

| Función | Puntos | Criterio |
|---|---|---|
| `leerLineas` | 0.25 | `catch`, `Left` con el mensaje, sin `'\r'`, lectura forzada |
| `cargarNivel` | 0.1 | Separa lo puro de lo impuro |
| `resumenNivel` | 0.15 | Formato del ejemplo; usa `Matriz` |
| `guardarPartida`, `cargarPartida` | 0.2 | Reutilizan `serializarPartida`/`parsearPartida` |
| `leerLeaderboard` | 0.1 | |
| `registrarPuntuacion`, `mejorPorJugador`, `ranking` | 0.2 | Una entrada por jugador, 10 como máximo, ordenada |

**Ejemplos:**

```
> leerLineas "levels/9/nivel.txt"
Left "levels/9/nivel.txt: openFile: does not exist (No such file or directory)"
> cargarNivel "levels/9/nivel.txt"
Left (ErrorFichero "levels/9/nivel.txt: openFile: does not exist (No such file or directory)")
> fmap nombreNivel <$> cargarNivel "levels/1/nivel.txt"
Right "1"
> resumenNivel "levels/1/nivel.txt"
Nivel: 1
Tamaño: 7 filas x 30 columnas
Celdas sólidas: 26
Enemigos: 6 (tipos: lawnmower)
Meta alcanzable desde (0,0): True
> resumenNivel "levels/2/nivel.txt"
Nivel: 2
Tamaño: 7 filas x 30 columnas
Celdas sólidas: 27
Enemigos: 6 (tipos: paper stapler)
Meta alcanzable desde (0,0): True
> guardarPartida "p.txt" (Partida 2 3 450)
> readFile "p.txt"
"NIVEL: 2\nVIDAS: 3\nPUNTUACION: 450\n"
> cargarPartida "p.txt"
Just (Partida {nivelGuardado = 2, vidasGuardadas = 3, puntuacionGuardada = 450})
> cargarPartida "no_existe.txt"
Nothing
> leerLeaderboard "no_existe.txt"
[]
> registrarPuntuacion "lb.txt" (Entrada "ana" 120)
[Entrada {nombreJugador = "ana", puntos = 120}]
> registrarPuntuacion "lb.txt" (Entrada "luis" 80)
[Entrada {nombreJugador = "ana", puntos = 120},Entrada {nombreJugador = "luis", puntos = 80}]
> registrarPuntuacion "lb.txt" (Entrada "ana" 90)         -- peor que la anterior de ana
[Entrada {nombreJugador = "ana", puntos = 120},Entrada {nombreJugador = "luis", puntos = 80}]
> registrarPuntuacion "lb.txt" (Entrada "eva" 200)
[Entrada {nombreJugador = "eva", puntos = 200},Entrada {nombreJugador = "ana", puntos = 120},Entrada {nombreJugador = "luis", puntos = 80}]
> readFile "lb.txt"
"eva;200\nana;120\nluis;80\n"
> let es = [Entrada "ana" 120, Entrada "luis" 80, Entrada "ana" 150, Entrada "eva" 80]
> mejorPorJugador es
fromList [("ana",150),("eva",80),("luis",80)]
> ranking 2 (mejorPorJugador es)
[Entrada {nombreJugador = "ana", puntos = 150},Entrada {nombreJugador = "eva", puntos = 80}]
```

---

## Subtarea 9 — Sprites (0.75 puntos)

Cada nivel usa imágenes `.png` numeradas con tres cifras: `walk001.png`, `walk002.png`… forman la animación de andar. La estructura de carpetas es:

```
sprites/player/{walk,stop,jump_up,jump_down,crouch}/<nombre>001.png ...        el jugador
levels/N/sprites/platform/platform001.png                                       baldosa (se escala a 160x60)
levels/N/sprites/background/back001.png ...                                     fondos (se escalan a 1000x600)
levels/N/sprites/meta/meta001.png ...                                           meta (se escala a 100x60)
levels/N/sprites/enemies/<tipo>/caminar/<tipo>001.png ...                       cada tipo de enemigo (se escala a 100x100)
```

**Módulos `Sprites` y `Jugador`.** Además de las funciones puntuadas, el módulo necesita `cargarImagen :: FilePath -> Float -> Float -> IO (Maybe Picture)` (lee una imagen con `JuicyPixels` —`readImage`— y la escala al tamaño dado; `Nothing` si no existe o no es válida; se puede convertir a `Picture` con `bitmapOfForeignPtr` de Gloss) y `cargarSprites :: Int -> NivelData -> IO Sprites` (carga todos los de un nivel con `cargarSecuencia` y construye el `Sprites`), ver «Piezas sin puntuación».

```haskell
nombreFrame     :: FilePath -> Int -> FilePath
cargarSecuencia :: FilePath -> Float -> Float -> IO [Picture]
buscarFrames    :: String -> Accion -> Sprites -> [Picture]
elegirFrame     :: Float -> [Picture] -> Picture
elegirAccion    :: Jugador -> Accion                           -- en el módulo Jugador
```

- `nombreFrame prefijo n`: `prefijo ++ número con 3 cifras ++ ".png"`.
- `cargarSecuencia prefijo ancho alto`: carga `prefijo001.png`, `prefijo002.png`… **hasta que falte uno** (recursión sobre `IO`); la lista vacía si no existe ni el primero.
- `buscarFrames clave accion sprites`: los fotogramas de esa entidad (`"jugador"` o el tipo de un enemigo) en esa acción, o `[]` si no existen (sin fallar; usad `Map.findWithDefault`).
- `elegirFrame fase fs`: el fotograma `floor fase` de la lista, **cíclicamente**; `blank` si la lista es vacía.
- `elegirAccion j`, por este orden: `vy > 1` → `SaltarSubiendo`; `vy < 0` → `SaltarCayendo`; agachado → `Agachar`; `vx == 0` → `Parado`; en otro caso `Caminar`.

| Función | Puntos | Criterio |
|---|---|---|
| `nombreFrame` | 0.1 | Rellena con ceros hasta 3 cifras |
| `cargarSecuencia` | 0.25 | Recursión sobre `IO`; para al primer fotograma que falta |
| `buscarFrames` | 0.15 | Total, con `Map` |
| `elegirFrame` | 0.1 | Cíclico; total |
| `elegirAccion` | 0.15 | Orden de las condiciones |

**Ejemplos:**

```
> nombreFrame "sprites/player/walk/walk" 7
"sprites/player/walk/walk007.png"
> nombreFrame "levels/1/sprites/meta/meta" 12
"levels/1/sprites/meta/meta012.png"
> length <$> cargarSecuencia "sprites/player/walk/walk" 60 90
4
> length <$> cargarSecuencia "sprites/player/nada/nada" 60 90
0
> length <$> cargarSecuencia "levels/2/sprites/enemies/paper/caminar/paper" 100 100
4
> elegirFrame 3.7 []
Blank
> elegirAccion j0                     -- en el aire, sin tocar el suelo aún
SaltarCayendo
> elegirAccion j1                     -- ya aterrizado
Parado
> elegirAccion (saltar ps j1)
SaltarSubiendo
> elegirAccion (correr 100 j1)
Caminar
> elegirAccion (agachar ps j1)
Agachar
```

(`elegirAccion j0` devuelve `Parado` mientras `vy == 0`; `j0` aún no ha empezado a caer. Con `aplicarGravedad 0.1 j0` pasa a `SaltarCayendo`.)

---

## Subtarea 10 — El juego: mundo, niveles encadenados y puntuación (1.65 puntos)

**Módulos `Mundo` y `Juego`.** Además de las puntuadas, hacen falta `posInicial = (90, 200)`, `manejarEvento` (teclado) y `camaraX` (ver «Piezas sin puntuación»).

```haskell
construirMundo    :: Int -> NivelData -> Int -> Int -> Sprites -> Mundo       -- nivel, datos, vidas, puntos, sprites
actualizarMundo   :: Float -> Mundo -> Mundo
guardarHistorial  :: Mundo -> Mundo
deshacer          :: Mundo -> Mundo
-- Juego
cargarFase        :: Int -> Int -> Int -> IO (Either ErrorNivel Mundo)
actualizarFrameIO :: String -> Float -> Mundo -> IO Mundo
```

- `construirMundo n nd v p ss`: el jugador en `posInicial` con `v` vidas y `p` puntos; los enemigos, plataformas y metas desde la matriz del nivel (Subtarea 5); `tiempoM = 0`, estado `Jugando`, `esperaM = Nothing`, `historialM` vacío y `registradaM = False`.
- `actualizarMundo dt m`: avanza `dt` segundos; **siempre** suma `dt` a `tiempoM`. Según el estado:
  - `Jugando`: gravedad → `moverYResolver` → se animan **todos** los enemigos → choques con enemigos → caída (solo se mira la caída si no ha habido daño por enemigo). El estado nuevo es, por este orden: `GameOver` si no quedan vidas; `PierdeVida` si ha perdido una vida (entonces `esperaM = Just tiempo-actual`); `NivelCompletado` si toca la meta; `Jugando` en otro caso.
  - `PierdeVida`: espera **3 segundos** (se compara `tiempoM m - t0 >= 3` con el tiempo *antes* de sumar `dt`); entonces el jugador reaparece en `posInicial` (en reposo), el estado vuelve a `Jugando` y `esperaM = Nothing`. Mientras tanto no cambia nada.
  - `GameOver` y `NivelCompletado`: no cambia nada (salvo el tiempo).
- `guardarHistorial m`: apila la posición actual del jugador en `historialM`. `deshacer m`: si el historial es vacío no hace nada; si no, lleva al jugador (en reposo) a la última posición apilada y la desapila. (`manejarEvento` los usa: cada pulsación de las flechas izquierda/derecha guarda la posición, y la tecla `U` deshace.)
- `cargarFase n v p`: carga el nivel `n` (`rutaNivel`), sus sprites (`cargarSprites`) y construye el mundo; `Left` si el nivel no se puede cargar.
- `actualizarFrameIO nombre dt m0`: es la función que se pasa a `playIO`. Avanza un paso con `actualizarMundo dt m0` y, según el estado resultante `m`:
  - **`NivelCompletado`** (si aún no está registrada): carga el nivel siguiente (`nivelNum m + 1`) con las vidas y puntos actuales. Si lo consigue, **guarda la partida** (`ficheroPartida`, nivel siguiente) y devuelve el mundo nuevo. Si no existe el fichero (`ErrorFichero`), imprime «¡Has completado todos los niveles!»; si falla por otro motivo, imprime el error; en ambos casos **registra la puntuación** (ver abajo).
  - **`GameOver`** (si aún no está registrada): registra la puntuación.
  - En otro caso, devuelve `m`.

  *Registrar la puntuación*: `registrarPuntuacion ficheroLeaderboard (Entrada nombre puntos)` y devolver el mundo con `registradaM = True`, para que **no se anote una vez por fotograma**.

| Función | Puntos | Criterio |
|---|---|---|
| `construirMundo` | 0.25 | Reutiliza las funciones de `Nivel` |
| `actualizarMundo` | 0.6 | Los tres estados; espera de 3 s; orden de los resultados |
| `cargarFase` | 0.15 | `Either` dentro de `IO` |
| `actualizarFrameIO` | 0.5 | Pasa de nivel, guarda y anota la puntuación una sola vez |
| `guardarHistorial`, `deshacer` | 0.15 | Solo usan la interfaz de `Pila`; total |

**Ejemplos:**

```
> Right m0 <- cargarFase 1 3 0
> (nivelNum m0, estadoM m0, length (plataformasM m0), M.size (enemigosM m0), posJugador (jugadorM m0), vidas (jugadorM m0))
(1,Jugando,26,6,(90.0,200.0),3)
> posJugador (jugadorM (actualizarMundo 0.5 m0))
(90.0,100.0)
> let mT = m0 { jugadorM = reaparecer (fst (posEnemigo e0) - 55, snd (posEnemigo e0)) (jugadorM m0) }
> let mT1 = actualizarMundo (1/60) mT                      -- choca de lado con el primer enemigo
> (estadoM mT1, vidas (jugadorM mT1), esperaM mT1)
(PierdeVida,2,Just 0.0)
> let mT3 = actualizarMundo 0.2 (actualizarMundo 2.9 mT1)
> (estadoM mT3, tiempoM mT3)                               -- aún no han pasado 3 s al empezar el paso
(PierdeVida,3.1166668)
> let mT4 = actualizarMundo 0.2 mT3
> (estadoM mT4, posJugador (jugadorM mT4), velJugador (jugadorM mT4), esperaM mT4, vidas (jugadorM mT4))
(Jugando,(90.0,200.0),(0.0,0.0),Nothing,2)
> let mCae = m0 { jugadorM = reaparecer (4*140+70, -1100) (jugadorM m0) }
> (estadoM (actualizarMundo (1/60) mCae), vidas (jugadorM (actualizarMundo (1/60) mCae)))
(PierdeVida,2)
> let [Meta (mx,my)] = metasM m0
> estadoM (actualizarMundo (1/60) (m0 { jugadorM = reaparecer (mx + 20, my + 40) (jugadorM m0) }))
NivelCompletado
> P.esVacia (historialM (deshacer m0))
True
> posJugador (jugadorM (deshacer (guardarHistorial m0)))
(90.0,200.0)
```

> **Vídeo de ejemplo.** En **eval.cs.us.es** tenéis un vídeo del juego terminado funcionando, para que veáis el comportamiento que se espera (movimiento, enemigos, cambio de nivel, menú y ranking). Usadlo como referencia al comprobar vuestro trabajo.

Una partida completa de prueba (jugando con el teclado) debe poder: moverse con las flechas, saltar y agacharse, pisar a los enemigos, perder vidas, pasar del nivel 1 al 2, terminar el juego y aparecer en el ranking. En el menú principal, la opción 1 empieza una partida, la 2 continúa la guardada, la 3 muestra el ranking y la 4 el resumen del nivel 1.

---

# Bonus — `Functor`, carga de varios niveles y toque personal (hasta +1.5)

| Apartado | Puntos | Qué se pide |
|---|---|---|
| a | 0.4 | `instance Functor Pila` y `instance Functor Cola`, definidas **solo con la interfaz** de cada TAD (en un módulo aparte, con `{-# OPTIONS_GHC -Wno-orphans #-}`), que cumplan las leyes `fmap id == id` y `fmap (f . g) == fmap f . fmap g` (comprobadlas en `ghci` con algún ejemplo) |
| b | 0.3 | `instance Functor (Dic k)` (transforma los valores) (con las mismas leyes) |
| c | 0.3 | `cargarNiveles :: [FilePath] -> IO (Either ErrorNivel [NivelData])` (en `Ficheros`): carga todos los ficheros y devuelve la lista de niveles, o el **primer** error en el orden de la lista (usad `mapM`, `fmap` y `sequence`) |
| d | 0.5 | **Estética y dinámicas propias**: ampliad el juego con vuestras propias ideas, sin romper lo pedido en el resto del enunciado (los ejemplos de `ghci` deben seguir funcionando igual). Ejemplos: nuevos niveles, sprites o fondos propios, nuevos tipos de enemigo o patrones de movimiento, objetos o mecánicas (monedas, vidas extra, plataformas móviles, power-ups), efectos visuales, sonido, un HUD o menús mejorados… |

**Sobre el apartado d.** Se valora la **originalidad y el cuidado** del resultado, y que la lógica nueva siga el estilo del curso (funciones puras, tipos explícitos, sin avisos con `-Wall`). Incluid en `reflexion.txt` (o en un `LEEME.md`) una breve descripción de lo que habéis añadido y cómo se prueba, e indicad los ficheros de recursos nuevos que hacen falta. Si añadís niveles nuevos, deben cumplir el formato de ficheros descrito arriba.

```
> fmap (*10) (P.apila 1 (P.apila 2 P.vacia))
10|20|-
> fmap show (C.inserta 2 (C.inserta 1 C.vacia))
<"1"<"2"<
> fmap length (D.deLista [(1,"a"),(2,"bcd")])
{1:1, 2:3}
> cargarNiveles ["levels/1/nivel.txt","levels/2/nivel.txt"] >>= print . fmap (map nombreNivel)
Right ["1","2"]
> cargarNiveles ["levels/1/nivel.txt","levels/9/nivel.txt"]
Left (ErrorFichero "levels/9/nivel.txt: openFile: does not exist (No such file or directory)")
```

---

## Resumen de la puntuación

| Subtarea | Puntos |
|---|---|
| **Bloque 1 — Tipos abstractos de datos** | |
| 1. Clientes de `Pila` | 0.7 |
| 2. Clientes de `Cola` | 0.5 |
| 3. `Dic` (árbol de búsqueda) | 1.2 |
| *Subtotal Bloque 1* | *2.4* |
| **Bloque 2 — Matrices y estructuras de nivel** | |
| 4. La rejilla como `Data.Array` | 1.2 |
| 5. Del fichero de nivel a los objetos del mundo | 1.5 |
| *Subtotal Bloque 2* | *2.7* |
| **Bloque 3 — Física y enemigos** | |
| 6. El jugador y la física | 0.75 |
| 7. Enemigos | 0.75 |
| *Subtotal Bloque 3* | *1.5* |
| **Bloque 4 — Entrada/salida, sprites y juego** | |
| 8. Ficheros: niveles, partidas y puntuaciones | 1.0 |
| 9. Sprites | 0.75 |
| 10. El juego: mundo, niveles encadenados y puntuación | 1.65 |
| *Subtotal Bloque 4* | *3.4* |
| **Total (obligatorio)** | **10.0** |
| Bonus `Functor`, `cargarNiveles` y estética y dinámicas propias *(opcional)* | hasta +1.5 |

## Criterios transversales

- **Abstracción**: `Pila`, `Cola` y `Dic` **no exportan constructores**; `Jugador` tampoco. Ninguna función fuera de su módulo puede usarlos: si hace falta, se añade una operación a la interfaz.
- **Tipos explícitos**: toda función lleva su firma. No se admiten nombres de tipos, constructores o campos distintos a los indicados.
- **Totalidad**: salvo `cima`, `desapila`, `primero` y `resto` (parciales por especificación), ninguna función puede fallar en tiempo de ejecución. Compilad con `ghc -Wall` y no dejéis avisos (`incomplete-patterns`, variables sin usar, imports sobrantes…).
- **Lo puro, separado de `IO`**: toda decisión (parsear, validar, ordenar, simular) se hace en funciones puras; las acciones `IO` solo leen, escriben, imprimen y llaman a esas funciones.
- **Errores de ficheros**: un fichero o una imagen que falte, o un nivel o una partida corruptos, **nunca** deben hacer caer el programa.
- **Sin duplicación**: reutilizad `buscarClave`, `splitOn`, `posicionMundo`, `serializarPartida`, `parsearNivelCompleto`, `mejorPorJugador`… en lugar de reescribirlas.
- **Casos borde**: listas, rejillas y patrones vacíos, claves repetidas, pilas y colas vacías, ficheros con líneas en blanco o saltos de línea de Windows, puntuaciones empatadas, enemigos que no se pueden matar.
