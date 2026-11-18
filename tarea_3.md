# Tarea 3 — Tipos propios, mónadas y módulos: el mundo del juego en pantalla

**Programación Declarativa — curso 2026/2027**

## Contexto y alcance

En las Tareas 1 y 2 trabajasteis con la lógica pura del motor de niveles usando solo tipos
sinónimo (`Celda = Char`, tuplas para todo). En esta tarea el proyecto da el salto a un
programa organizado como el juego final:

1. **Definición de tipos** (`data`, registros, clases de tipos e instancias): sustituimos
   `Char` y las tuplas por tipos propios que el compilador pueda comprobar.
   
2. **Mónadas** (`Maybe`, `Either`, notación `do`, `Applicative` y funtores): 
   interpretamos el texto de un nivel y de una partida guardada con errores controlados, 
   en vez de usar `error`.

3. **Gloss**: convertimos el mapa en objetos del mundo, los dibujamos y los movemos con 
   el teclado.
   
4. **Módulos**: repartimos el código en varios ficheros con listas de exportación y
   ocultación de constructores. **Este tema lo estudiaréis por vuestra cuenta** con la
   presentación publicada en Enseñanza Virtual; la Subtarea 7 comprueba que lo habéis
   aprendido.

> **Sobre la entrada/salida.** La E/S (`IO`) todavía no se ha visto, así que en esta tarea
> **no se leen ni escriben ficheros**: los niveles se incluyen dentro del código como
> listas de cadenas, y las funciones de lectura y análisis trabajan sobre ese texto, que es
> la parte «pura» del problema. Cuando veamos `IO`, conectaremos estas mismas funciones con
> ficheros reales sin tener que reescribirlas. El único `IO` de la tarea es el `main` que
> lanza la ventana de Gloss, y **os lo damos escrito**.

Al ser una tarea bisemanal, se reparte en cuatro bloques:

| Bloque | Tema | Puntos |
|---|---|---|
| 1 | Definición de tipos | 3.0 |
| 2 | Mónadas (`Maybe` y `Either`) | 3.0 |
| 3 | Gloss: del mapa al mundo jugable | 2.0 |
| 4 | Módulos (estudio autónomo) | 2.0 |
| | **Total** | **10.0** |
| Bonus | `Functor`, `Applicative` y `Monad` | hasta +1.0 |


> **Compatibilidad con las Tareas 1 y 2.** Sustituís `type Celda = Char` por un tipo
> `data`. Las funciones que clasificaban celdas (`esSolido`, `esMeta`, `esEnemigo`) pasan
> a hacer *pattern matching* sobre los constructores. Si el resto de vuestro código de las
> tareas anteriores usaba `Char`, adaptadlo o dejadlo fuera: **solo se evalúa lo que se
> pide en este enunciado**.

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

- **Código fuente:** el proyecto completo descrito en la Subtarea 7 (varios ficheros `.hs`), 
  que compile sin errores (todos los archivos comprimidos en un zip llamado codigo.zip)
  - Cada función lleva su **firma de tipos explícita** y un comentario `--` de una línea
    describiendo qué calcula.
  - Importaciones permitidas: los módulos propios y, de la librería base,
    `Data.List`, `Data.Ord`, `Text.Read` (`readMaybe`) y `Control.Monad` y, para el
    Bloque 3, `Graphics.Gloss` y `Graphics.Gloss.Interface.Pure.Game`. Cualquier otra 
    importación debe estar justificada en un comentario.
- **Código final seleccionado por el grupo**. Un zip denominado merge.zip que contenga la 
  implementación final tras la reunión de grupo.
- **Reflexión individual sobre las decisiones grupales:** un informe individual donde se
  detalle la postura personal frente a la elección de la solución final del grupo,
  justificando los puntos a favor o en contra de las decisiones tomadas.

---

# Bloque 1 — Definición de tipos (3.0 puntos)

## Subtarea 1 — `Celda` como tipo algebraico (1.0 puntos)

Tomamos ya la decisión que se anunciaba en la Tarea 1: una celda deja de ser un `Char`.
Ahora una celda será un tipo de datos `data Celda = ...` con los constructures necesarios para
contemplar las casuísticas que hay en un mapa.

```haskell
parsearCelda :: Char -> Celda
parsearGrid  :: [String] -> Grid
celdaAChar   :: Celda -> Char
esSolido     :: Celda -> Bool
esMeta       :: Celda -> Bool
esEnemigo    :: Celda -> Bool
```

| Función | Puntos | Criterio |
|---|---|---|
| `parsearCelda` y `parsearGrid` | 0.25 | Convierte un carácter al tipo de celda correspondiente |
| `celdaAChar` | 0.25 | operación inversa de `parsearCelda` |
| `esSolido`, `esMeta`, `esEnemigo` | 0.5 | Determina si una Celda es alguno de estos tipos |

**Ejemplos:**

