; 1.- Los valores del sector de la construcción son inestables por defecto
(defrule Construccion
    ; Las noticias generales son menos prioritarias que las específicas a
    ; un sector o valor, luego deben analizarse antes para reescribirlas
    ; después si fuera necesario.
    (declare (salience 10))

    ?f <- (Valor (Nombre ?valor) (Sector Construccion))
    =>
    (modify ?f (Estabilidad Inestable))
)

; 2.- Si la economía está bajando, los valores del sector servicios son
; inestables por defecto.
(defrule EconomiaBajaSectores
    ; Las noticias generales son menos prioritarias que las específicas a
    ; un sector o valor, luego deben analizarse antes para reescribirlas
    ; después si fuera necesario.
    (declare (salience 10))

    ?f <- (Valor (Nombre ?valor) (Sector Servicios))
    ; La economía va mal si el sector Ibex ha tenido pérdidas en los últimos
    ; 5 días
    (Sector (Nombre Ibex) (Perd5Consec true))
    =>
    (modify ?f (Estabilidad Inestable))
)

; 6.- Si hay una noticia negativa sobre la economía, todos los valores pasan a
; ser inestables durante 2 días.
(defrule NoticiaNegativaEconomia
    ; Las noticias generales son menos prioritarias que las específicas a
    ; un sector o valor, luego deben analizarse antes para reescribirlas
    ; después si fuera necesario.
    (declare (salience 10))

    ?f <- (Valor (Nombre ?valor))
    (Noticia (Nombre Economia) (Tipo Mala) (Antiguedad ?antig))
    (test (<= ?antig 2))
    =>
    (modify ?f (Estabilidad Inestable))
)


; 3.- Si hay una noticia positiva sobre él o su sector, un valor inestable deja
; de serlo durante 2 días
(defrule NoticiaPositiva
    ; Las noticias positivas siempre prevalecen sobre las negativas, así que
    ; esta regla debe ejecutarse la última.
    (declare (salience -10))
    ?f <- (Valor (Nombre ?valor) (Sector ?sector))
    (Noticia (Nombre ?noticia) (Tipo Buena) (Antiguedad ?antig))
    (test (<= ?antig 2))
    (or (eq ?noticia ?valor) (eq ?noticia ?sector))
    =>
    (modify ?f (Estabilidad Estable))
)

; 4.- Si hay una noticia negativa sobre él, un valor pasa a ser inestable
; durante 2 días
; 5.- Si hay una noticia negativa sobre un sector, los valores del sector pasan
; a ser inestables durante 2 días
(defrule NoticiaNegativa
    ?f <- (Valor (Nombre ?valor) (Sector ?sector))
    (Noticia (Nombre ?noticia) (Tipo Mala) (Antiguedad ?antig))
    (test
        (or (eq ?noticia ?valor) (eq ?noticia ?sector))
    )
    (test (<= ?antig 2))
    =>
    (modify ?f (Estabilidad Inestable))
)
