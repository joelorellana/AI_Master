(define (domain transporte_contenedores)

(:requirements :typing  :strips     :conditional-effects :negative-preconditions :disjunctive-preconditions)

;Se definen los tipos de objetos:
;Lugar: Ubicaciones espaciales de los lugares.
;Contenedor: Objeto a transportar, procesar.
;Espacio: Espacios donde pueden estar los contenedores en los lugares.
;Vagon: Espacios para almacenar y transportar el contenedor en el tren.
;Tren: Objeto que se desplaza y transporta los contenedores en los vagones.
(:types lugar  contenedor  espacio vagon  tren)

(:predicates
    
    ;ubicacion de lugares en las paradas:
    (almacen_en_lugar ?l - lugar)
    (fabrica_en_lugar ?l - lugar)
    (asignar_espacio ?l - lugar ?es - espacio)

    ;estados de los contenedores:
    (contenedor_eliminado ?con - contenedor)
    (contenedor_procesado ?con - contenedor)

    ;ubicacion de contenedores:
    (contenedor_en_espacio ?es - espacio ?con - contenedor)
    (contenedor_en_vagon ?v - vagon ?con - contenedor)

    ;estado de espacio: 
    (libre_espacio ?es - espacio)

    ;estado de vagones:
    (libre_vagon ?v - vagon)

    ;ubicacion del tren:
    (tren_ubicado_en ?l - lugar ?t - tren)
    (vagon_en_tren ?t1 - tren ?v - vagon)

    ;declaramos los caminos: 
    (camino ?l1 - lugar ?l2 - lugar)

    ;precondicion dummy para declarar la funcion "quedarse parado":
    (siempre_true ?tren1 - tren)

)


(:action cargar
    :parameters (?t1 - tren ?l1 - lugar ?v1 - vagon ?con1 - contenedor ?es - espacio)
    :precondition (and
        ;El tren debe estar en el lugar l1.
        ;El vagon debe estar libre.
        ;El contenedor debe estar en el espacio.
        ;El espacio debe estar en el lugar l1. 
        (tren_ubicado_en ?l1 ?t1)
        (libre_vagon ?v1)        
        (contenedor_en_espacio ?es ?con1)
        (not(contenedor_eliminado ?con1))
        (asignar_espacio ?l1 ?es)
        )
    :effect (and
        ;El contenedor deja de estar en el espacio.
        ;El vagon deja de estar libre.
        ;El contenedor esta en el vagon.
        ;El espacio en l1 empieza a estar libre.  
        (not (contenedor_en_espacio ?es ?con1))
        (not (libre_vagon ?v1))
        (contenedor_en_vagon ?v1  ?con1)
        (libre_espacio ?es)
        )
)

(:action mover
    :parameters (?l1 - lugar ?l2 - lugar ?t1 - tren)
    :precondition (and
        ;El tren debe estar en el lugar l1.
        ;Debe haber un camino de conexion entre l1 y l2. 
        (tren_ubicado_en ?l1 ?t1)
        (camino ?l1 ?l2)
        )
    :effect (and
        ;El tren deja de estar en l1.
        ;El tren esta en l2. 
        (not (tren_ubicado_en ?l1 ?t1))
        (tren_ubicado_en ?l2 ?t1)
        )
)

(:action descargar
    :parameters (?t1 - tren ?l1 - lugar ?v1 - vagon ?con1 - contenedor ?es - espacio)
    :precondition (and
        ;El espacio debe estar en el lugar l1.
        ;el espacio esta libre o el almacen esta en el lugar.
        ;y contenedor esta procesado.
        ;El contenedor debe estar en el vagon.
        ;El tren debe estar en el lugar l1.
        (asignar_espacio ?l1 ?es) 
        (or
            (libre_espacio ?es)
            (and 
            (almacen_en_lugar ?l1)
            (contenedor_procesado ?con1)
            )
        )      
        (contenedor_en_vagon ?v1 ?con1)
        (tren_ubicado_en ?l1 ?t1)
        ;la siguiente es una condiciones especial:
        ;en el puerto no podemos descargar nada, solo podemos cargar.
        ;asi que validamos que el lugar donde vamos a descargar no tenga puerto.
        (or(almacen_en_lugar ?l1)(fabrica_en_lugar ?l1))
        )
        ;el vagon empieza a estar libre.
        ;es espacio deja de estar libre.
        ;el contenedor deja de estar en el vagon. 
        ;el contenedor empieza a estar en el espacio.
    :effect (and 
        (not (contenedor_en_vagon ?v1 ?con1))
        (libre_vagon ?v1) 
        (not (libre_espacio ?es ))
        ;el siguiente when analiza la situacion en la que desamos eliminar un contenedor
        ;si se nos ocurre dejar un contenedor ya procesado en almacen
        ;este liberara el espacio y quedara como "contenedore_eliminado"
        (when
        ;Antecedent
            (and 
            (almacen_en_lugar ?l1)
            (contenedor_procesado ?con1)
            )
        ;Consequence
            (and 
            (contenedor_eliminado ?con1)
            (libre_espacio ?es)
            )
        )
        ;El siguiente when comprueba si el contenedor esta eliminado.
        ;Si lo esta, entonces, se libera el espacio.
        (when
        ;Antecedent
            (and
            (not
            (contenedor_eliminado ?con1) 
            )
            )
        ;Consequence
            (and 
            (contenedor_en_espacio ?es ?con1)   
            )
        )
        ;El siguiente when analiza si hemos dejado el contenedo en una fabrica,
        ;si es asi inmediatamente despues el contenedor se marca como "procesado".
        (when
        ;Antecedent
            (and 
            (fabrica_en_lugar ?l1)
            )
        ;Consequence
            (and 
            (contenedor_procesado ?con1)
            )
        )
        ) 
)
;A continuacion se realizar la accion quedarse parado.
;como no se pueden declarar precondiciones y efectos vacios entonces 
;utilizamos una predicado siempre positivo llamado "siempre_true"
(:action quedarse_parado
    :parameters (?tren1 - tren)
    :precondition (and 
                    (siempre_true ?tren1)
        )
    :effect (and
            (siempre_true ?tren1)
        )
    )
)