```
> parsearCelda '#'
Solido
> parsearCelda 'A'
InicioEnemigo "A"
> parsearGrid ["#.M", "A.."]
[[Solido,Vacio,META],[InicioEnemigo "A",Vacio,Vacio]]
> map (map celdaAChar) (parsearGrid ["#.M", "A.."])
["#.M","A.."]
> map esSolido [Solido, Vacio, META, InicioEnemigo "A"]
[True,False,False,False]
```

---

## Subtarea 2 — Registros: jugador, enemigos y estado del juego (1.0 puntos)

Define los tipos de datos para:

- **jugador**: Un jugador necesita un posición, una velocidad, las vidas que le quedan 
  y un puntuación. 

- **enemigo**: Un enemigo necesita un identificador, una posición, una velocidad, una 
  dimensión y un tipo de enemigo. 

- **tipo de enemigo**: El tipo de enemigo identificará las dinámicas de los enemigos. 
  Este tipo de datos debe establecer los tipos de enemigos que tendrá el juego. Por 
  ahora establecemos dos tipos: patrulla y perseguidor.
  
- **estado del juego**: El estado de juego determina determinado eventos que puede 
  producirse durante el juego: jugando, perdida de vida, terminar (gameover), nivel
  completado, ...

Se deberán crear la siguiente funciones:

```haskell
crearJugador    :: Vector2 -> Jugador
perderVida      :: Jugador -> Jugador
sumarPuntos     :: Int -> Jugador -> Jugador
conVelocidad    :: Vector2 -> Jugador -> Jugador
moverJugador    :: Float -> Jugador -> Jugador
estadoSiguiente :: Jugador -> Bool -> Bool -> EstadoJuego
```

| Función | Puntos | Criterio |
|---|---|---|
| definición de los tipos | 0.2 | exactamente los campos y constructores indicados |
| `crearJugador` | 0.2 | jugador en la posición dada, velocidad `(0,0)`, **3 vidas** y **0 puntos** |
| `perderVida`, `sumarPuntos`, `conVelocidad` | 0.2 | uso de **actualización de registro** (`j { campo = ... }`); `perderVida` nunca deja `vidas` por debajo de 0 |
| `moverJugador` | 0.2 | `posición + dt · velocidad` reutilizando `sumaVectores` y `escalarVector` |
| `estadoSiguiente` | 0.2 | ver reglas abajo |

`estadoSiguiente jugador recibioDaño tocaMeta` recibe al jugador **ya actualizado**:

1. si `vidas jugador <= 0` → gameover
2. si no, y `recibioDaño` → pierde vida
3. si no, y `tocaMeta` → completa nivel
4. en otro caso → jugando

**Ejemplos:**

```
> let j = crearJugador (20, 200)
> j
Jugador {posJugador = (20.0,200.0), velJugador = (0.0,0.0), vidas = 3, puntuacion = 0}
> perderVida j
Jugador {posJugador = (20.0,200.0), velJugador = (0.0,0.0), vidas = 2, puntuacion = 0}
> vidas (perderVida (perderVida (perderVida (perderVida j))))
0
> sumarPuntos 50 j
Jugador {posJugador = (20.0,200.0), velJugador = (0.0,0.0), vidas = 3, puntuacion = 50}
> moverJugador 0.5 (conVelocidad (10, -20) j)
Jugador {posJugador = (25.0,190.0), velJugador = (10.0,-20.0), vidas = 3, puntuacion = 0}
> estadoSiguiente j False False
Jugando
> estadoSiguiente j True False
PierdeVida
> estadoSiguiente j False True
NivelCompletado
> estadoSiguiente (perderVida (perderVida (perderVida j))) True True
GameOver
```

---

## Subtarea 3 — Una clase de tipos para los objetos del juego (1.0 puntos)

Todos los objetos con presencia en el mundo (plataformas, meta, enemigos, jugador) tienen
una posición y una caja de colisión. Lo expresamos con una **clase de tipos**:

```haskell
class Objeto a where
  posicion    :: a -> Vector2
  boundingBox :: a -> BoundingBox
  animar      :: Float -> a -> a
  animar _ = id                    -- método con implementación por defecto
```

Además hay que definir estos tipos de objeto:

```haskell
data Plataforma = Plataforma BoundingBox
  deriving (Eq, Show)

data Meta = Meta { posMeta :: Vector2 }
  deriving (Eq, Show)
```

Y estas funciones:

```haskell
solapan            :: BoundingBox -> BoundingBox -> Bool            -- la de la Tarea 1
colisionaCon       :: (Objeto a, Objeto b) => a -> b -> Bool
colisionaConAlguno :: (Objeto a, Objeto b) => a -> [b] -> Bool
```

