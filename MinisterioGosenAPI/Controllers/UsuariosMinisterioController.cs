using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;
using System.Data;

namespace MinisterioGosenAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosMinisterioController(IConfiguration _config) : ControllerBase
    {
        [HttpGet("ListarUsuariosPorMinisterioAPI")]
        public IActionResult ListarUsuariosPorMinisterioAPI(int idMinisterio)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Ministerio", idMinisterio);

            var response = context.Query<UsuariosMinisterioModel>(
                "spListarUsuariosPorMinisterio", parameters).ToList();

            return Ok(response);
        }

        [HttpGet("ListarUsuariosDisponiblesMinisterioAPI")]
        public IActionResult ListarUsuariosDisponiblesMinisterioAPI(int idMinisterio)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Ministerio", idMinisterio);

            var response = context.Query<UsuarioResponseModel>(
                "spListarUsuariosDisponiblesMinisterio", parameters).ToList();

            return Ok(response);
        }

        [HttpGet("ListarMinisteriosPorUsuarioAPI")]
        public IActionResult ListarMinisteriosPorUsuarioAPI(int idUsuario)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", idUsuario);

            var response = context.Query<UsuariosMinisterioModel>(
                "spListarMinisteriosPorUsuario", parameters).ToList();

            return Ok(response);
        }

        [HttpGet("ListarMinisteriosDisponiblesUsuarioAPI")]
        public IActionResult ListarMinisteriosDisponiblesUsuarioAPI(int idUsuario)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario", idUsuario);

            var response = context.Query<MinisterioModel>(
                "spListarMinisteriosDisponiblesUsuario", parameters).ToList();

            return Ok(response);
        }

        [HttpPost("CrearUsuarioMinisterioAPI")]
        public IActionResult CrearUsuarioMinisterioAPI(UsuariosMinisterioModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Ministerio", model.Id_Ministerio);
            parameters.Add("@Id_Usuario", model.Id_Usuario);
            parameters.Add("@Fecha_Ingreso", model.Fecha_Ingreso);
            parameters.Add("@Estado", model.Estado);
            parameters.Add("@Observacion", model.Observacion);

            var response = context.Execute("spCrearUsuarioMinisterio", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se pudo registrar el usuario al ministerio.");
        }

        [HttpPut("SalirUsuarioMinisterioAPI")]
        public IActionResult SalirUsuarioMinisterioAPI(UsuariosMinisterioModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Usuario_Ministerio", model.Id_Usuario_Ministerio);

            var response = context.Execute("spSalirUsuarioMinisterio", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se pudo sacar el usuario del ministerio.");
        }

        [HttpGet("ReportePersonasMinisterioAPI")]
        public IActionResult ReportePersonasMinisterioAPI(
            string? buscar,
            int? idMinisterio,
            string? estado,
            DateTime? fechaInicio,
            DateTime? fechaFin)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Buscar", buscar);
            parameters.Add("@Id_Ministerio", idMinisterio);
            parameters.Add("@Estado", estado);
            parameters.Add("@FechaInicio", fechaInicio);
            parameters.Add("@FechaFin", fechaFin);

            var response = context.Query<UsuariosMinisterioModel>(
                "spReportePersonasMinisterio",
                parameters,
                commandType: CommandType.StoredProcedure
            ).ToList();

            return Ok(response);
        }



    }
}