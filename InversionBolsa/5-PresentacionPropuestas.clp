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
    (bind ?p1 (obtenerMejorPropuesta 1000000000))
    (bind ?p2 (obtenerMejorPropuesta (fact-slot-value ?p1 RE)))
    (bind ?p3 (obtenerMejorPropuesta (fact-slot-value ?p2 RE)))
    (bind ?p4 (obtenerMejorPropuesta (fact-slot-value ?p3 RE)))
    (bind ?p5 (obtenerMejorPropuesta (fact-slot-value ?p4 RE)))

    (assert (MejoresPropuestas ?p1 ?p2 ?p3 ?p4 ?p5))
)

; Función que vende acciones de un valor de la cartera
; Argumentos:
;   * ?empresa: Nombre de la empresa a vender.
;   * ?precio: Precio de la acción de la empresa.
;   * ?valorCartera: Número de hecho del valor de la cartera.
;   * ?accActuales: Número de acciones actuales.
;   * ?accVender: Número de acciones a vender.
;        Si es NULL se pregunta al usuario.
(deffunction venderAcciones(?empresa ?precio ?valorCartera ?accActuales ?accVender)
    (if (eq ?accVender NULL) then
        ; Le solicitamos al usuario el número de acciones a vender
        (printout t "$> Introduce el número de acciones de " ?empresa " que quieres comprar: ")
        (bind ?accVender (read))

        ; Nos aseguramos de que el número de acciones introducido es correcto
        (while (not (and (>= ?accVender 0) (<= ?accVender ?accActuales) ) ) do
            (format t "$> ¡Cuidado! El número de acciones debe estar en el rango [%d, %d]: "
                0 ?accActuales
            )
            (bind ?accVender (read))
        )
    )

    ; Eliminamos el antiguo valor de la cartera
    (retract ?valorCartera)

    ; Calculamos el nuevo número de acciones de la empresa que poseemos
    (bind ?nuevasAcciones (- ?accActuales ?accVender))

    ; Si aún tenemos acciones añadimos un Valor a la cartera con los nuevos
    ; datos
    (if (> ?nuevasAcciones 0) then
        (bind ?nuevoValor (* ?nuevasAcciones ?precio))
        (assert
            (ValorCartera (Nombre ?empresa) (Acciones ?nuevasAcciones)
                          (Valor ?nuevoValor))
        )
    )

    ; Actualizamos el capital líquido (hay que tener en cuenta la comisión del
    ; 0.5% al hacer una transacción)
    (bind ?beneficios (* 0.955 (* ?precio ?accVender)))
    (do-for-fact
        ((?disponible ValorCartera))
        (eq DISPONIBLE (fact-slot-value ?disponible Nombre))

        (modify ?disponible (Valor ?beneficios))
    )

    ; Informamos de que la transacción se ha completado correctamente
    (printout t "    Se han vendido " ?accVender " acciones de la empresa "
        ?empresa "." crlf)
)


