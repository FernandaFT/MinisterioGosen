USE [master]
GO

CREATE DATABASE [ministerio_gosen]
GO

USE [ministerio_gosen]
GO

CREATE TABLE [dbo].[Actividad](
	[Id_Actividad] [int] IDENTITY(1,1) NOT NULL,
	[Nombre_Actividad] [varchar](100) NOT NULL,
	[Fecha_Ini] [date] NOT NULL,
	[Fecha_Fin] [date] NULL,
	[Lugar] [varchar](100) NULL,
	[Hora_Ini] [time](7) NULL,
	[Hora_Fin] [time](7) NULL,
	[Id_Tipo_Actividad] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Actividad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Actividad_Usuario](
	[Id_Actividad_Usuario] [int] IDENTITY(1,1) NOT NULL,
	[Id_Actividad] [int] NOT NULL,
	[Id_Usuario] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Hora] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Actividad_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Actividades_Ministerio](
	[Id_Minis_Actividad] [int] IDENTITY(1,1) NOT NULL,
	[Id_Actividad] [int] NOT NULL,
	[Id_Ministerio] [int] NOT NULL,
	[Fecha] [date] NULL,
	[Observacion] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Minis_Actividad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Citas](
	[Id_Cita] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Cita] [date] NOT NULL,
	[Id_Usuario_Cita] [int] NOT NULL,
	[Id_Usuario_Encargado] [int] NOT NULL,
	[Observacion_Inicial] [varchar](200) NULL,
	[Detalle_Cita] [varchar](500) NULL,
	[Estado] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Error](
	[Consecutivo] [int] IDENTITY(1,1) NOT NULL,
	[Mensaje] [varchar](max) NOT NULL,
	[Lugar] [varchar](50) NOT NULL,
	[FechaHora] [datetime] NOT NULL,
	[Id_Usuario] [int] NOT NULL,
 CONSTRAINT [PK_Error] PRIMARY KEY CLUSTERED 
(
	[Consecutivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE TABLE [dbo].[Ministerio](
	[Id_Ministerio] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion_Ministerio] [varchar](100) NOT NULL,
	[Observaciones_Ministerio] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Ministerio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Rol](
	[Id_Rol] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Tipo_Actividad](
	[Id_Tipo_Actividad] [int] IDENTITY(1,1) NOT NULL,
	[Nombre_Tipo] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Tipo_Actividad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Usuario](
	[Id_Usuario] [int] IDENTITY(1,1) NOT NULL,
	[Identificacion] [varchar](20) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Correo] [varchar](100) NOT NULL,
	[Contrasena] [varchar](255) NOT NULL,
	[Estado] [char](1) NOT NULL,
	[Id_Rol] [int] NOT NULL,
	[UsaContrasenaTemp] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Usuarios_Ministerio](
	[Id_Usuario_Ministerio] [int] IDENTITY(1,1) NOT NULL,
	[Id_Ministerio] [int] NOT NULL,
	[Id_Usuario] [int] NOT NULL,
	[Fecha_Ingreso] [date] NULL,
	[Fecha_Salida] [date] NULL,
	[Estado] [varchar](20) NULL,
	[Observacion] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Usuario_Ministerio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Rol] ON 
GO
INSERT [dbo].[Rol] ([Id_Rol], [Descripcion]) VALUES (1, N'Admin')
GO
INSERT [dbo].[Rol] ([Id_Rol], [Descripcion]) VALUES (2, N'Usuario')
GO
SET IDENTITY_INSERT [dbo].[Rol] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuario] ON 
GO
INSERT [dbo].[Usuario] ([Id_Usuario], [Identificacion], [Nombre], [Correo], [Contrasena], [Estado], [Id_Rol], [UsaContrasenaTemp]) VALUES (3, N'000000000', N'ADMINISTRADOR', N'ministeriogosen@gmail.com', N'admin!', N'A', 1, 0)
GO
INSERT [dbo].[Usuario] ([Id_Usuario], [Identificacion], [Nombre], [Correo], [Contrasena], [Estado], [Id_Rol], [UsaContrasenaTemp]) VALUES (4, N'116700557', N'FERNANDA FAJARDO TORRES', N'mfajardo00557@ufide.ac.cr', N'00557!', N'A', 2, 0)
GO
SET IDENTITY_INSERT [dbo].[Usuario] OFF
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Rol] ADD UNIQUE NONCLUSTERED 
(
	[Descripcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Usuario] ADD UNIQUE NONCLUSTERED 
(
	[Correo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Usuario] ADD UNIQUE NONCLUSTERED 
(
	[Identificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_UsaContrasenaTemp]  DEFAULT ((0)) FOR [UsaContrasenaTemp]
GO
ALTER TABLE [dbo].[Actividad]  WITH CHECK ADD  CONSTRAINT [fk_actividad_tipo_act] FOREIGN KEY([Id_Tipo_Actividad])
REFERENCES [dbo].[Tipo_Actividad] ([Id_Tipo_Actividad])
GO
ALTER TABLE [dbo].[Actividad] CHECK CONSTRAINT [fk_actividad_tipo_act]
GO
ALTER TABLE [dbo].[Actividad_Usuario]  WITH CHECK ADD  CONSTRAINT [fk_activ_usuario_activ] FOREIGN KEY([Id_Actividad])
REFERENCES [dbo].[Actividad] ([Id_Actividad])
GO
ALTER TABLE [dbo].[Actividad_Usuario] CHECK CONSTRAINT [fk_activ_usuario_activ]
GO
ALTER TABLE [dbo].[Actividad_Usuario]  WITH CHECK ADD  CONSTRAINT [fk_activ_usuario_usuario] FOREIGN KEY([Id_Usuario])
REFERENCES [dbo].[Usuario] ([Id_Usuario])
GO
ALTER TABLE [dbo].[Actividad_Usuario] CHECK CONSTRAINT [fk_activ_usuario_usuario]
GO
ALTER TABLE [dbo].[Actividades_Ministerio]  WITH CHECK ADD  CONSTRAINT [fk_activ_min_activ] FOREIGN KEY([Id_Actividad])
REFERENCES [dbo].[Actividad] ([Id_Actividad])
GO
ALTER TABLE [dbo].[Actividades_Ministerio] CHECK CONSTRAINT [fk_activ_min_activ]
GO
ALTER TABLE [dbo].[Actividades_Ministerio]  WITH CHECK ADD  CONSTRAINT [fk_activ_min_minist] FOREIGN KEY([Id_Ministerio])
REFERENCES [dbo].[Ministerio] ([Id_Ministerio])
GO
ALTER TABLE [dbo].[Actividades_Ministerio] CHECK CONSTRAINT [fk_activ_min_minist]
GO
ALTER TABLE [dbo].[Citas]  WITH CHECK ADD  CONSTRAINT [fk_cita_encargado] FOREIGN KEY([Id_Usuario_Encargado])
REFERENCES [dbo].[Usuario] ([Id_Usuario])
GO
ALTER TABLE [dbo].[Citas] CHECK CONSTRAINT [fk_cita_encargado]
GO
ALTER TABLE [dbo].[Citas]  WITH CHECK ADD  CONSTRAINT [fk_cita_usuario] FOREIGN KEY([Id_Usuario_Cita])
REFERENCES [dbo].[Usuario] ([Id_Usuario])
GO
ALTER TABLE [dbo].[Citas] CHECK CONSTRAINT [fk_cita_usuario]
GO
ALTER TABLE [dbo].[Citas] ADD  CONSTRAINT [DF_Citas_Estado]  DEFAULT ('Pendiente') FOR [Estado]
GO
ALTER TABLE [dbo].[Citas]  WITH CHECK ADD  CONSTRAINT [chk_estado_cita] CHECK  (([Estado]='Pendiente' OR [Estado]='Atendida'))
GO
ALTER TABLE [dbo].[Citas] CHECK CONSTRAINT [chk_estado_cita]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [fk_usuario_rol] FOREIGN KEY([Id_Rol])
REFERENCES [dbo].[Rol] ([Id_Rol])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [fk_usuario_rol]
GO
ALTER TABLE [dbo].[Usuarios_Ministerio]  WITH CHECK ADD  CONSTRAINT [fk_usuario_min_minist] FOREIGN KEY([Id_Ministerio])
REFERENCES [dbo].[Ministerio] ([Id_Ministerio])
GO
ALTER TABLE [dbo].[Usuarios_Ministerio] CHECK CONSTRAINT [fk_usuario_min_minist]
GO
ALTER TABLE [dbo].[Usuarios_Ministerio]  WITH CHECK ADD  CONSTRAINT [fk_usuario_min_usuario] FOREIGN KEY([Id_Usuario])
REFERENCES [dbo].[Usuario] ([Id_Usuario])
GO
ALTER TABLE [dbo].[Usuarios_Ministerio] CHECK CONSTRAINT [fk_usuario_min_usuario]
GO
ALTER TABLE [dbo].[Rol]  WITH CHECK ADD  CONSTRAINT [chk_descripcion_rol] CHECK  (([Descripcion]='Usuario' OR [Descripcion]='Admin'))
GO
ALTER TABLE [dbo].[Rol] CHECK CONSTRAINT [chk_descripcion_rol]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [chk_estado_usuario] CHECK  (([Estado]='I' OR [Estado]='A'))
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [chk_estado_usuario]

GO

CREATE   PROCEDURE [dbo].[spActivarUsuario]
    @Id_Usuario INT
AS
BEGIN
    UPDATE Usuario
    SET Estado = 'A'
    WHERE Id_Usuario = @Id_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spActualizarActividad]
    @Id_Actividad INT,
    @Nombre_Actividad VARCHAR(100),
    @Fecha_Ini DATE,
    @Fecha_Fin DATE,
    @Lugar VARCHAR(100),
    @Hora_Ini TIME(7),
    @Hora_Fin TIME(7),
    @Id_Tipo_Actividad INT
AS
BEGIN
    UPDATE Actividad
    SET Nombre_Actividad = @Nombre_Actividad,
        Fecha_Ini = @Fecha_Ini,
        Fecha_Fin = @Fecha_Fin,
        Lugar = @Lugar,
        Hora_Ini = @Hora_Ini,
        Hora_Fin = @Hora_Fin,
        Id_Tipo_Actividad = @Id_Tipo_Actividad
    WHERE Id_Actividad = @Id_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spActualizarActividadesMinisterio]
    @Id_Minis_Actividad INT,
    @Id_Actividad INT,
    @Id_Ministerio INT,
    @Fecha DATE,
    @Observacion VARCHAR(200)
AS
BEGIN
    UPDATE Actividades_Ministerio
    SET Id_Actividad = @Id_Actividad,
        Id_Ministerio = @Id_Ministerio,
        Fecha = @Fecha,
        Observacion = @Observacion
    WHERE Id_Minis_Actividad = @Id_Minis_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spActualizarActividadUsuario]
    @Id_Actividad_Usuario INT,
    @Id_Actividad INT,
    @Id_Usuario INT,
    @Fecha DATE,
    @Hora TIME(7)
