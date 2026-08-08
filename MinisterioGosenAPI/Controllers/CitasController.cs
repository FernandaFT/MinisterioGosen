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
        public async Task<IActionResult> ListarCitasAPI()
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var response = await context.QueryAsync<CitasModel>(
                "spListarCitas",
                commandType: CommandType.StoredProcedure
            );

            return Ok(response);
        }

        [HttpGet("ObtenerCitaAPI")]
        public async Task<IActionResult> ObtenerCitaAPI(int id)
        {
            using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Cita", id);

            var response = await context.QueryFirstOrDefaultAsync<CitasModel>(
                "spObtenerCita",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            if (response != null)
                return Ok(response);

            return NotFound("No se encontró la cita");
        }

        [HttpPost("CrearCitaAPI")]
        public async Task<IActionResult> CrearCitaAPI(CitasModel model)
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

                var idCita = await context.QueryFirstOrDefaultAsync<int>(
                    "spCrearCita",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                if (idCita > 0)
                    return Ok(new { Id_Cita = idCita });

                return BadRequest("No se ha registrado la cita.");
            }
            catch (SqlException ex)
            {
                // Captura los RAISERROR lanzados desde el Stored Procedure
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error al registrar la cita: {ex.Message}");
            }
        }

        [HttpPut("ActualizarCitaAPI")]
        public async Task<IActionResult> ActualizarCitaAPI(CitasModel model)
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

                var rowsAffected = await context.ExecuteAsync(
                    "spActualizarCita",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                if (rowsAffected > 0)
                    return Ok(rowsAffected);

                return BadRequest("No se ha actualizado la cita.");
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error al actualizar la cita: {ex.Message}");
            }
        }

        [HttpPut("AtenderCitaAPI")]
        public async Task<IActionResult> AtenderCitaAPI(CitasModel model)
        {
            try
            {
                using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

                var parameters = new DynamicParameters();
                parameters.Add("@Id_Cita", model.Id_Cita);
                parameters.Add("@Detalle_Cita", model.Detalle_Cita);

                var rowsAffected = await context.ExecuteAsync(
                    "spAtenderCita",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                if (rowsAffected > 0)
                    return Ok(rowsAffected);

                return BadRequest("No se ha podido marcar la cita como atendida.");
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
        public async Task<IActionResult> EliminarCitaAPI(int id)
        {
            try
            {
                using var context = new SqlConnection(_config["ConnectionStrings:DefaultConnection"]);

                var parameters = new DynamicParameters();
                parameters.Add("@Id_Cita", id);

                var rowsAffected = await context.ExecuteAsync(
                    "spEliminarCita",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                if (rowsAffected > 0)
                    return Ok(rowsAffected);

                return BadRequest("No se ha eliminado la cita.");
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest($"No se puede eliminar esta cita: {ex.Message}");
            }
        }
    }
}