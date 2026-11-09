# Organización en módulos

## ¿Qué es un módulo?

Un módulo es un fichero `.hs` que agrupa definiciones relacionadas (tipos, clases,
funciones) bajo un nombre, que coincide con el del fichero. Sirve para repartir el
programa en piezas con una responsabilidad clara: `Tipos` tiene los tipos básicos,
`Objeto` la clase de objetos del mundo, `Nivel` la lectura del mapa, `Render` el dibujo,
etc. Cada módulo indica con `import` qué necesita de los demás, así que las dependencias
quedan a la vista y el compilador puede comprobar que no hay ciclos
(simplificado; `A <- B` significa «`B` importa `A`»):

```
Tipos  <-  Objeto  <-  Jugador, Nivel  <-  Mundo  <-  Render  <-  Main
                       Nivel  <-  Partida
```

## ¿Qué es una lista de exportación?

Es la lista entre paréntesis que va tras `module X (...) where`. Indica qué partes del
módulo pueden usar los demás; lo que no aparece queda privado. Así separamos la
**interfaz** (lo que ofrecemos) de la **implementación** (cómo lo hacemos). Por ejemplo,
`Nivel` exporta `parsearFichero` pero oculta `separar`, `buscarOError` y `leerFondos`, que
son solo pasos internos: si mañana los cambiamos, ningún otro módulo se rompe.

En un tipo se puede exportar el nombre con sus constructores (`Celda(..)`) o **solo el
nombre** (`Jugador`). En el segundo caso, fuera del módulo se puede usar el tipo, pero no
construir ni desmontar sus valores con el constructor.

## ¿Por qué ocultar el constructor de `Jugador`?

Un jugador tiene una **invariante**: sus vidas nunca son negativas. Dentro de `Jugador`
todas las funciones la respetan (`crearJugador` empieza con 3 vidas y `perderVida` usa
`max 0`). Si exportáramos `Jugador(..)`, cualquier módulo podría escribir
`Jugador (0,0) (0,0) (-5) 0` y crear un jugador imposible, que luego llegaría a
`estadoSiguiente` o al HUD.

Al exportar solo `Jugador`, junto con los selectores y las funciones, la única forma de
obtener un jugador fuera del módulo es `crearJugador`, y la única forma de cambiarlo es
con las funciones exportadas. Ese código de prueba ya **no compila**
(`Data constructor not in scope: Jugador`): el compilador garantiza la invariante y no
tenemos que comprobarla en `Mundo` ni en `Render`.

## Importación cualificada

En `Render` importamos `Jugador (Jugador)` para el nombre del tipo y
`import qualified Jugador as J` para el resto (`J.vidas`, `J.puntuacion`,
`J.posJugador`). Al leer el código se ve enseguida que esos datos vienen de la interfaz
pública del tipo abstracto y no de `Mundo`, que también tiene campos del jugador
(`jugadorM`).
