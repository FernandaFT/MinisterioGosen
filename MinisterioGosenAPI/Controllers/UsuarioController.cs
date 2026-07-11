using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;
using System.Data;

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
                return Ok(response);
            }

            return BadRequest("No se ha actualizado su contraseña, intente nuevamente más tarde");
        }

        [HttpPut("CambiarPerfilAPI")]
        public IActionResult CambiarPerfilAPI(ActualizarPerfilRequestModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();

            parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", model.Id_Usuario);
            parameters.Add("@Identificacion", model.Identificacion);
            parameters.Add("@Nombre", model.Nombre);
            parameters.Add("@Correo", model.Correo);
            var response = context.Execute("spActualizarPerfil", parameters);

            if (response > 0)
            {
                return Ok("La información se ha actualizado correctamente");
            }

            return BadRequest("No se ha actualizado su información, intente nuevamente más tarde");
        }

        [HttpGet("ListarRolesAPI")]
        public IActionResult ListarRolesAPI()
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var response = context.Query<RolResponseModel>("spListarRoles").ToList();

            return Ok(response);
        }

        [HttpGet("ListarUsuariosAPI")]
        public IActionResult ListarUsuariosAPI()
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var response = context.Query<UsuarioResponseModel>("spListarUsuarios").ToList();

            return Ok(response);
        }

        [HttpGet("ObtenerUsuarioAPI")]
        public IActionResult ObtenerUsuarioAPI(int id)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", id);

            var response = context.QueryFirstOrDefault<UsuarioResponseModel>("spObtenerUsuario", parameters);

            if (response != null)
                return Ok(response);

            return NotFound("No se encontró la información del usuario");
        }

        [HttpPut("ActualizarUsuarioAPI")]
        public IActionResult ActualizarUsuarioAPI(UsuarioResponseModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", model.Id_Usuario);
            parameters.Add("@Nombre", model.Nombre);
            parameters.Add("@Correo", model.Correo);
            parameters.Add("@Estado", model.Estado);
            parameters.Add("@Id_Rol", model.Id_Rol);

            var response = context.Execute("spActualizarUsuario", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha actualizado la información del usuario");
        }

        [HttpPut("DesactivarUsuarioAPI")]
        public IActionResult DesactivarUsuarioAPI(UsuarioEstadoRequestModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", model.Id_Usuario);

            var response = context.Execute(
                "spDesactivarUsuario", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha desactivado el usuario");
        }

        [HttpPut("ActivarUsuarioAPI")]
        public IActionResult ActivarUsuarioAPI(UsuarioEstadoRequestModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", model.Id_Usuario);

            var response = context.Execute(
                "spActivarUsuario", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha activado el usuario");
        }

        [HttpPost("CrearUsuarioAPI")]
        public IActionResult CrearUsuarioAPI(CrearUsuarioRequestModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Identificacion", model.Identificacion);
            parameters.Add("@Nombre", model.Nombre);
            parameters.Add("@Correo", model.Correo);
            parameters.Add("@Contrasena", model.Contrasena);
            parameters.Add("@Estado", "A");
            parameters.Add("@Id_Rol", model.Id_Rol);

            var response = context.Execute("spCrearUsuario", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha registrado el usuario. Valide que la identificación o el correo no estén repetidos.");
        }
    }
}