; Función que compra acciones de un valor
; Argumentos:
;   * ?empresa: Nombre de la empresa a comprar.
;   * ?precio Precio de la acción de la empresa.
;   * ?accComprar: Número de acciones a comprar.
;       Si es NULL se pregunta al usuario.
;   * ?liquido: Dinero disponible
(deffunction comprarAcciones(?empresa ?precio ?accComprar ?liquido)
    (if (eq ?accComprar NULL) then
        ; Calculamos el máximo número posible de acciones a comprar
        (bind ?accMax (integer (/ ?liquido (* 1.005 ?precio))))

        ; Le solicitamos al usuario el número de acciones a comprar
        (printout t "$> Introduce el número de acciones de " ?empresa " que quieres comprar: ")
        (bind ?accComprar (read))

        ; Nos aseguramos de que el número de acciones introducido es correcto
        (while (not (and (> ?accComprar 0) (<= ?accComprar ?accMax) ) ) do
            (format t "$> ¡Cuidado! El número de acciones debe estar en el rango [%d, %d]: "
                0 ?accMax
            )
            (bind ?accComprar (read))
        )
    )

    ; Calculamos el valor de la transacción, añadiéndole un 0.5% de comisión
    (bind ?valorTransaccionBruto (* ?accComprar ?precio))
    (bind ?valorTransaccion (* 1.005 ?valorTransaccionBruto))

    ; Restamos el valor de la transacción al capital líquido
    (do-for-fact
        ((?disponible ValorCartera))
        (eq DISPONIBLE (fact-slot-value ?disponible Nombre))

        (modify ?disponible (Valor (- ?liquido ?valorTransaccion)))
    )

    ; Si ya tenemos un valor en la cartera de la empresa en la que queremos
    ; invertir, el nuevo número de acciones será la suma de las previas más
    ; las compradas
    (do-for-fact
        ((?vc ValorCartera))
        (eq ?empresa (fact-slot-value ?vc Nombre))

        ; Obtenemos el número actual de acciones
        (bind ?vcAcc (fact-slot-value ?vc Acciones))
        ;
        ; Actualizamos el valor de acciones que vamos a tener
        (bind ?accComprar (+ ?vcAcc ?accComprar))

        ; Eliminamos el valor de la cartera
        (retract ?vc)
    )

    ; Añadimos el nuevo valor a la cartera con el número de acciones
    ; comprado y su valor (sin la comisión del 0.5)
    (assert
        (ValorCartera (Nombre ?empresa) (Acciones ?accComprar)
            (Valor ?valorTransaccionBruto)
        )
    )

    ; Informamos de que la transacción se ha completado correctamente
    (printout t "    Ahora tienes " ?accComprar " acciones de la empresa "
        ?empresa "." crlf)
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
            (printout t "    Capital líquido: " ?valor "€." crlf)
        else
            (printout t "    " ?nombre ": " ?acciones " acciones con un valor de "
                ?valor "€." crlf)
        )
    )

    (printout t crlf "$> Pulse la tecla [Entrar] para continuar... ")
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

    (printout t crlf)
    (printout t "--------------------------------------------------------------------------" crlf)
    (printout t "---------------- SISTEMA DE APOYO A LA INVERSIÓN EN BOLSA ----------------" crlf)
    (printout t "----------------              Menú principal              ----------------" crlf)
    (printout t "--------------------------------------------------------------------------" crlf crlf)
    (printout t "    1 - Ver estado actual de la cartera" crlf)
    (printout t "    2 - Ver nuevas propuestas de movimientos" crlf)
    (printout t "    3 - Guardar la cartera actual" crlf)
    (printout t "    4 - Salir del programa" crlf crlf)
    (printout t "--------------------------------------------------------------------------" crlf crlf)
    (printout t "$> Teclee el número de la opción que desea ejecutar y pulse la tecla [Entrar]: ")

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
            (assert (Guardar))
        )

        (case 4 then
            (assert (Salir y guardar))
        )

        (default
            (printout t crlf "Opción inexistente, vuelva a intentarlo." crlf)
        )
    )

    (assert (Imprimir Menu))
)

