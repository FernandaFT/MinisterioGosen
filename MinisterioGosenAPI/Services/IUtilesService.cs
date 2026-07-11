namespace MinisterioGosenAPI.Services
{
    public interface IUtilesService
    {
        string GenerarContrasena();
        Task EnviarCorreoAsync(string destinatario, string asunto, string cuerpoHtml);
    }
}