AS
BEGIN
    UPDATE Actividad_Usuario
    SET Id_Actividad = @Id_Actividad,
        Id_Usuario = @Id_Usuario,
        Fecha = @Fecha,
        Hora = @Hora
    WHERE Id_Actividad_Usuario = @Id_Actividad_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spActualizarCita]
    @Id_Cita INT,
    @Fecha_Cita DATE,
    @Id_Usuario_Cita INT,
    @Id_Usuario_Encargado INT,
    @Observacion_Inicial VARCHAR(200),
    @Detalle_Cita VARCHAR(500)
AS
BEGIN
    UPDATE Citas
    SET Fecha_Cita = @Fecha_Cita,
        Id_Usuario_Cita = @Id_Usuario_Cita,
        Id_Usuario_Encargado = @Id_Usuario_Encargado,
        Observacion_Inicial = @Observacion_Inicial,
        Detalle_Cita = @Detalle_Cita
    WHERE Id_Cita = @Id_Cita;
END;

GO
CREATE   PROCEDURE [dbo].[spActualizarContrasenna]
    @Id_Usuario     int,
    @Contrasena     VARCHAR(255),
    @IndicadorTemp  bit
AS
BEGIN
    UPDATE dbo.Usuario
        SET Contrasena = @Contrasena,
            UsaContrasenaTemp = @IndicadorTemp
        WHERE Id_Usuario = @Id_Usuario
END


GO

