(deftemplate TTT
    (slot SSS)
    (slot otroSlot)
)

; Función genérica para encontrar el máximo valor del slot ?slot entre todos
; los hechos del template ?plantilla. Ejemplo de llamada: (valorMaximo TTT SSS)
(deffunction valorMaximo (?plantilla ?slot)
    ; "Inicializamos" el máximo a algo nulo
    (bind ?max FALSE)

    ; Recorremos todos los hechos sin ninguna restricción
    (do-for-all-facts ((?hecho ?plantilla)) TRUE
        ; Si el máximo no está aún inicializado o si el hecho actual tiene
        ; ?slot mayor que el del máximo, actualizamos el máximo.
        (if (or (not ?max)
                (> (fact-slot-value ?hecho ?slot) (fact-slot-value ?max ?slot))
            ) then
            (bind ?max ?hecho)
        )
    )

   (return (fact-slot-value ?max ?slot))
)
