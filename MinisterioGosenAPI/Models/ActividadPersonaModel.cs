using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


namespace MinisterioGosenAPI.Models
{
    public class ActividadPersonaModel
    {
        [Key]
        public int Id_Actividad_Persona { get; set; }

        [Required(ErrorMessage = "Debe seleccionar una actividad")]
        public int Id_Actividad { get; set; }

        [Required(ErrorMessage = "Debe seleccionar una persona")]
        public int Id_Persona { get; set; }

        [Required(ErrorMessage = "La fecha es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime Fecha { get; set; } = DateTime.Today;

        [StringLength(10, ErrorMessage = "La hora no puede superar 10 caracteres")]
        public string? Hora { get; set; }


    }
}