CREATE   PROCEDURE [dbo].[spActualizarMinisterio]
    @Id_Ministerio INT,
    @Descripcion_Ministerio VARCHAR(100),
    @Observaciones_Ministerio VARCHAR(200)
AS
BEGIN
    UPDATE Ministerio
    SET Descripcion_Ministerio = @Descripcion_Ministerio,
        Observaciones_Ministerio = @Observaciones_Ministerio
    WHERE Id_Ministerio = @Id_Ministerio;
END;

GO

CREATE   PROCEDURE [dbo].[spActualizarRol]
    @Id_Rol INT,
    @Descripcion VARCHAR(20)
AS
BEGIN
    UPDATE Rol SET Descripcion = @Descripcion WHERE Id_Rol = @Id_Rol;
END;

GO

/* ===========================
   CRUD: Tipo_Actividad
   =========================== */
CREATE   PROCEDURE [dbo].[spActualizarTipoActividad]
    @Id_Tipo_Actividad INT,
    @Nombre_Tipo VARCHAR(50)
AS
BEGIN
    UPDATE Tipo_Actividad 
    SET Nombre_Tipo = @Nombre_Tipo 
    WHERE Id_Tipo_Actividad = @Id_Tipo_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spActualizarUsuario]
    @Id_Usuario INT,
    @Nombre VARCHAR(100),
    @Correo VARCHAR(100),
    @Estado CHAR(1),
    @Id_Rol INT
AS
BEGIN
    UPDATE Usuario
    SET Nombre = @Nombre,
        Correo = @Correo,
        Estado = @Estado,
        Id_Rol = @Id_Rol
    WHERE Id_Usuario = @Id_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spActualizarUsuarioMinisterio]
    @Id_Usuario_Ministerio INT,
    @Id_Ministerio INT,
    @Id_Usuario INT,
    @Fecha_Ingreso DATE,
    @Fecha_Salida DATE,
    @Estado VARCHAR(20),
    @Observacion VARCHAR(200)
AS
BEGIN
    UPDATE Usuarios_Ministerio
    SET Id_Ministerio = @Id_Ministerio,
        Id_Usuario = @Id_Usuario,
        Fecha_Ingreso = @Fecha_Ingreso,
        Fecha_Salida = @Fecha_Salida,
        Estado = @Estado,
        Observacion = @Observacion
    WHERE Id_Usuario_Ministerio = @Id_Usuario_Ministerio;
END;

GO
CREATE   PROCEDURE [dbo].[spConsultarDashboard]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (SELECT COUNT(*) 
         FROM Usuario 
         WHERE Estado = 'A') AS TotalPersonas,

        (SELECT COUNT(*) 
         FROM Actividad) AS TotalActividades,

        (SELECT COUNT(*) 
         FROM Ministerio) AS TotalMinisterios,

        (SELECT COUNT(*) 
         FROM Citas
         WHERE Fecha_Cita >= CAST(GETDATE() AS DATE)) AS TotalCitasPendientes;
END;

GO

/* ===========================
   CRUD: Actividad
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearActividad]
    @Nombre_Actividad VARCHAR(100),
    @Fecha_Ini DATE,
    @Fecha_Fin DATE,
    @Lugar VARCHAR(100),
    @Hora_Ini TIME(7),
    @Hora_Fin TIME(7),
    @Id_Tipo_Actividad INT
AS
BEGIN
    INSERT INTO Actividad 
    (
        Nombre_Actividad, 
        Fecha_Ini, 
        Fecha_Fin, 
        Lugar, 
        Hora_Ini, 
        Hora_Fin, 
        Id_Tipo_Actividad
    )
    VALUES 
    (
        @Nombre_Actividad, 
        @Fecha_Ini, 
        @Fecha_Fin, 
        @Lugar, 
        @Hora_Ini, 
        @Hora_Fin, 
        @Id_Tipo_Actividad
    );

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS Id_Actividad;
END;

GO

/* ===========================
   CRUD: Actividades_Ministerio
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearActividadesMinisterio]
    @Id_Actividad INT,
    @Id_Ministerio INT,
    @Fecha DATE,
    @Observacion VARCHAR(200)
AS
BEGIN
    INSERT INTO Actividades_Ministerio (Id_Actividad, Id_Ministerio, Fecha, Observacion)
    VALUES (@Id_Actividad, @Id_Ministerio, @Fecha, @Observacion);
END;

GO

/* ===========================
   CRUD: Actividad_Usuario
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearActividadUsuario]
    @Id_Actividad INT,
    @Id_Usuario INT,
    @Fecha DATE,
    @Hora TIME(7)
AS
BEGIN
    INSERT INTO Actividad_Usuario (Id_Actividad, Id_Usuario, Fecha, Hora)
    VALUES (@Id_Actividad, @Id_Usuario, @Fecha, @Hora);
END;

GO

/* ===========================
   CRUD: Citas
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearCita]
    @Fecha_Cita DATE,
    @Id_Usuario_Cita INT,
    @Id_Usuario_Encargado INT,
    @Observacion_Inicial VARCHAR(200),
    @Detalle_Cita VARCHAR(500)
AS
BEGIN
    INSERT INTO Citas (Fecha_Cita, Id_Usuario_Cita, Id_Usuario_Encargado, Observacion_Inicial, Detalle_Cita)
    VALUES (@Fecha_Cita, @Id_Usuario_Cita, @Id_Usuario_Encargado, @Observacion_Inicial, @Detalle_Cita);
END;

GO

/* Marcar una cita como atendida */
CREATE   PROCEDURE [dbo].[spAtenderCita]
    @Id_Cita INT,
    @Detalle_Cita VARCHAR(500)
AS
BEGIN
    UPDATE Citas
    SET Estado = 'Atendida',
        Detalle_Cita = @Detalle_Cita
    WHERE Id_Cita = @Id_Cita;
END;

GO

