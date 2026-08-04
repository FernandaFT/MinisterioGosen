namespace MinisterioGosen.Models
{
    public class ChatbotResultadoModel
    {
        public ChatBotOpcionesModel? Seleccion { get; set; }

        public List<ChatBotOpcionesModel> Opciones { get; set; } = new();

        public ChatBotOpcionesModel? OpcionPadre { get; set; }
    }
}
    
