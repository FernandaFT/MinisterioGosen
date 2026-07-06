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

            var url = _config["Valores:UrlApi"] +
                $"UsuariosMinisterio/ReportePersonasMinisterioAPI?buscar={buscar}&idMinisterio={idMinisterio}&estado={estado}&fechaInicio={fechaInicio:yyyy-MM-dd}&fechaFin={fechaFin:yyyy-MM-dd}";

            var response = client.GetAsync(url).Result;

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

            var url = _config["Valores:UrlApi"] + "Actividad/ListarActividadesAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode != HttpStatusCode.OK)
                throw new Exception("Error al consultar el reporte de actividades");

            var datos = response.Content.ReadFromJsonAsync<List<ActividadModel>>().Result
                ?? new List<ActividadModel>();

            if (!string.IsNullOrWhiteSpace(buscar))
            {
                var texto = buscar.ToLower();

                datos = datos.Where(x =>
                    (x.Nombre_Actividad != null && x.Nombre_Actividad.ToLower().Contains(texto)) ||
                    (x.Lugar != null && x.Lugar.ToLower().Contains(texto)) ||
                    (x.Descripcion_Ministerio != null && x.Descripcion_Ministerio.ToLower().Contains(texto))
                ).ToList();
            }

            if (idMinisterio != null)
                datos = datos.Where(x => x.Id_Ministerio == idMinisterio).ToList();

            if (idTipoActividad != null)
                datos = datos.Where(x => x.Id_Tipo_Actividad == idTipoActividad).ToList();

            if (fechaInicio != null)
                datos = datos.Where(x => x.Fecha_Ini.Date >= fechaInicio.Value.Date).ToList();

            if (fechaFin != null)
                datos = datos.Where(x => x.Fecha_Ini.Date <= fechaFin.Value.Date).ToList();

            CargarMinisterios(idMinisterio);
            CargarTiposActividad(idTipoActividad);

            ViewBag.Buscar = buscar;
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

            var url = _config["Valores:UrlApi"] + "Actividad/ListarActividadesAPI";
            var response = client.GetAsync(url).Result;

            if (response.StatusCode != HttpStatusCode.OK)
                throw new Exception("Error al consultar el reporte de horarios");

            var datos = response.Content.ReadFromJsonAsync<List<ActividadModel>>().Result
                ?? new List<ActividadModel>();

            if (!string.IsNullOrWhiteSpace(buscar))
            {
                var texto = buscar.ToLower();

                datos = datos.Where(x =>
                    (x.Nombre_Actividad != null && x.Nombre_Actividad.ToLower().Contains(texto)) ||
                    (x.Lugar != null && x.Lugar.ToLower().Contains(texto)) ||
                    (x.Descripcion_Ministerio != null && x.Descripcion_Ministerio.ToLower().Contains(texto))
                ).ToList();
            }

            if (idMinisterio != null)
                datos = datos.Where(x => x.Id_Ministerio == idMinisterio).ToList();

            if (fechaInicio != null)
                datos = datos.Where(x => x.Fecha_Ini.Date >= fechaInicio.Value.Date).ToList();

            if (fechaFin != null)
                datos = datos.Where(x => x.Fecha_Ini.Date <= fechaFin.Value.Date).ToList();

            CargarMinisterios(idMinisterio);

            ViewBag.Buscar = buscar;
            ViewBag.FechaInicio = fechaInicio?.ToString("yyyy-MM-dd");
            ViewBag.FechaFin = fechaFin?.ToString("yyyy-MM-dd");

            return View(datos.OrderBy(x => x.Fecha_Ini).ToList());
        }


    }
}