/* ===========================
   CRUD: Ministerio
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearMinisterio]
    @Descripcion_Ministerio VARCHAR(100),
    @Observaciones_Ministerio VARCHAR(200)
AS
BEGIN
    INSERT INTO Ministerio (Descripcion_Ministerio, Observaciones_Ministerio)
    VALUES (@Descripcion_Ministerio, @Observaciones_Ministerio);
END;

GO

/* ===========================
   CRUD: Rol
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearRol]
    @Descripcion VARCHAR(20)
AS
BEGIN
    INSERT INTO Rol (Descripcion) VALUES (@Descripcion);
END;

GO

/* ===========================
   CRUD: Tipo_Actividad
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearTipoActividad]
    @Nombre_Tipo VARCHAR(50)
AS
BEGIN
    INSERT INTO Tipo_Actividad (Nombre_Tipo) VALUES (@Nombre_Tipo);
END;

GO

/* ===========================
   CRUD: Usuario
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearUsuario]
    @Identificacion VARCHAR(20),
    @Nombre VARCHAR(100),
    @Correo VARCHAR(100),
    @Contrasena VARCHAR(255),
    @Estado CHAR(1),
    @Id_Rol INT
AS
BEGIN
    INSERT INTO Usuario (Identificacion, Nombre, Correo, Contrasena, Estado, Id_Rol)
    VALUES (@Identificacion, @Nombre, @Correo, @Contrasena, @Estado, @Id_Rol);
END;

GO

/* ===========================
   CRUD: Usuarios_Ministerio
   =========================== */
CREATE   PROCEDURE [dbo].[spCrearUsuarioMinisterio]
    @Id_Ministerio INT,
    @Id_Usuario INT,
    @Fecha_Ingreso DATE,
    @Fecha_Salida DATE,
    @Estado VARCHAR(20),
    @Observacion VARCHAR(200)
AS
BEGIN
    INSERT INTO Usuarios_Ministerio (Id_Ministerio, Id_Usuario, Fecha_Ingreso, Fecha_Salida, Estado, Observacion)
    VALUES (@Id_Ministerio, @Id_Usuario, @Fecha_Ingreso, @Fecha_Salida, @Estado, @Observacion);
END;

GO

CREATE   PROCEDURE [dbo].[spDesactivarUsuario]
    @Id_Usuario INT
AS
BEGIN
    UPDATE Usuario
    SET Estado = 'I'
    WHERE Id_Usuario = @Id_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarActividad]
    @Id_Actividad INT
AS
BEGIN
    DELETE FROM Actividad WHERE Id_Actividad = @Id_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarActividadesMinisterio]
    @Id_Minis_Actividad INT
AS
BEGIN
    DELETE FROM Actividades_Ministerio WHERE Id_Minis_Actividad = @Id_Minis_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarActividadUsuario]
    @Id_Actividad_Usuario INT
AS
BEGIN
    DELETE FROM Actividad_Usuario WHERE Id_Actividad_Usuario = @Id_Actividad_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarCita]
    @Id_Cita INT
AS
BEGIN
    DELETE FROM Citas WHERE Id_Cita = @Id_Cita;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarMinisterio]
    @Id_Ministerio INT
AS
BEGIN
    DELETE FROM Ministerio WHERE Id_Ministerio = @Id_Ministerio;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarMinisterioPorActividad]
    @Id_Actividad INT
AS
BEGIN
    DELETE FROM Actividades_Ministerio
    WHERE Id_Actividad = @Id_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarRol]
    @Id_Rol INT
AS
BEGIN
    DELETE FROM Rol WHERE Id_Rol = @Id_Rol;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarTipoActividad]
    @Id_Tipo_Actividad INT
AS
BEGIN
    DELETE FROM Tipo_Actividad WHERE Id_Tipo_Actividad = @Id_Tipo_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarUsuario]
    @Id_Usuario INT
AS
BEGIN
    DELETE FROM Usuario WHERE Id_Usuario = @Id_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spEliminarUsuarioMinisterio]
    @Id_Usuario_Ministerio INT
AS
BEGIN
    DELETE FROM Usuarios_Ministerio WHERE Id_Usuario_Ministerio = @Id_Usuario_Ministerio;
END;

GO

CREATE   PROCEDURE [dbo].[spGuardarMinisterioActividad]
    @Id_Actividad INT,
    @Id_Ministerio INT,
    @Observacion VARCHAR(200)
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Actividades_Ministerio 
        WHERE Id_Actividad = @Id_Actividad
    )
    BEGIN
        UPDATE Actividades_Ministerio
        SET Id_Ministerio = @Id_Ministerio,
            Fecha = GETDATE(),
            Observacion = @Observacion
        WHERE Id_Actividad = @Id_Actividad;
    END
    ELSE
    BEGIN
        INSERT INTO Actividades_Ministerio 
        (
            Id_Actividad, 
            Id_Ministerio, 
            Fecha, 
            Observacion
        )
        VALUES 
        (
            @Id_Actividad, 
            @Id_Ministerio, 
            GETDATE(), 
            @Observacion
        );
    END
END;

