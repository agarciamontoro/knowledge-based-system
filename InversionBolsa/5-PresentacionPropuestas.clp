;------------------------------------------------------------------------------
;--------------- Definición de funciones y reglas genéricas -------------------
;------------------------------------------------------------------------------

; Función que devuelve el índice de hecho de la mejor propuesta aún no marcada
; como viable
(deffunction obtenerMejorPropuesta(?maxRE)
    ; "Inicializamos" el máximo a algo nulo
    (bind ?max FALSE)

    ; Recorremos todos los hechos...
    (do-for-all-facts ((?hecho Propuesta))
        ;... cuyo RE sea menor que maxRE
        (< (fact-slot-value ?hecho RE) ?maxRE)

        ; Si el máximo no está aún inicializado o si el hecho actual tiene
        ; ?slot mayor que el del máximo, actualizamos el máximo.
        (if (or (not ?max)
                (> (fact-slot-value ?hecho RE) (fact-slot-value ?max RE))
            ) then
            (bind ?max ?hecho)
        )
    )

    ; Devolvemos el índice de hecho de la propuesta
    (return ?max)
)

; Función que añade un hecho con los índices de hecho de las cinco mejores
; propuestas
(deffunction calcularMejoresPropuestas()
    (bind ?p1 (obtenerMejorPropuesta 1000))
    (bind ?p2 (obtenerMejorPropuesta (fact-slot-value ?p1 RE)))
    (bind ?p3 (obtenerMejorPropuesta (fact-slot-value ?p2 RE)))
    (bind ?p4 (obtenerMejorPropuesta (fact-slot-value ?p3 RE)))
    (bind ?p5 (obtenerMejorPropuesta (fact-slot-value ?p4 RE)))

    (assert (MejoresPropuestas ?p1 ?p2 ?p3 ?p4 ?p5))
)

; Imprime el estado actual de la cartera
(defrule ImprimirCartera
    (Modulo 5)
    ?f <- (Imprimir Cartera)

    =>

    (retract ?f)

    (do-for-all-facts ((?valorC ValorCartera)) TRUE
        (bind ?nombre (fact-slot-value ?valorC Nombre))
        (bind ?acciones (fact-slot-value ?valorC Acciones))
        (bind ?valor (fact-slot-value ?valorC Valor))

        (if (eq ?nombre DISPONIBLE) then
            (printout t "Capital líquido: " ?valor "€." crlf)
        else
            (printout t ?nombre ": " ?acciones " acciones con un valor de "
                ?valor "€." crlf)
        )
    )

    (printout t crlf "Pulse la tecla [Entrar] para continuar... ")
    (readline)
)

;------------------------------------------------------------------------------
;---------------------------- Gestión del menú --------------------------------
;------------------------------------------------------------------------------

(deffacts Menu
    (Imprimir Menu)
)

(defrule imprimirMenuGeneral
    (declare (salience -1))
    ?mod <- (Modulo 5)
    ?f <- (Imprimir Menu)

    =>

    (retract ?f)

    (printout t crlf crlf)
    (printout t "------------------------------------------------------" crlf)
    (printout t "------ SISTEMA DE APOYO A LA INVERSIÓN EN BOLSA ------" crlf)
    (printout t "------              Menú principal              ------" crlf)
    (printout t "------------------------------------------------------" crlf)
    (printout t "    1 - Ver estado actual de la cartera" crlf)
    (printout t "    2 - Ver nuevas propuestas de movimientos" crlf)
    (printout t "    3 - Salir del programa" crlf)
    (printout t "------------------------------------------------------" crlf)
    (printout t "    Introduzca el número de la opción que desea ejecutar: ")

    (bind ?opcionElegida (read))

    (printout t crlf)

    (switch ?opcionElegida
        (case 1 then
            (assert (Imprimir Cartera))
        )

        (case 2 then
            (calcularMejoresPropuestas)
            (assert (Imprimir MejoresPropuestas))
        )

        (case 3 then
            (retract ?mod)
        )

        (default
            (printout t crlf "Opción inexistente, vuelva a intentarlo." crlf)
        )
    )

    (assert (Imprimir Menu))
)

(defrule visualizarPropuestas
    (Modulo 5)
    ?m <- (Imprimir MejoresPropuestas)
    (MejoresPropuestas ?p1 ?p2 ?p3 ?p4 ?p5)

    =>

    (retract ?m)

    (bind ?i 0)
    (bind ?hechosPropuestas (create$ ?p1 ?p2 ?p3 ?p4 ?p5))
    (foreach ?p ?hechosPropuestas
        (bind ?i (+ ?i 1))

        (bind ?propuesta (fact-slot-value ?p PropuestaRedactada))
        (bind ?re (fact-slot-value ?p RE))
        (bind ?razon (fact-slot-value ?p Razon))


        (printout t crlf "------------------" crlf)
        (printout t "PROPUESTA NÚMERO " ?i ":")
        (printout t crlf "------------------" crlf)
        (printout t tab "¿Qué deberías hacer? ----------------> "
            ?propuesta "." crlf)
        (printout t tab "¿Cuál es la rentabilidad esperada ? -> "
            ?re "." crlf)
        (printout t tab "¿Por qué deberías hacerlo? ----------> "
            ?razon "." crlf)
    )

    (printout t crlf "Introduzca el número de la propuesta que quieras llevar a cabo (o el número 0 si no quieres realizar ninguna): ")

    ; Guardamos las propuestas elegidas por el usuario.
    (bind ?propElegida (read))

    (if (neq ?propElegida 0) then
        (assert (PropuestaElegida (nth$ ?propElegida ?hechosPropuestas)))
    )
)

