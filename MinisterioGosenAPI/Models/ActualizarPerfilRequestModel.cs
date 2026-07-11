using System.ComponentModel.DataAnnotations;

namespace MinisterioGosenAPI.Models
{
    public class ActualizarPerfilRequestModel
    {
        [Required]
        public int Id_Usuario { get; set; }

        [Required]
        public string Identificacion { get; set; } = string.Empty;

        [Required]
        public string Nombre { get; set; } = string.Empty;

        [Required]
        public string Correo { get; set; } = string.Empty;
       
    }
}