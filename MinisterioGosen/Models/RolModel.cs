using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MinisterioGosen.Models
{
    public class RolModel
    {
        public int Id_Rol { get; set; }
        public string Descripcion { get; set; } = string.Empty;
    }
}