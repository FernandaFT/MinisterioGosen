using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class HomeController (
        IHttpClientFactory _http, 
        IConfiguration _config) : Controller
    {

        #region Iniciar Sesión

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Error(int statusCode = 0)
        {
            ViewBag.StatusCode = statusCode;

            if (statusCode == 404)
            {
                ViewBag.Titulo = "Página no encontrada";
                ViewBag.Mensaje = "La sección solicitada todavía no se encuentra disponible.";
            }
            else
            {
                ViewBag.Titulo = "Se presentó un inconveniente técnico";
                ViewBag.Mensaje = "Por favor, comuníquese con el administrador del sistema.";
            }

            return View("Error");
        }

        [HttpPost]
        public IActionResult Index(UsuarioModel model)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Home/IniciarSesionAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var datos = response.Content.ReadFromJsonAsync<UsuarioModel>().Result;

                HttpContext.Session.SetString("Autenticado", "1");
                HttpContext.Session.SetString("Nombre", datos!.Nombre);
                HttpContext.Session.SetInt32("Id_Usuario", datos!.Id_Usuario);
                HttpContext.Session.SetInt32("Id_Rol", datos!.Id_Rol);

                if (datos!.UsaContrasenaTemp)
                    return RedirectToAction("Configuracion", "Usuario");

                return RedirectToAction("Principal", "Home");

            }else if (response.StatusCode == HttpStatusCode.NotFound)
            {
                ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
                return View();
            }

            throw new Exception("Error al iniciar sesión");
        }

        #endregion

        #region Registro Usuario

        [HttpGet]
        public IActionResult Registrar()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Registrar(UsuarioModel model)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Home/RegistrarAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                return RedirectToAction("Index", "Home");

            }
            else if (response.StatusCode == HttpStatusCode.BadRequest)
            {
                ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
                return View();
            }

            throw new Exception("Error al registrar usuario");
        }

        #endregion

        #region Recuperar Acceso

        [HttpGet]
        public IActionResult RecuperarAcceso()
        {
            return View();
        }

        [HttpPost]
        public IActionResult RecuperarAcceso(UsuarioModel model)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Home/RecuperarAccesoAPI";
            var response = client.PostAsJsonAsync(url, model).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                return RedirectToAction("Index", "Home");

            }
            else if (response.StatusCode == HttpStatusCode.BadRequest 
                    || response.StatusCode == HttpStatusCode.NotFound)
            {
                ViewBag.Mensaje = response.Content.ReadAsStringAsync().Result;
                return View();
            }

            throw new Exception("Error al recuperar el acceso");
        }

        #endregion

        #region Cerrar Sesión

        [HttpGet]
        public IActionResult Salir()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Index", "Home");
        }

        #endregion

        [HttpGet]
        public IActionResult Principal()
        {
            return View();
        }
    }
}
