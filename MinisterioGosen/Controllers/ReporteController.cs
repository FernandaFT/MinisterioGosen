using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
    public class ReporteController(
        IHttpClientFactory _http,
        IConfiguration _config) : Controller
    {
        private bool EsAdmin()
        {
            return HttpContext.Session.GetInt32("Id_Rol") == 1;
        }

        private void CargarMinisterios(int? idMinisterioSeleccionado = null)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Ministerio/ListarMinisteriosAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var ministerios = response.Content.ReadFromJsonAsync<List<MinisterioModel>>().Result
                    ?? new List<MinisterioModel>();

                ViewBag.Ministerios = new SelectList(
                    ministerios,
                    "Id_Ministerio",
                    "Descripcion_Ministerio",
                    idMinisterioSeleccionado
                );
            }
            else
            {
                ViewBag.Ministerios = new SelectList(
                    new List<MinisterioModel>(),
                    "Id_Ministerio",
                    "Descripcion_Ministerio"
                );
            }
        }

        private void CargarTiposActividad(int? idTipoSeleccionado = null)
        {
            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "TipoActividad/ListarTiposActividadAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode == HttpStatusCode.OK)
            {
                var tipos = response.Content.ReadFromJsonAsync<List<TipoActividadModel>>().Result
                    ?? new List<TipoActividadModel>();

                ViewBag.TiposActividad = new SelectList(
                    tipos,
                    "Id_Tipo_Actividad",
                    "Nombre_Tipo",
                    idTipoSeleccionado
                );
            }
            else
            {
                ViewBag.TiposActividad = new SelectList(
                    new List<TipoActividadModel>(),
                    "Id_Tipo_Actividad",
                    "Nombre_Tipo"
                );
            }
        }

        [HttpGet]
        public IActionResult Index()
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            return View();
        }

        [HttpGet]
        public IActionResult PersonasMinisterio(
            string? buscar,
            int? idMinisterio,
            string? estado,
            DateTime? fechaInicio,
            DateTime? fechaFin)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "UsuariosMinisterio/ReportePersonasMinisterioAPI";

            var filtros = new ReportePersonasMinisterioFiltroModel
            {
                Buscar = buscar,
                IdMinisterio = idMinisterio,
                Estado = estado,
                FechaInicio = fechaInicio,
                FechaFin = fechaFin
            };

            var response = client.PostAsJsonAsync(url, filtros).Result;

            if (response.StatusCode != HttpStatusCode.OK)
                throw new Exception("Error al consultar el reporte de personas por ministerio");

            var datos = response.Content.ReadFromJsonAsync<List<UsuariosMinisterioModel>>().Result
            ?? new List<UsuariosMinisterioModel>();

            CargarMinisterios(idMinisterio);

            ViewBag.Buscar = buscar;
            ViewBag.IdMinisterio = idMinisterio;
            ViewBag.Estado = estado;
            ViewBag.FechaInicio = fechaInicio?.ToString("yyyy-MM-dd");
            ViewBag.FechaFin = fechaFin?.ToString("yyyy-MM-dd");

            return View(datos);
        }

        [HttpGet]
        public IActionResult Actividades(
            string? buscar,
            int? idMinisterio,
            int? idTipoActividad,
            DateTime? fechaInicio,
            DateTime? fechaFin)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Actividad/ReporteActividadesAPI";

            var filtros = new ReporteActividadesFiltroModel
            {
                Buscar = buscar,
                IdMinisterio = idMinisterio,
                IdTipoActividad = idTipoActividad,
                FechaInicio = fechaInicio,
                FechaFin = fechaFin
            };

            var response = client.PostAsJsonAsync(url, filtros).Result;

            if (response.StatusCode != HttpStatusCode.OK)
                throw new Exception("Error al consultar el reporte de actividades");

            var datos = response.Content.ReadFromJsonAsync<List<ActividadModel>>().Result
                ?? new List<ActividadModel>();

            CargarMinisterios(idMinisterio);
            CargarTiposActividad(idTipoActividad);

            ViewBag.Buscar = buscar;
            ViewBag.IdMinisterio = idMinisterio;
            ViewBag.IdTipoActividad = idTipoActividad;
            ViewBag.FechaInicio = fechaInicio?.ToString("yyyy-MM-dd");
            ViewBag.FechaFin = fechaFin?.ToString("yyyy-MM-dd");

            return View(datos.OrderBy(x => x.Fecha_Ini).ToList());
        }

        [HttpGet]
        public IActionResult Horarios(
            string? buscar,
            int? idMinisterio,
            DateTime? fechaInicio,
            DateTime? fechaFin)
        {
            if (!EsAdmin())
                return RedirectToAction("Error", "Home", new { statusCode = 403 });

            using var client = _http.CreateClient();

            var url = _config["Valores:UrlApi"] + "Actividad/ReporteHorariosAPI";

            var filtros = new ReporteHorariosFiltroModel
            {
                Buscar = buscar,
                IdMinisterio = idMinisterio,
                FechaInicio = fechaInicio,
                FechaFin = fechaFin
            };

            var response = client.PostAsJsonAsync(url, filtros).Result;

            if (response.StatusCode != HttpStatusCode.OK)
                throw new Exception("Error al consultar el reporte de horarios");

            var datos = response.Content.ReadFromJsonAsync<List<ActividadModel>>().Result
                ?? new List<ActividadModel>();

            CargarMinisterios(idMinisterio);

            ViewBag.Buscar = buscar;
            ViewBag.IdMinisterio = idMinisterio;
            ViewBag.FechaInicio = fechaInicio?.ToString("yyyy-MM-dd");
            ViewBag.FechaFin = fechaFin?.ToString("yyyy-MM-dd");

            return View(datos.OrderBy(x => x.Fecha_Ini).ToList());
        }


    }
}