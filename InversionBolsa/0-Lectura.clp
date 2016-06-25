; Definición de los nombres de los archivos que contienen los datos
(deffacts NombresFicheros
    (Fichero Valores  "DatosIbex35/Analisis.txt")
    (Fichero Sectores "DatosIbex35/AnalisisSectores.txt")
    (Fichero Noticias "DatosIbex35/Noticias.txt")
    (Fichero Cartera  "DatosIbex35/Cartera.txt")
)

;------------------------------------------------------------------------
;---------------- Lectura de los datos de los valores -------------------
;------------------------------------------------------------------------

; Abre el fichero de valores
(defrule openFileValores
    (declare (salience 2))
    (Fichero Valores ?file)
    =>
    (open ?file DatosValores)
    (assert (SeguirLeyendo Valores))
)

; Lee el fichero de valores y guarda sus DatosValores
(defrule readFileValores
    (declare (salience 1))
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
              (RPD (read DatosValores))
              (Tam (read DatosValores))
              (Ibex (read DatosValores))
              (EtiqPER (read DatosValores))
              (EtiqRPD (read DatosValores))
              (Sector (read DatosValores))
              (Var5Dias (read DatosValores))
              (Perd3Consec (read DatosValores))
              (Perd5Consec (read DatosValores))
              (VarRespSector (read DatosValores))
              (VarRespSectorChico (read DatosValores))
              (VarMes (read DatosValores))
              (VarTri (read DatosValores))
              (VarSem (read DatosValores))
              (VarAnual (read DatosValores))
            )
        )
        (assert (SeguirLeyendo Valores))
    )
)

; Cierra el fichero de Valores
(defrule closeFileValores
    (declare (salience -1))
    =>
    (close DatosValores)
)

;------------------------------------------------------------------------
;---------------- Lectura de los datos de los sectores ------------------
;------------------------------------------------------------------------

; Abre el fichero de Sectores
(defrule openFileSectores
    (declare (salience 2))
    (Fichero Sectores ?file)
    =>
    (open ?file DatosSectores)
    (assert (SeguirLeyendo Sectores))
)

; Lee el fichero de Sectores y guarda sus datos
(defrule readFileSectores
    (declare (salience 1))
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
    =>
    (close DatosSectores)
)

;------------------------------------------------------------------------
;---------------- Lectura de los datos de las noticias ------------------
;------------------------------------------------------------------------

; Abre el fichero de Noticias
(defrule openFileNoticias
    (declare (salience 2))
    (Fichero Noticias ?file)
    =>
    (open ?file DatosNoticias)
    (assert (SeguirLeyendo Noticias))
)

; Lee el fichero de Noticias y guarda sus datos
(defrule readFileNoticias
    (declare (salience 1))
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
    =>
    (close DatosNoticias)
)


;------------------------------------------------------------------------
;----------------- Lectura de los datos de la cartera -------------------
;------------------------------------------------------------------------

; Abre el fichero de Cartera
(defrule openFileCartera
    (declare (salience 2))
    (Fichero Cartera ?file)
    =>
    (open ?file DatosCartera)
    (assert (SeguirLeyendo Cartera))
)

; Lee el fichero de Noticias y guarda sus datos
(defrule readFileCartera
    (declare (salience 1))
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
    =>
    (close DatosCartera)
)
