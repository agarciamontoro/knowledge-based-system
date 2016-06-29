; 1.- Los valores del sector de la construcción son inestables por defecto
(defrule Construccion
    (Modulo 0)
    ?f <- (Valor (Nombre ?valor) (Sector Construccion)
                 (Estabilidad ~Inestable))
    =>
    (modify ?f (Estabilidad Inestable))
)

; 2.- Si la economía está bajando, los valores del sector servicios son
; inestables por defecto.
(defrule EconomiaBajaSectores
    (Modulo 0)
    ; La economía va mal si el Ibex ha tenido pérdidas en los últimos 5 días
    (Sector (Nombre Ibex) (Perd5Consec true))
    ?f <- (Valor (Nombre ?valor) (Sector Servicios)
                 (Estabilidad ~Inestable))
    =>
    (modify ?f (Estabilidad Inestable))
)

; 3.- Si hay una noticia positiva sobre él o su sector, un valor inestable deja
; de serlo durante 2 días
(defrule NoticiaPositiva
    ; Las noticias positivas siempre prevalecen sobre las negativas, así que
    ; esta regla debe ejecutarse la última.
    (declare (salience -1))
    (Modulo 0)
    ?f <- (Valor (Nombre ?valor) (Sector ?sector)
                 (Estabilidad ~Estable))
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
; 6.- Si hay una noticia negativa sobre la economía, todos los valores pasan a
; ser inestables durante 2 días.
(defrule NoticiaNegativa
    (Modulo 0)
    ?f <- (Valor (Nombre ?valor) (Sector ?sector)
                 (Estabilidad ~Inestable))
    (Noticia (Nombre ?noticia) (Tipo Mala) (Antiguedad ?antig))
    (or (eq ?noticia ?valor) (eq ?noticia ?sector) (eq ?noticia ECONOMIA))
    (test (<= ?antig 2))
    =>
    (modify ?f (Estabilidad Inestable))
)

; Cambia al módulo 1
(defrule AvanzarAModulo1
    (declare (salience -2))
    ?f <- (Modulo 0)
    =>
    (retract ?f)
    (assert (Modulo 1))
)
