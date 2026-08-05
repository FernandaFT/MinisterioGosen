using System;
using System.ComponentModel.DataAnnotations;

namespace MinisterioGosen.Models
{
	public class ActividadMinisterioModel
	{
		[Key]
		public int Id_Minis_Actividad { get; set; }

		[Required(ErrorMessage = "Debe seleccionar una actividad")]
		public int Id_Actividad { get; set; }

		[Required(ErrorMessage = "Debe seleccionar un ministerio")]
		public int Id_Ministerio { get; set; }

		[DataType(DataType.Date)]
		public DateTime? Fecha { get; set; }

		[StringLength(200, ErrorMessage = "La observación no puede superar los 200 caracteres")]
		public string? Observacion { get; set; }

		// Campos auxiliares utilizados para mostrar en las vistas
		public string? NombreActividad { get; set; }
		public string? NombreMinisterio { get; set; }
	}
}
