using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;
using System.Data;

namespace MinisterioGosenAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CitasController(IConfiguration _config) : ControllerBase
    {
        [HttpGet("ListarCitasAPI")]
        public IActionResult ListarCitasAPI()
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var response = context.Query<CitasModel>("spListarCitas").ToList();

            return Ok(response);
        }

        [HttpGet("ObtenerCitaAPI")]
        public IActionResult ObtenerCitaAPI(int id)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Cita", id);

            var response = context.QueryFirstOrDefault<CitasModel>("spObtenerCita", parameters);

            if (response != null)
                return Ok(response);

            return NotFound("No se encontró la cita");
        }

        [HttpPost("CrearCitaAPI")]
        public IActionResult CrearCitaAPI(CitasModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Fecha_Cita", model.Fecha_Cita);
            parameters.Add("@Id_Usuario_Cita", model.Id_Usuario_Cita);
            parameters.Add("@Id_Usuario_Encargado", model.Id_Usuario_Encargado);
            parameters.Add("@Observacion_Inicial", model.Observacion_Inicial);
            parameters.Add("@Detalle_Cita", model.Detalle_Cita);

            var response = context.Execute("spCrearCita", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha registrado la cita");
        }

        [HttpPut("ActualizarCitaAPI")]
        public IActionResult ActualizarCitaAPI(CitasModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Cita", model.Id_Cita);
            parameters.Add("@Fecha_Cita", model.Fecha_Cita);
            parameters.Add("@Id_Usuario_Cita", model.Id_Usuario_Cita);
            parameters.Add("@Id_Usuario_Encargado", model.Id_Usuario_Encargado);
            parameters.Add("@Observacion_Inicial", model.Observacion_Inicial);
            parameters.Add("@Detalle_Cita", model.Detalle_Cita);

            var response = context.Execute("spActualizarCita", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha actualizado la cita");
        }

        [HttpPut("AtenderCitaAPI")]
        public IActionResult AtenderCitaAPI(CitasModel model)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Cita", model.Id_Cita);
            parameters.Add("@Detalle_Cita", model.Detalle_Cita);

            var response = context.Execute("spAtenderCita", parameters);

            if (response > 0)
                return Ok(response);

            return BadRequest("No se ha podido marcar la cita como atendida");
        }

        [HttpDelete("EliminarCitaAPI")]
        public IActionResult EliminarCitaAPI(int id)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            try
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Id_Cita", id);

                var response = context.Execute("spEliminarCita", parameters);

                if (response > 0)
                    return Ok(response);

                return BadRequest("No se ha eliminado la cita");
            }
            catch
            {
                return BadRequest("No se puede eliminar esta cita porque tiene información relacionada.");
            }
        }
    }
}