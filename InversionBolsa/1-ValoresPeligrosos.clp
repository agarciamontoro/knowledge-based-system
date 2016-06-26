(defrule ValorPeligrosoInestable
    (Modulo 1)
    (Valor (Nombre ?valor) (Estabilidad Inestable) (Perd3Consec true))
    ?f <- (ValorCartera (Nombre ?valor) (Peligroso false))
    =>
    (modify ?f (Peligroso true))
)

(defrule ValorPeligrosoVariacion
    (Modulo 1)
    ; TODO: Mirar si la ValRelativaSectorGrande debe ser true o false :(
    (Valor (Nombre ?valor) (Perd5Consec true) (VarRelativaSectorChico false))
    ?f <- (ValorCartera (Nombre ?valor) (Peligroso false))
    =>
    (modify ?f (Peligroso true))
)

; Cambia al módulo 2
(defrule AvanzarAModulo2
    (declare (salience -10000))
    ?f <- (Modulo 1)
    =>
    (retract ?f)
    (assert (Modulo 2))
)
