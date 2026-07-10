using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosenAPI.Models
{
    public class MinisterioModel
    {
        [Key]
        public int Id_Ministerio { get; set; }

        [Required(ErrorMessage = "La descripción del ministerio es obligatoria")]
        [StringLength(100, ErrorMessage = "La descripción no puede superar 100 caracteres")]
        public string Descripcion_Ministerio { get; set; } = string.Empty;

        [StringLength(200, ErrorMessage = "Las observaciones no pueden superar 200 caracteres")]
        public string? Observaciones_Ministerio { get; set; }

    }
}
