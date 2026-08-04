using System.Data;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;

namespace MinisterioGosenAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class ActividadUsuarioController(IConfiguration _config) : ControllerBase
	{
		[HttpGet("ListarActividadUsuarioAPI")]
		public IActionResult ListarActividadUsuarioAPI(int? idUsuario = null, int? idActividad = null)
		{
			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();

			if (idUsuario.HasValue)
				parameters.Add("@Id_Usuario", idUsuario.Value);

			if (idActividad.HasValue)
				parameters.Add("@Id_Actividad", idActividad.Value);

			var response = context.Query<ActividadUsuarioModel>(
				"spListarActividadUsuario",
				parameters,
				commandType: CommandType.StoredProcedure
			).ToList();

			return Ok(response);
		}

		[HttpGet("ObtenerActividadUsuarioAPI")]
		public IActionResult ObtenerActividadUsuarioAPI(int id)
		{
			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();
			parameters.Add("@Id_Actividad_Usuario", id);

			var response = context.QueryFirstOrDefault<ActividadUsuarioModel>("spObtenerActividadUsuario", parameters);

			if (response != null)
				return Ok(response);

			return NotFound(new { Success = false, Message = "No se encontró la participación" });
		}

		[HttpPost("CrearActividadUsuarioAPI")]
		public IActionResult CrearActividadUsuarioAPI([FromBody] ActividadUsuarioModel model)
		{
			if (!ModelState.IsValid)
				return BadRequest(ModelState);

			if (model.Id_Actividad <= 0 || model.Id_Usuario <= 0)
				return BadRequest(new { Success = false, Message = "Actividad y Usuario son obligatorios" });

			if (model.Fecha.Date < DateTime.Today)
				return BadRequest(new { Success = false, Message = "La fecha no puede ser anterior a la actual" });

			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();
			parameters.Add("@Id_Actividad", model.Id_Actividad);
			parameters.Add("@Id_Usuario", model.Id_Usuario);
			parameters.Add("@Fecha", model.Fecha);
			parameters.Add("@Hora", model.Hora);

			var idActividadUsuario = context.QuerySingle<int>("spCrearActividadUsuario", parameters, commandType: CommandType.StoredProcedure);

			if (idActividadUsuario > 0)
			{
				return Ok(new
				{
					Success = true,
					Id = idActividadUsuario,
					Message = "Participación registrada correctamente"
				});
			}

			return StatusCode(500, new { Success = false, Message = "Error interno: no se pudo registrar la participación" });
		}

		[HttpPut("ActualizarActividadUsuarioAPI")]
		public IActionResult ActualizarActividadUsuarioAPI([FromBody] ActividadUsuarioModel model)
		{
			if (!ModelState.IsValid)
				return BadRequest(ModelState);

			if (model.Id_Actividad_Usuario <= 0)
				return BadRequest(new { Success = false, Message = "El identificador de la participación es obligatorio" });

			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();
			parameters.Add("@Id_Actividad_Usuario", model.Id_Actividad_Usuario);
			parameters.Add("@Id_Actividad", model.Id_Actividad);
			parameters.Add("@Id_Usuario", model.Id_Usuario);
			parameters.Add("@Fecha", model.Fecha);
			parameters.Add("@Hora", model.Hora);

			var response = context.Execute("spActualizarActividadUsuario", parameters);

			if (response > 0)
				return Ok(new { Success = true, Message = "Participación actualizada correctamente" });

			return BadRequest(new { Success = false, Message = "No se ha actualizado la participación" });
		}

		[HttpDelete("EliminarActividadUsuarioAPI")]
		public IActionResult EliminarActividadUsuarioAPI(int id)
		{
			using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);
			var parameters = new DynamicParameters();
			parameters.Add("@Id_Actividad_Usuario", id);

			var response = context.Execute("spEliminarActividadUsuario", parameters);

			if (response > 0)
				return Ok(new { Success = true, Message = "Participación eliminada correctamente" });

			return BadRequest(new { Success = false, Message = "No se ha eliminado la participación" });
		}
	}
}
