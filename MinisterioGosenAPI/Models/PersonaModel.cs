using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosenAPI.Models
{
    [Table("Persona")]
    public class PersonaModel
    {
        [Key]
        public int Id_Persona { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio")]
        [StringLength(50, ErrorMessage = "El nombre no puede superar 50 caracteres")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "El primer apellido es obligatorio")]
        [StringLength(50, ErrorMessage = "El primer apellido no puede superar 50 caracteres")]
        public string Apellido1 { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "El segundo apellido no puede superar 50 caracteres")]
        public string? Apellido2 { get; set; }

        [Required(ErrorMessage = "La identificación es obligatoria")]
        [StringLength(20, ErrorMessage = "La identificación no puede superar 20 caracteres")]
        public string Identificacion { get; set; } = string.Empty;

        [DataType(DataType.Date)]
        public DateTime? Fecha_Nacimiento { get; set; }

        [Required(ErrorMessage = "Debe indicar si asiste al Ministerio Gosen")]
        [StringLength(1)]
        [RegularExpression("^[SN]$", ErrorMessage = "Use S para Sí o N para No")]
        public string Asiste_ministerio_gosen { get; set; } = "S";

        [StringLength(15, ErrorMessage = "El teléfono 1 no puede superar 15 caracteres")]
        public string? Telefono1 { get; set; }

        [StringLength(15, ErrorMessage = "El teléfono 2 no puede superar 15 caracteres")]
        public string? Telefono2 { get; set; }

        [StringLength(200, ErrorMessage = "La dirección no puede superar 200 caracteres")]
        public string? Direccion { get; set; }

        [StringLength(1)]
        [RegularExpression("^[AI]$", ErrorMessage = "Use A para Activo o I para Inactivo")]
        public string Estado { get; set; } = "A";


    }
}
