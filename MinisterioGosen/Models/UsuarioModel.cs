
namespace MinisterioGosen.Models
{

    public class UsuarioModel
    {
        public int Id_Usuario { get; set; }
        public string Identificacion { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Correo { get; set; } = string.Empty;
        public string Contrasena { get; set; } = string.Empty;
        public bool UsaContrasenaTemp { get; set; }
        public string ConfirmarContrasena { get; set; } = string.Empty;
    }
}
