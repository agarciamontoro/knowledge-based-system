; Si el PER es Bajo y el RPD alto, la empresa está infravalorada
(defrule InfravaloracionGeneral
    (Modulo 3)
    ?f <- (Valor (EtiqPER Bajo) (EtiqRPD Alto) (Valoracion ~Infravalorado ?x))

    =>

    ; Modificamos la valoración de la empresa y añadimos la razón
    (modify ?f (Valoracion Infravalorado "el PER es bajo y el RPD, alto"))
)

; Si la empresa ha caído bastante (más de un 30%) (en los últimos 3, 6 o 12 ), ; ha subido pero no mucho en el último mes, y el PER es bajo, la  empresa está
; infravalorada
(defrule InfravaloracionCaida
    (Modulo 3)
    ?f <- (Valor (EtiqPER Bajo) (VarMensual ?mes)
                 (Valoracion ~Infravalorado ?x) (VarTrimestral ?trim)
                 (VarSemestral ?sem) (VarAnual ?anual))
    (and
        ; El experto indicó que "subir no mucho" es estar entre un 0% y un 10%
        (> ?mes 0) (< ?mes 10)
        ; La caída anterior puede ser trimestral, semestral o anual
        (or
            (< ?trim -30)
            (< ?sem -30)
            (< ?anual -30)
        )
    )

    =>

    ; Definimos el razonamiento que nos ha llevado a catalogar la empresa como
    ; infravalorada.
    (if (< ?trim -30) then
        (bind ?razonVar (str-cat ?trim "% en el último trimestre"))
    else
        (if (< ?sem -30) then
            (bind ?razonVar (str-cat ?sem "% en el último semestre"))
        else
            (bind ?razonVar (str-cat ?anual "% en el último año"))
        )
    )

    ; Modificamos la valoración de la empresa y añadimos la razón
    (modify ?f (Valoracion Infravalorado
                    (str-cat "el PER es bajo, la empresa ha caído un " ?razonVar " y ha subido, pero no mucho, en el último mes")
                )
    )
)


; Si la empresa es grande, el RPD es alto y el PER Mediano, además no está
; bajando y se comporta mejor que su sector, la empresa está infravalorada
(defrule InfravaloracionEmpresaGrande
    (Modulo 3)
    ?f <- (Valor (EtiqPER Medio) (EtiqRPD Alto) (Tam Grande)
                 (VarMensual ?mes) (VarRelativaSector ?varSector)
                 (Valoracion ~Infravalorado ?x))
    (and
        (>= ?mes 0) ; La empresa no está bajando
        (> ?varSector 0) ; Se comporta mejor que su sector
    )

    =>

    ; Modificamos la valoración de la empresa y añadimos la razón
    (modify ?f (Valoracion Infravalorado
                    (str-cat "la empresa es grande y no está bajando, el RPD es alto, el PER es medio y además tiene una variación positiva de un" ?varSector "% con respecto a su sector"))
    )
)

; Cambia al módulo 4
(defrule AvanzarAModulo4
    (declare (salience -1))
    ?f <- (Modulo 3)
    =>
    (retract ?f)
    (assert (Modulo 4))
)
