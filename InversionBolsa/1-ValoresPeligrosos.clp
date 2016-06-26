; Si un valor es inestable y está perdiendo de forma continua durante los
; últimos 3 dias es peligroso
(defrule ValorPeligrosoInestable
    (Modulo 1)
    (Valor (Nombre ?valor) (Estabilidad Inestable) (Perd3Consec true))
    ?f <- (ValorCartera (Nombre ?valor) (Peligroso false))
    =>
    (modify ?f (Peligroso true "el valor es inestable y, además, ha tenido pérdidas durante los últimos tres días"))
)

; Si un valor está perdiendo durante los últimos 5 dias y la variación en esos
; 5 días con respecto a la variación del sector es mayor de un -5%, ese valor
; es peligroso
(defrule ValorPeligrosoVariacion
    (Modulo 1)
    ; TODO: Mirar si la ValRelativaSectorGrande debe ser true o false :(
    (Valor (Nombre ?valor) (Perd5Consec true) (VarRelativaSectorChico false)
           (VarRelativaSector ?varRel))
    ?f <- (ValorCartera (Nombre ?valor) (Peligroso false))
    =>
    (modify ?f (Peligroso true
                    (str-cat "el valor ha tenido pérdidas durante los últimos cinco días, en los que su variación con respecto a la del sector ha sido de un " ?varRel "%")
               )
    )
)

; Cambia al módulo 2
(defrule AvanzarAModulo2
    (declare (salience -1))
    ?f <- (Modulo 1)
    =>
    (retract ?f)
    (assert (Modulo 2))
)
