using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Net;
using static System.Net.WebRequestMethods;

namespace MinisterioGosen.Controllers
{
    public class UsuarioController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        public IActionResult Perfil()
        {
            return View();
        }

        #region Cambiar Contraseña

        [HttpGet]
        public IActionResult Configuracion()
        {
            return View();
        }

        [HttpPost]
        public IActionResult CambiarContrasena(UsuarioModel model)
        {
            model.Id_Usuario = HttpContext.Session.GetInt32("Id_Usuario")!.Value;

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/CambiarContrasenaAPI";
            var response = client.PutAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                return RedirectToAction("Salir", "Home");
            }
            else if (response.StatusCode == HttpStatusCode.BadRequest)
            {
                ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
                return View();
            }

            throw new Exception("Error al cambiar la contraseña");
        }

        #endregion
    }
}
