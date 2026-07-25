using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;
using System.Data;

namespace MinisterioGosen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DashboardController(IConfiguration _configuration) : ControllerBase
    {
        [HttpGet]
        [Route("ConsultarDashboardAPI")]
        public async Task<IActionResult> ConsultarDashboardAPI()
        {
            try
            {
                var connectionString = _configuration.GetConnectionString("DefaultConnection");

                await using var connection = new SqlConnection(connectionString);
                await connection.OpenAsync();
                using var resultados = await connection.QueryMultipleAsync("spConsultarDashboard");

                /*
                 * Resultado 1:
                 * Totales principales del dashboard.
                 */
                var dashboard = await resultados.ReadFirstOrDefaultAsync<DashboardModel>();
                if (dashboard == null)
                {
                    return NotFound(new
                    {
                        mensaje ="No se encontró información para el dashboard."
                    });
                }

                /*
                 * Resultado 2:
                 * Citas agrupadas por estado.
                 */
                dashboard.CitasPorEstado =(await resultados.ReadAsync<DashboardGraficoModel>()).ToList();

                /*
                 * Resultado 3:
                 * Actividades agrupadas por mes.
                 */
                dashboard.ActividadesPorMes = (await resultados.ReadAsync<DashboardGraficoModel>()).ToList();

                /*
                 * Resultado 4:
                 * Asistencia o personas registradas por actividad.
                 */
                dashboard.AsistenciaPorActividad = (await resultados.ReadAsync<DashboardGraficoModel>()).ToList();

                /*
                 * Resultado 5:
                 * Personas agrupadas por ministerio.
                 */
                dashboard.PersonasPorMinisterio = (await resultados.ReadAsync<DashboardGraficoModel>()).ToList();
                return Ok(dashboard);
            }
            catch (SqlException ex)
            {
                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    new
                    {
                        mensaje = "Ocurrió un error al consultar la base de datos.", detalle = ex.Message
                    }
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    new
                    {
                        mensaje = "Ocurrió un error al cargar el dashboard.", detalle = ex.Message
                    }
                );
            }
        }
    }
}