using System.ComponentModel.DataAnnotations;

namespace MinisterioGosenAPI.Models
{
    public class CambiarContrasenaRequestModel
    {
        [Required]
        public int Id_Usuario { get; set; }

        [Required]
        public string Contrasena { get; set; } = string.Empty;
    }
}
