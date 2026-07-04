using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class DashboardController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        [HttpGet]
        public IActionResult Index()
        {
            var idRol = HttpContext.Session.GetInt32("Id_Rol");

            if (idRol != 1)
            {
                return RedirectToAction("Principal", "Home");
            }

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Dashboard/ConsultarDashboardAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<DashboardModel>().Result;
                return View(datos);
            }

            ViewBag.Mensaje = "No se pudo cargar la información del dashboard";
            return View(new DashboardModel());
        }
    }
}