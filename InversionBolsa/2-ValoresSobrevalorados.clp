; Si el PER es Alto y el RPD bajo, la empresa está sobrevalorada
(defrule SobrevaloracionGeneral
    (Modulo 2)
    ?f <- (Valor (EtiqPER Alto) (EtiqRPD Bajo) (Valoracion ~Sobrevalorado ?x))
    =>
    (modify ?f (Valoracion Sobrevalorado "el PER es alto y el RPD, bajo"))
)

; Caso Empresa pequeña:
; Si el PER es alto entonces la empresa está sobrevalorada
; Si el PER es Mediano y el RPD es bajo la empresa está sobrevalorada
(defrule SobrevaloracionEmpresaPequenia1
    (Modulo 2)
    ?f <- (Valor (EtiqPER ?per) (EtiqRPD ?rpd) (Tam PEQUENIA)
                 (Valoracion ~Sobrevalorado ?x))
    (or
        (eq ?per Alto)
        (and (eq ?per Medio) (eq ?rpd Bajo))
    )
    =>
    (bind ?razon "la empresa es pequeña")
    (if (eq ?per Alto) then
        (bind ?razon (str-cat ?razon " y el PER es alto"))
     else
         (bind ?razon (str-cat ?razon ", el PER es medio y el RPD es bajo"))

    )
    (modify ?f (Valoracion Sobrevalorado ?razon))
)

; Caso  Empresa grande:
; Si el RPD es bajo y el PER es Mediano o Alto la empresa está sobrevalorada
; Si el RPD es Mediano y el PER es Alto la empresa está sobrevalorada
(defrule SobrevaloracionEmpresaGrande
    (Modulo 2)
    ?f <- (Valor (EtiqPER ?per) (EtiqRPD ?rpd) (Tam GRANDE)
                 (Valoracion ~Sobrevalorado ?x))
    (or
        (and
            (eq ?rpd Bajo)
            (or (eq ?per Medio) (eq ?per Alto))
        )
        (and
            (eq ?rpd Medio)
            (eq ?per Alto)
        )
    )
    =>
    (bind ?razon "la empresa es grande")
    (if (and (eq ?rpd Medio) (eq ?per Alto)) then
        (bind ?razon (str-cat ?razon ", el RPD es medio y el PER, alto"))
     else
         (bind ?razon (str-cat ?razon ", el RPD es bajo y el PER es medio-alto"))
    )
    (modify ?f (Valoracion Sobrevalorado ?razon))
)

; Cambia al módulo 3
(defrule AvanzarAModulo3
    (declare (salience -1))
    ?f <- (Modulo 2)
    =>
    (retract ?f)
    (assert (Modulo 3))
)
