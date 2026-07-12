using System.ComponentModel.DataAnnotations;

namespace MinisterioGosenAPI.Models
{
    public class CitasModel
    {
        [Key]
        public int Id_Cita { get; set; }

        [Required(ErrorMessage = "La fecha de la cita es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime Fecha_Cita { get; set; } = DateTime.Today;

        [Required(ErrorMessage = "Debe seleccionar la persona que registra la cita")]
        public int Id_Usuario_Cita { get; set; }

        [Required(ErrorMessage = "Debe seleccionar el encargado")]
        public int Id_Usuario_Encargado { get; set; }

        [StringLength(200, ErrorMessage = "La observación inicial no puede superar 200 caracteres")]
        public string? Observacion_Inicial { get; set; }

        [StringLength(500, ErrorMessage = "El detalle no puede superar 500 caracteres")]
        public string? Detalle_Cita { get; set; }

        public string Estado { get; set; } = "Pendiente";

        // Solo se llenan cuando el SP hace JOIN con Usuario (spListarCitas)
        public string? Nombre_Usuario_Cita { get; set; }

        public string? Nombre_Usuario_Encargado { get; set; }
    }
}