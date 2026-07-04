using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class MinisterioController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        private bool EsAdmin()
        {
            return HttpContext.Session.GetInt32("Id_Rol") == 1;
        }

        [HttpGet]
        public IActionResult Index()
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Ministerio/ListarMinisteriosAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<List<MinisterioModel>>().Result;
                return View(datos);
            }

            throw new Exception("Error al consultar los ministerios");
        }

        [HttpGet]
        public IActionResult Crear()
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            return View();
        }

        [HttpPost]
        public IActionResult Crear(MinisterioModel model)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Ministerio/CrearMinisterioAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "Ministerio");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View(model);
        }

        [HttpGet]
        public IActionResult Editar(int id)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"Ministerio/ObtenerMinisterioAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<MinisterioModel>().Result;
                return View(datos);
            }

            return RedirectToAction("Index", "Ministerio");
        }

        [HttpPost]
        public IActionResult Editar(MinisterioModel model)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Ministerio/ActualizarMinisterioAPI";
            var response = client.PutAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "Ministerio");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View(model);
        }

        [HttpGet]
        public IActionResult Eliminar(int id)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"Ministerio/ObtenerMinisterioAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<MinisterioModel>().Result;
                return View(datos);
            }

            return RedirectToAction("Index", "Ministerio");
        }

        [HttpPost]
        public IActionResult ConfirmarEliminar(MinisterioModel model)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"Ministerio/EliminarMinisterioAPI?id={model.Id_Ministerio}";
            var response = client.DeleteAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "Ministerio");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View("Eliminar", model);
        }
    }
}