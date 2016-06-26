; Definición de los atributos propios de un valor
(deftemplate Valor
    (slot Nombre)
    (slot Precio)
    (slot VarDia)
    (slot Capitalizacion)
    (slot PER)
    (slot RPD)
    (slot Tam)
    (slot Ibex)
    (slot EtiqPER)
    (slot EtiqRPD)
    (slot Sector)
    (slot Var5Dias)
    (slot Perd3Consec)
    (slot Perd5Consec)
    (slot VarRelativaSector)
    (slot VarRelativaSectorChico)
    (slot VarMensual)
    (slot VarTrimestral)
    (slot VarSemestral)
    (slot VarAnual)
    (slot Estabilidad
        (default NULL)
    )
    (multislot Valoracion
        (default NULL)
    )
)

; Definición de los atributos propios de un sector
(deftemplate Sector
    (slot Nombre)
    (slot VarDia)
    (slot Capitalizacion)
    (slot PER)
    (slot RPD)
    (slot Ibex)
    (slot Var5Dias)
    (slot Perd3Consec)
    (slot Perd5Consec)
    (slot VarMensual)
    (slot VarTrimestral)
    (slot VarSemestral)
    (slot VarAnual)
)

; Definición de los atributos propios de una noticia
(deftemplate Noticia
    (slot Nombre)
    (slot Tipo)
    (slot Antiguedad)
)

; Definición de los atributos propios de un valor en la cartera
(deftemplate ValorCartera
    (slot Nombre)
    (slot Acciones)
    (slot Valor)
    (multislot Peligroso
        (default false)
    )
)

; Definición de los atributos propios de una posible propuesta al usuario
(deftemplate Propuesta
    (slot Propuesta)
    (slot Acciones)
    (slot Razon)
)
