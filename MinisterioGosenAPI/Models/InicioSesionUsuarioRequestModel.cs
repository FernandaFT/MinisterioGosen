using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosenAPI.Models
{
    public class InicioSesionUsuarioRequestModel
    {
        [Required] 
        public string Correo { get; set; } = string.Empty;
       
        [Required] 
        public string Contrasena { get; set; } = string.Empty;

    }
}