GO
CREATE   PROCEDURE [dbo].[spIniciarSesionUsuario]
    @Correo varchar(100),
    @Contrasena varchar(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Id_Usuario,
        Identificacion,
        Nombre,
        Correo,
        Estado,
        Id_Rol,
        UsaContrasenaTemp
    FROM dbo.Usuario
    WHERE Correo = @Correo
      AND Contrasena = @Contrasena
      AND Estado = 'A';
END

GO

CREATE   PROCEDURE [dbo].[spListarActividades]
AS
BEGIN
    SELECT 
        A.Id_Actividad,
        A.Nombre_Actividad,
        A.Fecha_Ini,
        A.Fecha_Fin,
        A.Lugar,
        CONVERT(VARCHAR(5), A.Hora_Ini, 108) AS Hora_Ini,
        CONVERT(VARCHAR(5), A.Hora_Fin, 108) AS Hora_Fin,
        A.Id_Tipo_Actividad,
        T.Nombre_Tipo,
        AM.Id_Ministerio,
        M.Descripcion_Ministerio,
        AM.Observacion AS Observacion_Ministerio_Actividad
    FROM Actividad A
    INNER JOIN Tipo_Actividad T 
        ON A.Id_Tipo_Actividad = T.Id_Tipo_Actividad
    LEFT JOIN Actividades_Ministerio AM
        ON A.Id_Actividad = AM.Id_Actividad
    LEFT JOIN Ministerio M
        ON AM.Id_Ministerio = M.Id_Ministerio
    ORDER BY A.Fecha_Ini DESC;
END;

GO
CREATE   PROCEDURE [dbo].[spListarMinisterios]
AS
BEGIN
    SELECT 
        Id_Ministerio,
        Descripcion_Ministerio,
        Observaciones_Ministerio
    FROM Ministerio
    ORDER BY Descripcion_Ministerio;
END;

GO

CREATE   PROCEDURE [dbo].[spListarRoles]
AS
BEGIN
    SELECT 
        Id_Rol,
        Descripcion
    FROM Rol
    ORDER BY Id_Rol;
END;

GO

CREATE   PROCEDURE [dbo].[spListarTiposActividad]
AS
BEGIN
    SELECT 
        Id_Tipo_Actividad,
        Nombre_Tipo
    FROM Tipo_Actividad
    ORDER BY Nombre_Tipo;
END;

GO

CREATE   PROCEDURE [dbo].[spListarUsuarios]
AS
BEGIN
    SELECT 
        U.Id_Usuario,
        U.Identificacion,
        U.Nombre,
        U.Correo,
        U.Estado,
        U.Id_Rol,
        R.Descripcion AS Rol
    FROM Usuario U
    INNER JOIN Rol R ON U.Id_Rol = R.Id_Rol
    ORDER BY U.Nombre;
END;

GO
CREATE   PROCEDURE [dbo].[spObtenerActividad]
    @Id_Actividad INT
AS
BEGIN
    SELECT 
        A.Id_Actividad,
        A.Nombre_Actividad,
        A.Fecha_Ini,
        A.Fecha_Fin,
        A.Lugar,
        CONVERT(VARCHAR(5), A.Hora_Ini, 108) AS Hora_Ini,
        CONVERT(VARCHAR(5), A.Hora_Fin, 108) AS Hora_Fin,
        A.Id_Tipo_Actividad,
        AM.Id_Ministerio,
        M.Descripcion_Ministerio,
        AM.Observacion AS Observacion_Ministerio_Actividad
    FROM Actividad A
    LEFT JOIN Actividades_Ministerio AM
        ON A.Id_Actividad = AM.Id_Actividad
    LEFT JOIN Ministerio M
        ON AM.Id_Ministerio = M.Id_Ministerio
    WHERE A.Id_Actividad = @Id_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerActividadesMinisterio]
    @Id_Minis_Actividad INT
AS
BEGIN
    SELECT * FROM Actividades_Ministerio WHERE Id_Minis_Actividad = @Id_Minis_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerActividadUsuario]
    @Id_Actividad_Usuario INT
AS
BEGIN
    SELECT * FROM Actividad_Usuario WHERE Id_Actividad_Usuario = @Id_Actividad_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerCita]
    @Id_Cita INT
AS
BEGIN
    SELECT * FROM Citas WHERE Id_Cita = @Id_Cita;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerMinisterio]
    @Id_Ministerio INT
AS
BEGIN
    SELECT * FROM Ministerio WHERE Id_Ministerio = @Id_Ministerio;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerRol]
    @Id_Rol INT
AS
BEGIN
    SELECT * FROM Rol WHERE Id_Rol = @Id_Rol;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerTipoActividad]
    @Id_Tipo_Actividad INT
AS
BEGIN
    SELECT * FROM Tipo_Actividad WHERE Id_Tipo_Actividad = @Id_Tipo_Actividad;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerUsuario]
    @Id_Usuario INT
AS
BEGIN
    SELECT * FROM Usuario WHERE Id_Usuario = @Id_Usuario;
END;

GO

CREATE   PROCEDURE [dbo].[spObtenerUsuarioMinisterio]
    @Id_Usuario_Ministerio INT
AS
BEGIN
    SELECT * FROM Usuarios_Ministerio WHERE Id_Usuario_Ministerio = @Id_Usuario_Ministerio;
END;

GO

CREATE   PROCEDURE [dbo].[spRegistrarError]
	@Mensaje varchar(MAX),
	@Lugar varchar(50),
	@FechaHora datetime,
	@Id_Usuario int
AS
BEGIN
	INSERT INTO dbo.Error(Mensaje, Lugar, FechaHora, Id_Usuario)
	VALUES (@Mensaje,@Lugar,@FechaHora, @Id_Usuario)
END


GO

CREATE   PROCEDURE [dbo].[spRegistrarUsuario]
    @Identificacion VARCHAR(20),
    @Nombre         VARCHAR(100),
    @Correo         VARCHAR(100),
    @Contrasena     VARCHAR(255)
AS
BEGIN
    SET NOCOUNT OFF;

    DECLARE @Id_Rol_Usuario INT;
    DECLARE @ContrasenaNOTemp BIT = 0;

    SELECT @Id_Rol_Usuario = Id_Rol
    FROM dbo.Rol
    WHERE Descripcion = 'Usuario';

    IF @Id_Rol_Usuario IS NULL
    BEGIN
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.Usuario WHERE Identificacion = @Identificacion)
    BEGIN
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.Usuario WHERE Correo = @Correo)
    BEGIN
        RETURN;
    END

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
    (
        @Identificacion,
        @Nombre,
        @Correo,
        @Contrasena,
        'A',
        @Id_Rol_Usuario,
        @ContrasenaNOTemp
    );
END


GO

CREATE   PROCEDURE [dbo].[spValidarCorreo]
    @Correo varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id_Usuario,Identificacion,Nombre,Correo,Estado
    FROM dbo.Usuario
    WHERE Correo = @Correo
      AND Estado = 'A';
END
GO
USE [master]
GO
ALTER DATABASE [ministerio_gosen] SET  READ_WRITE 
GO



---------------usuario de un Ministerio-----------------
USE ministerio_gosen;
GO
CREATE OR ALTER PROCEDURE spListarUsuariosPorMinisterio
    @Id_Ministerio INT
AS
BEGIN
    SELECT 
        UM.Id_Usuario_Ministerio,
        UM.Id_Ministerio,
        UM.Id_Usuario,
        UM.Fecha_Ingreso,
        UM.Fecha_Salida,
        UM.Estado,
        UM.Observacion,
        U.Nombre,
        U.Correo,
        R.Descripcion AS Rol
    FROM Usuarios_Ministerio UM
    INNER JOIN Usuario U ON UM.Id_Usuario = U.Id_Usuario
    INNER JOIN Rol R ON U.Id_Rol = R.Id_Rol
    WHERE UM.Id_Ministerio = @Id_Ministerio
      AND UM.Fecha_Salida IS NULL
    ORDER BY U.Nombre;
