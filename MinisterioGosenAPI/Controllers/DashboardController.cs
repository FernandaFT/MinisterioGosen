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
        public IActionResult ConsultarDashboardAPI()
        {
            using var context = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));

            var datos = context.QueryFirstOrDefault<DashboardModel>("spConsultarDashboard");

            if (datos == null)
            {
                return NotFound();
            }

            return Ok(datos);
        }
    }
}