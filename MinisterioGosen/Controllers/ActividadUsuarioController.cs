using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MinisterioGosen.Models;
using System.Net;

namespace MinisterioGosen.Controllers
{
	public class ActividadUsuarioController(
		IHttpClientFactory _http,
		IConfiguration _config) : Controller
	{
		private bool EsAdmin()
		{
			return HttpContext.Session.GetInt32("Id_Rol") == 1;
		}

		private void CargarActividades(int? idActividadSeleccionada = null)
		{
			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + "Actividad/ListarActividadesAPI";
			var response = client.GetAsync(url).Result;

			if (response.StatusCode == HttpStatusCode.OK)
			{
				var actividades = response.Content.ReadFromJsonAsync<List<ActividadModel>>().Result;

				// Ordenar alfabéticamente por Nombre_Actividad
				var actividadesOrdenadas = actividades?
					.OrderBy(a => a.Nombre_Actividad)
					.ToList() ?? new List<ActividadModel>();

				ViewBag.Actividades = new SelectList(
					actividadesOrdenadas,
					"Id_Actividad",
					"Nombre_Actividad",
					idActividadSeleccionada
				);
			}
			else
			{
				ViewBag.Actividades = new SelectList(new List<ActividadModel>(), "Id_Actividad", "Nombre_Actividad");
			}
		}

		private void CargarUsuarios(int? idUsuarioSeleccionado = null)
		{
			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + "Usuario/ListarUsuariosAPI";
			var response = client.GetAsync(url).Result;

			if (response.StatusCode == HttpStatusCode.OK)
			{
				var usuarios = response.Content.ReadFromJsonAsync<List<UsuarioModel>>().Result?
					.Select(u => new {
						u.Id_Usuario,
						Texto = u.Nombre
					}).ToList();

				ViewBag.Usuarios = new SelectList(usuarios, "Id_Usuario", "Texto", idUsuarioSeleccionado);
			}
			else
			{
				ViewBag.Usuarios = new SelectList(new List<UsuarioModel>(), "Id_Usuario", "Nombre_Usuario");
			}
		}

		[HttpGet]
		public IActionResult Index(int? idUsuario = null, int? idActividad = null)
		{
			if (!EsAdmin())
				return RedirectToAction("Error", "Home", new { statusCode = 403 });

			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + "ActividadUsuario/ListarActividadUsuarioAPI";

			var queryParams = new List<string>();
			if (idUsuario.HasValue)
				queryParams.Add($"idUsuario={idUsuario.Value}");
			if (idActividad.HasValue)
				queryParams.Add($"idActividad={idActividad.Value}");

			if (queryParams.Any())
				url += "?" + string.Join("&", queryParams);

			var response = client.GetAsync(url).Result;

			if (response.StatusCode == HttpStatusCode.OK)
			{
				var datos = response.Content.ReadFromJsonAsync<List<ActividadUsuarioModel>>().Result;
				CargarUsuarios(idUsuario);
				CargarActividades(idActividad);
				return View(datos ?? new List<ActividadUsuarioModel>());
			}

			ViewBag.Mensaje = "Error al consultar las participaciones.";
			CargarUsuarios(idUsuario);
			CargarActividades(idActividad);
			return View(new List<ActividadUsuarioModel>());
		}

		[HttpGet]
		public IActionResult Crear()
		{
			if (!EsAdmin())
				return RedirectToAction("Error", "Home", new { statusCode = 403 });

			CargarActividades();
			CargarUsuarios();

			return View();
		}

		[HttpPost]
		public IActionResult Crear(ActividadUsuarioModel model)
		{
			if (!EsAdmin())
				return RedirectToAction("Error", "Home", new { statusCode = 403 });

			if (!string.IsNullOrWhiteSpace(model.Observacion))
				model.Observacion = model.Observacion.Trim();

			if (!ModelState.IsValid)
			{
				CargarActividades(model.Id_Actividad);
				CargarUsuarios(model.Id_Usuario);
				return View(model);
			}

			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + "ActividadUsuario/CrearActividadUsuarioAPI";
			var response = client.PostAsJsonAsync(url, model).Result;

			if (response.StatusCode == HttpStatusCode.OK)
				return RedirectToAction("Index", "ActividadUsuario");

			var contenido = response.Content.ReadAsStringAsync().Result;
			try
			{
				var json = System.Text.Json.JsonDocument.Parse(contenido);
				ViewBag.Mensaje = json.RootElement.GetProperty("message").GetString();
			}
			catch
			{
				ViewBag.Mensaje = contenido;
			}

			CargarActividades(model.Id_Actividad);
			CargarUsuarios(model.Id_Usuario);
			return View(model);
		}

		[HttpGet]
		public IActionResult Editar(int id)
		{
			if (!EsAdmin())
				return RedirectToAction("Error", "Home", new { statusCode = 403 });

			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + $"ActividadUsuario/ObtenerActividadUsuarioAPI?id={id}";
			var response = client.GetAsync(url).Result;

			if (response.StatusCode == HttpStatusCode.OK)
			{
				var datos = response.Content.ReadFromJsonAsync<ActividadUsuarioModel>().Result;
				if (datos != null)
				{
					CargarActividades(datos.Id_Actividad);
					CargarUsuarios(datos.Id_Usuario);
					return View(datos);
				}
				else
				{
					ViewBag.Mensaje = "No se encontró la participación.";
					return RedirectToAction("Index", "ActividadUsuario");
				}
			}

			ViewBag.Mensaje = "Error al consultar la participación.";
			return RedirectToAction("Index", "ActividadUsuario");
		}

		[HttpPost]
		public IActionResult Editar(ActividadUsuarioModel model)
		{
			if (!EsAdmin())
				return RedirectToAction("Error", "Home", new { statusCode = 403 });

			if (!string.IsNullOrWhiteSpace(model.Observacion))
				model.Observacion = model.Observacion.Trim();

			if (!ModelState.IsValid)
			{
				CargarActividades(model.Id_Actividad);
				CargarUsuarios(model.Id_Usuario);
				return View(model);
			}

			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + "ActividadUsuario/ActualizarActividadUsuarioAPI";
			var response = client.PutAsJsonAsync(url, model).Result;

			if (response.StatusCode == HttpStatusCode.OK)
				return RedirectToAction("Index", "ActividadUsuario");

			var contenido = response.Content.ReadAsStringAsync().Result;
			try
			{
				var json = System.Text.Json.JsonDocument.Parse(contenido);
				ViewBag.Mensaje = json.RootElement.GetProperty("message").GetString();
			}
			catch
			{
				ViewBag.Mensaje = contenido;
			}

			CargarActividades(model.Id_Actividad);
			CargarUsuarios(model.Id_Usuario);
			return View(model);
		}

		[HttpGet]
		public IActionResult Eliminar(int id)
		{
			if (!EsAdmin())
				return RedirectToAction("Error", "Home", new { statusCode = 403 });

			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + $"ActividadUsuario/ObtenerActividadUsuarioAPI?id={id}";
			var response = client.GetAsync(url).Result;

			if (response.StatusCode == HttpStatusCode.OK)
			{
				var datos = response.Content.ReadFromJsonAsync<ActividadUsuarioModel>().Result;
				return View(datos ?? new ActividadUsuarioModel());
			}

			ViewBag.Mensaje = "Error al consultar la participación.";
			return RedirectToAction("Index", "ActividadUsuario");
		}

		[HttpPost]
		public IActionResult ConfirmarEliminar(ActividadUsuarioModel model)
		{
			if (!EsAdmin())
				return RedirectToAction("Error", "Home", new { statusCode = 403 });

			using var client = _http.CreateClient();
			var url = _config["Valores:UrlApi"] + $"ActividadUsuario/EliminarActividadUsuarioAPI?id={model.Id_Actividad_Usuario}";
			var response = client.DeleteAsync(url).Result;

			if (response.StatusCode == HttpStatusCode.OK)
				return RedirectToAction("Index", "ActividadUsuario");

			var contenido = response.Content.ReadAsStringAsync().Result;
			try
			{
				var json = System.Text.Json.JsonDocument.Parse(contenido);
				ViewBag.Mensaje = json.RootElement.GetProperty("message").GetString();
			}
			catch
			{
				ViewBag.Mensaje = contenido;
			}

			return View("Eliminar", model);
		}
	}
}