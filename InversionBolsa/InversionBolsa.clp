(deffunction main()
    (clear)

    ; Módulo 0: Definición de estructuras, lectura de datos y
    ; detección de valores inestables
    (load "0-EstructuraConocimiento.clp")
    (load "0-Lectura.clp")
    (load "0-ValoresInestables.clp")

    ; Módulo 1: Detección de valores peligrosos
    (load "1-ValoresPeligrosos.clp")

    ; Módulo 2: Detección de valores sobrevalorados
    (load "2-ValoresSobrevalorados.clp")

    ; Módulo 3: Detección de valores infravalorados
    (load "3-ValoresInfravalorados.clp")

    ; Módulo 4: Obtención de propuestas
    (load "4-ObtencionPropuestas.clp")

    ; Módulo 5: Obtención de propuestas
    (load "5-PresentacionPropuestas.clp")

    (reset)

    ; Empezamos por el módulo 0
    (assert (Modulo 0))

    (run)
)

(main)
