using System.ComponentModel.DataAnnotations;

namespace MinisterioGosenAPI.Models
{
    public class RecuperarAccesoRequestModel
    {
        [Required]
        public string Correo { get; set; } = string.Empty;
    }
}