END;
GO
---------listar usuarios disponibles para un ministerio )que no sean admin---------------------

CREATE OR ALTER PROCEDURE spListarUsuariosDisponiblesMinisterio
    @Id_Ministerio INT
AS
BEGIN
    SELECT 
        U.Id_Usuario,
        U.Identificacion,
        U.Nombre,
        U.Correo,
        U.Estado,
        U.Id_Rol,
        R.Descripcion AS Rol
    FROM Usuario U
    INNER JOIN Rol R ON U.Id_Rol = R.Id_Rol
    WHERE U.Id_Rol <> 1
      AND U.Estado = 'A'
      AND NOT EXISTS (
          SELECT 1
          FROM Usuarios_Ministerio UM
          WHERE UM.Id_Usuario = U.Id_Usuario
            AND UM.Id_Ministerio = @Id_Ministerio
            AND UM.Fecha_Salida IS NULL
      )
    ORDER BY U.Nombre;
END;
GO

------listar ministerios de un usuario-------------

CREATE OR ALTER PROCEDURE spListarMinisteriosPorUsuario
    @Id_Usuario INT
AS
BEGIN
    SELECT 
        UM.Id_Usuario_Ministerio,
        UM.Id_Ministerio,
        UM.Id_Usuario,
        UM.Fecha_Ingreso,
        UM.Fecha_Salida,
        UM.Estado,
        UM.Observacion,
        M.Descripcion_Ministerio
    FROM Usuarios_Ministerio UM
    INNER JOIN Ministerio M ON UM.Id_Ministerio = M.Id_Ministerio
    WHERE UM.Id_Usuario = @Id_Usuario
      AND UM.Fecha_Salida IS NULL
    ORDER BY M.Descripcion_Ministerio;
END;
GO

----------listar ministerios disponibles para los usuarios-----

CREATE OR ALTER PROCEDURE spListarMinisteriosDisponiblesUsuario
    @Id_Usuario INT
AS
BEGIN
    SELECT 
        M.Id_Ministerio,
        M.Descripcion_Ministerio,
        M.Observaciones_Ministerio
    FROM Ministerio M
    WHERE NOT EXISTS (
        SELECT 1
        FROM Usuarios_Ministerio UM
        WHERE UM.Id_Ministerio = M.Id_Ministerio
          AND UM.Id_Usuario = @Id_Usuario
          AND UM.Fecha_Salida IS NULL
    )
    ORDER BY M.Descripcion_Ministerio;
END;
GO

-- alter de crear usuario ministerio----------------

CREATE OR ALTER PROCEDURE spCrearUsuarioMinisterio
    @Id_Ministerio INT,
    @Id_Usuario INT,
    @Fecha_Ingreso DATE,
    @Estado VARCHAR(20),
    @Observacion VARCHAR(200)
AS
BEGIN
    INSERT INTO Usuarios_Ministerio 
    (
        Id_Ministerio, 
        Id_Usuario, 
        Fecha_Ingreso, 
        Fecha_Salida, 
        Estado, 
        Observacion
    )
    VALUES 
    (
        @Id_Ministerio, 
        @Id_Usuario, 
        @Fecha_Ingreso, 
        NULL, 
        @Estado, 
        @Observacion
    );
END;
GO
------salida de un usuario de su ministerio fecha de salida---------------

CREATE OR ALTER PROCEDURE spSalirUsuarioMinisterio
    @Id_Usuario_Ministerio INT
AS
BEGIN
    UPDATE Usuarios_Ministerio
    SET Fecha_Salida = GETDATE(),
        Estado = 'Inactivo'
    WHERE Id_Usuario_Ministerio = @Id_Usuario_Ministerio;
END;
GO
-------reportes------------------------------------------

CREATE OR ALTER PROCEDURE spReportePersonasMinisterio
    @Buscar VARCHAR(100) = NULL,
    @Id_Ministerio INT = NULL,
    @Estado VARCHAR(20) = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SELECT 
        UM.Id_Usuario_Ministerio,
        UM.Id_Ministerio,
        UM.Id_Usuario,
        UM.Fecha_Ingreso,
        UM.Fecha_Salida,
        UM.Estado,
        UM.Observacion,

        U.Nombre,
        U.Correo,
        R.Descripcion AS Rol,

        M.Descripcion_Ministerio
    FROM Usuarios_Ministerio UM
    INNER JOIN Usuario U 
        ON UM.Id_Usuario = U.Id_Usuario
    INNER JOIN Ministerio M 
        ON UM.Id_Ministerio = M.Id_Ministerio
    INNER JOIN Rol R 
        ON U.Id_Rol = R.Id_Rol
    WHERE 
        (
            @Buscar IS NULL 
            OR @Buscar = ''
            OR U.Nombre LIKE '%' + @Buscar + '%'
            OR U.Correo LIKE '%' + @Buscar + '%'
            OR M.Descripcion_Ministerio LIKE '%' + @Buscar + '%'
        )
        AND (
            @Id_Ministerio IS NULL 
            OR UM.Id_Ministerio = @Id_Ministerio
        )
        AND (
            @Estado IS NULL 
            OR @Estado = ''
            OR UM.Estado = @Estado
        )
        AND (
            @FechaInicio IS NULL 
            OR UM.Fecha_Ingreso >= @FechaInicio
        )
        AND (
            @FechaFin IS NULL 
            OR UM.Fecha_Ingreso <= @FechaFin
        )
    ORDER BY M.Descripcion_Ministerio, U.Nombre;
END;
GO




--------------------------------------------------------
----reporte de actividades--------------------

