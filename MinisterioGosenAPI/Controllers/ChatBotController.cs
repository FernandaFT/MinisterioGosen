using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using MinisterioGosenAPI.Models;
using System.Data;

namespace MinisterioGosenAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChatbotController(IConfiguration _configuration) : ControllerBase
    {
        [HttpGet]
        [Route("ConsultarChatbotAPI")]
        public IActionResult ConsultarChatbotAPI(int? idOpcion = null)
        {
            using var context = new SqlConnection(
                _configuration.GetConnectionString("DefaultConnection")
            );

            var parameters = new DynamicParameters();
            parameters.Add("@Id_Opcion", idOpcion);

            using var resultados = context.QueryMultiple(
                "SP_ConsultarChatbot",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            ChatBotOpcionesModel? seleccion =
                resultados.ReadFirstOrDefault<ChatBotOpcionesModel>();

            List<ChatBotOpcionesModel> opciones =
                resultados.Read<ChatBotOpcionesModel>().ToList();

            ChatBotOpcionesModel? opcionPadre =
                resultados.ReadFirstOrDefault<ChatBotOpcionesModel>();

            if (idOpcion.HasValue && seleccion == null)
            {
                return NotFound("No se encontró la opción seleccionada");
            }

            var response = new ChatbotResultadoModel
            {
                Seleccion = seleccion,
                Opciones = opciones,
                OpcionPadre = opcionPadre
            };

            return Ok(response);
        }
    }
}