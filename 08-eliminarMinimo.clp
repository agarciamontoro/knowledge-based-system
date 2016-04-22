(deftemplate TTT
    (slot SSS)
    (slot otroSlot)
)

; Regla genérica que elimina el hecho del tipo ?plantilla con el menor valor en ; el slot ?slot. Ej. de uso: (assert (Eliminar TTT menor SSS))
(defrule eliminarMinimo
    (Eliminar ?plantilla menor ?slot)
    =>

    ; "Inicializamos" el mínimo a algo nulo
    (bind ?min FALSE)

    ; Recorremos todos los hechos del tipo ?plantilla sin ninguna restricción
    (do-for-all-facts ((?hecho ?plantilla)) TRUE
        ; Si el mínimo no está aún inicializado o si el hecho actual tiene
        ; ?slot menor que el del mínimo, actualizamos el mínimo.
        (if (or (not ?min)
                (< (fact-slot-value ?hecho ?slot) (fact-slot-value ?min ?slot))
            ) then
            (bind ?min ?hecho)
        )
    )

    ; Eliminamos el hecho encontrado
    (retract ?min)
)