(defrule ejecutarPropuesta
    (Modulo 5)
    ?f <- (PropuestaElegida ?propuesta)

    =>

    (retract ?f)

    ; Nos quedamos con el tipo de Propuesta
    (bind ?tipoPropuesta (nth$ 1 (fact-slot-value ?propuesta Propuesta)))

    ; Obtención de los datos de la empresa
    (bind ?empresaAVender (nth$ 2 (fact-slot-value ?propuesta Propuesta)))
    (bind ?empresaAComprar (nth$ 3 (fact-slot-value ?propuesta Propuesta)))
    (bind ?acc (fact-slot-value ?propuesta NumAcciones))

    (printout t ?tipoPropuesta ?empresaAComprar ?empresaAVender ?acc crlf)

    (switch ?tipoPropuesta
        (case Comprar then
            (assert (Comprar ?empresaAComprar ?acc))
        )
        (case Vender then
            (assert (Vender ?empresaAVender ?acc))
        )
        (case Cambiar then
            (assert (Cambiar ?empresaAVender ?empresaAComprar))
        )
    )
)

; TODO: Qué pasa si ya hay un valor en la cartera de ?empresa
; TODO: Ver comisiones al comprar
(defrule comprarAcciones
    (Modulo 5)
    ?f <- (Comprar ?empresa ?acc)
    (Valor (Nombre ?empresa) (Precio ?precio))
    ?disp <- (ValorCartera (Nombre DISPONIBLE) (Valor ?liquido))

    =>

    (retract ?f)

    (bind ?valor (* ?acc ?precio))
    (modify ?disp (Valor (- ?liquido ?valor)))

    (assert
        (ValorCartera (Nombre ?empresa) (Acciones ?acc) (Valor ?valor))
    )

    (printout t "Se han comprado" ?acc " acciones de la empresa "
        ?empresa "." crlf)
)

; TODO: Ver comisiones al vender
(defrule venderAcciones
    (Modulo 5)
    ?f <- (Vender ?empresa ?accVender)
    (Valor (Nombre ?empresa) (Precio ?precio))
    ?valorCartera <- (ValorCartera (Nombre ?empresa) (Acciones ?accActuales))

    ?disp <- (ValorCartera (Nombre DISPONIBLE) (Valor ?liquido))

    =>

    (retract ?f)

    ; Calculamos el nuevo número de acciones de la empresa que poseemos
    (bind ?nuevasAcciones (- ?accActuales ?accVender))

    ; Eliminamos el antiguo valor de la cartera
    (retract ?valorCartera)

    ; Si aún tenemos acciones añadimos un Valor a la cartera con los nuevos
    ; datos
    (if (> ?nuevasAcciones 0) then
        (bind ?nuevoValor (* ?nuevasAcciones ?precio))
        (assert
            (ValorCartera (Nombre ?empresa) (Acciones ?nuevasAcciones)
                          (Valor ?nuevoValor))
        )
    )

    ; Actualizamos el capital líquido
    (bind ?beneficios (* ?precio ?accVender))
    (modify ?disp (Valor ?beneficios))

    (printout t "Se han vendido" ?accVender " acciones de la empresa "
        ?empresa "." crlf)
)

(defrule cambiarAcciones
    (Modulo 5)
    ?f <- (Cambiar ?empresaAVender ?empresaAComprar)
    (Valor (Nombre ?empresaAVender) (Precio ?precioAVender))
    (ValorCartera (Nombre ?empresaAVender) (Acciones ?accVender))
    (Valor (Nombre ?empresaAComprar) (Precio ?precioAComprar))

    =>

    (retract ?f)

    ; Calculamos el ratio de intercambio de acciones
    (bind ?ratio (/ ?precioAVender ?precioAComprar))

    ; Calculamos el capital total de la cartera
    (bind ?valorTotalCartera 0)
    (do-for-all-facts ((?vc ValorCartera)) TRUE
        (bind ?valorActual (fact-slot-value ?vc Valor))
        (bind ?valorTotalCartera (+ ?valorTotalCartera ?valorActual))
    )

    (printout t "El capital total de tu cartera es de " ?valorTotalCartera ". Por cada acción de " ?empresaAVender " puedes comprar " ?ratio " acciones de " ?empresaAComprar ". Por favor, introduce el número de acciones que quieres vender de " ?empresaAVender " y nostros calcularemos cuántas comprar de " ?empresaAComprar ": ")

    ; TODO: Ver cuántas acciones intercambiamos y comprobar que todo va bien.
    (bind ?acc (read))

    (while (not (and (>= ?acc 0) (<= ?acc ?accVender) ) ) do
        (format t "\n El número de acciones debe estar entre [%d, %d]: "
            0 ?accVender
        )
        (bind ?acc (read))
	)

    ; Vendemos las acciones indicadas por el usuario
    (assert (Vender ?empresaAVender ?acc))

    ; Compramos las acciones indicadas el usuario
    (assert (Comprar ?empresaAComprar (* ?acc ?ratio)))
)
