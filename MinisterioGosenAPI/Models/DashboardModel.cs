namespace MinisterioGosenAPI.Models
{
    public class DashboardModel
    {
        // Tarjetas principales
        public int TotalPersonas { get; set; }
        public int TotalActividades { get; set; }
        public int TotalMinisterios { get; set; }
        public int TotalCitasPendientes { get; set; }

        // Gráficos
        public List<DashboardGraficoModel> CitasPorEstado { get; set; } = new();

        public List<DashboardGraficoModel> ActividadesPorMes { get; set; } = new();

        public List<DashboardGraficoModel> AsistenciaPorActividad { get; set; } = new();

        public List<DashboardGraficoModel> PersonasPorMinisterio { get; set; } = new();
    }

    public class DashboardGraficoModel
    {
        public string Etiqueta { get; set; } = string.Empty;

        public int Cantidad { get; set; }
    }

}
