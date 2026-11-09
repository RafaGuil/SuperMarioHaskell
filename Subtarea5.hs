module Subtarea5 where

import Text.Read (readMaybe)
import Provisional   -- temporal: en el merge se cambia por los módulos del grupo

-- Errores posibles al interpretar un nivel (dado en el enunciado).
data ErrorNivel
  = FormatoInvalido String
  | NivelSinMeta
  | NivelConVariasMetas Int
  deriving (Eq, Show)

-- Datos de un nivel ya interpretado (dado en el enunciado).
data NivelData = NivelData
  { nombreNivel :: String
  , fondos      :: [Int]
  , gridNivel   :: Grid
  } deriving (Eq, Show)