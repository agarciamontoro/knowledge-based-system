; Si una empresa es peligrosa, ha bajado el último mes y ha bajado más de
; un 3% con respecto a su sector  en el último mes,  proponer vender las
; acciones de la empresa.
(defrule VentaPeligrosas
    (Modulo 4)
    (ValorCartera (Nombre ?valor) (Peligroso true ?razon) (Acciones ?acc))
    (Valor (Nombre ?valor) (VarMensual ?mes) (VarRelativaSector ?rel)
           (RPD ?rpd))

           (printout t "Recalculando propuestas..." crlf)
    =>

    (assert
        (Propuesta
            (Propuesta Vender ?valor NULL)
            (RE (- 20 ?rpd))
            (Razon
                (str-cat "La empresa es peligrosa porque " ?razon ". Además, está entrando en tendencia bajista con respecto a su sector. Según mi estimación, existe una probabilidad no despreciable de que pueda caer al cabo del año un 20%: aunque produzca " ?rpd "% por dividendos, perderíamos un " (- 20 ?rpd) "%")
            )
            (PropuestaRedactada
                (str-cat "Vender las " ?acc " acciones que tienes en " ?valor)
            )
        )
    )
)

; Si una empresa está infravalorada y el usuario tiene dinero para invertir
; proponer invertir el dinero en las acciones de la empresa.
;;;; RE=(PERMedio-PER)*100/(5*PER)+RPD
(defrule InvertirInfravalorada
    (Modulo 4)
    (Valor (Nombre ?valor) (Valoracion Infravalorado ?razonInfra)
           (Sector ?sector) (Precio ?precio) (PER ?per) (RPD ?rpd))
    (Sector (Nombre ?sector) (PER ?perMedio))
    (ValorCartera (Nombre DISPONIBLE) (Valor ?dinero))
    (test (> ?dinero ?precio))

    =>

    (assert
        (Propuesta
            (Propuesta Comprar NULL ?valor)
            (RE
                (+
                    (* 100 (/ (- ?perMedio ?per) (* 5 ?per)))
                    ?rpd
                )
            )
            (Razon
                (str-cat "Esta empresa está infravalorada -" ?razonInfra "- y seguramente el PER tienda al PER medio en 5 años, con lo que se debería revalorizar un " (/ (- ?perMedio ?per) (* 5 ?per)) "% anual a lo que habría que sumar el " ?rpd "% de beneficios por dividendos")
            )
            (PropuestaRedactada
                (str-cat "Comprar acciones de " ?valor)
            )
        )
    )
)

; Si una empresa de mi cartera está sobrevalorada y el rendimiento por
; año < 5 + precio dinero, proponer vender las acciones de esa empresa;
(defrule VenderSobrevalorada
    (Modulo 4)
    (ValorCartera (Nombre ?valor) (Acciones ?acc))
    (Valor (Nombre ?valor) (Valoracion Sobrevalorado ?razonSobre) (RPA ?rpa)
           (PER ?per) (RPD ?rpd) (Sector ?sector))
    (Sector (Nombre ?sector) (PER ?perMedio))

    (test (< ?rpa (+ 5 ?*precioDinero*)))
    (test (neq ?per 0)) ; Evitamos dividir por cero.

    =>

    (assert
        (Propuesta
            (Propuesta Vender ?valor NULL)
            (RE
                (-
                    (* 100 (/ (- ?per ?perMedio) (* 5 ?per)))
                    ?rpd
                )
            )
            (Razon
                (str-cat "Esta empresa está sobrevalorada -" ?razonSobre "-, es mejor amortizar lo invertido, ya que seguramente el PER tan alto deberá bajar al PER medio del sector en unos 5 años, con lo que se debería devaluar un " (/ (- ?per ?perMedio) (* 5 ?per)) "% anual, así que aunque se pierda el " ?rpd "% de beneficios por dividendos, saldría rentable")
            )
            (PropuestaRedactada
                (str-cat "Vender las " ?acc " acciones que tienes en " ?valor)
            )
        )
    )
)

; Proponer cambiar una inversión a valores más rentables
(defrule CambiarInversion
    (Modulo 4)
    (Valor (Nombre ?empresa1) (Valoracion ~Sobrevalorado ?a) (RPD ?rpd1))
    (ValorCartera (Nombre ?empresa2))
    (Valor (Nombre ?empresa2) (Valoracion ~Infravalorado ?b) (RPD ?rpd2)
           (RPA ?rpa2))
    (test (neq ?empresa1 ?empresa2))

    (test (> ?rpd1 (+ ?rpa2 ?rpd2 1)))

    =>

    (assert
        (Propuesta
            (Propuesta Cambiar ?empresa2 ?empresa1)
            (RE (- ?rpd1 (+ ?rpa2 ?rpd2 1)))
            (Razon
                (str-cat ?empresa1 " debe tener una revalorización acorde con la evolución de la bolsa. Por dividendos se espera un " ?rpd1 "%, que es más de lo que te está dando " ?empresa2 ", por eso te propongo cambiar los valores por los de esta otra. Aunque se pague el 1% del coste del cambio te saldría rentable")
            )
            (PropuestaRedactada
                (str-cat "Destinar a " ?empresa1 " la inversión que actualmente tienes en " ?empresa2)
            )
        )
    )

)

; Cambia al módulo 5
(defrule AvanzarAModulo5
    (declare (salience -1))
    ?f <- (Modulo 4)
    =>
    (retract ?f)
    (assert (Modulo 5))
)
