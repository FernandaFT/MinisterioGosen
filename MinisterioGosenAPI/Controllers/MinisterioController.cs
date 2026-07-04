using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;

namespace MinisterioGosenAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MinisterioController(IConfiguration _config) : ControllerBase
    {
        [HttpGet("ListarMinisteriosAPI")]
        public IActionResult ListarMinisteriosAPI()
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var response = context.Query<MinisterioModel>("spListarMinisterios").ToList();

            return Ok(response);
        }

        [HttpGet("ObtenerMinisterioAPI")]
        public IActionResult ObtenerMinisterioAPI(int id)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Ministerio", id);

            var response = context.QueryFirstOrDefault<MinisterioModel>("spObtenerMinisterio", parameters);

            if (response != null)
                return Ok(response);

            return NotFound("No se encontró el ministerio");
        }

        [HttpPost("CrearMinisterioAPI")]
        public IActionResult CrearMinisterioAPI(MinisterioModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Descripcion_Ministerio", model.Descripcion_Ministerio);
            parameters.Add("@Observaciones_Ministerio", model.Observaciones_Ministerio);

            var response = context.Execute("spCrearMinisterio", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha registrado el ministerio");
        }

        [HttpPut("ActualizarMinisterioAPI")]
        public IActionResult ActualizarMinisterioAPI(MinisterioModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Ministerio", model.Id_Ministerio);
            parameters.Add("@Descripcion_Ministerio", model.Descripcion_Ministerio);
            parameters.Add("@Observaciones_Ministerio", model.Observaciones_Ministerio);

            var response = context.Execute("spActualizarMinisterio", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha actualizado el ministerio");
        }

        [HttpDelete("EliminarMinisterioAPI")]
        public IActionResult EliminarMinisterioAPI(int id)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Ministerio", id);

            try
            {
                var response = context.Execute("spEliminarMinisterio", parameters);

                if (response > 0)
                    return Ok(response);

                return BadRequest("No se ha eliminado el ministerio");
            }
            catch
            {
                return BadRequest("No se puede eliminar este ministerio porque tiene información relacionada.");
            }
        }
    }
}