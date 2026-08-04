(function () {
    const root = document.getElementById("chatbotRoot");

    if (!root) {
        return;
    }

    const urlConsultarChatbot = root.dataset.url;

    document.addEventListener("DOMContentLoaded", iniciarChatbot);

    function iniciarChatbot() {
        const datosIniciales = leerJson("chatbotDatosIniciales");
        const mensajeInicial = leerJson("chatbotMensajeInicial");

        if (mensajeInicial) {
            mostrarError(mensajeInicial);
            return;
        }

        mostrarOpciones(datosIniciales);
    }

    function leerJson(idElemento) {
        const elemento = document.getElementById(idElemento);

        if (!elemento) {
            return null;
        }

        const contenido = elemento.textContent.trim();

        if (!contenido) {
            return null;
        }

        return JSON.parse(contenido);
    }

    async function consultarChatbot(idOpcion = null) {
        let url = urlConsultarChatbot;

        if (idOpcion !== null && idOpcion !== undefined) {
            url += "?idOpcion=" + encodeURIComponent(idOpcion);
        }

        const response = await fetch(url, {
            method: "GET",
            headers: {
                "Accept": "application/json"
            },
            cache: "no-store"
        });

        const contenido = await response.text();

        let datos = null;

        if (contenido.trim()) {
            datos = JSON.parse(contenido);
        }

        if (!response.ok) {
            const mensaje =
                typeof datos === "string"
                    ? datos
                    : datos?.mensaje;

            throw new Error(
                mensaje ||
                contenido ||
                "No se pudo consultar el chatbot."
            );
        }

        return datos;
    }

    async function seleccionarOpcion(idOpcion, textoOpcion) {
        if (!idOpcion) {
            mostrarError("La opción seleccionada no contiene un identificador.");
            return;
        }

        ocultarError();
        agregarMensaje(textoOpcion, true);
        mostrarCargando();

        try {
            const datos = await consultarChatbot(idOpcion);

            const respuesta = datos?.seleccion?.respuesta;

            if (respuesta) {
                agregarMensaje(respuesta, false);
            }

            mostrarOpciones(datos);
        } catch (error) {
            agregarMensaje(
                "No fue posible procesar la opción seleccionada.",
                false
            );

            mostrarError(error.message);
        }
    }

    async function cargarMenuPrincipal() {
        ocultarError();
        mostrarCargando();

        try {
            const datos = await consultarChatbot();

            mostrarOpciones(datos);
        } catch (error) {
            mostrarError(error.message);
        }
    }

    async function cargarNivel(idOpcion) {
        ocultarError();
        mostrarCargando();

        try {
            const datos = await consultarChatbot(idOpcion);

            mostrarOpciones(datos);
        } catch (error) {
            mostrarError(error.message);
        }
    }

    function mostrarOpciones(datos) {
        const contenedor = document.getElementById("contenedorOpciones");

        contenedor.replaceChildren();

        const opciones = datos?.opciones ?? [];

        opciones.forEach(function (opcion) {
            const boton = crearBotonOpcion(
                opcion.idOpcion,
                opcion.textoOpcion
            );

            contenedor.appendChild(boton);
        });

        if (opciones.length === 0) {
            const mensaje = document.createElement("div");

            mensaje.className = "text-center text-secondary small py-2";

            mensaje.innerHTML =
                '<i class="bi bi-check-circle me-1"></i>' +
                "No hay más opciones disponibles.";

            contenedor.appendChild(mensaje);
        }

        agregarNavegacion(datos);
    }

    function crearBotonOpcion(idOpcion, textoOpcion) {
        const boton = document.createElement("button");

        boton.type = "button";
        boton.className = "btn btn-outline-success text-start rounded-3";

        const icono = document.createElement("i");

        icono.className = "bi bi-chevron-right me-2";

        boton.appendChild(icono);
        boton.appendChild(
            document.createTextNode(textoOpcion || "Opción")
        );

        boton.addEventListener("click", function () {
            seleccionarOpcion(idOpcion, textoOpcion);
        });

        return boton;
    }

    function agregarNavegacion(datos) {
        const contenedor = document.getElementById("contenedorOpciones");

        const seleccion = datos?.seleccion;
        const opcionPadre = datos?.opcionPadre;

        if (opcionPadre) {
            const botonVolver = crearBotonNavegacion(
                "Volver",
                "bi bi-arrow-left me-1",
                "btn btn-outline-secondary rounded-3",
                function () {
                    cargarNivel(opcionPadre.idOpcion);
                }
            );

            contenedor.appendChild(botonVolver);
        } else if (seleccion) {
            const botonVolver = crearBotonNavegacion(
                "Volver",
                "bi bi-arrow-left me-1",
                "btn btn-outline-secondary rounded-3",
                cargarMenuPrincipal
            );

            contenedor.appendChild(botonVolver);
        }

        if (seleccion) {
            const botonPrincipal = crearBotonNavegacion(
                "Menú principal",
                "bi bi-house-door me-1",
                "btn btn-secondary rounded-3",
                cargarMenuPrincipal
            );

            contenedor.appendChild(botonPrincipal);
        }
    }

    function crearBotonNavegacion(texto, claseIcono, claseBoton, accion) {
        const boton = document.createElement("button");

        boton.type = "button";
        boton.className = claseBoton;

        const icono = document.createElement("i");

        icono.className = claseIcono;

        boton.appendChild(icono);
        boton.appendChild(document.createTextNode(texto));

        boton.addEventListener("click", accion);

        return boton;
    }

    function agregarMensaje(texto, esUsuario) {
        if (!texto) {
            return;
        }

        const contenedor = document.getElementById("contenedorMensajes");

        const fila = document.createElement("div");

        fila.className = esUsuario
            ? "d-flex justify-content-end mb-3"
            : "d-flex justify-content-start mb-3";

        const burbuja = document.createElement("div");

        burbuja.className = esUsuario
            ? "text-white shadow-sm rounded-4 px-3 py-2 w-75"
            : "bg-white border shadow-sm rounded-4 px-3 py-2 w-75";

        if (esUsuario) {
            burbuja.style.backgroundColor = "#0d2422";
        }

        const icono = document.createElement("i");

        icono.className = esUsuario
            ? "bi bi-person-fill me-2"
            : "bi bi-robot me-2";

        const contenido = document.createElement("span");

        contenido.textContent = texto;

        burbuja.appendChild(icono);
        burbuja.appendChild(contenido);

        fila.appendChild(burbuja);
        contenedor.appendChild(fila);

        contenedor.scrollTop = contenedor.scrollHeight;
    }

    function mostrarCargando() {
        const contenedor = document.getElementById("contenedorOpciones");

        contenedor.innerHTML =
            '<div class="d-flex align-items-center justify-content-center text-secondary py-2">' +
            '<div class="spinner-border spinner-border-sm me-2" role="status">' +
            '<span class="visually-hidden">Cargando...</span>' +
            '</div>' +
            'Cargando opciones...' +
            '</div>';
    }

    function mostrarError(mensaje) {
        const alerta = document.getElementById("mensajeError");

        alerta.textContent =
            mensaje || "Ocurrió un error al cargar el chatbot.";

        alerta.classList.remove("d-none");

        const contenedor = document.getElementById("contenedorOpciones");

        contenedor.innerHTML =
            '<button type="button" id="btnReintentarChatbot" class="btn btn-danger rounded-3">' +
            '<i class="bi bi-arrow-clockwise me-1"></i>' +
            'Reintentar' +
            '</button>';

        document
            .getElementById("btnReintentarChatbot")
            .addEventListener("click", cargarMenuPrincipal);
    }

    function ocultarError() {
        const alerta = document.getElementById("mensajeError");

        alerta.textContent = "";
        alerta.classList.add("d-none");
    }
})();