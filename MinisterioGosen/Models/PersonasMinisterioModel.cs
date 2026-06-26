using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosen.Models
{
    [Table("Personas_Ministerio")]
    public class PersonasMinisterioModel
    {
        [Key]
        public int Id_Persona_Ministerio { get; set; }

        [Required(ErrorMessage = "Debe seleccionar un ministerio")]
        public int Id_Ministerio { get; set; }

        [Required(ErrorMessage = "Debe seleccionar una persona")]
        public int Id_Persona { get; set; }

        [DataType(DataType.Date)]
        public DateTime? Fecha_Ingreso { get; set; }

        [DataType(DataType.Date)]
        public DateTime? Fecha_Salida { get; set; }

        [StringLength(20, ErrorMessage = "El estado no puede superar 20 caracteres")]
        public string? Estado { get; set; } = "Activo";

        [StringLength(200, ErrorMessage = "La observación no puede superar 200 caracteres")]
        public string? Observacion { get; set; }

    }
}
