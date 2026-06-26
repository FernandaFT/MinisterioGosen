using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosen.Models
{
    [Table("Usuario")]
    public class UsuarioModel
    {
        [Key]
        public int Id_Usuario { get; set; }

        [Required(ErrorMessage = "El nombre de usuario es obligatorio")]
        [StringLength(50, ErrorMessage = "El usuario no puede superar 50 caracteres")]
        public string Nombre_Usuario { get; set; } = string.Empty;

        [Required(ErrorMessage = "El tipo de usuario es obligatorio")]
        [StringLength(20, ErrorMessage = "El tipo de usuario no puede superar 20 caracteres")]
        public string Tipo_Usuario { get; set; } = string.Empty;

        [Required(ErrorMessage = "La clave es obligatoria")]
        [StringLength(100, ErrorMessage = "La clave no puede superar 100 caracteres")]
        [DataType(DataType.Password)]
        public string Clave_Usuario { get; set; } = string.Empty;

        [Required(ErrorMessage = "Debe asociar una persona")]
        public int Id_Persona { get; set; }

    }
}