CREATE OR ALTER PROCEDURE spReporteActividades
    @Buscar VARCHAR(100) = NULL,
    @Id_Ministerio INT = NULL,
    @Id_Tipo_Actividad INT = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SELECT
        A.Id_Actividad,
        A.Nombre_Actividad,
        A.Fecha_Ini,
        A.Fecha_Fin,
        A.Lugar,

        CASE 
            WHEN A.Hora_Ini IS NULL THEN NULL
            ELSE DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', A.Hora_Ini), CAST(CAST(A.Fecha_Ini AS DATE) AS DATETIME))
        END AS Hora_Ini,

        CASE 
            WHEN A.Hora_Fin IS NULL THEN NULL
            ELSE DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', A.Hora_Fin), CAST(CAST(ISNULL(A.Fecha_Fin, A.Fecha_Ini) AS DATE) AS DATETIME))
        END AS Hora_Fin,

        A.Id_Tipo_Actividad,
        TA.Nombre_Tipo,

        AM.Id_Ministerio,
        M.Descripcion_Ministerio,
        AM.Observacion AS Observacion_Ministerio_Actividad
    FROM Actividad A
    INNER JOIN Tipo_Actividad TA
        ON A.Id_Tipo_Actividad = TA.Id_Tipo_Actividad
    LEFT JOIN Actividades_Ministerio AM
        ON A.Id_Actividad = AM.Id_Actividad
    LEFT JOIN Ministerio M
        ON AM.Id_Ministerio = M.Id_Ministerio
    WHERE
        (
            @Buscar IS NULL
            OR @Buscar = ''
            OR A.Nombre_Actividad LIKE '%' + @Buscar + '%'
            OR A.Lugar LIKE '%' + @Buscar + '%'
            OR M.Descripcion_Ministerio LIKE '%' + @Buscar + '%'
            OR TA.Nombre_Tipo LIKE '%' + @Buscar + '%'
        )
        AND (
            @Id_Ministerio IS NULL
            OR AM.Id_Ministerio = @Id_Ministerio
        )
        AND (
            @Id_Tipo_Actividad IS NULL
            OR A.Id_Tipo_Actividad = @Id_Tipo_Actividad
        )
        AND (
            @FechaInicio IS NULL
            OR CAST(A.Fecha_Ini AS DATE) >= @FechaInicio
        )
        AND (
            @FechaFin IS NULL
            OR CAST(A.Fecha_Ini AS DATE) <= @FechaFin
        )
    ORDER BY A.Fecha_Ini, A.Hora_Ini;
END;
GO

----reporte de horario-----------------------

CREATE OR ALTER PROCEDURE spReporteHorarios
    @Buscar VARCHAR(100) = NULL,
    @Id_Ministerio INT = NULL,
    @Id_Tipo_Actividad INT = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SELECT
        A.Id_Actividad,
        A.Nombre_Actividad,
        A.Fecha_Ini,
        A.Fecha_Fin,
        A.Lugar,

        CASE 
            WHEN A.Hora_Ini IS NULL THEN NULL
            ELSE DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', A.Hora_Ini), CAST(CAST(A.Fecha_Ini AS DATE) AS DATETIME))
        END AS Hora_Ini,

        CASE 
            WHEN A.Hora_Fin IS NULL THEN NULL
            ELSE DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', A.Hora_Fin), CAST(CAST(ISNULL(A.Fecha_Fin, A.Fecha_Ini) AS DATE) AS DATETIME))
        END AS Hora_Fin,

        A.Id_Tipo_Actividad,
        TA.Nombre_Tipo,

        AM.Id_Ministerio,
        M.Descripcion_Ministerio,
        AM.Observacion AS Observacion_Ministerio_Actividad
    FROM Actividad A
    INNER JOIN Tipo_Actividad TA
        ON A.Id_Tipo_Actividad = TA.Id_Tipo_Actividad
    LEFT JOIN Actividades_Ministerio AM
        ON A.Id_Actividad = AM.Id_Actividad
    LEFT JOIN Ministerio M
        ON AM.Id_Ministerio = M.Id_Ministerio
    WHERE
        (
            @Buscar IS NULL
            OR @Buscar = ''
            OR A.Nombre_Actividad LIKE '%' + @Buscar + '%'
            OR A.Lugar LIKE '%' + @Buscar + '%'
            OR M.Descripcion_Ministerio LIKE '%' + @Buscar + '%'
            OR TA.Nombre_Tipo LIKE '%' + @Buscar + '%'
        )
        AND (
            @Id_Ministerio IS NULL
            OR AM.Id_Ministerio = @Id_Ministerio
        )
        AND (
            @Id_Tipo_Actividad IS NULL
            OR A.Id_Tipo_Actividad = @Id_Tipo_Actividad
        )
        AND (
            @FechaInicio IS NULL
            OR CAST(A.Fecha_Ini AS DATE) >= @FechaInicio
        )
        AND (
            @FechaFin IS NULL
            OR CAST(A.Fecha_Ini AS DATE) <= @FechaFin
        )
    ORDER BY A.Fecha_Ini, A.Hora_Ini;
END;
GO

------------------ ACTUALIZAR PERFIL---------------------------

CREATE PROCEDURE [dbo].[spActualizarPerfil]
    @Id_Usuario INT,
    @Identificacion VARCHAR(20),
    @Nombre VARCHAR(100),
    @Correo VARCHAR(100)
AS
BEGIN
    UPDATE Usuario
    SET Nombre = @Nombre,
        Identificacion = @Identificacion,
        Correo = @Correo 
    WHERE Id_Usuario = @Id_Usuario;
END;
GO


  -------- INSERTS-----------------------------------

  /* =========================
   TIPOS DE ACTIVIDAD
   ========================= */

INSERT INTO Tipo_Actividad (Nombre_Tipo)
VALUES ('Culto');

INSERT INTO Tipo_Actividad (Nombre_Tipo)
VALUES ('Reuni n');

/* =========================
   MINISTERIOS
   ========================= */

INSERT INTO Ministerio
(
    Descripcion_Ministerio,
    Observaciones_Ministerio
)
VALUES
(
    'Ministerio de J venes',
    'Ministerio encargado de actividades juveniles'
);

INSERT INTO Ministerio
(
    Descripcion_Ministerio,
    Observaciones_Ministerio
)
VALUES
(
    'Ministerio de M sica',
    'Ministerio encargado de la alabanza y m sica'
);


/* =========================
   ACTIVIDADES
   ========================= */

INSERT INTO Actividad
(
    Nombre_Actividad,
    Fecha_Ini,
    Fecha_Fin,
    Lugar,
    Hora_Ini,
    Hora_Fin,
    Id_Tipo_Actividad
)
VALUES
(
    'Culto Juvenil',
    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    DATEADD(DAY, 11, CAST(GETDATE() AS DATE)),
    'Sal n principal',
    '18:00',
    '20:00',
    (SELECT Id_Tipo_Actividad
     FROM Tipo_Actividad
     WHERE Nombre_Tipo = 'Culto')
);