| Elemento | Puntos | Criterio |
|---|---|---|
| `instance Objeto` para `Plataforma`, `Meta` y `Jugador` | 0.4 | sin definir `animar` (se usa el valor por defecto). Cajas: `Plataforma` = su propia caja; `Meta` en `(x, y)` = `(x, y, 70, 80)`; `Jugador` en `(x, y)` = `(x - 30, y, 60, 90)` |
| `instance Objeto Enemigo` | 0.2 | caja = `(x - w/2, y - h/2, w, h)`; `animar dt` desplaza al enemigo `dt · velocidad` (con actualización de registro) |
| `colisionaCon` | 0.2 | se define **con polimorfismo restringido** por la clase, usando `boundingBox` y `solapan` |
| `colisionaConAlguno` | 0.2 | un objeto contra una lista de objetos **de otro tipo** (se agradece `any`) |

**Ejemplos:**

```
> boundingBox (Plataforma (0, 0, 140, 40))
(0.0,0.0,140.0,40.0)
> boundingBox (Meta (100, 40))
(100.0,40.0,70.0,80.0)
> boundingBox (crearJugador (20, 200))
(-10.0,200.0,60.0,90.0)
> let e = Enemigo "A" (200, 50) (-40, 0) (80, 50) Patrulla
> boundingBox e
(160.0,25.0,80.0,50.0)
> posicion (animar 0.5 e)
(180.0,50.0)
> posicion (animar 0.5 (Meta (100, 40)))
(100.0,40.0)
> colisionaCon (crearJugador (0, 0)) (Plataforma (20, 10, 140, 40))
True
> colisionaCon (crearJugador (0, 0)) (Plataforma (500, 10, 140, 40))
False
> colisionaConAlguno (crearJugador (0, 0)) [Meta (900, 0), Meta (20, 10)]
True
> colisionaConAlguno (crearJugador (0, 0)) ([] :: [Meta])
False
```

---

# Bloque 2 — Mónadas (3.0 puntos)

## Subtarea 4 — La mónada `Maybe`: leer una partida guardada y una tabla de puntuaciones (1.25 puntos)

Vamos a **interpretar el contenido de ficheros** (ya leídos como `[String]`) sin tocar
todavía el disco. La entrada puede estar incompleta o corrupta, y eso se modela con
`Maybe`.

```haskell
data Partida = Partida
  { nivelGuardado      :: Int
  , vidasGuardadas     :: Int
  , puntuacionGuardada :: Int
  } deriving (Eq, Show)

data Entrada = Entrada { nombreJugador :: String, puntos :: Int }
  deriving (Eq, Show)
```

```haskell
buscarClave         :: String -> [String] -> Maybe String
serializarPartida   :: Partida -> [String]
parsearPartida      :: [String] -> Maybe Partida
parsearEntrada      :: String -> Maybe Entrada
parsearLeaderboard  :: [String] -> Maybe [Entrada]
mejoresPuntuaciones :: Int -> [Entrada] -> [Entrada]
```

| Función | Puntos | Criterio |
|---|---|---|
| `buscarClave` | 0.25 | devuelve lo que sigue a la clave en la **primera** línea que empiece por ella (`stripPrefix`) |
| `serializarPartida` y `parsearPartida` | 0.5 | `parsearPartida` en **notación `do`** sobre `Maybe`: si falta una clave o un número no se puede leer (`readMaybe`), todo el resultado es `Nothing`. Sin `case` anidados |
| `parsearEntrada` | 0.25 | formato `"nombre;puntos"`; nombre no vacío y exactamente dos campos separados por `;` |
| `parsearLeaderboard` | 0.15 | **con `mapM`**: ignora las líneas vacías, pero si alguna otra línea es inválida, devuelve `Nothing` |
| `mejoresPuntuaciones` | 0.1 | las `n` mejores entradas, de mayor a menor puntuación (`sortOn`, `Down`, `take`) |

El formato de partida es:

```
NIVEL: 2
VIDAS: 3
PUNTUACION: 150
```

Para dividir cadenas se os proporciona (copiadla tal cual):

```haskell
splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, [])  -> [a]
  (a, _:b) -> a : splitOn c b
```

**Ejemplos:**

```
> buscarClave "NIVEL: " ["VIDAS: 3", "NIVEL: 2"]
Just "2"
> buscarClave "NIVEL: " ["VIDAS: 3"]
Nothing
> serializarPartida (Partida 2 3 150)
["NIVEL: 2","VIDAS: 3","PUNTUACION: 150"]
> parsearPartida ["NIVEL: 2", "VIDAS: 3", "PUNTUACION: 150"]
Just (Partida {nivelGuardado = 2, vidasGuardadas = 3, puntuacionGuardada = 150})
> parsearPartida ["NIVEL: 2", "VIDAS: tres", "PUNTUACION: 150"]
Nothing
> parsearPartida ["NIVEL: 2", "VIDAS: 3"]
Nothing
> parsearEntrada "Ana;120"
Just (Entrada {nombreJugador = "Ana", puntos = 120})
> parsearEntrada "Ana;mucho"
Nothing
> parsearEntrada "Ana"
Nothing
> parsearLeaderboard ["Ana;120", "Luis;340"]
Just [Entrada {nombreJugador = "Ana", puntos = 120},Entrada {nombreJugador = "Luis", puntos = 340}]
> parsearLeaderboard ["Ana;120", "roto"]
Nothing
> mejoresPuntuaciones 2 [Entrada "Ana" 120, Entrada "Luis" 340, Entrada "Eva" 200]
[Entrada {nombreJugador = "Luis", puntos = 340},Entrada {nombreJugador = "Eva", puntos = 200}]
```

