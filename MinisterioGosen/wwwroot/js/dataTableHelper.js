function inicializarDataTable(idTabla, opciones = {}) {
    const tabla = document.getElementById(idTabla);

    if (!tabla) {
        console.warn(`No se encontró la tabla con ID: ${idTabla}`);
        return;
    }

    const cantidadColumnas = tabla.querySelectorAll("thead th").length;
    const filas = Array.from(tabla.querySelectorAll("tbody tr"));

    const tieneRegistrosValidos = filas.some(fila => {
        const columnas = fila.querySelectorAll("td");

        return columnas.length === cantidadColumnas &&
            !fila.querySelector("td[colspan]");
    });

    if (!tieneRegistrosValidos) {
        return;
    }

    if (DataTable.isDataTable(tabla)) {
        return;
    }

    const configuracionPredeterminada = {
        pageLength: 10,
        lengthMenu: [5, 10, 25, 50],
        order: [],

        columnDefs: [
            {
                targets: -1,
                orderable: false,
                searchable: false
            }
        ],

        language: {
            search: "Buscar:",
            searchPlaceholder: "Buscar...",
            lengthMenu: "Mostrar _MENU_ registros",
            info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
            infoEmpty: "No hay registros disponibles",
            infoFiltered: "(filtrado de _MAX_ registros)",
            zeroRecords: "No se encontraron resultados",
            emptyTable: "No hay registros disponibles",

            paginate: {
                first: "Primero",
                last: "Último",
                next: "Siguiente",
                previous: "Anterior"
            }
        }
    };

    new DataTable(tabla, {
        ...configuracionPredeterminada,
        ...opciones
    });
}

/*
 * Inicializa automáticamente todas las tablas
 * que tengan el atributo data-datatable.
 */
document.addEventListener("DOMContentLoaded", function () {
    const tablas = document.querySelectorAll("table[data-datatable]");

    tablas.forEach(tabla => {
        inicializarDataTable(tabla.id);
    });
});