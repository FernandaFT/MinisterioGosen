namespace MinisterioGosenAPI.Models
{
    public class UsuarioResponseModel
    {
        public int Id_Usuario { get; set; }
        public string Identificacion { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Correo { get; set; } = string.Empty;
        public string Estado { get; set; } = string.Empty;
        public bool UsaContrasenaTemp { get; set; }

        public int Id_Rol { get; set; }
        public string Rol { get; set; } = string.Empty;
    }
}