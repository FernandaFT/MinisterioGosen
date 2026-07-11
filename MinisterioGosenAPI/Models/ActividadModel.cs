using System.ComponentModel.DataAnnotations;

namespace MinisterioGosenAPI.Models
{
    public class ActividadModel
    {
        [Key]
        public int Id_Actividad { get; set; }

        [Required(ErrorMessage = "El nombre de la actividad es obligatorio")]
        [StringLength(100, ErrorMessage = "El nombre no puede superar 100 caracteres")]
        public string Nombre_Actividad { get; set; } = string.Empty;

        [Required(ErrorMessage = "La fecha de inicio es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime Fecha_Ini { get; set; } = DateTime.Today;

        [DataType(DataType.Date)]
        public DateTime? Fecha_Fin { get; set; }

        [StringLength(100, ErrorMessage = "El lugar no puede superar 100 caracteres")]
        public string? Lugar { get; set; }

        public DateTime? Hora_Ini { get; set; }

        public DateTime? Hora_Fin { get; set; }

        [Required(ErrorMessage = "Debe seleccionar un tipo de actividad")]
        public int Id_Tipo_Actividad { get; set; }

        public string Nombre_Tipo { get; set; } = string.Empty;

        public int? Id_Ministerio { get; set; }

        public string? Descripcion_Ministerio { get; set; }

        public string? Observacion_Ministerio_Actividad { get; set; }
    }
}