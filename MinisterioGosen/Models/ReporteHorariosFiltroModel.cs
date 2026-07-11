namespace MinisterioGosen.Models
{
    public class ReporteHorariosFiltroModel
    {
        public string? Buscar { get; set; }
        public int? IdMinisterio { get; set; }
        public int? IdTipoActividad { get; set; }
        public DateTime? FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }

    }
}
