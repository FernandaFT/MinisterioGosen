using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;

namespace MinisterioGosenAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeController(IConfiguration _config) : ControllerBase
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
    }
}