using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosenAPI.Models
{
    public class RegistroUsuarioRequestModel
    {
        [Required]
        public string Identificacion { get; set; } = string.Empty;

        [Required]
        public string Nombre { get; set; } = string.Empty;
      
        [Required] 
        public string Correo { get; set; } = string.Empty;
       
        [Required] 
        public string Contrasena { get; set; } = string.Empty;

    }
}
