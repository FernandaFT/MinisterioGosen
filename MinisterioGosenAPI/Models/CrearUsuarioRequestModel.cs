using System.ComponentModel.DataAnnotations;

namespace MinisterioGosenAPI.Models
{
    public class CrearUsuarioRequestModel
    {
        public string Identificacion { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Correo { get; set; } = string.Empty;
        public string Contrasena { get; set; } = string.Empty;
        public int Id_Rol { get; set; }
    }
}