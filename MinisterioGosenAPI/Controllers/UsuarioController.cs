using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;

namespace MinisterioGosenAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController(IConfiguration _config) : ControllerBase
    {
        [HttpPut("CambiarContrasenaAPI")]
        public IActionResult CambiarContrasenaAPI(CambiarContrasenaRequestModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();

            parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", model.Id_Usuario);
            parameters.Add("@Contrasena", model.Contrasena);
            parameters.Add("@IndicadorTemp", false);
            var response = context.Execute("spActualizarContrasenna", parameters);

            if (response > 0)
            {
                //3. Enviar un correo electrónico al usuario

                return Ok(response);
            }

            return BadRequest("No se ha actualizado su contraseña, intente nuevamente más tarde");
        }
    }
}
