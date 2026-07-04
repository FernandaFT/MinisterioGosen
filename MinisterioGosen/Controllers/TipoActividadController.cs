using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class TipoActividadController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        [HttpGet]
        public IActionResult Index()
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "TipoActividad/ListarTiposActividadAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<List<TipoActividadModel>>().Result;
                return View(datos);
            }

            throw new Exception("Error al consultar los tipos de actividad");
        }

        [HttpGet]
        public IActionResult Crear()
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            return View();
        }

        [HttpPost]
        public IActionResult Crear(TipoActividadModel model)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "TipoActividad/CrearTipoActividadAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "TipoActividad");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View(model);
        }

        [HttpGet]
        public IActionResult Editar(int id)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"TipoActividad/ObtenerTipoActividadAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<TipoActividadModel>().Result;
                return View(datos);
            }

            return RedirectToAction("Index", "TipoActividad");
        }

        [HttpPost]
        public IActionResult Editar(TipoActividadModel model)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "TipoActividad/ActualizarTipoActividadAPI";
            var response = client.PutAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "TipoActividad");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View(model);
        }

        [HttpGet]
        public IActionResult Eliminar(int id)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"TipoActividad/ObtenerTipoActividadAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<TipoActividadModel>().Result;
                return View(datos);
            }

            return RedirectToAction("Index", "TipoActividad");
        }

        [HttpPost]
        public IActionResult ConfirmarEliminar(TipoActividadModel model)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"TipoActividad/EliminarTipoActividadAPI?id={model.Id_Tipo_Actividad}";
            var response = client.DeleteAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "TipoActividad");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View("Eliminar", model);
        }
    }
}