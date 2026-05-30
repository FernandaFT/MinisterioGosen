using Microsoft.AspNetCore.Mvc;
using MinisterioGosen.Models;
using System.Diagnostics;

namespace MinisterioGosen.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Principal()
        {
            return View();
        }

        #region Registro Usuario
        [HttpGet]
        public IActionResult Registrar()
        {
            return View();
        }
        #endregion

        #region Recuperar Acceso
        public IActionResult RecuperarAcceso()
        {
            return View();
        }
        #endregion
    }
}
