using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class CitasController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        #region Validaciones de sesión

        private bool EstaLogueado()
        {
            return HttpContext.Session.GetString("Autenticado") == "1";
        }

        private bool EsAdmin()
        {
            return HttpContext.Session.GetInt32("Id_Rol") == 1;
        }

        #endregion

        #region Helpers de combos

        // Carga los usuarios que pueden ser "encargados" de una cita (administradores activos)
        private void CargarEncargados(int? idSeleccionado = null)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/ListarUsuariosAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var usuarios = response.Content.ReadFromJsonAsync<List<UsuarioModel>>().Result
                    ?? new List<UsuarioModel>();

                var encargados = usuarios
                    .Where(u => u.Estado == "A" && u.Id_Rol == 1)
                    .ToList();

                ViewBag.Encargados = new SelectList(encargados, "Id_Usuario", "Nombre", idSeleccionado);
            }
            else
            {
                ViewBag.Encargados = new SelectList(new List<UsuarioModel>(), "Id_Usuario", "Nombre");
            }
        }

        #endregion

        #region Listado

        [HttpGet]
        public IActionResult Index()
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Citas/ListarCitasAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<List<CitasModel>>().Result;
                return View(datos);
            }

            throw new Exception("Error al consultar las citas");
        }

        #endregion

        #region Crear Cita

        [HttpGet]
        public IActionResult Crear()
        {
            if (!EstaLogueado())
                return RedirectToAction("Index", "Home");

            CargarEncargados();

            return View();
        }

        [HttpPost]
        public IActionResult Crear(CitasModel model)
        {
            if (!EstaLogueado())
                return RedirectToAction("Index", "Home");

            // La cita siempre se agenda a nombre del usuario logueado
            model.Id_Usuario_Cita = HttpContext.Session.GetInt32("Id_Usuario")!.Value;

            if (model.Fecha_Cita.Date < DateTime.Today)
            {
                ViewBag.Mensaje = "La fecha de la cita no puede ser anterior a la fecha actual.";

                CargarEncargados(model.Id_Usuario_Encargado);
                return View(model);
            }

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Citas/CrearCitaAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                TempData["CitaExitosa"] = "true";
                return RedirectToAction("Crear", "Citas");
            }

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;

            CargarEncargados(model.Id_Usuario_Encargado);
            return View(model);
        }

        #endregion

        #region Editar Cita

        [HttpGet]
        public IActionResult Editar(int id)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"Citas/ObtenerCitaAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<CitasModel>().Result;

                CargarEncargados(datos!.Id_Usuario_Encargado);

                return View(datos);
            }

            return RedirectToAction("Index", "Citas");
        }

        [HttpPost]
        public IActionResult Editar(CitasModel model)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            if (model.Fecha_Cita.Date < DateTime.Today)
            {
                ViewBag.Mensaje = "La fecha de la cita no puede ser anterior a la fecha actual.";

                CargarEncargados(model.Id_Usuario_Encargado);
                return View(model);
            }

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Citas/ActualizarCitaAPI";
            var response = client.PutAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "Citas");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;

            CargarEncargados(model.Id_Usuario_Encargado);
            return View(model);
        }

        #endregion

        #region Atender Cita

        [HttpGet]
        public IActionResult Atender(int id)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"Citas/ObtenerCitaAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<CitasModel>().Result;
                return View(datos);
            }

            return RedirectToAction("Index", "Citas");
        }

        [HttpPost]
        public IActionResult ConfirmarAtender(CitasModel model)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Citas/AtenderCitaAPI";
            var response = client.PutAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                TempData["CitaAtendida"] = "true";
                return RedirectToAction("Index", "Citas");
            }

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View("Atender", model);
        }

        #endregion
    }
}