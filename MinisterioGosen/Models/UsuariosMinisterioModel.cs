namespace MinisterioGosen.Models
{
    public class UsuariosMinisterioModel
    {
        public int Id_Usuario_Ministerio { get; set; }

        public int Id_Ministerio { get; set; }

        public int Id_Usuario { get; set; }

        public DateTime? Fecha_Ingreso { get; set; }

        public DateTime? Fecha_Salida { get; set; }

        public string? Estado { get; set; } = "Activo";

        public string? Observacion { get; set; }


        public string? Nombre { get; set; }

        public string? Correo { get; set; }

        public string? Rol { get; set; }

        public string? Descripcion_Ministerio { get; set; }
    }
}