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
            try
            {
                using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

                var parameters = new DynamicParameters();
                parameters.Add("@Fecha_Cita", model.Fecha_Cita);
                parameters.Add("@Hora_Cita", model.Hora_Cita);
                parameters.Add("@Id_Usuario_Cita", model.Id_Usuario_Cita);
                parameters.Add("@Id_Usuario_Encargado", model.Id_Usuario_Encargado);
                parameters.Add("@Observacion_Inicial", model.Observacion_Inicial);
                parameters.Add("@Detalle_Cita", model.Detalle_Cita);

                // El SP devuelve SCOPE_IDENTITY(), usamos QueryFirstOrDefault para capturar el ID
                var idCita = context.QueryFirstOrDefault<int>("spCrearCita", parameters, commandType: CommandType.StoredProcedure);

                if (idCita > 0)
                    return Ok(new { Id_Cita = idCita });

                return BadRequest("No se ha registrado la cita");
            }
            catch (SqlException ex)
            {
                // Capturar el mensaje de error del servidor SQL
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error al registrar la cita: {ex.Message}");
            }
        }

        [HttpPut("ActualizarCitaAPI")]
        public IActionResult ActualizarCitaAPI(CitasModel model)
        {
            try
            {
                using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

                var parameters = new DynamicParameters();
                parameters.Add("@Id_Cita", model.Id_Cita);
                parameters.Add("@Fecha_Cita", model.Fecha_Cita);
                parameters.Add("@Hora_Cita", model.Hora_Cita);
                parameters.Add("@Id_Usuario_Cita", model.Id_Usuario_Cita);
                parameters.Add("@Id_Usuario_Encargado", model.Id_Usuario_Encargado);
                parameters.Add("@Observacion_Inicial", model.Observacion_Inicial);
                parameters.Add("@Detalle_Cita", model.Detalle_Cita);

                var response = context.Execute("spActualizarCita", parameters, commandType: CommandType.StoredProcedure);

                if (response > 0)
                    return Ok(response);

                return BadRequest("No se ha actualizado la cita");
            }
            catch (SqlException ex)
            {
                // Capturar el mensaje de error del servidor SQL
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error al actualizar la cita: {ex.Message}");
            }
        }

        [HttpPut("AtenderCitaAPI")]
        public IActionResult AtenderCitaAPI(CitasModel model)
        {
            try
            {
                using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

                var parameters = new DynamicParameters();
                parameters.Add("@Id_Cita", model.Id_Cita);
                parameters.Add("@Detalle_Cita", model.Detalle_Cita);

                var response = context.Execute("spAtenderCita", parameters, commandType: CommandType.StoredProcedure);

                if (response > 0)
                    return Ok(response);

                return BadRequest("No se ha podido marcar la cita como atendida");
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error al atender la cita: {ex.Message}");
            }
        }

        [HttpDelete("EliminarCitaAPI")]
        public IActionResult EliminarCitaAPI(int id)
        {
            try
            {
                using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

                var parameters = new DynamicParameters();
                parameters.Add("@Id_Cita", id);

                var response = context.Execute("spEliminarCita", parameters, commandType: CommandType.StoredProcedure);

                if (response > 0)
                    return Ok(response);

                return BadRequest("No se ha eliminado la cita");
            }
            catch (Exception ex)
            {
                return BadRequest("No se puede eliminar esta cita porque tiene información relacionada.");
            }
        }
    }
}
