using Microsoft.AspNetCore.Http.HttpResults;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography.Xml;

namespace MinisterioGosen.Models
{
    public class ChatBotOpcionesModel
    {
        [DisplayName("Id Opción")]
        public int IdOpcion { get; set; }
        [DisplayName("Texto Opción")]
        [StringLength(200)]
        public string TextoOpcion { get; set; } = string.Empty;
        [DisplayName("Respuesta")]
        public string? Respuesta { get; set; } = string.Empty;
        [DisplayName("Id Opción Padre")]
        public int? IdOpcionPadre { get; set; }
        [DisplayName("Orden")]  
        public int Orden { get; set; }
        public bool Activo { get; set; }


    }
}
