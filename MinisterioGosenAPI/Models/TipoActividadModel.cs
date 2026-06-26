using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosenAPI.Models
{
    [Table("Tipo_Actividad")]
    public class TipoActividadModel
    {
        [Key]
        public int Id_Tipo_Actividad { get; set; }

        [Required(ErrorMessage = "El nombre del tipo de actividad es obligatorio")]
        [StringLength(50, ErrorMessage = "El nombre no puede superar 50 caracteres")]
        public string Nombre_Tipo { get; set; } = string.Empty;


    }
}
