using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class UsuariosMinisterioController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        private bool EsAdmin()
        {
            return HttpContext.Session.GetInt32("Id_Rol") == 1;
        }

        [HttpGet]
        public IActionResult AsignarPersona(int idMinisterio)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var urlMinisterio = _config["Valores:UrlApi"] + $"Ministerio/ObtenerMinisterioAPI?id={idMinisterio}";
            var responseMinisterio = client.GetAsync(urlMinisterio).Result;

            if (responseMinisterio.StatusCode != HttpStatusCode.OK)
                return RedirectToAction("Index", "Ministerio");

            var ministerio = responseMinisterio.Content.ReadFromJsonAsync<MinisterioModel>().Result;

            var urlUsuariosActuales = _config["Valores:UrlApi"] + $"UsuariosMinisterio/ListarUsuariosPorMinisterioAPI?idMinisterio={idMinisterio}";
            var usuariosActuales = client.GetFromJsonAsync<List<UsuariosMinisterioModel>>(urlUsuariosActuales).Result;

            var urlUsuariosDisponibles = _config["Valores:UrlApi"] + $"UsuariosMinisterio/ListarUsuariosDisponiblesMinisterioAPI?idMinisterio={idMinisterio}";
            var usuariosDisponibles = client.GetFromJsonAsync<List<UsuarioModel>>(urlUsuariosDisponibles).Result;

            ViewBag.Ministerio = ministerio;
            ViewBag.UsuariosActuales = usuariosActuales ?? new List<UsuariosMinisterioModel>();
            ViewBag.UsuariosDisponibles = usuariosDisponibles ?? new List<UsuarioModel>();

            var model = new UsuariosMinisterioModel
            {
                Id_Ministerio = idMinisterio,
                Fecha_Ingreso = DateTime.Now,
                Estado = "Activo"
            };

            return View(model);
        }

        [HttpPost]
        public IActionResult RegistrarDesdeMinisterio(UsuariosMinisterioModel model)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            if (model.Fecha_Ingreso == null)
                model.Fecha_Ingreso = DateTime.Now;

            model.Estado = "Activo";

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "UsuariosMinisterio/CrearUsuarioMinisterioAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("AsignarPersona", new { idMinisterio = model.Id_Ministerio });

            TempData["Mensaje"] = response.Content.ReadAsStringAsync().Result;
            return RedirectToAction("AsignarPersona", new { idMinisterio = model.Id_Ministerio });
        }

        [HttpGet]
        public IActionResult RegistrarMinisterio(int idUsuario)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var urlUsuario = _config["Valores:UrlApi"] + $"Usuario/ObtenerUsuarioAPI?id={idUsuario}";
            var responseUsuario = client.GetAsync(urlUsuario).Result;

            if (responseUsuario.StatusCode != HttpStatusCode.OK)
                return RedirectToAction("Index", "Usuario");

            var usuario = responseUsuario.Content.ReadFromJsonAsync<UsuarioModel>().Result;

            if (usuario!.Id_Rol == 1)
                return RedirectToAction("Index", "Usuario");

            var urlMinisteriosActuales = _config["Valores:UrlApi"] + $"UsuariosMinisterio/ListarMinisteriosPorUsuarioAPI?idUsuario={idUsuario}";
            var ministeriosActuales = client.GetFromJsonAsync<List<UsuariosMinisterioModel>>(urlMinisteriosActuales).Result;

            var urlMinisteriosDisponibles = _config["Valores:UrlApi"] + $"UsuariosMinisterio/ListarMinisteriosDisponiblesUsuarioAPI?idUsuario={idUsuario}";
            var ministeriosDisponibles = client.GetFromJsonAsync<List<MinisterioModel>>(urlMinisteriosDisponibles).Result;

            ViewBag.Usuario = usuario;
            ViewBag.MinisteriosActuales = ministeriosActuales ?? new List<UsuariosMinisterioModel>();
            ViewBag.MinisteriosDisponibles = ministeriosDisponibles ?? new List<MinisterioModel>();

            var model = new UsuariosMinisterioModel
            {
                Id_Usuario = idUsuario,
                Fecha_Ingreso = DateTime.Now,
                Estado = "Activo"
            };

            return View(model);
        }

        [HttpPost]
        public IActionResult RegistrarDesdeUsuario(UsuariosMinisterioModel model)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            if (model.Fecha_Ingreso == null)
                model.Fecha_Ingreso = DateTime.Now;

            model.Estado = "Activo";

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "UsuariosMinisterio/CrearUsuarioMinisterioAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
                return RedirectToAction("RegistrarMinisterio", new { idUsuario = model.Id_Usuario });

            TempData["Mensaje"] = response.Content.ReadAsStringAsync().Result;
            return RedirectToAction("RegistrarMinisterio", new { idUsuario = model.Id_Usuario });
        }

        [HttpPost]
        public IActionResult Salir(UsuariosMinisterioModel model, string origen)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "UsuariosMinisterio/SalirUsuarioMinisterioAPI";
            var response = client.PutAsJsonAsync(url, model).Result;

            if (origen == "ministerio")
                return RedirectToAction("AsignarPersona", new { idMinisterio = model.Id_Ministerio });

            return RedirectToAction("RegistrarMinisterio", new { idUsuario = model.Id_Usuario });
        }
    }
}