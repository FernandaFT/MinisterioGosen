using System.Data;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosen.Models;
using MinisterioGosenAPI.Models;

namespace MinisterioGosenAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class ActividadMinisterioController(IConfiguration _config) : ControllerBase
	{
		[HttpGet("ListarActividadMinisterioAPI")]
		public IActionResult ListarActividadMinisterioAPI(int? idActividad = null, int? idMinisterio = null)
		{
			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();

			if (idActividad.HasValue)
				parameters.Add("@Id_Actividad", idActividad.Value);

			if (idMinisterio.HasValue)
				parameters.Add("@Id_Ministerio", idMinisterio.Value);

			var response = context.Query<ActividadMinisterioModel>(
				"spListarActividadMinisterio",
				parameters,
				commandType: CommandType.StoredProcedure
			).ToList();

			return Ok(response);
		}

		[HttpGet("ObtenerActividadMinisterioAPI")]
		public IActionResult ObtenerActividadMinisterioAPI(int id)
		{
			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();
			parameters.Add("@Id_Minis_Actividad", id);

			var response = context.QueryFirstOrDefault<ActividadMinisterioModel>(
				"spObtenerActividadMinisterio",
				parameters
			);

			if (response != null)
				return Ok(response);

			return NotFound(new { Success = false, Message = "No se encontró la actividad ministerial" });
		}

		[HttpPost("CrearActividadMinisterioAPI")]
		public IActionResult CrearActividadMinisterioAPI([FromBody] ActividadMinisterioModel model)
		{
			if (!ModelState.IsValid)
				return BadRequest(ModelState);

			if (model.Id_Actividad <= 0 || model.Id_Ministerio <= 0)
				return BadRequest(new { Success = false, Message = "Actividad y Ministerio son obligatorios" });

			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();
			parameters.Add("@Id_Actividad", model.Id_Actividad);
			parameters.Add("@Id_Ministerio", model.Id_Ministerio);
			parameters.Add("@Fecha", model.Fecha);
			parameters.Add("@Observacion", model.Observacion);

			var idActividadMinisterio = context.QuerySingle<int>(
				"spCrearActividadesMinisterio",
				parameters,
				commandType: CommandType.StoredProcedure
			);

			if (idActividadMinisterio > 0)
			{
				return Ok(new
				{
					Success = true,
					Id = idActividadMinisterio,
					Message = "Actividad ministerial registrada correctamente"
				});
			}

			return StatusCode(500, new { Success = false, Message = "Error interno: no se pudo registrar la actividad ministerial" });
		}

		[HttpPut("ActualizarActividadMinisterioAPI")]
		public IActionResult ActualizarActividadMinisterioAPI([FromBody] ActividadMinisterioModel model)
		{
			if (!ModelState.IsValid)
				return BadRequest(ModelState);

			if (model.Id_Minis_Actividad <= 0)
				return BadRequest(new { Success = false, Message = "El identificador de la actividad ministerial es obligatorio" });

			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();
			parameters.Add("@Id_Minis_Actividad", model.Id_Minis_Actividad);
			parameters.Add("@Id_Actividad", model.Id_Actividad);
			parameters.Add("@Id_Ministerio", model.Id_Ministerio);
			parameters.Add("@Fecha", model.Fecha);
			parameters.Add("@Observacion", model.Observacion);

			var response = context.Execute("spActualizarActividadesMinisterio", parameters);

			if (response > 0)
				return Ok(new { Success = true, Message = "Actividad ministerial actualizada correctamente" });

			return BadRequest(new { Success = false, Message = "No se ha actualizado la actividad ministerial" });
		}


        [HttpDelete("EliminarActividadMinisterioAPI")]
        public IActionResult EliminarActividadMinisterioAPI(int id)
        {
            using var context = new SqlConnection(
                _config["ConnectionStrings:DefaultConnection"]
            );

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Minis_Actividad", id);

            var filasAfectadas = context.QuerySingle<int>(
                "spEliminarActividadMinisterio",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            if (filasAfectadas > 0)
            {
                return Ok(new
                {
                    Success = true,
                    Message = "Actividad por ministerio eliminada correctamente."
                });
            }

            return NotFound(new
            {
                Success = false,
                Message = "La asignación indicada no existe o ya fue eliminada."
            });
        }
    }
}