---

## Subtarea 5 — La mónada `Either`: interpretar y validar un nivel (1.75 puntos)

`Maybe` nos dice *que* algo falló; `Either` nos dice **por qué**. Un fichero de nivel tiene
una cabecera, una línea `---` y el mapa:

```
NOMBRE: Colinas
FONDOS: 1,2,3
---
..M
#.A
```

```haskell
data ErrorNivel
  = FormatoInvalido String
  | NivelSinMeta
  | NivelConVariasMetas Int
  deriving (Eq, Show)

data NivelData = NivelData
  { nombreNivel :: String
  , fondos      :: [Int]
  , gridNivel   :: Grid
  } deriving (Eq, Show)
```

```haskell
parsearFichero       :: [String] -> Either ErrorNivel NivelData
validarNivel         :: NivelData -> Either ErrorNivel NivelData
parsearNivelCompleto :: [String] -> Either ErrorNivel NivelData
```

| Función | Puntos | Criterio |
|---|---|---|
| `parsearFichero` | 1.0 | en notación `do` sobre `Either`. Errores `FormatoInvalido` con mensaje propio si: falta `---` (que es el separador), no hay mapa tras `---`, falta la clave `NOMBRE: ` o `FONDOS: `, o `FONDOS` contiene algo no numérico (usad `buscarClave` de la Subtarea 4 y convertid su `Maybe` en `Either`) |
| `validarNivel` | 0.5 | `NivelSinMeta` si no hay ninguna celda `META`; `NivelConVariasMetas n` si hay `n > 1`; el nivel en `Right` si hay exactamente una |
| `parsearNivelCompleto` | 0.25 | composición de las dos anteriores **con `>>=`** (no con `case`) |

**Ejemplos:**

```
> parsearFichero ["NOMBRE: Colinas", "FONDOS: 1,2", "---", "..M", "#.A"]
Right (NivelData {nombreNivel = "Colinas", fondos = [1,2], gridNivel = [[Vacio,Vacio,META],[Solido,Vacio,InicioEnemigo "A"]]})
> parsearFichero ["NOMBRE: Colinas", "FONDOS: 1,2"]
Left (FormatoInvalido "falta el separador '---'")
> parsearFichero ["FONDOS: 1,2", "---", "..M"]
Left (FormatoInvalido "falta la clave 'NOMBRE: '")
> validarNivel (NivelData "X" [] [[Vacio, META], [META, Vacio]])
Left (NivelConVariasMetas 2)
> validarNivel (NivelData "X" [] [[Vacio, Vacio]])
Left NivelSinMeta
> parsearNivelCompleto ["NOMBRE: X", "FONDOS: 1", "---", "..."]
Left NivelSinMeta
```

> Los textos de los mensajes de `FormatoInvalido` son **libres** salvo los dos que se
> muestran arriba; lo que se comprueba es el constructor.


---

# Bloque 3 — Gloss: del mapa al mundo jugable (2.0 puntos)

Hasta ahora todo se probaba en `ghci`. Ahora usamos `Graphics.Gloss` para **ver el nivel
y mover al jugador** con las flechas del teclado. Todo lo que escribís es **código puro**
(funciones que reciben valores y devuelven `Picture` o un mundo nuevo); el único `IO` es el
`main`, que os damos escrito y que llama a `play`.

Todavía no hay gravedad ni colisión con plataformas: el jugador se mueve libremente y solo 
interactúa con **enemigos** (le quitan una vida) y con la **meta** (completa el nivel).

## Subtarea 6 — Del mapa a los objetos, y de los objetos a la pantalla (2.0 puntos)

### 6A. Del mapa a los objetos (0.75 puntos)

Cada celda del mapa mide `tamCelda = 40` unidades. La primera fila del texto es la **más
alta** del nivel, y el eje `y` crece hacia arriba.

```haskell
tamCelda :: Float
tamCelda = 40

posicionCelda     :: Int -> Int -> Int -> Vector2
gridAPlataformas  :: Grid -> [Plataforma]
metasDesdeGrid    :: Grid -> [Meta]
enemigosDesdeGrid :: Grid -> [Enemigo]
```

