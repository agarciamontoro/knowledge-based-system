(defrule IniciarContador
    ; Si se pide contar hechos...
    (ContarHechos ?hecho)
    ; ... y no hemos empezado aún a contar...
    (not (NumeroHechos ?hecho ?n))
    =>
    ; ... iniciamos el contador a 0.
    (assert (NumeroHechos ?hecho 0))
)

(defrule GenerarSuma
    ; Por cada hecho del tipo que hay que contar...
    (ContarHechos ?hecho)
    (Hecho ?hecho $?)
    =>
    ;... añadimos un sumatorio de uno.
    (assert (SumarUno ?hecho))
)

(defrule ContarUno
    ; Si hay un sumatorio de uno...
    ?sum <- (SumarUno ?hecho)
    ; ... y el número de hechos es n...
    ?prevCont <- (NumeroHechos ?hecho ?n)
    =>
    ; ... ponemos el número de hechos a n+1...
    (assert (NumeroHechos ?hecho (+ ?n 1)))
    ; ... y eliminamos el sumatorio y el anterior número de hechos n.
    (retract ?sum ?prevCont)
)
