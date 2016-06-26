(defrule VentaPeligrosas
    (ValorCartera (Nombre ?valor) (Peligroso true ?razon) (Acciones ?acc))
    (Valor (Nombre ?valor) (VarMensual ?mes) (VarRelativaSector ?rel))
    =>
    (assert
        (Propuesta
            (Propuesta Vender)
            (Acciones ?acc)
            (Razon
                (str-cat "La empresa es peligrosa por " ?razon ". Además, está entrando en tendencia bajista con respecto a su sector. Según mi estimación, existe una probabilidad no despreciable de que pueda caer al cabo del año un 20%: aunque produzca " ?rpd " por dividendos, perderíamos un " (- 20 ?rpd))
            )
        )
    )

)


"La empresa es peligrosa por …..; además está entrando en  tendencia bajista ;;;; con respecto a su sector.  Según mi estimación existe una probabilidad no despreciable  de ;;;; que pueda caer al cabo del año un 20%, aunque produzca rpd% por dividendos
;;;; perderíamos un 20-rpd %)
