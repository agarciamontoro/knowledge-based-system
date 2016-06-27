; Si una empresa es peligrosa, ha bajado el último mes y ha bajado más de
; un 3% con respecto a su sector  en el último mes,  proponer vender las
; acciones de la empresa.
(defrule VentaPeligrosas
    (Modulo 4)
    (ValorCartera (Nombre ?valor) (Peligroso true ?razon) (Acciones ?acc))
    (Valor (Nombre ?valor) (VarMensual ?mes) (VarRelativaSector ?rel)
           (RPD ?rpd))
    =>
    (assert
        (Propuesta
            (Propuesta Vender)
            (NumAcciones ?acc)
            (RE (- 20 ?rpd))
            (Razon
                (str-cat "La empresa es peligrosa porque " ?razon ". Además, está entrando en tendencia bajista con respecto a su sector. Según mi estimación, existe una probabilidad no despreciable de que pueda caer al cabo del año un 20%: aunque produzca " ?rpd "% por dividendos, perderíamos un " (- 20 ?rpd) "%")
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
    (ValorCartera (Nombre Disponible) (Valor ?dinero))
    (> ?dinero ?precio)

    =>

    (assert
        (Propuesta
            (Propuesta Comprar)
            ; TODO: Ver qué número de acciones proponemos :(
            (NumAcciones 100000000000000000)
            (RE
                (/
                    (- ?perMedio ?per)
                    (+ (* 5 ?per) ?rpd)
                )
            )
            (Razon
                (str-cat "Esta empresa está infravalorada -" ?razonInfra "- y seguramente el PER tienda al PER medio en 5 años, con lo que se debería revalorizar un " (/ (- ?perMedio ?per) (* 5 ?per)) "% anual a lo que habría que sumar el " ?rpd "% de beneficios por dividendos")
            )
        )
    )
)

; Si una empresa de mi cartera está sobrevalorada y el rendimiento por
; año < 5 + precio dinero, proponer vender las acciones de esa empresa;
(defrule VenderSobrevalorada
    (Modulo 4)
    (ValorCartera (Nombre ?valor) (Acciones ?numAcciones))
    (Valor (Nombre ?valor) (Valoracion Sobrevalorada ?razonSobre); (RPA ?rpa)
           (PER ?per) (RPD ?rpd) (Sector ?sector))
    (Sector (Nombre ?sector) (PER ?perMedio))

    ; TODO: Definir RPA y *PrecioDinero*
    ;(< ?rpa (+ 5 ?*PrecioDinero*))

    =>

    (assert
        (Propuesta
            (Propuesta Vender)
            (NumAcciones ?numAcciones)
            (RE
                (/
                    (- (- ?per ?perMedio) ?rpd)
                    (* 5 ?per)
                )
            )
            (Razon
                (str-cat "Esta empresa está sobrevalorada -" ?razonSobre "-, es mejor amortizar lo invertido, ya que seguramente el PER tan alto deberá bajar al PER medio del sector en unos 5 años, con lo que se debería devaluar un " (/ (- ?per ?perMedio) (* 5 ?per)) "% anual, así que aunque se pierda el " ?rpd "% de beneficios por dividendos, saldría rentable")
            )
        )
    )
)












;;;; Proponer cambiar una inversión a valores más rentables
;;;; Si una empresa (empresa1) no está sobrevalorada y  su RPD  es mayor que el
;;;; (revalorización por año esperado + RPD+1) de una empresa de mi cartera (empresa 2)   ;;;;  que no está infravalorada, proponer cambiar las acciones de una empresa por las de la
;;;; otra, RE= (RPD empresa1 - (rendimiento por año obtenido  empresa2 + rdp empresa2 +1)
;;;; Explicación: empresa1 debe tener una revalorización acorde con la evolución de la bolsa. ;;;; Por dividendos se espera un RPD%, que es más de lo que te está dando  empresa2, por ;;;; eso te propongo cambiar los valores por los de esta otra (rendimiento por año obtenido de ;;;; revalorización + rdp de beneficios). Aunque se pague  el 1% del coste del cambio te saldría ;;;; rentable).
