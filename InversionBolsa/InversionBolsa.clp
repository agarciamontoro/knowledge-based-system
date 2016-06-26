(deffunction main()
    (clear)

    ; Módulo 0: Definición de estructuras, lectura de datos y
    ; detección de valores inestables
    (load "0-EstructuraConocimiento.clp")
    (load "0-Lectura.clp")
    (load "0-ValoresInestables.clp")

    ; Módulo 1: Detección de valores peligrosos
    (load "1-ValoresPeligrosos.clp")

    (reset)

    ; Empezamos por el módulo 0
    (assert (Modulo 0))
    (run)
)

(main)
