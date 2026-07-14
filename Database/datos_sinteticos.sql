/*
===============================================================================
DATOS SINTÉTICOS - MINISTERIO GOSÉN
Base esperada: ministerio_gosen
Motor: SQL Serversss

Carga generada:
- Rol: conserva/crea únicamente Admin y Usuario.
- Tipo_Actividad: 12 tipos coherentes.
- Ministerio: 12 ministerios coherentes.
- Usuario: 60 usuarios sintéticos.
- Usuarios_Ministerio: 120 relaciones.
- Actividad: 80 actividades.
- Actividades_Ministerio: 80 relaciones, una por actividad.
- Actividad_Usuario: 240 participaciones, tres por actividad.
- Citas: 60 citas.
- Error: 50 registros de prueba.

IMPORTANTE:
- El script no modifica los usuarios reales existentes.
- Los usuarios sintéticos utilizan el dominio @gosen.test.
- Para volver a generar la carga, cambie @RecrearDatosSinteticos a 1.
===============================================================================
*/

USE [ministerio_gosen];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @RecrearDatosSinteticos BIT = 0;
DECLARE @Hoy DATE = CAST(GETDATE() AS DATE);

BEGIN TRY
    BEGIN TRANSACTION;

    /* =========================================================
       1. VERIFICACIÓN Y LIMPIEZA OPCIONAL
       ========================================================= */

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Usuario
        WHERE Correo LIKE '%@gosen.test'
    )
    AND @RecrearDatosSinteticos = 0
    BEGIN
        THROW 50001,
              'Ya existen datos sintéticos. Cambie @RecrearDatosSinteticos a 1 para eliminarlos y volverlos a generar.',
              1;
    END;

    IF @RecrearDatosSinteticos = 1
    BEGIN
        CREATE TABLE #UsuariosPrevios
        (
            Id_Usuario INT PRIMARY KEY
        );

        INSERT INTO #UsuariosPrevios (Id_Usuario)
        SELECT Id_Usuario
        FROM dbo.Usuario
        WHERE Correo LIKE '%@gosen.test';

        CREATE TABLE #ActividadesPrevias
        (
            Id_Actividad INT PRIMARY KEY
        );

        INSERT INTO #ActividadesPrevias (Id_Actividad)
        SELECT DISTINCT Id_Actividad
        FROM dbo.Actividades_Ministerio
        WHERE Observacion LIKE '[[]SINTETICO[]]%';

        DELETE AU
        FROM dbo.Actividad_Usuario AU
        WHERE EXISTS
        (
            SELECT 1
            FROM #ActividadesPrevias AP
            WHERE AP.Id_Actividad = AU.Id_Actividad
        )
        OR EXISTS
        (
            SELECT 1
            FROM #UsuariosPrevios UP
            WHERE UP.Id_Usuario = AU.Id_Usuario
        );

        DELETE C
        FROM dbo.Citas C
        WHERE C.Observacion_Inicial LIKE '[[]SINTETICO[]]%'
           OR EXISTS
              (
                  SELECT 1
                  FROM #UsuariosPrevios UP
                  WHERE UP.Id_Usuario = C.Id_Usuario_Cita
                     OR UP.Id_Usuario = C.Id_Usuario_Encargado
              );

        DELETE E
        FROM dbo.Error E
        WHERE E.Mensaje LIKE '[[]SINTETICO[]]%'
           OR EXISTS
              (
                  SELECT 1
                  FROM #UsuariosPrevios UP
                  WHERE UP.Id_Usuario = E.Id_Usuario
              );

        DELETE AM
        FROM dbo.Actividades_Ministerio AM
        WHERE EXISTS
        (
            SELECT 1
            FROM #ActividadesPrevias AP
            WHERE AP.Id_Actividad = AM.Id_Actividad
        );

        DELETE A
        FROM dbo.Actividad A
        WHERE EXISTS
        (
            SELECT 1
            FROM #ActividadesPrevias AP
            WHERE AP.Id_Actividad = A.Id_Actividad
        );

        DELETE UM
        FROM dbo.Usuarios_Ministerio UM
        WHERE UM.Observacion LIKE '[[]SINTETICO[]]%'
           OR EXISTS
              (
                  SELECT 1
                  FROM #UsuariosPrevios UP
                  WHERE UP.Id_Usuario = UM.Id_Usuario
              );

        DELETE U
        FROM dbo.Usuario U
        WHERE EXISTS
        (
            SELECT 1
            FROM #UsuariosPrevios UP
            WHERE UP.Id_Usuario = U.Id_Usuario
        );

        DELETE FROM dbo.Ministerio
        WHERE Observaciones_Ministerio LIKE '[[]SINTETICO[]]%';
    END;

    /* =========================================================
       2. CATÁLOGOS BASE
       ========================================================= */

    IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE Descripcion = 'Admin')
        INSERT INTO dbo.Rol (Descripcion) VALUES ('Admin');

    IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE Descripcion = 'Usuario')
        INSERT INTO dbo.Rol (Descripcion) VALUES ('Usuario');

    DECLARE @IdRolUsuario INT =
    (
        SELECT TOP (1) Id_Rol
        FROM dbo.Rol
        WHERE Descripcion = 'Usuario'
        ORDER BY Id_Rol
    );

    IF @IdRolUsuario IS NULL
        THROW 50002, 'No fue posible localizar el rol Usuario.', 1;

    DECLARE @TiposBase TABLE
    (
        Orden INT PRIMARY KEY,
        Nombre_Tipo VARCHAR(50) NOT NULL
    );

    INSERT INTO @TiposBase (Orden, Nombre_Tipo)
    VALUES
        (1,  'Culto general'),
        (2,  'Reunión'),
        (3,  'Taller'),
        (4,  'Capacitación'),
        (5,  'Ensayo'),
        (6,  'Visita comunitaria'),
        (7,  'Campamento'),
        (8,  'Convivio'),
        (9,  'Jornada social'),
        (10, 'Campaña'),
        (11, 'Estudio bíblico'),
        (12, 'Actividad infantil');

    INSERT INTO dbo.Tipo_Actividad (Nombre_Tipo)
    SELECT TB.Nombre_Tipo
    FROM @TiposBase TB
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.Tipo_Actividad TA
        WHERE TA.Nombre_Tipo = TB.Nombre_Tipo
    );

    CREATE TABLE #Tipos
    (
        Orden INT PRIMARY KEY,
        Id_Tipo_Actividad INT NOT NULL,
        Nombre_Tipo VARCHAR(50) NOT NULL
    );

    INSERT INTO #Tipos (Orden, Id_Tipo_Actividad, Nombre_Tipo)
    SELECT
        TB.Orden,
        MIN(TA.Id_Tipo_Actividad),
        TB.Nombre_Tipo
    FROM @TiposBase TB
    INNER JOIN dbo.Tipo_Actividad TA
        ON TA.Nombre_Tipo = TB.Nombre_Tipo
    GROUP BY TB.Orden, TB.Nombre_Tipo;

    DECLARE @MinisteriosBase TABLE
    (
        Orden INT PRIMARY KEY,
        Descripcion_Ministerio VARCHAR(100) NOT NULL,
        Observacion VARCHAR(200) NOT NULL
    );

    INSERT INTO @MinisteriosBase
    (
        Orden,
        Descripcion_Ministerio,
        Observacion
    )
    VALUES
        (1,  'Ministerio de Jóvenes',
             '[SINTETICO] Acompañamiento y formación de adolescentes y jóvenes.'),
        (2,  'Ministerio de Música y Alabanza',
             '[SINTETICO] Coordinación de alabanza, músicos y ensayos.'),
        (3,  'Ministerio de Niñez',
             '[SINTETICO] Atención y formación de niños de la comunidad.'),
        (4,  'Ministerio de Mujeres',
             '[SINTETICO] Actividades de apoyo, formación y convivencia.'),
        (5,  'Ministerio de Hombres',
             '[SINTETICO] Formación, acompañamiento y servicio comunitario.'),
        (6,  'Ministerio de Matrimonios y Familia',
             '[SINTETICO] Orientación y actividades para familias.'),
        (7,  'Ministerio de Acción Social',
             '[SINTETICO] Atención de necesidades y ayudas comunitarias.'),
        (8,  'Ministerio de Intercesión',
             '[SINTETICO] Organización de espacios de oración e intercesión.'),
        (9,  'Ministerio de Evangelismo',
             '[SINTETICO] Actividades de alcance y visitas comunitarias.'),
        (10, 'Ministerio de Comunicaciones',
             '[SINTETICO] Difusión, fotografía y comunicación institucional.'),
        (11, 'Ministerio de Ujieres y Protocolo',
             '[SINTETICO] Recepción, orden y apoyo logístico.'),
        (12, 'Ministerio de Adulto Mayor',
             '[SINTETICO] Acompañamiento y actividades para adultos mayores.');

    INSERT INTO dbo.Ministerio
    (
        Descripcion_Ministerio,
        Observaciones_Ministerio
    )
    SELECT
        MB.Descripcion_Ministerio,
        MB.Observacion
    FROM @MinisteriosBase MB
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.Ministerio M
        WHERE M.Descripcion_Ministerio = MB.Descripcion_Ministerio
    );

    CREATE TABLE #Ministerios
    (
        Orden INT PRIMARY KEY,
        Id_Ministerio INT NOT NULL,
        Descripcion_Ministerio VARCHAR(100) NOT NULL
    );

    INSERT INTO #Ministerios
    (
        Orden,
        Id_Ministerio,
        Descripcion_Ministerio
    )
    SELECT
        MB.Orden,
        MIN(M.Id_Ministerio),
        MB.Descripcion_Ministerio
    FROM @MinisteriosBase MB
    INNER JOIN dbo.Ministerio M
        ON M.Descripcion_Ministerio = MB.Descripcion_Ministerio
    GROUP BY MB.Orden, MB.Descripcion_Ministerio;

    /* =========================================================
       3. TABLA AUXILIAR DE NÚMEROS
       ========================================================= */

    CREATE TABLE #Numeros
    (
        N INT PRIMARY KEY
    );

    INSERT INTO #Numeros (N)
    SELECT TOP (240)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM sys.all_objects A
    CROSS JOIN sys.all_objects B;

    /* =========================================================
       4. USUARIOS: 60
       ========================================================= */

    DECLARE @Nombres TABLE
    (
        Orden INT PRIMARY KEY,
        Nombre VARCHAR(30) NOT NULL
    );

    INSERT INTO @Nombres (Orden, Nombre)
    VALUES
        (1, 'Daniel'),   (2, 'María'),     (3, 'José'),
        (4, 'Sofía'),    (5, 'Andrés'),    (6, 'Valeria'),
        (7, 'Carlos'),   (8, 'Gabriela'),  (9, 'Luis'),
        (10, 'Paola'),   (11, 'David'),    (12, 'Natalia'),
        (13, 'Esteban'), (14, 'Andrea'),   (15, 'Miguel'),
        (16, 'Laura'),   (17, 'Sebastián'),(18, 'Daniela'),
        (19, 'Javier'),  (20, 'Camila');

    DECLARE @Apellidos TABLE
    (
        Orden INT PRIMARY KEY,
        Apellido VARCHAR(30) NOT NULL
    );

    INSERT INTO @Apellidos (Orden, Apellido)
    VALUES
        (1, 'Rodríguez'), (2, 'Mora'),       (3, 'Jiménez'),
        (4, 'Vargas'),    (5, 'Sánchez'),    (6, 'Castro'),
        (7, 'Rojas'),     (8, 'Solano'),     (9, 'Araya'),
        (10, 'Quesada'),  (11, 'Ramírez'),   (12, 'Chaves'),
        (13, 'Gómez'),    (14, 'Salazar'),   (15, 'Alvarado'),
        (16, 'Méndez'),   (17, 'Cordero'),   (18, 'Pérez'),
        (19, 'Calderón'), (20, 'Hernández');

    INSERT INTO dbo.Usuario
    (
        Identificacion,
        Nombre,
        Correo,
        Contrasena,
        Estado,
        Id_Rol,
        UsaContrasenaTemp
    )
    SELECT
        CONCAT('SYN', RIGHT('000000000' + CAST(N.N AS VARCHAR(9)), 9)),
        CONCAT(NO.Nombre, ' ', A1.Apellido, ' ', A2.Apellido),
        CONCAT('persona', RIGHT('000' + CAST(N.N AS VARCHAR(3)), 3), '@gosen.test'),
        CONCAT('Temporal!', RIGHT('000' + CAST(N.N AS VARCHAR(3)), 3)),
        CASE WHEN N.N % 15 = 0 THEN 'I' ELSE 'A' END,
        @IdRolUsuario,
        CASE WHEN N.N % 7 = 0 THEN 1 ELSE 0 END
    FROM #Numeros N
    INNER JOIN @Nombres NO
        ON NO.Orden = ((N.N - 1) % 20) + 1
    INNER JOIN @Apellidos A1
        ON A1.Orden = ((N.N * 3 - 1) % 20) + 1
    INNER JOIN @Apellidos A2
        ON A2.Orden = ((N.N * 7 + 4) % 20) + 1
    WHERE N.N <= 60;

    CREATE TABLE #Usuarios
    (
        N INT PRIMARY KEY,
        Id_Usuario INT NOT NULL,
        Estado CHAR(1) NOT NULL
    );

    INSERT INTO #Usuarios (N, Id_Usuario, Estado)
    SELECT
        ROW_NUMBER() OVER (ORDER BY U.Id_Usuario),
        U.Id_Usuario,
        U.Estado
    FROM dbo.Usuario U
    WHERE U.Correo LIKE '%@gosen.test';

    /* =========================================================
       5. USUARIOS POR MINISTERIO: 120
       Cada usuario se relaciona con dos ministerios.
       ========================================================= */

    INSERT INTO dbo.Usuarios_Ministerio
    (
        Id_Ministerio,
        Id_Usuario,
        Fecha_Ingreso,
        Fecha_Salida,
        Estado,
        Observacion
    )
    SELECT
        M.Id_Ministerio,
        U.Id_Usuario,
        DATEADD(DAY, -(45 + (U.N * 2) + (X.Grupo * 15)), @Hoy),
        CASE
            WHEN U.Estado = 'I' OR (X.Grupo = 1 AND U.N % 6 = 0)
                THEN DATEADD(DAY, -(1 + (U.N % 30)), @Hoy)
            ELSE NULL
        END,
        CASE
            WHEN U.Estado = 'I' OR (X.Grupo = 1 AND U.N % 6 = 0)
                THEN 'Inactivo'
            ELSE 'Activo'
        END,
        CONCAT(
            '[SINTETICO] ',
            CASE
                WHEN X.Grupo = 0 THEN 'Asignación principal al ministerio.'
                ELSE 'Participación complementaria en el ministerio.'
            END
        )
    FROM #Usuarios U
    CROSS JOIN (VALUES (0), (1)) X(Grupo)
    INNER JOIN #Ministerios M
        ON M.Orden =
           CASE
               WHEN X.Grupo = 0
                   THEN ((U.N - 1) % 12) + 1
               ELSE ((U.N + 4) % 12) + 1
           END;

    /* =========================================================
       6. ACTIVIDADES: 80
       ========================================================= */

    CREATE TABLE #PlanActividades
    (
        N INT PRIMARY KEY,
        Nombre_Actividad VARCHAR(100) NOT NULL,
        Fecha_Ini DATE NOT NULL,
        Fecha_Fin DATE NULL,
        Lugar VARCHAR(100) NULL,
        Hora_Ini TIME(7) NULL,
        Hora_Fin TIME(7) NULL,
        Id_Tipo_Actividad INT NOT NULL,
        Orden_Ministerio INT NOT NULL
    );

    INSERT INTO #PlanActividades
    (
        N,
        Nombre_Actividad,
        Fecha_Ini,
        Fecha_Fin,
        Lugar,
        Hora_Ini,
        Hora_Fin,
        Id_Tipo_Actividad,
        Orden_Ministerio
    )
    SELECT
        N.N,
        CONCAT(
            CASE T.Orden
                WHEN 1  THEN 'Culto comunitario'
                WHEN 2  THEN 'Reunión de planificación'
                WHEN 3  THEN 'Taller de formación'
                WHEN 4  THEN 'Capacitación de voluntarios'
                WHEN 5  THEN 'Ensayo general'
                WHEN 6  THEN 'Visita a familias'
                WHEN 7  THEN 'Campamento de integración'
                WHEN 8  THEN 'Convivio comunitario'
                WHEN 9  THEN 'Jornada de apoyo social'
                WHEN 10 THEN 'Campaña de alcance'
                WHEN 11 THEN 'Estudio bíblico'
                WHEN 12 THEN 'Actividad recreativa infantil'
            END,
            ' ',
            RIGHT('000' + CAST(N.N AS VARCHAR(3)), 3)
        ),
        DATEADD(DAY, -60 + (N.N * 2), @Hoy),
        CASE
            WHEN T.Orden IN (7, 9, 10)
                THEN DATEADD(DAY, -59 + (N.N * 2), @Hoy)
            ELSE DATEADD(DAY, -60 + (N.N * 2), @Hoy)
        END,
        CASE N.N % 8
            WHEN 0 THEN 'Templo principal'
            WHEN 1 THEN 'Salón comunal'
            WHEN 2 THEN 'Aula 1'
            WHEN 3 THEN 'Aula 2'
            WHEN 4 THEN 'Parque de La Fila'
            WHEN 5 THEN 'Casa pastoral'
            WHEN 6 THEN 'Cancha multiuso'
            ELSE 'Comunidad de La Fila'
        END,
        CASE N.N % 5
            WHEN 0 THEN CAST('08:00' AS TIME)
            WHEN 1 THEN CAST('10:00' AS TIME)
            WHEN 2 THEN CAST('14:00' AS TIME)
            WHEN 3 THEN CAST('16:00' AS TIME)
            ELSE CAST('18:00' AS TIME)
        END,
        CASE N.N % 5
            WHEN 0 THEN CAST('10:00' AS TIME)
            WHEN 1 THEN CAST('12:00' AS TIME)
            WHEN 2 THEN CAST('16:00' AS TIME)
            WHEN 3 THEN CAST('18:00' AS TIME)
            ELSE CAST('20:00' AS TIME)
        END,
        T.Id_Tipo_Actividad,
        ((N.N - 1) % 12) + 1
    FROM #Numeros N
    INNER JOIN #Tipos T
        ON T.Orden = ((N.N - 1) % 12) + 1
    WHERE N.N <= 80;

    INSERT INTO dbo.Actividad
    (
        Nombre_Actividad,
        Fecha_Ini,
        Fecha_Fin,
        Lugar,
        Hora_Ini,
        Hora_Fin,
        Id_Tipo_Actividad
    )
    SELECT
        P.Nombre_Actividad,
        P.Fecha_Ini,
        P.Fecha_Fin,
        P.Lugar,
        P.Hora_Ini,
        P.Hora_Fin,
        P.Id_Tipo_Actividad
    FROM #PlanActividades P;

    CREATE TABLE #Actividades
    (
        N INT PRIMARY KEY,
        Id_Actividad INT NOT NULL,
        Orden_Ministerio INT NOT NULL,
        Fecha_Ini DATE NOT NULL,
        Hora_Ini TIME(7) NULL
    );

    INSERT INTO #Actividades
    (
        N,
        Id_Actividad,
        Orden_Ministerio,
        Fecha_Ini,
        Hora_Ini
    )
    SELECT
        P.N,
        A.Id_Actividad,
        P.Orden_Ministerio,
        P.Fecha_Ini,
        P.Hora_Ini
    FROM #PlanActividades P
    INNER JOIN dbo.Actividad A
        ON A.Nombre_Actividad = P.Nombre_Actividad
       AND A.Fecha_Ini = P.Fecha_Ini;

    /* =========================================================
       7. ACTIVIDADES POR MINISTERIO: 80
       ========================================================= */

    INSERT INTO dbo.Actividades_Ministerio
    (
        Id_Actividad,
        Id_Ministerio,
        Fecha,
        Observacion
    )
    SELECT
        A.Id_Actividad,
        M.Id_Ministerio,
        A.Fecha_Ini,
        CONCAT(
            '[SINTETICO] Actividad organizada por ',
            M.Descripcion_Ministerio,
            '.'
        )
    FROM #Actividades A
    INNER JOIN #Ministerios M
        ON M.Orden = A.Orden_Ministerio;

    /* =========================================================
       8. PARTICIPACIÓN EN ACTIVIDADES: 240
       Tres participantes activos del ministerio organizador.
       ========================================================= */

    INSERT INTO dbo.Actividad_Usuario
    (
        Id_Actividad,
        Id_Usuario,
        Fecha,
        Hora
    )
    SELECT
        A.Id_Actividad,
        P.Id_Usuario,
        A.Fecha_Ini,
        A.Hora_Ini
    FROM #Actividades A
    INNER JOIN #Ministerios M
        ON M.Orden = A.Orden_Ministerio
    CROSS APPLY
    (
        SELECT TOP (3)
            UM.Id_Usuario
        FROM dbo.Usuarios_Ministerio UM
        INNER JOIN dbo.Usuario U
            ON U.Id_Usuario = UM.Id_Usuario
        WHERE UM.Id_Ministerio = M.Id_Ministerio
          AND UM.Estado = 'Activo'
          AND UM.Fecha_Salida IS NULL
          AND U.Estado = 'A'
          AND U.Correo LIKE '%@gosen.test'
        ORDER BY CHECKSUM(A.N, UM.Id_Usuario)
    ) P;

    /* =========================================================
       9. CITAS: 60
       ========================================================= */

    CREATE TABLE #Encargados
    (
        N INT PRIMARY KEY,
        Id_Usuario INT NOT NULL
    );

    INSERT INTO #Encargados (N, Id_Usuario)
    SELECT
        ROW_NUMBER() OVER (ORDER BY U.Id_Usuario),
        U.Id_Usuario
    FROM
    (
        SELECT TOP (8)
            Id_Usuario
        FROM dbo.Usuario
        WHERE Estado = 'A'
          AND
          (
              Correo LIKE '%@gosen.test'
              OR Id_Rol =
                 (
                     SELECT TOP (1) Id_Rol
                     FROM dbo.Rol
                     WHERE Descripcion = 'Admin'
                     ORDER BY Id_Rol
                 )
          )
        ORDER BY
            CASE WHEN Correo LIKE '%@gosen.test' THEN 1 ELSE 0 END,
            Id_Usuario
    ) U;

    DECLARE @CantidadEncargados INT = (SELECT COUNT(*) FROM #Encargados);

    IF @CantidadEncargados = 0
        THROW 50003, 'No existen usuarios activos para asignar como encargados de citas.', 1;

    INSERT INTO dbo.Citas
    (
        Fecha_Cita,
        Id_Usuario_Cita,
        Id_Usuario_Encargado,
        Observacion_Inicial,
        Detalle_Cita,
        Estado
    )
    SELECT
        DATEADD(DAY, -30 + (N.N - 1), @Hoy),
        UC.Id_Usuario,
        UE.Id_Usuario,
        CONCAT(
            '[SINTETICO] ',
            CASE N.N % 6
                WHEN 0 THEN 'Solicitud de orientación familiar.'
                WHEN 1 THEN 'Consulta sobre participación en actividades.'
                WHEN 2 THEN 'Solicitud de apoyo comunitario.'
                WHEN 3 THEN 'Conversación de acompañamiento personal.'
                WHEN 4 THEN 'Consulta sobre integración a un ministerio.'
                ELSE 'Seguimiento de una solicitud anterior.'
            END
        ),
        CASE
            WHEN DATEADD(DAY, -30 + (N.N - 1), @Hoy) < @Hoy
                THEN
                    CASE N.N % 5
                        WHEN 0 THEN 'La persona fue atendida y se acordó seguimiento.'
                        WHEN 1 THEN 'Se brindó orientación y se compartieron los próximos pasos.'
                        WHEN 2 THEN 'La consulta fue resuelta durante la cita.'
                        WHEN 3 THEN 'Se coordinó apoyo con el ministerio correspondiente.'
                        ELSE 'Se registró el caso para seguimiento posterior.'
                    END
            ELSE NULL
        END,
        CASE
            WHEN DATEADD(DAY, -30 + (N.N - 1), @Hoy) < @Hoy
                THEN 'Atendida'
            ELSE 'Pendiente'
        END
    FROM #Numeros N
    INNER JOIN #Usuarios UC
        ON UC.N = N.N
    INNER JOIN #Encargados UE
        ON UE.N = ((N.N - 1) % @CantidadEncargados) + 1
    WHERE N.N <= 60;

    /* =========================================================
       10. REGISTRO DE ERRORES: 50
       ========================================================= */

    INSERT INTO dbo.Error
    (
        Mensaje,
        Lugar,
        FechaHora,
        Id_Usuario
    )
    SELECT
        CONCAT(
            '[SINTETICO] ',
            CASE N.N % 8
                WHEN 0 THEN 'No se pudo enviar la notificación por correo.'
                WHEN 1 THEN 'Se produjo un tiempo de espera al consultar la base de datos.'
                WHEN 2 THEN 'No se encontró el registro solicitado.'
                WHEN 3 THEN 'La validación de los datos recibidos no fue satisfactoria.'
                WHEN 4 THEN 'Ocurrió un error al generar el reporte.'
                WHEN 5 THEN 'La sesión del usuario había expirado.'
                WHEN 6 THEN 'No fue posible completar la actualización solicitada.'
                ELSE 'Se registró una respuesta inesperada del servicio.'
            END
        ),
        CASE N.N % 7
            WHEN 0 THEN '/simulacion/api/usuarios'
            WHEN 1 THEN '/simulacion/api/actividades'
            WHEN 2 THEN '/simulacion/api/citas'
            WHEN 3 THEN '/simulacion/api/ministerios'
            WHEN 4 THEN '/simulacion/api/reportes'
            WHEN 5 THEN '/simulacion/api/sesion'
            ELSE '/simulacion/api/dashboard'
        END,
        DATEADD
        (
            MINUTE,
            -(N.N * 37),
            DATEADD(DAY, -(N.N % 25), CAST(GETDATE() AS DATETIME))
        ),
        U.Id_Usuario
    FROM #Numeros N
    INNER JOIN #Usuarios U
        ON U.N = ((N.N - 1) % 60) + 1
    WHERE N.N <= 50;

    COMMIT TRANSACTION;

    /* =========================================================
       11. RESUMEN DE VERIFICACIÓN
       ========================================================= */

    SELECT 'Rol' AS Tabla, COUNT(*) AS Total_Registros
    FROM dbo.Rol

    UNION ALL
    SELECT 'Tipo_Actividad', COUNT(*)
    FROM dbo.Tipo_Actividad

    UNION ALL
    SELECT 'Ministerio', COUNT(*)
    FROM dbo.Ministerio

    UNION ALL
    SELECT 'Usuario', COUNT(*)
    FROM dbo.Usuario

    UNION ALL
    SELECT 'Usuarios_Ministerio', COUNT(*)
    FROM dbo.Usuarios_Ministerio

    UNION ALL
    SELECT 'Actividad', COUNT(*)
    FROM dbo.Actividad

    UNION ALL
    SELECT 'Actividades_Ministerio', COUNT(*)
    FROM dbo.Actividades_Ministerio

    UNION ALL
    SELECT 'Actividad_Usuario', COUNT(*)
    FROM dbo.Actividad_Usuario

    UNION ALL
    SELECT 'Citas', COUNT(*)
    FROM dbo.Citas

    UNION ALL
    SELECT 'Error', COUNT(*)
    FROM dbo.Error;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
