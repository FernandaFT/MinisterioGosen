/*
 * Paginación simple para grillas de tarjetas (no tablas).
 * Uso: agregar data-card-pagination y opcionalmente
 * data-page-size="N" al contenedor de las tarjetas (ej. <div class="row g-4">).
 */
function inicializarPaginacionTarjetas(contenedor, tamanoPagina) {
    const items = Array.from(contenedor.children);

    if (items.length <= tamanoPagina) {
        return;
    }

    const totalPaginas = Math.ceil(items.length / tamanoPagina);
    let paginaActual = 1;

    const controles = document.createElement("div");
    controles.className = "d-flex justify-content-center align-items-center gap-2 mt-4 flex-wrap";
    contenedor.insertAdjacentElement("afterend", controles);

    function mostrarPagina(pagina) {
        paginaActual = pagina;

        const inicio = (pagina - 1) * tamanoPagina;
        const fin = inicio + tamanoPagina;

        items.forEach(function (item, index) {
            item.style.display = (index >= inicio && index < fin) ? "" : "none";
        });

        renderControles();
    }

    function crearBoton(texto, deshabilitado, clases, alHacerClick) {
        const boton = document.createElement("button");
        boton.type = "button";
        boton.textContent = texto;
        boton.className = clases;
        boton.disabled = deshabilitado;
        boton.addEventListener("click", alHacerClick);
        return boton;
    }

    function renderControles() {
        controles.innerHTML = "";

        controles.appendChild(
            crearBoton("Anterior", paginaActual === 1,
                "btn btn-outline-secondary btn-sm rounded-pill px-3",
                function () { mostrarPagina(paginaActual - 1); })
        );

        for (let i = 1; i <= totalPaginas; i++) {
            const esActual = i === paginaActual;

            controles.appendChild(
                crearBoton(String(i), false,
                    "btn btn-sm rounded-pill px-3 " + (esActual ? "btn-primary" : "btn-outline-secondary"),
                    function () { mostrarPagina(i); })
            );
        }

        controles.appendChild(
            crearBoton("Siguiente", paginaActual === totalPaginas,
                "btn btn-outline-secondary btn-sm rounded-pill px-3",
                function () { mostrarPagina(paginaActual + 1); })
        );
    }

    mostrarPagina(1);
}

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-card-pagination]").forEach(function (contenedor) {
        const tamanoPagina = parseInt(contenedor.getAttribute("data-page-size"), 10) || 6;
        inicializarPaginacionTarjetas(contenedor, tamanoPagina);
    });
});