(defrule visualizarPropuestas
    (Modulo 5)
    ?f <- (Imprimir MejoresPropuestas)
    (MejoresPropuestas ?p1 ?p2 ?p3 ?p4 ?p5)

    =>

    (retract ?f)

    (if (eq ?p1 FALSE) then
        (printout t "$> Lo sentimos, en este momento no tenemos propuesas que ofrecerte." crlf)
    else
        (bind ?numPropuesta 0)
        (bind ?hechosPropuestas (create$ ?p1 ?p2 ?p3 ?p4 ?p5))
        (foreach ?p ?hechosPropuestas
            (if (neq ?p FALSE) then
                (bind ?numPropuesta (+ ?numPropuesta 1))

                (bind ?propuesta (fact-slot-value ?p PropuestaRedactada))
                (bind ?re (fact-slot-value ?p RE))
                (bind ?razon (fact-slot-value ?p Razon))

                (printout t "------------------" crlf)
                (printout t "PROPUESTA NÚMERO " ?numPropuesta ":")
                (printout t crlf "------------------" crlf)
                (printout t "    ¿Qué deberías hacer? ---------------> "
                ?propuesta "." crlf)
                (printout t "    ¿Cuál es la rentabilidad esperada? -> "
                ?re "%" crlf)
                (printout t "    ¿Por qué deberías hacerlo? ---------> "
                ?razon "." crlf crlf)
            )
        )

        (printout t crlf "$> Introduce el número de la propuesta que quieras llevar a cabo (o el número 0 si no quieres realizar ninguna) y pulsa la tecla [Enter]: ")

        ; Guardamos las propuestas elegidas por el usuario.
        (bind ?propElegida (read))
        (while (or (< ?propElegida 0) (> ?propElegida ?numPropuesta))
            (printout t "$> ¡Cuidado! Introduce un entero entre 0 y " ?numPropuesta ": ")
            (bind ?propElegida (read))
        )

        (if (neq ?propElegida 0) then
            (assert (PropuestaElegida (nth$ ?propElegida ?hechosPropuestas)))
        )
    )
)

;------------------------------------------------------------------------------
;------------------------ Ejecución de propuestas -----------------------------
;------------------------------------------------------------------------------

(defrule ejecutarPropuesta
    (Modulo 5)
    ?f <- (PropuestaElegida ?propuesta)

    =>

    (retract ?f)

    ; Obtenemos el tipo de Propuesta
    (bind ?tipoPropuesta (nth$ 1 (fact-slot-value ?propuesta Propuesta)))

    ; Obtenemos los datos de la empresa
    (bind ?empresaAVender (nth$ 2 (fact-slot-value ?propuesta Propuesta)))
    (bind ?empresaAComprar (nth$ 3 (fact-slot-value ?propuesta Propuesta)))

    ; Gestionamos cada tipo de propuesta por separado
    (switch ?tipoPropuesta
        (case Comprar then
            (assert (Comprar ?empresaAComprar NULL))
        )
        (case Vender then
            (assert (Vender ?empresaAVender NULL))
        )
        (case Cambiar then
            (assert (Cambiar ?empresaAVender ?empresaAComprar))
        )
    )

    ; Eliminamos todas las propuestas para volver a recalcular
    (do-for-all-facts ((?p Propuesta)) TRUE
        (retract ?p)
    )
)

(defrule comprarAcciones
    ?m <- (Modulo 5)
    ?f <- (Comprar ?empresa ?accComprar)
    (Valor (Nombre ?empresa) (Precio ?precio))
    ?disponible <- (ValorCartera (Nombre DISPONIBLE) (Valor ?liquido))

    =>

    (retract ?f)

    ; Ejecutamos la compra
    (comprarAcciones ?empresa
                     ?precio
                     ?accComprar
                     ?liquido)

    ; Recalculamos propuestas
    (retract ?m)
    (assert (Modulo 4))

    (printout t crlf "$> Pulse la tecla [Entrar] para continuar... ")
    (readline)
)

(defrule venderAcciones
    ?m <- (Modulo 5)
    ?f <- (Vender ?empresa ?accVender)
    (Valor (Nombre ?empresa) (Precio ?precio))
    ?valorCartera <- (ValorCartera (Nombre ?empresa) (Acciones ?accActuales))

    ?disponible <- (ValorCartera (Nombre DISPONIBLE) (Valor ?liquido))

    =>

    (retract ?f)

    ; Ejecutamos la venta
    (venderAcciones ?empresa
                    ?precio
                    ?valorCartera
                    ?accActuales
                    ?accVender
    )

    ; Recalculamos propuestas
    (retract ?m)
    (assert (Modulo 4))

    (printout t crlf "$> Pulse la tecla [Entrar] para continuar... ")
    (readline)
)

