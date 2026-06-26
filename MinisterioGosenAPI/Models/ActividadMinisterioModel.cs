using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosenAPI.Models
{
    [Table("Actividades_Ministerio")]
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

        [StringLength(200, ErrorMessage = "La observación no puede superar 200 caracteres")]
        public string? Observacion { get; set; }


    }
}