INSERT INTO Actividad
(
    Nombre_Actividad,
    Fecha_Ini,
    Fecha_Fin,
    Lugar,
    Hora_Ini,
    Hora_Fin,
    Id_Tipo_Actividad
)
VALUES
(
    'Reuni n de J venes',
    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    DATEADD(DAY, 11, CAST(GETDATE() AS DATE)),
    'Aula 1',
    '16:00',
    '18:00',
    (SELECT Id_Tipo_Actividad
     FROM Tipo_Actividad
     WHERE Nombre_Tipo = 'Reuni n')
);

INSERT INTO Actividad
(
    Nombre_Actividad,
    Fecha_Ini,
    Fecha_Fin,
    Lugar,
    Hora_Ini,
    Hora_Fin,
    Id_Tipo_Actividad
)
VALUES
(
    'Culto de Alabanza',
    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    DATEADD(DAY, 11, CAST(GETDATE() AS DATE)),
    'Templo principal',
    '09:00',
    '11:00',
    (SELECT Id_Tipo_Actividad
     FROM Tipo_Actividad
     WHERE Nombre_Tipo = 'Culto')
);

INSERT INTO Actividad
(
    Nombre_Actividad,
    Fecha_Ini,
    Fecha_Fin,
    Lugar,
    Hora_Ini,
    Hora_Fin,
    Id_Tipo_Actividad
)
VALUES
(
    'Ensayo Musical',
    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    DATEADD(DAY, 11, CAST(GETDATE() AS DATE)),
    'Sal n de m sica',
    '19:00',
    '21:00',
    (SELECT Id_Tipo_Actividad
     FROM Tipo_Actividad
     WHERE Nombre_Tipo = 'Reuni n')
);


/* =========================
   ASIGNAR ACTIVIDADES
   A LOS MINISTERIOS
   ========================= */

INSERT INTO Actividades_Ministerio
(
    Id_Actividad,
    Id_Ministerio,
    Fecha,
    Observacion
)
VALUES
(
    (SELECT Id_Actividad
     FROM Actividad
     WHERE Nombre_Actividad = 'Culto Juvenil'),

    (SELECT Id_Ministerio
     FROM Ministerio
     WHERE Descripcion_Ministerio = 'Ministerio de J venes'),

    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    'Actividad del Ministerio de J venes'
);

INSERT INTO Actividades_Ministerio
(
    Id_Actividad,
    Id_Ministerio,
    Fecha,
    Observacion
)
VALUES
(
    (SELECT Id_Actividad
     FROM Actividad
     WHERE Nombre_Actividad = 'Reuni n de J venes'),

    (SELECT Id_Ministerio
     FROM Ministerio
     WHERE Descripcion_Ministerio = 'Ministerio de J venes'),

    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    'Reuni n de planificaci n juvenil'
);

INSERT INTO Actividades_Ministerio
(
    Id_Actividad,
    Id_Ministerio,
    Fecha,
    Observacion
)
VALUES
(
    (SELECT Id_Actividad
     FROM Actividad
     WHERE Nombre_Actividad = 'Culto de Alabanza'),

    (SELECT Id_Ministerio
     FROM Ministerio
     WHERE Descripcion_Ministerio = 'Ministerio de M sica'),

    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    'Actividad del Ministerio de M sica'
);

INSERT INTO Actividades_Ministerio
(
    Id_Actividad,
    Id_Ministerio,
    Fecha,
    Observacion
)
VALUES
(
    (SELECT Id_Actividad
     FROM Actividad
     WHERE Nombre_Actividad = 'Ensayo Musical'),

    (SELECT Id_Ministerio
     FROM Ministerio
     WHERE Descripcion_Ministerio = 'Ministerio de M sica'),

    DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    'Ensayo general del equipo de m sica'
);

GO


/*SP PARA LISTAR CITAS*/
CREATE OR ALTER PROCEDURE [dbo].[spListarCitas]
AS
BEGIN
    SELECT 
        C.Id_Cita,
        C.Fecha_Cita,
        C.Id_Usuario_Cita,
        UC.Nombre AS Nombre_Usuario_Cita,
        C.Id_Usuario_Encargado,
        UE.Nombre AS Nombre_Usuario_Encargado,
        C.Observacion_Inicial,
        C.Detalle_Cita,
        C.Estado
    FROM Citas C
    INNER JOIN Usuario UC ON C.Id_Usuario_Cita = UC.Id_Usuario
    INNER JOIN Usuario UE ON C.Id_Usuario_Encargado = UE.Id_Usuario
    ORDER BY C.Fecha_Cita DESC;
END;
GO

/*APARTADO CHAT BOT*/

CREATE TABLE Chat_Bot_Opciones
(
	Id_Opcion int IDENTITY(1,1) PRIMARY KEY,
	Texto_Opcion nvarchar (200) NOT NULL,
	Respuesta varchar (200),
	Id_Opcion_Padre int,
	Orden int NOT NULL DEFAULT 1,
	Activo bit NOT NULL DEFAULT 1,
	Constraint FK_Opcion_Padre Foreign Key (Id_Opcion_Padre) REFERENCES Chat_Bot_Opciones (Id_Opcion)
);
GO


CREATE OR ALTER PROCEDURE SP_ConsultarChatbot
    @Id_Opcion INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id_Opcion,
        Texto_Opcion,
        Respuesta,
        Id_Opcion_Padre,
        Orden,
        Activo
    FROM Chat_Bot_Opciones
    WHERE Id_Opcion = @Id_Opcion
      AND Activo = 1;

    SELECT
        Id_Opcion,
        Texto_Opcion,
        Respuesta,
        Id_Opcion_Padre,
        Orden,
        Activo
    FROM Chat_Bot_Opciones
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
        Padre.Id_Opcion,
        Padre.Texto_Opcion,
        Padre.Respuesta,
        Padre.Id_Opcion_Padre,
        Padre.Orden,
        Padre.Activo
    FROM Chat_Bot_Opciones AS Hijo
    INNER JOIN Chat_Bot_Opciones AS Padre
        ON Padre.Id_Opcion = Hijo.Id_Opcion_Padre
    WHERE Hijo.Id_Opcion = @Id_Opcion
      AND Padre.Activo = 1;
END;
GO