(defrule cambiarAcciones
    ?m <- (Modulo 5)
    ?f <- (Cambiar ?empresaAVender ?empresaAComprar)
    (Valor (Nombre ?empresaAVender) (Precio ?precioAVender))
    (Valor (Nombre ?empresaAComprar) (Precio ?precioAComprar))
    ?valorCartera <- (ValorCartera (Nombre ?empresaAVender) (Acciones
                        ?accActuales))
    (ValorCartera (Nombre DISPONIBLE) (Valor ?dineroDisponible))

    =>

    (retract ?f)

    ; Calculamos el ratio de intercambio de acciones
    (bind ?ratio (/ ?precioAVender ?precioAComprar))

    ; Le solicitamos al usuario el número de acciones a intercambiar
    (printout t "$> Por cada acción de " ?empresaAVender " puedes comprar " ?ratio " acciones de " ?empresaAComprar "." crlf
        "$> Por favor, introduce el número de acciones que quieres vender de " ?empresaAVender " y nosotros calcularemos cuántas comprar de " ?empresaAComprar ": ")

    (bind ?accVender (read))

    (while (not (and (>= ?accVender 0) (<= ?accVender ?accActuales) ) ) do
        (format t "$> ¡Cuidado! El número de acciones debe estar en el rango [%d, %d]: "
            0 ?accActuales
        )
        (bind ?accVender (read))
	)

    ; Ejecutamos la venta
    (venderAcciones ?empresaAVender
                    ?precioAVender
                    ?valorCartera
                    ?accActuales
                    ?accVender
    )

    ; Calculamos el número máximo de acciones que podemos comprar con el dinero
    ; ganado en la venta anterior: la parte entera del producto
    ; accVender * ratio
    (bind ?accComprar (integer (* ?accVender ?ratio)))

    ; Ejecutamos la compra
    (comprarAcciones ?empresaAComprar
                     ?precioAComprar
                     ?accComprar
                     ?dineroDisponible
    )


    ; El dinero restante (el dinero obtenido al vender ?accVender acciones
    ; menos el dinero obtenido al comprar ?accComprar acciones) lo metemos en
    ; capital líquido
    (bind ?beneficio (* ?accVender  ?precioAVender))
    (bind ?inversion (* ?accComprar ?precioAComprar))
    (bind ?restante (- ?beneficio ?inversion))

    ; Actualizamos el dinero metálico disponible
    (do-for-fact
        ((?disponible ValorCartera))
        (eq DISPONIBLE (fact-slot-value ?disponible Nombre))

        (modify ?disponible (Valor (+ ?dineroDisponible ?restante)))
    )

    ; Recalculamos propuestas
    (retract ?m)
    (assert (Modulo 4))

    (printout t crlf "$> Pulse la tecla [Entrar] para continuar... ")
    (readline)
)

;------------------------------------------------------------------------------
;-------------------- Gestión de la salida del sistema ------------------------
;------------------------------------------------------------------------------


(defrule SalirGuardar
    (Modulo 5)
    ?s <- (Salir y guardar)

    =>

    (retract ?s)

    (printout t "$> ¿Quiere guardar la cartera antes de salir? [s]í/[n]o: ")
    (bind ?respuesta (read))

    (switch ?respuesta
        (case s then
            (assert (Guardar))
            (assert (Salir))
        )

        (case n then
            (printout t "$> ¡Hasta la próxima!" crlf)
            (exit)
        )

        (default
            (assert (Salir y guardar))
        )
    )

)

(defrule Guardar
    (Modulo 5)
    (Guardar)
    (Fichero Cartera ?ficheroCartera)

    =>

    (open ?ficheroCartera streamCartera "w")

    (do-for-all-facts ((?v ValorCartera)) TRUE
        (bind ?nombre (fact-slot-value ?v Nombre))
        (bind ?acciones (fact-slot-value ?v Acciones))
        (bind ?valor (fact-slot-value ?v Valor))
        (printout streamCartera ?nombre " " ?acciones " " ?valor crlf)
    )

    (printout t crlf "$> Datos guardados en " ?ficheroCartera
        "." crlf)
)

(defrule Salir
    (declare (salience -1))
    (Modulo 5)
    (Salir)

    =>

    (printout t "$> ¡Hasta la próxima!" crlf)
    (exit)
)