| Función | Puntos | Criterio |
|---|---|---|
| `posicionCelda total i j` | 0.25 | esquina **inferior izquierda** de la celda de la fila `i` (contando desde arriba) y columna `j`, en un mapa de `total` filas: `x = j·tamCelda`, `y = (total-1-i)·tamCelda` |
| `gridAPlataformas` | 0.25 | una `Plataforma (x, y, tamCelda, tamCelda)` por cada celda `Solido`, **con lista por comprensión** |
| `metasDesdeGrid` y `enemigosDesdeGrid` | 0.25 | una `Meta` en la esquina de cada `META`; un `Enemigo` por cada `InicioEnemigo ident`, con `id = ident`, **centrado en su celda** (esquina + `tamCelda/2` en cada eje), velocidad `(-40, 0)`, dimensiones `(tamCelda, tamCelda)` y tipo `Patrulla` (el patrón `InicioEnemigo ident` puede ir en el generador de la comprensión) |

**Ejemplos:**

```
> posicionCelda 2 0 1
(40.0,40.0)
> posicionCelda 2 1 0
(0.0,0.0)
> gridAPlataformas [[Solido, Vacio], [Vacio, Solido]]
[Plataforma (0.0,40.0,40.0,40.0),Plataforma (40.0,0.0,40.0,40.0)]
> metasDesdeGrid (parsearGrid ["..M", "#.A"])
[Meta {posMeta = (80.0,40.0)}]
> enemigosDesdeGrid (parsearGrid ["..M", "#.A"])
[Enemigo {idEnemigo = "A", posEnemigo = (100.0,20.0), velEnemigo = (-40.0,0.0), dimEnemigo = (40.0,40.0), tipoEnemigo = Patrulla}]
> enemigosDesdeGrid (parsearGrid ["..M", "###"])
[]
```

### 6B. Del mundo a la pantalla (0.75 puntos)

Para probarlo en `ghci`, cargad también `import Graphics.Gloss`: un `Picture` de Gloss
se puede mostrar con `show` y comparar con `==`.

```haskell
dibujarObjeto :: Objeto a => Color -> a -> Picture
dibujarHUD    :: Jugador -> Picture
mensajeEstado :: EstadoJuego -> Maybe String
dibujarMundo  :: Mundo -> Picture
```

| Función | Puntos | Criterio |
|---|---|---|
| `dibujarObjeto col o` | 0.25 | **función genérica sobre la clase `Objeto`**: un rectángulo sólido (`rectangleSolid`) de color `col` con el tamaño y la posición de su `boundingBox` (`translate` al **centro** de la caja) |
| `dibujarHUD` y `mensajeEstado` | 0.25 | `dibujarHUD`: el texto `"Vidas: v   Puntos: p"` (con tres espacios), con `translate (-380) 270` y `scale 0.15 0.15`. `mensajeEstado`: `Nothing` si se está `Jugando`; `"PIERDE VIDA (R para reiniciar)"`, `"GAME OVER"` y `"NIVEL COMPLETADO"` en `Just` para los otros estados |
| `dibujarMundo` | 0.25 | ver el recuadro de debajo |

`dibujarMundo` compone, con `Pictures`: la **escena** (todo lo del mundo, desplazada con
`translate (-px) (-py)` para que la cámara siga al jugador, siendo `(px, py)` su posición),
el HUD (**fijo**, sin desplazar) y, si `mensajeEstado` devuelve texto, el mensaje centrado
(`translate (-250) 0 (scale 0.3 0.3 (color black (text msg)))`). En la escena, por este orden
(el último se dibuja encima): plataformas en `greyN 0.5`, metas en `green`, enemigos en
`red`, y el jugador en `blue`. Cada grupo se dibuja con `map (dibujarObjeto ...)`.

**Ejemplos:**

```
> dibujarObjeto red (Meta (100, 40))
Translate 135.0 80.0 (Color (RGBA 1.0 0.0 0.0 1.0) (Polygon [(-35.0,-40.0),(-35.0,40.0),(35.0,40.0),(35.0,-40.0)]))
> dibujarObjeto red (Meta (100, 40)) == translate 135 80 (color red (rectangleSolid 70 80))
True
> dibujarHUD (sumarPuntos 50 (crearJugador (0, 0)))
Translate (-380.0) 270.0 (Scale 0.15 0.15 (Text "Vidas: 3   Puntos: 50"))
> map mensajeEstado [Jugando, PierdeVida, GameOver, NivelCompletado]
[Nothing,Just "PIERDE VIDA (R para reiniciar)",Just "GAME OVER",Just "NIVEL COMPLETADO"]
```

### 6C. El mundo y su paso de simulación (0.5 puntos)

El tipo `Mundo` y `mundoInicial` **se os dan escritos** (copiadlos tal cual):

```haskell
data Mundo = Mundo
  { jugadorM     :: Jugador
  , enemigosM    :: [Enemigo]
  , plataformasM :: [Plataforma]
  , metasM       :: [Meta]
  , estadoM      :: EstadoJuego
  , nivelM       :: NivelData
  } deriving (Eq, Show)

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
```

