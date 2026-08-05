document.addEventListener("DOMContentLoaded", function () {
    const dashboardDataElement =
        document.getElementById("dashboard-data");

    if (!dashboardDataElement) {
        return;
    }

    if (typeof Chart === "undefined") {
        console.error("Chart.js no se encuentra cargado.");
        return;
    }

    let dashboardData;

    try {
        dashboardData = JSON.parse(
            dashboardDataElement.textContent
        );
    } catch (error) {
        console.error(
            "No fue posible leer los datos del dashboard.",
            error
        );

        return;
    }

    const colores = {
        verdeOscuro: "#07574f",
        verdePrincipal: "#168c62",
        verdeClaro: "#72b8a3",
        azul: "#146ef5",
        azulClaro: "#78a9f8",
        dorado: "#d19a00",
        amarillo: "#f2c94c",
        gris: "#9aa8a5",
        rojo: "#d9534f"
    };

    const paleta = [
        colores.dorado,
        colores.verdePrincipal,
        colores.rojo,
        colores.azul,
        colores.verdeClaro,
        colores.azulClaro,
        colores.amarillo,
        colores.gris,
        colores.verdeOscuro
    ];

    configurarChartJs();

    crearGraficoCitas();
    crearGraficoActividades();
    crearGraficoAsistencias();
    crearGraficoMinisterios();

    function configurarChartJs() {
        Chart.defaults.font.family =
            "'Inter', 'Segoe UI', Arial, sans-serif";

        Chart.defaults.color = "#687573";

        Chart.defaults.plugins.tooltip.backgroundColor =
            "#0b3935";

        Chart.defaults.plugins.tooltip.titleColor =
            "#ffffff";

        Chart.defaults.plugins.tooltip.bodyColor =
            "#ffffff";

        Chart.defaults.plugins.tooltip.padding = 12;
        Chart.defaults.plugins.tooltip.cornerRadius = 10;
    }

    function crearGraficoCitas() {
        const canvas =
            document.getElementById("graficoCitasEstado");

        if (!canvas) {
            return;
        }

        const citas = dashboardData.citasPorEstado ?? [];

        if (citas.length === 0) {
            mostrarSinDatos(canvas);
            return;
        }

        new Chart(canvas, {
            type: "doughnut",

            data: {
                labels: citas.map(function (item) {
                    return item.etiqueta;
                }),

                datasets: [
                    {
                        data: citas.map(function (item) {
                            return item.cantidad;
                        }),

                        backgroundColor: paleta,
                        borderColor: "#ffffff",
                        borderWidth: 4,
                        hoverOffset: 8
                    }
                ]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: "65%",

                plugins: {
                    legend: {
                        position: "bottom",

                        labels: {
                            usePointStyle: true,
                            pointStyle: "circle",
                            padding: 18,
                            boxWidth: 10
                        }
                    },

                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                const valores =
                                    context.dataset.data;

                                const total = valores.reduce(
                                    function (acumulado, valor) {
                                        return acumulado + valor;
                                    },
                                    0
                                );

                                const porcentaje =
                                    total > 0
                                        ? (
                                            context.raw * 100 / total
                                        ).toFixed(1)
                                        : "0.0";

                                return (
                                    context.label +
                                    ": " +
                                    context.raw +
                                    " (" +
                                    porcentaje +
                                    "%)"
                                );
                            }
                        }
                    }
                }
            }
        });
    }

    function crearGraficoActividades() {
        const canvas =
            document.getElementById("graficoActividadesMes");

        if (!canvas) {
            return;
        }

        const actividades =
            dashboardData.actividadesPorMes ?? [];

        if (actividades.length === 0) {
            mostrarSinDatos(canvas);
            return;
        }

        new Chart(canvas, {
            type: "line",

            data: {
                labels: actividades.map(function (item) {
                    return item.etiqueta;
                }),

                datasets: [
                    {
                        label: "Actividades",

                        data: actividades.map(function (item) {
                            return item.cantidad;
                        }),

                        borderColor: colores.verdePrincipal,
                        backgroundColor:
                            "rgba(22, 140, 98, 0.14)",

                        borderWidth: 3,
                        pointBackgroundColor:
                            colores.verdePrincipal,

                        pointBorderColor: "#ffffff",
                        pointBorderWidth: 3,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        fill: true,
                        tension: 0.35
                    }
                ]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                interaction: {
                    intersect: false,
                    mode: "index"
                },

                scales: {
                    x: {
                        grid: {
                            display: false
                        },

                        ticks: {
                            maxRotation: 0
                        }
                    },

                    y: {
                        beginAtZero: true,

                        ticks: {
                            precision: 0,
                            stepSize: 1
                        },

                        grid: {
                            color:
                                "rgba(7, 87, 79, 0.08)"
                        }
                    }
                },

                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    }

    function crearGraficoAsistencias() {
        const canvas =
            document.getElementById(
                "graficoAsistenciaActividad"
            );

        if (!canvas) {
            return;
        }

        const asistencias =
            dashboardData.asistenciaPorActividad ?? [];

        if (asistencias.length === 0) {
            mostrarSinDatos(canvas);
            return;
        }

        new Chart(canvas, {
            type: "bar",

            data: {
                labels: asistencias.map(function (item) {
                    return item.etiqueta;
                }),

                datasets: [
                    {
                        label: "Asistentes",

                        data: asistencias.map(function (item) {
                            return item.cantidad;
                        }),

                        backgroundColor:
                            "rgba(20, 110, 245, 0.78)",

                        borderColor: colores.azul,
                        borderWidth: 1,
                        borderRadius: 8,
                        borderSkipped: false,
                        barThickness: 18
                    }
                ]
            },

            options: {
                indexAxis: "y",
                responsive: true,
                maintainAspectRatio: false,

                scales: {
                    x: {
                        beginAtZero: true,

                        ticks: {
                            precision: 0,
                            stepSize: 1
                        },

                        grid: {
                            color:
                                "rgba(20, 110, 245, 0.08)"
                        }
                    },

                    y: {
                        grid: {
                            display: false
                        }
                    }
                },

                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    }

    function crearGraficoMinisterios() {
        const canvas =
            document.getElementById(
                "graficoPersonasMinisterio"
            );

        if (!canvas) {
            return;
        }

        const ministerios =
            dashboardData.personasPorMinisterio ?? [];

        if (ministerios.length === 0) {
            mostrarSinDatos(canvas);
            return;
        }

        new Chart(canvas, {
            type: "bar",

            data: {
                labels: ministerios.map(function (item) {
                    return item.etiqueta;
                }),

                datasets: [
                    {
                        label: "Personas",

                        data: ministerios.map(function (item) {
                            return item.cantidad;
                        }),

                        backgroundColor:
                            "rgba(7, 87, 79, 0.80)",

                        borderColor: colores.verdeOscuro,
                        borderWidth: 1,
                        borderRadius: 8,
                        borderSkipped: false,
                        barThickness: 18
                    }
                ]
            },

            options: {
                indexAxis: "y",
                responsive: true,
                maintainAspectRatio: false,

                scales: {
                    x: {
                        beginAtZero: true,

                        ticks: {
                            precision: 0,
                            stepSize: 1
                        },

                        grid: {
                            color:
                                "rgba(7, 87, 79, 0.08)"
                        }
                    },

                    y: {
                        grid: {
                            display: false
                        }
                    }
                },

                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    }

    function mostrarSinDatos(canvas) {
        const contenedor = canvas.parentElement;

        canvas.remove();

        contenedor.innerHTML = `
            <div class="dashboard-no-data">
                <i class="bi bi-bar-chart"></i>
                <h6>No hay información disponible</h6>
                <p>
                    Todavía no existen registros para este gráfico.
                </p>
            </div>
        `;
    }
});