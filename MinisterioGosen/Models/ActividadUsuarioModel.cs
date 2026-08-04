using System;
using System.ComponentModel.DataAnnotations;

namespace MinisterioGosen.Models
{
	public class ActividadUsuarioModel
	{
		[Key]
		public int Id_Actividad_Usuario { get; set; }

		[Required(ErrorMessage = "Debe seleccionar una actividad")]
		public int Id_Actividad { get; set; }

		[Required(ErrorMessage = "Debe seleccionar un usuario")]
		public int Id_Usuario { get; set; }

		[Required(ErrorMessage = "Debe ingresar una fecha")]
		[DataType(DataType.Date)]
		public DateTime Fecha { get; set; }

		[DataType(DataType.Time)]
		public TimeSpan? Hora { get; set; }

		[StringLength(200, ErrorMessage = "La observación no puede superar los 200 caracteres")]
		public string? Observacion { get; set; }

		// 🔹 Campos auxiliares para mostrar en las vistas
		public string? NombreActividad { get; set; }
		public string? NombreUsuario { get; set; }
		public string? IdentificacionUsuario { get; set; }
	}
}

