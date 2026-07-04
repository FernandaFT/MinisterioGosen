using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
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

        [HttpGet]
        public IActionResult Index()
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/ListarUsuariosAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<List<UsuarioModel>>().Result;
                return View(datos);
            }

            throw new Exception("Error al consultar usuarios");
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

        private void CargarRoles(int? idRolSeleccionado = null)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/ListarRolesAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var roles = response.Content.ReadFromJsonAsync<List<RolModel>>().Result;
                ViewBag.Roles = new SelectList(roles, "Id_Rol", "Descripcion", idRolSeleccionado);
            }
            else
            {
                ViewBag.Roles = new SelectList(new List<RolModel>(), "Id_Rol", "Descripcion");
            }
        }

        [HttpGet]
        public IActionResult Editar(int id)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"Usuario/ObtenerUsuarioAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<UsuarioModel>().Result;

                CargarRoles(datos!.Id_Rol);
                return View(datos);
            }

            return RedirectToAction("Index", "Usuario");
        }

        [HttpPost]
        public IActionResult Editar(UsuarioModel model)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/ActualizarUsuarioAPI";
            var response = client.PutAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                return RedirectToAction("Index", "Usuario");
            }

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            CargarRoles(model.Id_Rol);
            return View(model);
        }

        [HttpGet]
        public IActionResult Desactivar(int id)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + $"Usuario/ObtenerUsuarioAPI?id={id}";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<UsuarioModel>().Result;
                return View(datos);
            }

            return RedirectToAction("Index", "Usuario");
        }

        [HttpPost]
        public IActionResult ConfirmarDesactivar(UsuarioModel model)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/DesactivarUsuarioAPI";

            var request = new
            {
                Id_Usuario = model.Id_Usuario
            };

            var response = client.PutAsJsonAsync(url, request).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "Usuario");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            return View("Desactivar", model);
        }

        [HttpGet]
        public IActionResult Activar(int id)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/ActivarUsuarioAPI";

            var request = new
            {
                Id_Usuario = id
            };

            var response = client.PutAsJsonAsync(url, request).Result;

            return RedirectToAction("Index", "Usuario");
        }

        [HttpGet]
        public IActionResult Crear()
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            CargarRoles();
            return View();
        }

        [HttpPost]
        public IActionResult Crear(UsuarioModel model)
        {
            if (HttpContext.Session.GetInt32("Id_Rol") != 1)
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Usuario/CrearUsuarioAPI";

            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("Index", "Usuario");

            ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
            CargarRoles(model.Id_Rol);

            return View(model);
        }
        #endregion
    }
}
