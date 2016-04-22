(deftemplate TTT
    (slot nombreslot1)
    (slot nombreslot2)
    (multislot nombreslot3)
)

; Regla que permite introducir un hecho del tipo TTT con una sóla línea,
; separando los slots con espacios y dejando el único multislot, también
; separado con espacios, al final-
(defrule IntroducirTTT
    =>
    ; Se pide la información perteneciente a un TTT
    (printout t "Introduzca un TTT: ")

    ; Separamos cada una de las palabras del string y las guardamos
    ; en una variable multivalor
    (bind ?multiValue (explode$ (readline)))

    ; Tomamos el primer y segundo elemento de la variable multivalor
    (bind ?slot1 (nth$ 1 ?multiValue))
    (bind ?slot2 (nth$ 2 ?multiValue))

    ; Tomamos los elementos (3, ..., n) de la variable multivalor, donde
    ; n es el número total de valores.
    (bind ?slot3 (subseq$ ?multiValue 3 (length$ multiValue)))

    ; Guardamos los valores con la sintaxis de TTT
    (assert (TTT
        (nombreslot1 ?slot1)
        (nombreslot2 ?slot2)
        (nombreslot3 ?slot3)
    ))
)
