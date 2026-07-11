using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;
using MinisterioGosenAPI.Services;

namespace MinisterioGosenAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeController(IConfiguration _config, IUtilesService _utiles) : ControllerBase
    {
        [HttpPost("RegistrarAPI")]
        public IActionResult RegistrarAPI(RegistroUsuarioRequestModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
                parameters.Add("@Nombre", model.Nombre);
                parameters.Add("@Identificacion", model.Identificacion);
                parameters.Add("@Correo", model.Correo);
                parameters.Add("@Contrasena", model.Contrasena);
            var response = context.Execute("spRegistrarUsuario", parameters);

            if(response > 0)
                return Ok(response);

            return BadRequest("No se ha registrado su información, valide que no tenga una cuenta ya creada");
        }

        [HttpPost("IniciarSesionAPI")]
        public IActionResult IniciarSesionAPI(InicioSesionUsuarioRequestModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Correo", model.Correo);
            parameters.Add("@Contrasena", model.Contrasena);
            var response = context.QueryFirstOrDefault<UsuarioResponseModel>("spIniciarSesionUsuario",parameters);

            if (response != null)
                return Ok(response);
            else
                return NotFound("No se ha validado su información correctamente");
        }

        [HttpPost("RecuperarAccesoAPI")]
        public async Task<IActionResult> RecuperarAccesoAPI(RecuperarAccesoRequestModel model)
        {
            //1. Validar que el correo exista en la base de datos
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Correo", model.Correo);
            var response = context.QueryFirstOrDefault<UsuarioResponseModel>("spValidarCorreo", parameters);

            if (response == null)
                return NotFound("No se ha validado su información correctamente");

            //2 Generar una contraseña temporal
            var temporal = _utiles.GenerarContrasena();

            parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", response.Id_Usuario);
            parameters.Add("@Contrasena", temporal);
            parameters.Add("@IndicadorTemp", true);
            var update = context.Execute("spActualizarContrasenna", parameters);

            if (update > 0)
            {
                //3. Enviar la contraseña temporal al correo electrónico del usuario
                string ruta = Path.Combine(AppContext.BaseDirectory, "Templates", "RecuperarAcceso.html");
                string plantilla = System.IO.File.ReadAllText(ruta);

                plantilla = plantilla.Replace("{{TEMPORAL}}", temporal);
                plantilla = plantilla.Replace("{{NOMBRE}}", response.Nombre);

                await _utiles.EnviarCorreoAsync(model.Correo, "Recuperación de acceso", plantilla);
                return Ok(response);
            }

            return BadRequest("No se ha recuperado su acceso, intente nuevamente más tarde");
        }
    }
}