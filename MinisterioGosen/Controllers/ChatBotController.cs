using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class ChatBotController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        [HttpGet]
        public IActionResult Index()
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] +
                      "ChatBot/ConsultarChatBotAPI";

            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content
                    .ReadFromJsonAsync<ChatbotResultadoModel>()
                    .Result;

                return View(datos);
            }

            ViewBag.Mensaje =
                "No se pudieron cargar las opciones del chatbot";

            return View(new ChatbotResultadoModel());
        }

        [HttpGet]
        public IActionResult ConsultarChatBot(int? idOpcion)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] +
                      "ChatBot/ConsultarChatBotAPI";

            if (idOpcion.HasValue)
            {
                url += "?idOpcion=" + idOpcion.Value;
            }

            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content
                    .ReadFromJsonAsync<ChatbotResultadoModel>()
                    .Result;

                return Ok(datos);
            }

            if (response.StatusCode == HttpStatusCode.NotFound)
            {
                return NotFound(
                    "No se encontró la opción seleccionada"
                );
            }

            return BadRequest(
                "No se pudieron cargar las opciones del chatbot"
            );
        }
    }
}