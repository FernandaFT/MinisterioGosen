using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosenAPI.Models
{
    [Table("Citas")]
    public class CitasModel
    {
        [Key]
        public int Id_Cita { get; set; }

        [Required(ErrorMessage = "La fecha de la cita es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime Fecha_Cita { get; set; } = DateTime.Today;

        [Required(ErrorMessage = "Debe seleccionar la persona de la cita")]
        public int Id_Persona_Cita { get; set; }

        [Required(ErrorMessage = "Debe seleccionar el encargado")]
        public int Id_Persona_Encargado { get; set; }

        [StringLength(200, ErrorMessage = "La observación inicial no puede superar 200 caracteres")]
        public string? Observacion_Inicial { get; set; }

        [StringLength(500, ErrorMessage = "El detalle no puede superar 500 caracteres")]
        public string? Detalle_Cita { get; set; }


    }
}
