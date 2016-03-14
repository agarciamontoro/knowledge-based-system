(deffacts Relaciones
    ; Duales de cada parentesco
    (RelacionDual Hermano Hermano)
    (RelacionDual Padre Hijo)
    (RelacionDual Tio Sobrino)
    (RelacionDual Primo Primo)
    (RelacionDual Pareja Pareja)
    (RelacionDual Cuñado Cuñado)
    (RelacionDual Suegro Yerno)
    (RelacionDual Abuelo Nieto)
    (RelacionDual Consuegro Consuegro)

    ; Composición de parentescos
    (Composicion Padre Padre Abuelo)
    (Composicion Hermano Padre Tio)
    (Composicion Pareja Hermano Cuñado)
    (Composicion Hermano Pareja Cuñado)
    (Composicion Hijo Tio Primo)
    (Composicion Padre Pareja Suegro)
    (Composicion Hijo Padre Hermano)
    (Composicion Pareja Padre Padre)
    (Composicion Suegro Hijo Consuegro)

    ; Relación masculino-femenino
    (RelacionGenero Padre Madre)
    (RelacionGenero Hijo Hija)
    (RelacionGenero Tio Tia)
    (RelacionGenero Cuñado Cuñada)
    (RelacionGenero Primo Prima)
    (RelacionGenero Abuelo Abuela)
    (RelacionGenero Hermano Hermana)
    (RelacionGenero Pareja Pareja)
    (RelacionGenero Sobrino Sobrina)
    (RelacionGenero Suegro Suegra)
    (RelacionGenero Yerno Nuera)
    (RelacionGenero Nieto Nieta)
    (RelacionGenero Consuegro Consuegra)

    ; Declaración de género - mujeres
    (Genero "Maruja Triviño" Mujer)
    (Genero "Concepción Caballero" Mujer)
    (Genero "Concepción Montoro" Mujer)
    (Genero "Consuelo García" Mujer)
    (Genero "Magdalena Garrido" Mujer)
    (Genero "Rocío Ramírez" Mujer)
    (Genero "Paloma Montoro" Mujer)

    ; Declaración de género - hombres
    (Genero "Antonio García" Hombre)
    (Genero "Pepe Montoro" Hombre)
    (Genero "José María García" Hombre)
    (Genero "José Montoro" Hombre)
    (Genero "Vicente Ramírez" Hombre)
    (Genero "Juan Vicente Ramírez" Hombre)
    (Genero "Antonio Ramírez" Hombre)
    (Genero "David Montoro" Hombre)
    (Genero "Alejandro García" Hombre)
    (Genero "Javier García" Hombre)

    ; Abuelos paternos y sus hijos (padre y tía paterna)
    (Relacion Pareja "Maruja Triviño" "Antonio García")
    (Relacion Padre "Maruja Triviño" "José María García")
    (Relacion Padre "Maruja Triviño" "Consuelo García")

    ; Abuelos maternos y sus hijos (madre y tío materno)
    (Relacion Pareja "Concepción Caballero" "Pepe Montoro")
    (Relacion Padre "Concepción Caballero" "Concepción Montoro")
    (Relacion Padre "Concepción Caballero" "José Montoro")

    ; Tíos paternos y sus hijos (primos paternos)
    (Relacion Pareja "Consuelo García" "Vicente Ramírez")
    (Relacion Padre "Consuelo García" "Juan Vicente Ramírez")
    (Relacion Padre "Consuelo García" "Antonio Ramírez")
    (Relacion Padre "Consuelo García" "Rocío Ramírez")

    ; Tíos maternos y sus hijos (primos paternos)
    (Relacion Pareja "Magdalena Garrido" "José Montoro")
    (Relacion Padre "Magdalena Garrido" "David Montoro")
    (Relacion Padre "Magdalena Garrido" "Paloma Montoro")

    ; Padres y sus hijos (hermano y yo mismo)
    (Relacion Pareja "Concepción Montoro" "José María García")
    (Relacion Padre "Concepción Montoro" "Javier García")
    (Relacion Padre "Concepción Montoro" "Alejandro García")
)

; Le da la vuelta a las relaciones duales para evitar escribir el doble :)
(defrule MetaDualizar
    (RelacionDual ?R1 ?R2)
    =>
    (assert (RelacionDual ?R2 ?R1))
)

; Crea las relaciones duales
(defrule Dualizar
    (Relacion ?R1 ?x ?y)
    (RelacionDual ?R1 ?R2)
    =>
    (assert (Relacion ?R2 ?y ?x))
)

; Compone relaciones; p. ej., el padre de mi padre es mi abuelo
(defrule Componer
    (Relacion ?R1 ?x ?y)
    (Relacion ?R2 ?y ?z)
    (Composicion ?R1 ?R2 ?R3)
    (test (neq ?x ?z))
    =>
    (assert (Relacion ?R3 ?x ?z))
)

; Consultas (cuyo primer participante es de género masculino)
(defrule ConsultaMasculino
    (Pregunta ?nombre1 ?nombre2)
    (Relacion ?relacion ?nombre1 ?nombre2)
    (Genero ?nombre1 Hombre)
    =>
    (printout t crlf ?nombre1 " es " ?relacion " de " ?nombre2 crlf)
)

; Consultas (cuyo primer participante es de género femenino)
(defrule ConsultaFemenino
    (Pregunta ?nombre1 ?nombre2)
    (Relacion ?relacion ?nombre1 ?nombre2)
    (Genero ?nombre1 Mujer)
    (RelacionGenero ?relacion ?relacionFem)
    =>
    (printout t crlf ?nombre1 " es " ?relacionFem " de " ?nombre2 crlf)
)

(defrule ObtenerRelacion
    =>
    (printout t "Introduzca el nombre de la primera persona: ")
    (bind ?nombre1 (readline))
    (printout t "Introduzca el nombre de la segunda persona: ")
    (bind ?nombre2 (readline))
    (assert (Pregunta ?nombre1 ?nombre2))
)