Vosotros escribís:

```haskell
actualizarMundo :: Float -> Mundo -> Mundo
manejarEvento   :: Event -> Mundo -> Mundo
```

(`Event`, `Key(..)`, `KeyState(..)` y `SpecialKey(..)` vienen de
`Graphics.Gloss.Interface.Pure.Game`.)

| Función | Puntos | Criterio |
|---|---|---|
| `actualizarMundo dt` | 0.3 | si el estado **no** es `Jugando`, el mundo no cambia. Si lo es: mueve al jugador (`moverJugador`), anima a los enemigos (`animar`), calcula con `colisionaConAlguno` si el jugador toca a algún enemigo (daño; entonces `perderVida`) y si toca alguna meta, y actualiza `estadoM` con `estadoSiguiente` |
| `manejarEvento` | 0.2 | pulsar `←`/`→` fija la velocidad horizontal a `-100`/`100` y pulsar `↑`/`↓` la vertical a `100`/`-100` (sin tocar la otra componente); soltar una flecha anula **su** componente (la horizontal con `←`/`→`, la vertical con `↑`/`↓`); pulsar la tecla `r` devuelve `mundoInicial (nivelM m)`; cualquier otro evento no cambia el mundo |

Para el teclado, el patrón de un evento de tecla especial es, por ejemplo:

```haskell
EventKey (SpecialKey KeyRight) Down _ _        -- flecha derecha pulsada
EventKey (SpecialKey KeyRight) Up   _ _        -- flecha derecha soltada
EventKey (Char 'r') Down _ _                   -- tecla r pulsada
```

**Ejemplos** (con `import Graphics.Gloss.Interface.Pure.Game` y un nivel de tres filas,
`...M` / `.A..` / `####`):

```
> let Right nd = parsearNivelCompleto ["NOMBRE: T", "FONDOS: 1", "---", "...M", ".A..", "####"]
> let m0 = mundoInicial nd
> posJugador (jugadorM m0)
(60.0,120.0)
> estadoM m0
Jugando
> let m1 = manejarEvento (EventKey (SpecialKey KeyRight) Down (Modifiers Up Up Up) (0, 0)) m0
> velJugador (jugadorM m1)
(100.0,0.0)
> let m2 = actualizarMundo 0.5 m1
> posJugador (jugadorM m2)
(110.0,120.0)
> estadoM m2
NivelCompletado
> let m3 = manejarEvento (EventKey (SpecialKey KeyRight) Up (Modifiers Up Up Up) (0, 0)) m2
> velJugador (jugadorM m3)
(0.0,0.0)
```

Y con un jugador que toca a un enemigo (nivel `.A.M`, jugador en `(60, 20)`):

```
> let Right nd3 = parsearNivelCompleto ["NOMBRE: T", "FONDOS: 1", "---", ".A.M"]
> let me = (mundoInicial nd3) { jugadorM = crearJugador (60, 20) }
> let me' = actualizarMundo 0.1 me
> estadoM me'
PierdeVida
> vidas (jugadorM me')
2
> posJugador (jugadorM (actualizarMundo 0.1 me'))   -- el mundo está congelado
(60.0,20.0)
> estadoM (manejarEvento (EventKey (Char 'r') Down (Modifiers Up Up Up) (0, 0)) me')
Jugando
```

### El programa principal (dado)

`Main.hs` **se os da escrito**. Si todo está bien, `runhaskell Main.hs` abre una
ventana con el nivel, que podéis recorrer con las flechas. Vosotros solo podéis cambiar el
contenido de `nivel1Lineas` para probar otros mapas.

```haskell
module Main (main) where

import Graphics.Gloss
import Nivel
import Mundo
import Render

nivel1Lineas :: [String]
nivel1Lineas =
  [ "NOMBRE: Colinas"
  , "FONDOS: 1,2,3"
  , "---"
  , "..................M"
  , "..........A........"
  , "####.....####.#####"
  ]

ventana :: Display
ventana = InWindow "Plataformas" (800, 600) (100, 100)

main :: IO ()
main = case parsearNivelCompleto nivel1Lineas of
  Left err -> display ventana white (scale 0.2 0.2 (text (show err)))
  Right nd -> play ventana white 60 (mundoInicial nd) dibujarMundo manejarEvento actualizarMundo
```

Si el nivel está mal formado, la propia ventana muestra el error de `Either`.

**Nota**: En los materiales del curso, podréis encontrar un video del resultados esperado
de esta tarea.

---

# Bloque 4 — Módulos (2.0 puntos)

## Subtarea 7 — Organización del proyecto en módulos (2.0 puntos)

Revisad el tema de módulos que podéis encontrar en enseñanza virtual.

