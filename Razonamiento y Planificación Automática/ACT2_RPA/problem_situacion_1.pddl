(define (problem contenedores_almacen_camino_extra)
    (:domain transporte_contenedores)

    (:objects
    ;Hay un tren: 
    tren - tren
    ;Hay dos fabricas, un puerto y un almacen:
    fabrica1 fabrica2 puerto almacen - lugar 
    ;Ocho espacios asociados al puerto: 
    e1 e2 e3 e4 e5 e6 e7 e8 - espacio
    ;Dos espacios asociados almacen fabrica 1:
    e1f1 e2f1  - espacio
    ;Tres espacios asociados almacen  fabrica 2:
    e1f2 e2f2 e3f2 - espacio
    ;Tres espacio en almacen: 
    e1a e2a e3a - espacio
    ;Ocho contenedores:
    contenedor1 contenedor2 contenedor3 contenedor4 contenedor5 contenedor6 contenedor7 contenedor8 - contenedor
    ;Cuatro vagones en el tren:
    v1 v2 v3 v4 - vagon
    )

    (:init
    ;Definimos que tenemos en cada lugar:
    (almacen_en_lugar almacen)
    (fabrica_en_lugar fabrica1)
    (fabrica_en_lugar fabrica2)
    ;Definimos donde esta el tren:
    (tren_ubicado_en puerto tren)
    ;Donde estan los contenedortenedores inicialmente:
    (contenedor_en_espacio e1 contenedor1)
    (contenedor_en_espacio e2 contenedor2)
    (contenedor_en_espacio e3 contenedor3)
    (contenedor_en_espacio e4 contenedor4)
    (contenedor_en_espacio e5 contenedor5)
    (contenedor_en_espacio e6 contenedor6)
    (contenedor_en_espacio e7 contenedor7)
    (contenedor_en_espacio e8 contenedor8)
    ;Que espacios estan libres inicalmente:
    (libre_espacio e1f1)
    (libre_espacio e2f1)
    (libre_espacio e1f2)
    (libre_espacio e2f2)
    (libre_espacio e3f2)
    (libre_espacio e1a)
    (libre_espacio e2a)
    (libre_espacio e3a)
    ;Donde pertenece cada espacio:
    (asignar_espacio puerto e1)
    (asignar_espacio puerto e2)
    (asignar_espacio puerto e3)
    (asignar_espacio puerto e4)
    (asignar_espacio puerto e5)
    (asignar_espacio puerto e6)
    (asignar_espacio puerto e7)
    (asignar_espacio puerto e8)
    (asignar_espacio fabrica1 e1f1)
    (asignar_espacio fabrica1 e2f1)
    (asignar_espacio fabrica2 e1f2)
    (asignar_espacio fabrica2 e2f2)
    (asignar_espacio fabrica2 e3f2)
    (asignar_espacio almacen e1a)
    (asignar_espacio almacen e2a)
    (asignar_espacio almacen e3a)
    ;Que vagones estan libres inicialmente:
    (libre_vagon v1)
    (libre_vagon v2)
    (libre_vagon v3)
    (libre_vagon v4)
    ;Conexiones entre los lugares: 
    (camino fabrica1 fabrica2)
    (camino fabrica2 puerto)
    (camino puerto almacen)
    (camino almacen fabrica1)
    (camino fabrica2 fabrica1)
    (camino puerto fabrica2)
    (camino almacen puerto)
    (camino fabrica1 almacen)
    ;situacion extra
    (camino fabrica2 almacen)
    (camino almacen fabrica2)
    ;Vagones en tren:
    (vagon_en_tren tren v1)
    (vagon_en_tren tren v2)
    (vagon_en_tren tren v3)
    (vagon_en_tren tren v4)
    ;Condicion para vagon parado:
    (siempre_true tren)
    )
    ;Los contenedores deben estar todos eliminados:
    (:goal (and
    (forall (?c - contenedor)
    (contenedor_eliminado ?c)
    )
    )
    )
)