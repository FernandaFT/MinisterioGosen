# MinisterioGosen
<div align="center">

# ⛪ Ministerio Gosen

**Plataforma web para la administración de ministerios, actividades, citas, usuarios, reportes y asistencia pastoral.**

![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![ASP.NET Core](https://img.shields.io/badge/ASP.NET%20Core-MVC%20%2B%20Web%20API-5C2D91?style=for-the-badge&logo=dotnet&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Base%20de%20datos-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Dapper](https://img.shields.io/badge/Dapper-Micro%20ORM-0A66C2?style=for-the-badge)
![Bootstrap](https://img.shields.io/badge/Bootstrap-UI-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)
![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-success?style=for-the-badge)

</div>

---

## 📌 Descripción

**Ministerio Gosen** es una solución desarrollada con **ASP.NET Core MVC** y **ASP.NET Core Web API** para apoyar la gestión operativa de una iglesia o comunidad ministerial. El sistema centraliza procesos como registro e inicio de sesión de usuarios, administración de ministerios, planificación de actividades, gestión de citas, asignación de personas a ministerios, reportes y consultas mediante chatbot.

El repositorio está organizado en una solución con dos proyectos principales:

| Proyecto | Descripción |
| --- | --- |
| `MinisterioGosen` | Aplicación web MVC con vistas Razor, estilos, scripts y consumo de la API. |
| `MinisterioGosenAPI` | API REST que expone endpoints para usuarios, ministerios, actividades, citas, reportes, dashboard y chatbot. |

---

## ✨ Funcionalidades principales

### 🔐 Autenticación y acceso

- Inicio de sesión de usuarios.
- Registro de nuevos usuarios.
- Recuperación de acceso por correo electrónico.
- Cierre de sesión.
- Página principal posterior al inicio de sesión.
- Manejo de errores y páginas de estado HTTP.

### 👥 Gestión de usuarios

- Listado de usuarios registrados.
- Creación de usuarios desde el panel administrativo.
- Edición de datos de usuario.
- Activación y desactivación de usuarios.
- Cambio de contraseña.
- Actualización de perfil personal.
- Administración de roles.

### 🙌 Gestión de ministerios

- Listado de ministerios.
- Creación de ministerios.
- Edición de ministerios existentes.
- Eliminación de ministerios.
- Consulta de información individual por ministerio.

### 🧑‍🤝‍🧑 Asignación de personas a ministerios

- Asignar usuarios a un ministerio.
- Registrar ministerios desde la vista de usuario.
- Consultar usuarios vinculados a un ministerio.
- Consultar ministerios vinculados a un usuario.
- Ver usuarios disponibles para agregarse a un ministerio.
- Ver ministerios disponibles para asignarse a un usuario.
- Retirar usuarios de un ministerio.

### 📅 Gestión de actividades

- Listado de actividades.
- Creación de actividades con fecha, hora, lugar y tipo de actividad.
- Edición de actividades.
- Eliminación de actividades.
- Consulta pública o interna de actividades.
- Vista de horarios.
- Asociación opcional de actividades con ministerios.

### 🏷️ Tipos de actividad

- Listado de tipos de actividad.
- Creación de nuevos tipos.
- Edición de tipos existentes.
- Eliminación de tipos de actividad.
- Uso de tipos para clasificar actividades.

### 🗓️ Gestión de citas

- Listado de citas.
- Creación de citas.
- Edición de citas.
- Atención o confirmación de citas.
- Eliminación de citas desde la API.
- Seguimiento del estado de atención.

### 📊 Dashboard

- Consulta de indicadores generales del sistema.
- Vista centralizada para resumir información relevante.
- Integración con API mediante el endpoint de dashboard.

### 📈 Reportes

- Reporte de actividades.
- Reporte de horarios.
- Reporte de personas por ministerio.
- Filtros mediante modelos especializados para consultas y generación de resultados.

### 🤖 Chatbot

- Módulo de chatbot integrado en la aplicación web.
- Consulta de opciones o respuestas desde la API.
- Script flotante para experiencia de asistencia dentro del sitio.

### 🧾 Manejo de errores

- Middleware para capturar excepciones en la aplicación MVC.
- Endpoint API para registrar errores.
- Páginas de error personalizadas para códigos de estado HTTP.

### 📬 Envío de correos

- Servicio utilitario para envío de correos.
- Plantilla HTML para recuperación de acceso.
- Configuración para cuenta de Gmail y contraseña de aplicación.

---

## 🧱 Arquitectura del proyecto

```text
MinisterioGosen/
├── Database/
│   ├── DB_Ministerio_Gosen.sql
│   └── Seeding Ministerio Gosen.sql
├── MinisterioGosen/
│   ├── Controllers/
│   ├── Models/
│   ├── Views/
│   ├── wwwroot/
│   ├── Program.cs
│   └── appsettings.json
├── MinisterioGosenAPI/
│   ├── Controllers/
│   ├── Models/
│   ├── Services/
│   ├── Templates/
│   ├── Program.cs
│   └── appsettings.json
└── MinisterioGosen.slnx
```

---

## 🛠️ Tecnologías utilizadas

- **C#**
- **.NET 10.0**
- **ASP.NET Core MVC**
- **ASP.NET Core Web API**
- **Razor Views**
- **SQL Server / LocalDB**
- **Dapper**
- **Microsoft.Data.SqlClient**
- **MailKit**
- **Bootstrap**
- **jQuery**
- **OpenAPI**

---

## 🔌 Endpoints principales de la API

La API usa la ruta base configurada como:

```text
https://localhost:7013/api/
```

### Usuarios y autenticación

| Método | Endpoint | Descripción |
| --- | --- | --- |
| `POST` | `/api/Home/RegistrarAPI` | Registrar usuario. |
| `POST` | `/api/Home/IniciarSesionAPI` | Iniciar sesión. |
| `POST` | `/api/Home/RecuperarAccesoAPI` | Recuperar acceso. |
| `GET` | `/api/Usuario/ListarUsuariosAPI` | Listar usuarios. |
| `GET` | `/api/Usuario/ObtenerUsuarioAPI` | Obtener usuario por identificador. |
| `POST` | `/api/Usuario/CrearUsuarioAPI` | Crear usuario. |
| `PUT` | `/api/Usuario/ActualizarUsuarioAPI` | Actualizar usuario. |
| `PUT` | `/api/Usuario/DesactivarUsuarioAPI` | Desactivar usuario. |
| `PUT` | `/api/Usuario/ActivarUsuarioAPI` | Activar usuario. |
| `PUT` | `/api/Usuario/CambiarContrasenaAPI` | Cambiar contraseña. |
| `PUT` | `/api/Usuario/CambiarPerfilAPI` | Cambiar perfil. |
| `GET` | `/api/Usuario/ListarRolesAPI` | Listar roles. |

### Ministerios

| Método | Endpoint | Descripción |
| --- | --- | --- |
| `GET` | `/api/Ministerio/ListarMinisteriosAPI` | Listar ministerios. |
| `GET` | `/api/Ministerio/ObtenerMinisterioAPI` | Obtener ministerio. |
| `POST` | `/api/Ministerio/CrearMinisterioAPI` | Crear ministerio. |
| `PUT` | `/api/Ministerio/ActualizarMinisterioAPI` | Actualizar ministerio. |
| `DELETE` | `/api/Ministerio/EliminarMinisterioAPI` | Eliminar ministerio. |

### Actividades y tipos

| Método | Endpoint | Descripción |
| --- | --- | --- |
| `GET` | `/api/Actividad/ListarActividadesAPI` | Listar actividades. |
| `GET` | `/api/Actividad/ObtenerActividadAPI` | Obtener actividad. |
| `POST` | `/api/Actividad/CrearActividadAPI` | Crear actividad. |
| `PUT` | `/api/Actividad/ActualizarActividadAPI` | Actualizar actividad. |
| `DELETE` | `/api/Actividad/EliminarActividadAPI` | Eliminar actividad. |
| `POST` | `/api/Actividad/ReporteActividadesAPI` | Reporte de actividades. |
| `POST` | `/api/Actividad/ReporteHorariosAPI` | Reporte de horarios. |
| `GET` | `/api/TipoActividad/ListarTiposActividadAPI` | Listar tipos de actividad. |
| `POST` | `/api/TipoActividad/CrearTipoActividadAPI` | Crear tipo de actividad. |
| `PUT` | `/api/TipoActividad/ActualizarTipoActividadAPI` | Actualizar tipo de actividad. |
| `DELETE` | `/api/TipoActividad/EliminarTipoActividadAPI` | Eliminar tipo de actividad. |

### Citas, reportes y chatbot

| Método | Endpoint | Descripción |
| --- | --- | --- |
| `GET` | `/api/Citas/ListarCitasAPI` | Listar citas. |
| `POST` | `/api/Citas/CrearCitaAPI` | Crear cita. |
| `PUT` | `/api/Citas/ActualizarCitaAPI` | Actualizar cita. |
| `PUT` | `/api/Citas/AtenderCitaAPI` | Atender cita. |
| `DELETE` | `/api/Citas/EliminarCitaAPI` | Eliminar cita. |
| `GET` | `/api/Dashboard/ConsultarDashboardAPI` | Consultar dashboard. |
| `GET` | `/api/ChatBot/ConsultarChatbotAPI` | Consultar chatbot. |
| `POST` | `/api/UsuariosMinisterio/ReportePersonasMinisterioAPI` | Reporte de personas por ministerio. |

---

## ⚙️ Requisitos previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- [.NET SDK 10.0](https://dotnet.microsoft.com/)
- SQL Server o SQL Server LocalDB
- Git
- Un editor como Visual Studio, Visual Studio Code o Rider

---

## 🚀 Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd MinisterioGosen
```

### 2. Crear la base de datos

Ejecuta los scripts ubicados en la carpeta `Database`:

1. `Database/DB_Ministerio_Gosen.sql`
2. `Database/Seeding Ministerio Gosen.sql`

### 3. Configurar la cadena de conexión

Edita `MinisterioGosenAPI/appsettings.json` según tu entorno:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=ministerio_gosen;Integrated Security=True;TrustServerCertificate=True;"
  }
}
```

### 4. Configurar la URL de la API en la aplicación MVC

Edita `MinisterioGosen/appsettings.json`:

```json
{
  "Valores": {
    "UrlApi": "https://localhost:7013/api/"
  }
}
```

### 5. Restaurar dependencias

```bash
dotnet restore MinisterioGosen.slnx
```

### 6. Ejecutar la API

```bash
dotnet run --project MinisterioGosenAPI/MinisterioGosenAPI.csproj
```

### 7. Ejecutar la aplicación web

En otra terminal:

```bash
dotnet run --project MinisterioGosen/MinisterioGosen.csproj
```

---

## 🔐 Variables y configuración sensible

> ⚠️ No subas credenciales reales al repositorio.

Para la recuperación de acceso por correo, configura los valores de `Correos` en `MinisterioGosenAPI/appsettings.json` o mediante secretos de usuario/variables de entorno:

```json
{
  "Correos": {
    "CuentaGmail": "tu-correo@gmail.com",
    "ContrasenaAplicacion": "tu-contraseña-de-aplicación"
  }
}
```

---

## 🗄️ Base de datos

La solución utiliza SQL Server y procedimientos almacenados. Los scripts incluidos permiten:

- Crear la base de datos `ministerio_gosen`.
- Crear tablas necesarias para usuarios, ministerios, actividades, citas, reportes y chatbot.
- Insertar datos iniciales para comenzar a probar la aplicación.

---

## 🧪 Comandos útiles

```bash
# Compilar toda la solución
dotnet build MinisterioGosen.slnx

# Ejecutar la API
dotnet run --project MinisterioGosenAPI/MinisterioGosenAPI.csproj

# Ejecutar la aplicación MVC
dotnet run --project MinisterioGosen/MinisterioGosen.csproj
```

---

## 🤝 Contribución

Las contribuciones son bienvenidas. Para colaborar:

1. Haz un fork del repositorio.
2. Crea una rama para tu cambio: `git checkout -b feature/mi-mejora`.
3. Realiza tus cambios y valida la compilación.
4. Haz commit: `git commit -m "Describe tu cambio"`.
5. Abre un Pull Request.

---

## 📄 Licencia

Este repositorio no especifica una licencia todavía. Si planeas usarlo o distribuirlo, agrega un archivo `LICENSE` con los términos correspondientes.

---

<div align="center">

**Hecho con ❤️ para apoyar la organización y servicio del Ministerio Gosen.**

</div>