El código de las subtareas anteriores **no puede estar en un solo fichero**. Dividid el
proyecto en estos módulos (un fichero `.hs` por módulo, mismo nombre que el módulo):

| Módulo | Contenido |
|---|---|
| `Tipos` | `Vector2`, `BoundingBox`, `sumaVectores`, `escalarVector`, `Celda`, `Grid`, `TipoEnemigo`, `EstadoJuego`, y de la Subtarea 1: `parsearCelda`, `parsearGrid`, `celdaAChar`, `esSolido`, `esMeta`, `esEnemigo` |
| `Objeto` | clase `Objeto`, `Plataforma`, `Meta`, `Enemigo`, `solapan`, `colisionaCon`, `colisionaConAlguno` |
| `Jugador` | `Jugador`, su instancia de `Objeto`, y sus funciones (`crearJugador`, `perderVida`, `sumarPuntos`, `conVelocidad`, `moverJugador`, `estadoSiguiente`) |
| `Nivel` | `ErrorNivel`, `NivelData`, `splitOn`, `buscarClave`, `parsearFichero`, `validarNivel`, `parsearNivelCompleto` y las de la Subtarea 6A (`tamCelda`, `posicionCelda`, `gridAPlataformas`, `metasDesdeGrid`, `enemigosDesdeGrid`); más `parsearNiveles` y `todasLasPosiciones` si hacéis el bonus |
| `Partida` | `Partida`, `Entrada` y las funciones de la Subtarea 4 (salvo `buscarClave` y `splitOn`); más `parsearPartidaA` y `puntuacionTotal` si hacéis el bonus |
| `Mundo` | `Mundo`, `mundoInicial`, `actualizarMundo`, `manejarEvento` |
| `Render` | `dibujarObjeto`, `dibujarHUD`, `mensajeEstado`, `dibujarMundo` |
| `Main` | el programa principal dado (`main :: IO ()`) |

| Criterio | Puntos |
|---|---|
| **Compila** con `ghc --make Main.hs` y la ventana de Gloss muestra el nivel y responde al teclado | 0.5 |
| **Listas de exportación explícitas** en todos los módulos salvo `Main`, exportando solo lo necesario (no vale exportar todo por comodidad: ocultad, por ejemplo, `buscarOError` si la usáis internamente) | 0.4 |
| **Dependencias sin ciclos** y coherentes con el diagrama de abajo; sin importaciones innecesarias (`ghc -Wall` no debe avisar de `unused-imports`) | 0.4 |
| **Tipo abstracto `Jugador`**: el módulo `Jugador` exporta el tipo **sin constructor** (`Jugador` y no `Jugador(..)`), junto con los selectores y las funciones necesarias, de modo que ningún otro módulo pueda crear un jugador con `vidas` negativas | 0.4 |
| **Importación cualificada** (`import qualified ... as ...`) usada al menos una vez y con sentido | 0.15 |
| **Documento breve** `LEEME.md` (máx. 1 página) que explica en vuestras palabras qué es un módulo, qué es una lista de exportación y por qué ocultar el constructor de `Jugador` protege las invariantes | 0.15 |

Diagrama de dependencias esperado (una flecha `A → B` significa «`A` importa `B`»):

```
Tipos
Objeto    ──→ Tipos
Jugador   ──→ Tipos, Objeto
Nivel     ──→ Tipos, Objeto
Partida   ──→ Nivel
Mundo     ──→ Tipos, Objeto, Jugador, Nivel
Render    ──→ Tipos, Objeto, Jugador, Mundo
Main      ──→ Nivel, Mundo, Render
```

(`Main` puede importar además lo que necesite; lo importante es que **no haya ciclos**
y que `Tipos` no dependa de ningún otro módulo del proyecto. `Mundo` y `Render` solo pueden
usar las funciones exportadas de `Jugador`, no su constructor.)

**Comprobación del tipo abstracto.** Un fichero cualquiera que importe `Jugador` e intente
`Jugador (0,0) (0,0) (-5) 0` **no debe compilar**. Eso es exactamente lo que se busca: la
única forma de obtener un `Jugador` fuera de su módulo es `crearJugador`.

> Los alumnos deben consultar la presentación de módulos publicada en Enseñanza Virtual.
> Si surge alguna duda, planteadla en el foro de la asignatura.

---

# Bonus — `Functor`, `Applicative` y `Monad` (hasta +1.0 punto extra)

Puntuación: 0.25 puntos por función, hasta un máximo de 1.0. Se trata de **reescribir en
estilo funcional** código que ya sabéis hacer con `case`/`do`, usando las operaciones de
las clases `Functor`, `Applicative` y `Monad`/`Traversable` (`fmap`, `<$>`, `<*>`, `pure`,
`>>=`, `traverse`…). **Prohibido usar `case` y `do`** en estas cuatro funciones.

