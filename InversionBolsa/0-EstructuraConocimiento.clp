; Definición de los atributos propios de un valor
(deftemplate Valor
    (field Nombre)
    (field Precio)
    (field VarDia)
    (field Capitalizacion)
    (field PER)
    (field RPD)
    (field Tam)
    (field Ibex)
    (field EtiqPER)
    (field EtiqRPD)
    (field Sector)
    (field Var5Dias)
    (field Perd3Consec)
    (field Perd5Consec)
    (field VarRelativaSector)
    (field VarRelativaSectorChico)
    (field VarMes)
    (field VarTri)
    (field VarSem)
    (field VarAnual)
    (field Estabilidad
        (default NULL)
    )
)

; Definición de los atributos propios de un sector
(deftemplate Sector
    (field Nombre)
    (field VarDia)
    (field Capitalizacion)
    (field PER)
    (field RPD)
    (field Ibex)
    (field Var5Dias)
    (field Perd3Consec)
    (field Perd5Consec)
    (field VarMensual)
    (field VarTrimestral)
    (field VarSemestral)
    (field VarAnual)
)

; Definición de los atributos propios de una noticia
(deftemplate Noticia
    (field Nombre)
    (field Tipo)
    (field Antiguedad)
)

; Definición de los atributos propios de un valor en la cartera
(deftemplate ValorCartera
    (field Nombre)
    (field Acciones)
    (field Valor)
    (field Peligroso
        (default false)
    )
)
