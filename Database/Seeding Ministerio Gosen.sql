USE [ministerio_gosen];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    /* ============================================================
       1. ASEGURAR TABLA DEL CHATBOT SI NO EXISTE
       ============================================================ */

    IF OBJECT_ID('dbo.Chat_Bot_Opciones', 'U') IS NULL
    BEGIN
        CREATE TABLE dbo.Chat_Bot_Opciones
        (
            Id_Opcion INT IDENTITY(1,1) PRIMARY KEY,
            Texto_Opcion NVARCHAR(200) NOT NULL,
            Respuesta VARCHAR(200) NULL,
            Id_Opcion_Padre INT NULL,
            Orden INT NOT NULL DEFAULT 1,
            Activo BIT NOT NULL DEFAULT 1,
            CONSTRAINT FK_Opcion_Padre
                FOREIGN KEY (Id_Opcion_Padre)
                REFERENCES dbo.Chat_Bot_Opciones (Id_Opcion)
        );
    END;

    /* ============================================================
       2. LIMPIEZA EN ORDEN DE DEPENDENCIAS
       ============================================================ */

    DELETE FROM dbo.Chat_Bot_Opciones;
    DELETE FROM dbo.Error;
    DELETE FROM dbo.Actividad_Usuario;
    DELETE FROM dbo.Actividades_Ministerio;
    DELETE FROM dbo.Usuarios_Ministerio;
    DELETE FROM dbo.Citas;
    DELETE FROM dbo.Actividad;
    DELETE FROM dbo.Tipo_Actividad;
    DELETE FROM dbo.Ministerio;
    DELETE FROM dbo.Usuario;
    DELETE FROM dbo.Rol;

    DBCC CHECKIDENT ('dbo.Chat_Bot_Opciones', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Error', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Actividad_Usuario', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Actividades_Ministerio', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Usuarios_Ministerio', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Citas', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Actividad', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Tipo_Actividad', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Ministerio', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Usuario', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('dbo.Rol', RESEED, 0) WITH NO_INFOMSGS;

    /* ============================================================
       3. ROLES
       ============================================================ */

    SET IDENTITY_INSERT dbo.Rol ON;

    INSERT INTO dbo.Rol
    (
        Id_Rol,
        Descripcion
    )
    VALUES
    (1, 'Admin'),
    (2, 'Usuario');

    SET IDENTITY_INSERT dbo.Rol OFF;

    /* ============================================================
       4. USUARIOS
       Admin: ministeriogosen@gmail.com / admin123
       Usuarios normales: usuario123
       ============================================================ */

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
    VALUES
    ('000000000', 'ADMINISTRADOR MINISTERIO GOSEN', 'ministeriogosen@gmail.com', 'admin123', 'A', 1, 0);

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
    VALUES
    ('116700557', 'MARIA FERNANDA FAJARDO TORRES', 'maria.fajardo@gosen.local', 'usuario123', 'A', 2, 0),
    ('114560987', 'JONATHAN STEVEN BARRANTES MORA', 'jonathan.barrantes@gosen.local', 'usuario123', 'A', 2, 0),
    ('109870654', 'AARON AZOFEIFA SALAZAR', 'aaron.azofeifa@gosen.local', 'usuario123', 'A', 2, 0),
    ('112340987', 'YESENIA SALAZAR PEREZ', 'yesenia.salazar@gosen.local', 'usuario123', 'A', 2, 0),
    ('116780432', 'CARLOS ANDRES MORA ROJAS', 'carlos.mora@gosen.local', 'usuario123', 'A', 2, 0),
    ('120980765', 'ANA LUCIA VARGAS SOLIS', 'ana.vargas@gosen.local', 'usuario123', 'A', 2, 0),
    ('107650234', 'JOSE DANIEL CHACON RUIZ', 'jose.chacon@gosen.local', 'usuario123', 'A', 2, 0),
    ('115670983', 'DANIELA CASTRO JIMENEZ', 'daniela.castro@gosen.local', 'usuario123', 'A', 2, 0),
    ('110980456', 'LUIS FERNANDO BRENES SOTO', 'luis.brenes@gosen.local', 'usuario123', 'A', 2, 0),
    ('119870345', 'SOFIA HERNANDEZ ARIAS', 'sofia.hernandez@gosen.local', 'usuario123', 'A', 2, 0),
    ('108760543', 'MIGUEL ANGEL ROJAS CAMPOS', 'miguel.rojas@gosen.local', 'usuario123', 'A', 2, 0),
    ('117650987', 'VALERIA MONTERO FALLAS', 'valeria.montero@gosen.local', 'usuario123', 'A', 2, 0),
    ('113450876', 'GABRIEL NUNEZ ALVARADO', 'gabriel.nunez@gosen.local', 'usuario123', 'A', 2, 0),
    ('121340765', 'KATHERINE MORALES VEGA', 'katherine.morales@gosen.local', 'usuario123', 'A', 2, 0),
    ('106780912', 'ANDRES SALAS PORRAS', 'andres.salas@gosen.local', 'usuario123', 'A', 2, 0),
    ('122450673', 'PAOLA RAMIREZ AGUILAR', 'paola.ramirez@gosen.local', 'usuario123', 'A', 2, 0),
    ('105670432', 'ESTEBAN CALDERON LOPEZ', 'esteban.calderon@gosen.local', 'usuario123', 'A', 2, 0),
    ('124560981', 'NATALIA SEGURA MENDEZ', 'natalia.segura@gosen.local', 'usuario123', 'A', 2, 0),
    ('103450876', 'RICARDO VARGAS ZAMORA', 'ricardo.vargas@gosen.local', 'usuario123', 'I', 2, 0),
    ('126780453', 'ELENA JIMENEZ CORDERO', 'elena.jimenez@gosen.local', 'usuario123', 'A', 2, 1),
    ('125001001', 'MARIANA SOLANO RIVERA', 'mariana.solano@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001002', 'DIEGO ALVARADO CAMPOS', 'diego.alvarado@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001003', 'LAURA PEREZ MONGE', 'laura.perez@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001004', 'FABIAN SOTO VARGAS', 'fabian.soto@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001005', 'GABRIELA QUESADA ARIAS', 'gabriela.quesada@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001006', 'MAURICIO VARGAS HERRERA', 'mauricio.vargas@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001007', 'ADRIANA MORALES ROJAS', 'adriana.morales@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001008', 'JORGE CASTILLO FALLAS', 'jorge.castillo@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001009', 'MONICA ARIAS SANCHEZ', 'monica.arias@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001010', 'PABLO RODRIGUEZ SALAS', 'pablo.rodriguez@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001011', 'SILVIA MENDEZ CAMPOS', 'silvia.mendez@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001012', 'OSCAR CHAVES BRENES', 'oscar.chaves@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001013', 'KARLA VILLALOBOS SEGURA', 'karla.villalobos@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001014', 'EMMANUEL GOMEZ LOPEZ', 'emmanuel.gomez@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001015', 'JULIANA NAVARRO SOLIS', 'juliana.navarro@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001016', 'HECTOR MORA CORDERO', 'hector.mora@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001017', 'TATIANA AGUILAR PEREIRA', 'tatiana.aguilar@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001018', 'ROBERTO CALDERON NUÑEZ', 'roberto.calderon@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001019', 'MELISSA JIMENEZ VARGAS', 'melissa.jimenez@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001020', 'BRAYAN MURILLO FONSECA', 'brayan.murillo@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001021', 'CAMILA LEIVA ZAMORA', 'camila.leiva@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001022', 'SEBASTIAN COTO VEGA', 'sebastian.coto@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001023', 'MARCELA ARCE PANIAGUA', 'marcela.arce@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001024', 'GERARDO ACUÑA RIVAS', 'gerardo.acuna@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001025', 'PATRICIA BARRANTES ARAYA', 'patricia.barrantes@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001026', 'DAVID CAMPOS RETANA', 'david.campos@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001027', 'ELIANA LOPEZ CASTRO', 'eliana.lopez@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001028', 'SAMUEL ROJAS ALPIZAR', 'samuel.rojas@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001029', 'MARTA SANCHEZ PORRAS', 'marta.sanchez@gosen.local', 'usuario123', 'A', 2, 0),
    ('125001030', 'ISAAC MONGE VALVERDE', 'isaac.monge@gosen.local', 'usuario123', 'A', 2, 0);

    DECLARE @IdAdmin INT =
    (
        SELECT Id_Usuario
        FROM dbo.Usuario
        WHERE Correo = 'ministeriogosen@gmail.com'
    );

    /* ============================================================
       5. TIPOS DE ACTIVIDAD
       ============================================================ */

    INSERT INTO dbo.Tipo_Actividad
    (
        Nombre_Tipo
    )
    VALUES
    ('Culto'),
    ('Reunion'),
    ('Taller'),
    ('Capacitacion'),
    ('Visita'),
    ('Ayuda social'),
    ('Oracion'),
    ('Servicio comunitario');

    /* ============================================================
       6. MINISTERIOS
       ============================================================ */

    INSERT INTO dbo.Ministerio
    (
        Descripcion_Ministerio,
        Observaciones_Ministerio
    )
    VALUES
    ('Ministerio de Niños', 'Atencion, enseñanza y actividades para poblacion infantil.'),
    ('Ministerio de Jovenes', 'Formacion, integracion y acompañamiento para jovenes.'),
    ('Ministerio de Mujeres', 'Reuniones, talleres y acompañamiento espiritual para mujeres.'),
    ('Ministerio de Adultos', 'Enseñanza, seguimiento y participacion comunitaria de adultos.'),
    ('Ministerio de Musica', 'Coordinacion musical y apoyo en reuniones y actividades especiales.'),
    ('Ministerio de Ayuda Social', 'Apoyo a familias, visitas y acompañamiento comunitario.'),
    ('Ministerio de Oracion', 'Oracion, acompañamiento espiritual y seguimiento a solicitudes.'),
    ('Ministerio de Evangelismo', 'Actividades de alcance comunitario y evangelismo.'),
    ('Ministerio de Multimedia', 'Apoyo tecnico, sonido, proyeccion y comunicacion.'),
    ('Ministerio de Bienvenida', 'Recibimiento, orientacion y apoyo a visitantes.');

    /* ============================================================
       7. USUARIOS POR MINISTERIO
       ============================================================ */

    DECLARE @TotalMinisterios INT =
    (
        SELECT COUNT(*)
        FROM dbo.Ministerio
    );

    ;WITH Usuarios AS
    (
        SELECT
            Id_Usuario,
            ROW_NUMBER() OVER (ORDER BY Id_Usuario) AS RN
        FROM dbo.Usuario
        WHERE Id_Rol = 2
    ),
    Ministerios AS
    (
        SELECT
            Id_Ministerio,
            ROW_NUMBER() OVER (ORDER BY Id_Ministerio) AS RN
        FROM dbo.Ministerio
    )
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
        DATEADD(DAY, -((U.RN * 5) % 210), CAST(GETDATE() AS DATE)),
        NULL,
        'Activo',
        'Miembro activo del ministerio.'
    FROM Usuarios U
    INNER JOIN Ministerios M
        ON M.RN = ((U.RN - 1) % @TotalMinisterios) + 1;

    ;WITH Usuarios AS
    (
        SELECT
            Id_Usuario,
            ROW_NUMBER() OVER (ORDER BY Id_Usuario) AS RN
        FROM dbo.Usuario
        WHERE Id_Rol = 2
          AND Estado = 'A'
    ),
    Ministerios AS
    (
        SELECT
            Id_Ministerio,
            ROW_NUMBER() OVER (ORDER BY Id_Ministerio) AS RN
        FROM dbo.Ministerio
    )
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
        DATEADD(DAY, -((U.RN * 7) % 180), CAST(GETDATE() AS DATE)),
        NULL,
        'Activo',
        'Apoyo adicional en actividades del ministerio.'
    FROM Usuarios U
    INNER JOIN Ministerios M
        ON M.RN = ((U.RN + 2) % @TotalMinisterios) + 1
    WHERE U.RN % 4 = 0
      AND NOT EXISTS
      (
          SELECT 1
          FROM dbo.Usuarios_Ministerio UM
          WHERE UM.Id_Usuario = U.Id_Usuario
            AND UM.Id_Ministerio = M.Id_Ministerio
            AND UM.Fecha_Salida IS NULL
      );

    /* ============================================================
       8. ACTIVIDADES Y RELACION CON MINISTERIOS
       ============================================================ */

    DECLARE @ActividadesSeed TABLE
    (
        Nombre_Actividad VARCHAR(100),
        DiasDesdeHoy INT,
        DiasDuracion INT,
        Lugar VARCHAR(100),
        Hora_Ini TIME(7),
        Hora_Fin TIME(7),
        Nombre_Tipo VARCHAR(50),
        Ministerio VARCHAR(100),
        Observacion VARCHAR(200)
    );

    INSERT INTO @ActividadesSeed
    (
        Nombre_Actividad,
        DiasDesdeHoy,
        DiasDuracion,
        Lugar,
        Hora_Ini,
        Hora_Fin,
        Nombre_Tipo,
        Ministerio,
        Observacion
    )
    VALUES
    ('Culto dominical familiar', 2, 0, 'Templo principal', '09:00', '11:00', 'Culto', 'Ministerio de Musica', 'Apoyo musical en culto dominical.'),
    ('Reunion de jovenes', 4, 0, 'Salon multiuso', '17:00', '19:00', 'Reunion', 'Ministerio de Jovenes', 'Reunion semanal de jovenes.'),
    ('Taller para padres y niños', 7, 0, 'Aula de niños', '14:00', '16:00', 'Taller', 'Ministerio de Niños', 'Taller formativo para familias.'),
    ('Visita a familias de la comunidad', 10, 0, 'La Fila de Mora', '08:00', '12:00', 'Visita', 'Ministerio de Ayuda Social', 'Visitas programadas a familias.'),
    ('Capacitacion de servidores', 12, 0, 'Aula principal', '13:00', '16:00', 'Capacitacion', 'Ministerio de Adultos', 'Capacitacion general de servidores.'),
    ('Entrega de viveres', 15, 0, 'Centro comunitario', '09:00', '12:00', 'Servicio comunitario', 'Ministerio de Ayuda Social', 'Entrega comunitaria de viveres.'),
    ('Noche de oracion', 18, 0, 'Templo principal', '18:30', '20:00', 'Oracion', 'Ministerio de Oracion', 'Noche de oracion congregacional.'),
    ('Reunion de mujeres', 20, 0, 'Salon multiuso', '15:00', '17:00', 'Reunion', 'Ministerio de Mujeres', 'Reunion mensual de mujeres.'),
    ('Ensayo de alabanza', 21, 0, 'Templo principal', '16:00', '18:00', 'Reunion', 'Ministerio de Musica', 'Ensayo previo al culto.'),
    ('Taller de liderazgo juvenil', 24, 0, 'Aula principal', '14:00', '17:00', 'Taller', 'Ministerio de Jovenes', 'Taller formativo para jovenes.'),
    ('Actividad recreativa infantil', 28, 0, 'Area verde', '09:00', '11:30', 'Servicio comunitario', 'Ministerio de Niños', 'Actividad recreativa infantil.'),
    ('Charla de apoyo familiar', 30, 0, 'Salon multiuso', '14:00', '16:00', 'Taller', 'Ministerio de Adultos', 'Charla abierta para familias.'),
    ('Culto de alabanza', 32, 0, 'Templo principal', '18:00', '20:00', 'Culto', 'Ministerio de Musica', 'Actividad de alabanza y adoracion.'),
    ('Jornada de limpieza comunitaria', 35, 0, 'Comunidad La Fila', '08:00', '11:00', 'Servicio comunitario', 'Ministerio de Evangelismo', 'Servicio comunitario local.'),
    ('Reunion de equipo multimedia', 36, 0, 'Cabina tecnica', '18:00', '19:30', 'Reunion', 'Ministerio de Multimedia', 'Coordinacion tecnica semanal.'),
    ('Capacitacion de bienvenida', 38, 0, 'Recepcion', '10:00', '12:00', 'Capacitacion', 'Ministerio de Bienvenida', 'Capacitacion para equipo de bienvenida.'),
    ('Escuela dominical infantil', 40, 0, 'Aula de niños', '09:00', '10:30', 'Taller', 'Ministerio de Niños', 'Clase dominical para niños.'),
    ('Encuentro de parejas', 42, 0, 'Salon multiuso', '18:00', '20:00', 'Taller', 'Ministerio de Adultos', 'Actividad de apoyo familiar.'),
    ('Campaña de donacion', 45, 1, 'Centro comunitario', '09:00', '15:00', 'Ayuda social', 'Ministerio de Ayuda Social', 'Recoleccion y clasificacion de donaciones.'),
    ('Reunion de planificacion evangelismo', 47, 0, 'Aula principal', '18:00', '20:00', 'Reunion', 'Ministerio de Evangelismo', 'Planificacion de actividades comunitarias.'),
    ('Practica de sonido', 49, 0, 'Templo principal', '17:00', '19:00', 'Capacitacion', 'Ministerio de Multimedia', 'Practica de sonido y proyeccion.'),
    ('Devocional de mujeres', 52, 0, 'Salon multiuso', '16:00', '18:00', 'Oracion', 'Ministerio de Mujeres', 'Devocional y seguimiento espiritual.'),
    ('Convivio juvenil', 55, 0, 'Area verde', '15:00', '18:00', 'Servicio comunitario', 'Ministerio de Jovenes', 'Convivio e integracion de jovenes.'),
    ('Taller de apoyo emocional', 58, 0, 'Aula principal', '14:00', '16:30', 'Taller', 'Ministerio de Adultos', 'Taller de acompañamiento familiar.'),
    ('Visita de seguimiento', 60, 0, 'Comunidad La Fila', '09:00', '12:00', 'Visita', 'Ministerio de Oracion', 'Seguimiento a solicitudes de oracion.'),
    ('Reunion general de servidores', 62, 0, 'Templo principal', '18:30', '20:30', 'Reunion', 'Ministerio de Bienvenida', 'Coordinacion general de servidores.'),
    ('Culto juvenil especial', 65, 0, 'Templo principal', '18:00', '20:30', 'Culto', 'Ministerio de Jovenes', 'Culto especial organizado por jovenes.'),
    ('Clase de musica basica', 68, 0, 'Salon de musica', '14:00', '16:00', 'Capacitacion', 'Ministerio de Musica', 'Formacion musical basica.'),
    ('Tarde de juegos infantiles', 70, 0, 'Area verde', '14:00', '17:00', 'Servicio comunitario', 'Ministerio de Niños', 'Actividad recreativa para niños.'),
    ('Reunion de intercesion', 73, 0, 'Templo principal', '19:00', '20:30', 'Oracion', 'Ministerio de Oracion', 'Reunion de intercesion.'),
    ('Atencion a visitantes', 75, 0, 'Recepcion', '08:30', '11:30', 'Servicio comunitario', 'Ministerio de Bienvenida', 'Apoyo a visitantes en culto.'),
    ('Taller de redes sociales', 78, 0, 'Aula multimedia', '15:00', '17:00', 'Capacitacion', 'Ministerio de Multimedia', 'Capacitacion de comunicacion digital.'),
    ('Salida evangelistica', 80, 0, 'Comunidad cercana', '08:00', '12:00', 'Visita', 'Ministerio de Evangelismo', 'Actividad de alcance comunitario.'),
    ('Encuentro de adultos mayores', 83, 0, 'Salon multiuso', '10:00', '12:00', 'Reunion', 'Ministerio de Adultos', 'Encuentro y acompañamiento.'),
    ('Taller de manualidades', 85, 0, 'Aula de mujeres', '14:00', '16:00', 'Taller', 'Ministerio de Mujeres', 'Taller creativo y de convivencia.'),
    ('Culto de accion de gracias', 90, 0, 'Templo principal', '18:00', '20:00', 'Culto', 'Ministerio de Musica', 'Culto congregacional especial.');

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
        S.Nombre_Actividad,
        DATEADD(DAY, S.DiasDesdeHoy, CAST(GETDATE() AS DATE)),
        DATEADD(DAY, S.DiasDesdeHoy + S.DiasDuracion, CAST(GETDATE() AS DATE)),
        S.Lugar,
        S.Hora_Ini,
        S.Hora_Fin,
        TA.Id_Tipo_Actividad
    FROM @ActividadesSeed S
    INNER JOIN dbo.Tipo_Actividad TA
        ON TA.Nombre_Tipo = S.Nombre_Tipo;

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
        S.Observacion
    FROM @ActividadesSeed S
    INNER JOIN dbo.Actividad A
        ON A.Nombre_Actividad = S.Nombre_Actividad
    INNER JOIN dbo.Ministerio M
        ON M.Descripcion_Ministerio = S.Ministerio;

    /* ============================================================
       9. PARTICIPACION DE USUARIOS EN ACTIVIDADES
       ============================================================ */

    DECLARE @TotalUsuarios INT =
    (
        SELECT COUNT(*)
        FROM dbo.Usuario
        WHERE Id_Rol = 2
          AND Estado = 'A'
    );

    ;WITH Actividades AS
    (
        SELECT
            Id_Actividad,
            Fecha_Ini,
            Hora_Ini,
            ROW_NUMBER() OVER (ORDER BY Id_Actividad) AS RN
        FROM dbo.Actividad
    ),
    Usuarios AS
    (
        SELECT
            Id_Usuario,
            ROW_NUMBER() OVER (ORDER BY Id_Usuario) AS RN
        FROM dbo.Usuario
        WHERE Id_Rol = 2
          AND Estado = 'A'
    )
    INSERT INTO dbo.Actividad_Usuario
    (
        Id_Actividad,
        Id_Usuario,
        Fecha,
        Hora
    )
    SELECT
        A.Id_Actividad,
        U.Id_Usuario,
        A.Fecha_Ini,
        A.Hora_Ini
    FROM Actividades A
    INNER JOIN Usuarios U
        ON U.RN = ((A.RN * 2 - 1) % @TotalUsuarios) + 1
        OR U.RN = ((A.RN * 2 + 7) % @TotalUsuarios) + 1
        OR U.RN = ((A.RN * 2 + 15) % @TotalUsuarios) + 1;

    /* ============================================================
       10. CITAS
       Estado solo permite: Pendiente / Atendida
       ============================================================ */

    ;WITH Usuarios AS
    (
        SELECT
            Id_Usuario,
            ROW_NUMBER() OVER (ORDER BY Id_Usuario) AS RN
        FROM dbo.Usuario
        WHERE Id_Rol = 2
          AND Estado = 'A'
    ),
    Encargados AS
    (
        SELECT
            Id_Usuario,
            ROW_NUMBER() OVER (ORDER BY Id_Usuario) AS RN
        FROM dbo.Usuario
        WHERE Id_Rol = 2
          AND Estado = 'A'
    )
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
        DATEADD(DAY, U.RN + 1, CAST(GETDATE() AS DATE)),
        U.Id_Usuario,
        CASE
            WHEN U.RN % 4 = 0 THEN @IdAdmin
            ELSE E.Id_Usuario
        END,
        CASE
            WHEN U.RN % 5 = 0 THEN 'Solicitud de apoyo familiar.'
            WHEN U.RN % 5 = 1 THEN 'Consulta sobre participacion en ministerio.'
            WHEN U.RN % 5 = 2 THEN 'Solicitud de acompañamiento espiritual.'
            WHEN U.RN % 5 = 3 THEN 'Consulta sobre actividades disponibles.'
            ELSE 'Solicitud de orientacion general.'
        END,
        CASE
            WHEN U.RN % 3 = 0 THEN 'Cita atendida y registrada con seguimiento.'
            ELSE 'Cita pendiente de revision por administracion.'
        END,
        CASE
            WHEN U.RN % 3 = 0 THEN 'Atendida'
            ELSE 'Pendiente'
        END
    FROM Usuarios U
    INNER JOIN Encargados E
        ON E.RN = ((U.RN + 6) % @TotalUsuarios) + 1
    WHERE U.RN <= 25;

    /* ============================================================
       11. ERRORES DE EJEMPLO
       ============================================================ */

    INSERT INTO dbo.Error
    (
        Mensaje,
        Lugar,
        FechaHora,
        Id_Usuario
    )
    VALUES
    ('Intento de acceso con contraseña incorrecta.', 'Home/IniciarSesion', DATEADD(DAY, -5, GETDATE()), @IdAdmin),
    ('Validacion de formulario incompleta.', 'Usuario/Crear', DATEADD(DAY, -4, GETDATE()), @IdAdmin),
    ('Error controlado al consultar citas.', 'Citas/Listar', DATEADD(DAY, -3, GETDATE()), @IdAdmin),
    ('Parametro requerido no recibido.', 'Actividad/Crear', DATEADD(DAY, -2, GETDATE()), @IdAdmin),
    ('Consulta sin resultados disponibles.', 'Reportes/Index', DATEADD(DAY, -1, GETDATE()), @IdAdmin);

    /* ============================================================
       12. CHATBOT
       Mantener respuestas cortas porque Respuesta es VARCHAR(200)
       ============================================================ */

    DECLARE @IdInfo INT;
    DECLARE @IdMinisterios INT;
    DECLARE @IdActividades INT;
    DECLARE @IdCitas INT;
    DECLARE @IdHorarios INT;
    DECLARE @IdContacto INT;
    DECLARE @IdUsuarioAcceso INT;
    DECLARE @IdUbicacion INT;
    DECLARE @IdAgendar INT;

    INSERT INTO dbo.Chat_Bot_Opciones
    (
        Texto_Opcion,
        Respuesta,
        Id_Opcion_Padre,
        Orden,
        Activo
    )
    VALUES
    (N'Informacion general', 'Seleccione la informacion que desea consultar.', NULL, 1, 1);
    SET @IdInfo = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Ministerios', 'Seleccione el ministerio sobre el que desea informacion.', NULL, 2, 1);
    SET @IdMinisterios = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Actividades', 'Seleccione una opcion relacionada con actividades.', NULL, 3, 1);
    SET @IdActividades = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Citas', 'Seleccione una opcion relacionada con citas.', NULL, 4, 1);
    SET @IdCitas = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Horarios', 'Seleccione el horario que desea consultar.', NULL, 5, 1);
    SET @IdHorarios = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Contacto', 'Seleccione el medio por el cual desea comunicarse.', NULL, 6, 1);
    SET @IdContacto = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Usuario y acceso', 'Seleccione una opcion relacionada con su usuario.', NULL, 7, 1);
    SET @IdUsuarioAcceso = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Que es Ministerio Gosen', 'Ministerio Gosen brinda acompañamiento espiritual, actividades comunitarias y apoyo a familias.', @IdInfo, 1, 1),
    (N'Quien puede usar el sistema', 'El sistema puede ser usado por usuarios registrados y administradores autorizados.', @IdInfo, 2, 1),
    (N'Ubicacion', 'Seleccione la informacion de ubicacion que desea consultar.', @IdInfo, 3, 1);

    SELECT @IdUbicacion = Id_Opcion
    FROM dbo.Chat_Bot_Opciones
    WHERE Texto_Opcion = N'Ubicacion'
      AND Id_Opcion_Padre = @IdInfo;

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Direccion', 'El Ministerio Gosen se ubica en La Fila de Mora, Puriscal.', @IdUbicacion, 1, 1),
    (N'Como llegar', 'Solicite indicaciones a la administracion o revise la ubicacion oficial compartida.', @IdUbicacion, 2, 1),

    (N'Ver ministerios disponibles', 'Puede consultar los ministerios desde la opcion Ministerios del menu principal.', @IdMinisterios, 1, 1),
    (N'Participar en un ministerio', 'Comuniquese con la administracion o consulte el ministerio de su interes.', @IdMinisterios, 2, 1),
    (N'Ministerio de Niños', 'Realiza actividades formativas y recreativas para niños.', @IdMinisterios, 3, 1),
    (N'Ministerio de Jovenes', 'Promueve reuniones, talleres y actividades para jovenes.', @IdMinisterios, 4, 1),
    (N'Ministerio de Ayuda Social', 'Organiza visitas, entregas y apoyo comunitario.', @IdMinisterios, 5, 1),
    (N'Ministerio de Oracion', 'Brinda acompañamiento espiritual y seguimiento a solicitudes.', @IdMinisterios, 6, 1),

    (N'Proximas actividades', 'Las actividades disponibles se consultan en la seccion Actividades.', @IdActividades, 1, 1),
    (N'Inscribirme en una actividad', 'Revise la actividad y comuniquese con la administracion para confirmar participacion.', @IdActividades, 2, 1),
    (N'Tipos de actividades', 'El sistema registra cultos, reuniones, talleres, visitas y servicio comunitario.', @IdActividades, 3, 1),

    (N'Agendar una cita', 'Ingrese a Agendar Cita, complete la informacion solicitada y espere confirmacion.', @IdCitas, 1, 1);

    SET @IdAgendar = SCOPE_IDENTITY();

    INSERT INTO dbo.Chat_Bot_Opciones
    (Texto_Opcion, Respuesta, Id_Opcion_Padre, Orden, Activo)
    VALUES
    (N'Consultar una cita', 'Puede revisar sus citas desde la seccion Citas o solicitar apoyo a la administracion.', @IdCitas, 2, 1),
    (N'Cancelar una cita', 'Para cancelar una cita, comuniquese con la administracion con anticipacion.', @IdCitas, 3, 1),
    (N'Datos necesarios', 'Para agendar se requiere nombre, motivo de cita y disponibilidad de fecha.', @IdAgendar, 1, 1),
    (N'Confirmacion de cita', 'La cita queda sujeta a revision y confirmacion de la administracion.', @IdAgendar, 2, 1),

    (N'Horario de atencion', 'El horario de atencion depende de la disponibilidad de la administracion.', @IdHorarios, 1, 1),
    (N'Horario de actividades', 'Los horarios varian segun el ministerio y la programacion semanal.', @IdHorarios, 2, 1),
    (N'Atencion en feriados', 'La atencion en feriados depende de la programacion oficial.', @IdHorarios, 3, 1),

    (N'Telefono', 'Puede comunicarse con la administracion al numero oficial del Ministerio Gosen.', @IdContacto, 1, 1),
    (N'Correo electronico', 'Puede escribir al correo ministeriogosen@gmail.com.', @IdContacto, 2, 1),
    (N'Solicitar ayuda', 'Para solicitar ayuda, registre una cita o comuniquese con la administracion.', @IdContacto, 3, 1),

    (N'Cambiar contraseña', 'Ingrese a Configuracion y actualice su contraseña desde su perfil.', @IdUsuarioAcceso, 1, 1),
    (N'Actualizar mi perfil', 'Ingrese a Configuracion para actualizar su informacion personal.', @IdUsuarioAcceso, 2, 1),
    (N'No puedo ingresar', 'Solicite apoyo a la administracion para revisar su usuario.', @IdUsuarioAcceso, 3, 1);

    COMMIT TRANSACTION;

    PRINT 'Carga completa ejecutada correctamente.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Error ejecutando la carga de datos.';
    PRINT ERROR_MESSAGE();

    THROW;
END CATCH;
GO

/* ============================================================
   13. SP DEL CHATBOT CON ALIAS PARA MODELOS C#
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.SP_ConsultarChatbot
    @Id_Opcion INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id_Opcion AS IdOpcion,
        Texto_Opcion AS TextoOpcion,
        Respuesta,
        Id_Opcion_Padre AS IdOpcionPadre,
        Orden,
        Activo
    FROM dbo.Chat_Bot_Opciones
    WHERE Id_Opcion = @Id_Opcion
      AND Activo = 1;

    SELECT
        Id_Opcion AS IdOpcion,
        Texto_Opcion AS TextoOpcion,
        Respuesta,
        Id_Opcion_Padre AS IdOpcionPadre,
        Orden,
        Activo
    FROM dbo.Chat_Bot_Opciones
    WHERE Activo = 1
      AND
      (
          (@Id_Opcion IS NULL AND Id_Opcion_Padre IS NULL)
          OR
          (@Id_Opcion IS NOT NULL AND Id_Opcion_Padre = @Id_Opcion)
      )
    ORDER BY
        Orden,
        Texto_Opcion;

    SELECT
        Padre.Id_Opcion AS IdOpcion,
        Padre.Texto_Opcion AS TextoOpcion,
        Padre.Respuesta,
        Padre.Id_Opcion_Padre AS IdOpcionPadre,
        Padre.Orden,
        Padre.Activo
    FROM dbo.Chat_Bot_Opciones AS Hijo
    INNER JOIN dbo.Chat_Bot_Opciones AS Padre
        ON Padre.Id_Opcion = Hijo.Id_Opcion_Padre
    WHERE Hijo.Id_Opcion = @Id_Opcion
      AND Padre.Activo = 1;
END;
GO

/* ============================================================
   14. VALIDACION RAPIDA
   ============================================================ */

SELECT 'Rol' AS Tabla, COUNT(*) AS Total FROM dbo.Rol
UNION ALL SELECT 'Usuario', COUNT(*) FROM dbo.Usuario
UNION ALL SELECT 'Ministerio', COUNT(*) FROM dbo.Ministerio
UNION ALL SELECT 'Tipo_Actividad', COUNT(*) FROM dbo.Tipo_Actividad
UNION ALL SELECT 'Actividad', COUNT(*) FROM dbo.Actividad
UNION ALL SELECT 'Actividad_Usuario', COUNT(*) FROM dbo.Actividad_Usuario
UNION ALL SELECT 'Actividades_Ministerio', COUNT(*) FROM dbo.Actividades_Ministerio
UNION ALL SELECT 'Usuarios_Ministerio', COUNT(*) FROM dbo.Usuarios_Ministerio
UNION ALL SELECT 'Citas', COUNT(*) FROM dbo.Citas
UNION ALL SELECT 'Error', COUNT(*) FROM dbo.Error
UNION ALL SELECT 'Chat_Bot_Opciones', COUNT(*) FROM dbo.Chat_Bot_Opciones;
GO