```haskell
parsearPartidaA    :: [String] -> Maybe Partida          -- módulo Partida
puntuacionTotal    :: [String] -> Maybe Int              -- módulo Partida
parsearNiveles     :: [[String]] -> Either ErrorNivel [NivelData]   -- módulo Nivel
todasLasPosiciones :: Grid -> [(Int, Int)]               -- módulo Nivel
```

| Función | Puntos | Qué se pide |
|---|---|---|
| `parsearPartidaA` | 0.25 | **`Applicative`**: igual que `parsearPartida` (Subtarea 4), pero construyendo `Partida` con `<$>` y `<*>` en lugar de `do`. Debe dar exactamente los mismos resultados |
| `puntuacionTotal` | 0.25 | **`Functor`**: suma los puntos de una tabla de puntuaciones válida (`parsearLeaderboard`), aplicando una función **dentro** del `Maybe` con `<$>`/`fmap` |
| `parsearNiveles` | 0.25 | **`traverse`** (o `mapM`) sobre `Either`: interpreta y valida una lista de niveles con `parsearNivelCompleto`; devuelve todos los niveles o **el primer error** |
| `todasLasPosiciones` | 0.25 | **`Applicative` de listas**: todas las posiciones `(fila, columna)` de una rejilla rectangular, en orden de filas, con `(,) <$> ... <*> ...` y sin comprensiones |

**Ejemplos:**

```
> parsearPartidaA ["NIVEL: 2", "VIDAS: 3", "PUNTUACION: 150"]
Just (Partida {nivelGuardado = 2, vidasGuardadas = 3, puntuacionGuardada = 150})
> parsearPartidaA ["NIVEL: 2", "VIDAS: tres", "PUNTUACION: 150"]
Nothing
> parsearPartidaA ["NIVEL: 2", "VIDAS: 3"]
Nothing
> puntuacionTotal ["Ana;120", "Luis;340", "Eva;200"]
Just 660
> puntuacionTotal []
Just 0
> puntuacionTotal ["Ana;120", "roto"]
Nothing
> parsearNiveles [["NOMBRE: A", "FONDOS: 1", "---", "..M"], ["NOMBRE: B", "FONDOS: 2", "---", "#.M"]]
Right [NivelData {nombreNivel = "A", fondos = [1], gridNivel = [[Vacio,Vacio,META]]},NivelData {nombreNivel = "B", fondos = [2], gridNivel = [[Solido,Vacio,META]]}]
> parsearNiveles [["NOMBRE: A", "FONDOS: 1", "---", "..M"], ["NOMBRE: B", "FONDOS: 2", "---", "..."]]
Left NivelSinMeta
> parsearNiveles []
Right []
> todasLasPosiciones (parsearGrid ["..", "#."])
[(0,0),(0,1),(1,0),(1,1)]
> todasLasPosiciones (parsearGrid ["..M"])
[(0,0),(0,1),(0,2)]
> todasLasPosiciones []
[]
```

---

## Resumen de la puntuación

| Subtarea | Puntos |
|---|---|
| **Bloque 1 — Definición de tipos** | |
| 1. `Celda` como tipo algebraico | 1.0 |
| 2. Registros: jugador, enemigos y estado | 1.0 |
| 3. Clase `Objeto` | 1.0 |
| *Subtotal Bloque 1* | *3.0* |
| **Bloque 2 — Mónadas** | |
| 4. `Maybe`: partida y puntuaciones | 1.25 |
| 5. `Either`: interpretar y validar un nivel | 1.75 |
| *Subtotal Bloque 2* | *3.0* |
| **Bloque 3 — Gloss** | |
| 6. Del mapa al mundo jugable (6A 0.75 · 6B 0.75 · 6C 0.5) | 2.0 |
| *Subtotal Bloque 3* | *2.0* |
| **Bloque 4 — Módulos** | |
| 7. Organización en módulos | 2.0 |
| *Subtotal Bloque 4* | *2.0* |
| **Total (obligatorio)** | **10.0** |
| Bonus `Functor`/`Applicative`/`Monad` *(opcional)* | hasta +1.0 |


## Criterios transversales

- **Tipos explícitos**: toda función lleva su firma. No se admiten tipos distintos a los
  indicados (nombres de tipos, constructores y campos).
- **Totalidad**: ninguna función puede fallar en tiempo de ejecución por patrones no
  cubiertos. Compilad con `ghc -Wall` y no dejéis avisos `incomplete-patterns`.
- **Uso correcto de la mónada que corresponde**: lo que sea análisis con posible fallo
  se hace en `Maybe`/`Either`; el `main` dado es el único código con `IO`.
- **Sin duplicación**: reutilizad `buscarClave`, `splitOn`, `posicionCelda`,
  `sumaVectores`, etc., en lugar de reescribirlas.
- **Casos límite a considerar**: listas vacías, claves repetidas, líneas en blanco, 
  números negativos, mapas sin enemigos o sin sólidos.