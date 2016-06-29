; Definición de los nombres de los archivos que contienen los datos
(deffacts NombresFicheros
    ; Fichero con los datos actuales de los valores del mercado
    (Fichero Valores  "Datos/Analisis.txt")

    ; Fichero con los datos actuales de los sectores del mercado
    (Fichero Sectores "Datos/AnalisisSectores.txt")

    ; Fichero con los datos actuales de las noticias
    (Fichero Noticias "Datos/Noticias.txt")

    ; Fichero con los datos actuales de la cartera de valores del usuario
    (Fichero Cartera  "Datos/Cartera.txt")
)

;------------------------------------------------------------------------------
;------------------- Lectura de los datos de los valores ----------------------
;------------------------------------------------------------------------------

; Abre el fichero de valores
(defrule openFileValores
    (declare (salience 2))
    (Modulo 0)
    (Fichero Valores ?file)
    =>
    (open ?file DatosValores)
    (assert (SeguirLeyendo Valores))
)

; Lee el fichero de valores y guarda sus DatosValores
(defrule readFileValores
    (declare (salience 1))
    (Modulo 0)
    ?f <- (SeguirLeyendo Valores)
    =>
    (bind ?PrimerCampo (read DatosValores))
    (retract ?f)
    (if (neq ?PrimerCampo EOF) then
        (assert
            (Valor
              (Nombre ?PrimerCampo)
              (Precio (read DatosValores))
              (VarDia (read DatosValores))
              (Capitalizacion (read DatosValores))
              (PER (read DatosValores))
              (RPD (* 100 (read DatosValores)))
              (Tam (read DatosValores))
              (Ibex (read DatosValores))
              (EtiqPER (read DatosValores))
              (EtiqRPD (read DatosValores))
              (Sector (read DatosValores))
              (Var5Dias (read DatosValores))
              (Perd3Consec (read DatosValores))
              (Perd5Consec (read DatosValores))
              (VarRelativaSector (read DatosValores))
              (VarRelativaSectorChico (read DatosValores))
              (VarMensual (read DatosValores))
              (VarTrimestral (read DatosValores))
              (VarSemestral (read DatosValores))
              (VarAnual (read DatosValores))
            )
        )
        (assert (SeguirLeyendo Valores))
    )
)

; Cierra el fichero de Valores
(defrule closeFileValores
    (declare (salience -1))
    (Modulo 0)
    =>
    (close DatosValores)
)

;------------------------------------------------------------------------------
;------------------- Lectura de los datos de los sectores ---------------------
;------------------------------------------------------------------------------

; Abre el fichero de Sectores
(defrule openFileSectores
    (declare (salience 2))
    (Modulo 0)
    (Fichero Sectores ?file)
    =>
    (open ?file DatosSectores)
    (assert (SeguirLeyendo Sectores))
)

; Lee el fichero de Sectores y guarda sus datos
(defrule readFileSectores
    (declare (salience 1))
    (Modulo 0)
    ?f <- (SeguirLeyendo Sectores)
    =>
    (bind ?PrimerCampo (read DatosSectores))
    (retract ?f)
    (if (neq ?PrimerCampo EOF) then
        (assert
            (Sector
              (Nombre ?PrimerCampo)
              (VarDia (read DatosSectores))
              (Capitalizacion (read DatosSectores))
              (PER (read DatosSectores))
              (RPD (read DatosSectores))
              (Ibex (read DatosSectores))
              (Var5Dias (read DatosSectores))
              (Perd3Consec (read DatosSectores))
              (Perd5Consec (read DatosSectores))
              (VarMensual (read DatosSectores))
              (VarTrimestral (read DatosSectores))
              (VarSemestral (read DatosSectores))
              (VarAnual (read DatosSectores))
            )
        )
        (assert (SeguirLeyendo Sectores))
    )
)

; Cierra el fichero de Sectores
(defrule closeFileSectores
    (declare (salience -1))
    (Modulo 0)
    =>
    (close DatosSectores)
)

;------------------------------------------------------------------------------
;------------------- Lectura de los datos de las noticias ---------------------
;------------------------------------------------------------------------------

; Abre el fichero de Noticias
(defrule openFileNoticias
    (declare (salience 2))
    (Modulo 0)
    (Fichero Noticias ?file)
    =>
    (open ?file DatosNoticias)
    (assert (SeguirLeyendo Noticias))
)

; Lee el fichero de Noticias y guarda sus datos
(defrule readFileNoticias
    (declare (salience 1))
    (Modulo 0)
    ?f <- (SeguirLeyendo Noticias)
    =>
    (bind ?PrimerCampo (read DatosNoticias))
    (retract ?f)
    (if (neq ?PrimerCampo EOF) then
        (assert
            (Noticia
              (Nombre ?PrimerCampo)
              (Tipo (read DatosNoticias))
              (Antiguedad (read DatosNoticias))
            )
        )
        (assert (SeguirLeyendo Noticias))
    )
)

; Cierra el fichero de Noticias
(defrule closeFileNoticias
    (declare (salience -1))
    (Modulo 0)
    =>
    (close DatosNoticias)
)


;------------------------------------------------------------------------------
;-------------------- Lectura de los datos de la cartera ----------------------
;------------------------------------------------------------------------------

; Abre el fichero de Cartera
(defrule openFileCartera
    (declare (salience 2))
    (Modulo 0)
    (Fichero Cartera ?file)
    =>
    (open ?file DatosCartera)
    (assert (SeguirLeyendo Cartera))
)

; Lee el fichero de Noticias y guarda sus datos
(defrule readFileCartera
    (declare (salience 1))
    (Modulo 0)
    ?f <- (SeguirLeyendo Cartera)
    =>
    (bind ?PrimerCampo (read DatosCartera))
    (retract ?f)
    (if (neq ?PrimerCampo EOF) then
        (assert
            (ValorCartera
              (Nombre ?PrimerCampo)
              (Acciones (read DatosCartera))
              (Valor (read DatosCartera))
            )
        )
        (assert (SeguirLeyendo Cartera))
    )
)

; Cierra el fichero de Noticias
(defrule closeFileCartera
    (declare (salience -1))
    (Modulo 0)
    =>
    (close DatosCartera)
)


;------------------------------------------------------------------------------
;----------------------------- Cálculo del RPA --------------------------------
;------------------------------------------------------------------------------
; El rendimiento por año es, según el experto, la rentabilidad por dividendo
; más la variación del valor en el último tramo temporal considerado, que se
; usa como predicción de la variación anual próxima del valor. Hemos
; considerado aquí como último tramo temporal el último trimestre; el experto
; apuntó que no debíamos tomar valores muy lejanos, que no permiten tener en
; cuenta el comporamiento actual del valor, ni demasiado cercanos, que centran
; el cálculo sólo en un comportamiento muy reciente que no tiene por qué
; reflejar el comportamiento general.
(defrule calculoRPA
    (Modulo 0)
    ?f <- (Valor (RPD ?rpd) (VarTrimestral ?trim) (RPA NULL))

    =>

    (modify ?f (RPA (+ ?rpd ?trim)))
)
