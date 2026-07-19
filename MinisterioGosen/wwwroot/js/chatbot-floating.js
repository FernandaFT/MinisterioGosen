(function () {
    let chatbotCargado = false;

    document.addEventListener("DOMContentLoaded", inicializarChatbot);

    function inicializarChatbot() {
        const chatbotPanel = document.getElementById("chatbotOffcanvas");

        if (!chatbotPanel) {
            return;
        }

        chatbotPanel.addEventListener("shown.bs.offcanvas", function () {
            ocultarBotonesFlotantes();

            if (!chatbotCargado) {
                cargarChatbotMenuPrincipal();
                chatbotCargado = true;
            }
        });

        chatbotPanel.addEventListener("hidden.bs.offcanvas", function () {
            reiniciarChatbot();
            mostrarBotonesFlotantes();
        });
    }

    function obtenerValor(objeto, nombres) {
        if (!objeto) {
            return null;
        }

        for (const nombre of nombres) {
            if (objeto[nombre] !== undefined) {
                return objeto[nombre];
            }
        }

        return null;
    }

    function obtenerUrlChatbot() {
        const panel = document.getElementById("chatbotOffcanvas");

        return panel?.dataset?.chatbotUrl || "/Chatbot/ConsultarChatbot";
    }

    async function consultarChatbot(idOpcion = null) {
        let url = obtenerUrlChatbot();

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

        if (contenido.trim() !== "") {
            datos = JSON.parse(contenido);
        }

        if (!response.ok) {
            const mensaje =
                typeof datos === "string"
                    ? datos
                    : datos?.mensaje;

            throw new Error(
                mensaje || contenido || "No se pudo consultar el chatbot."
            );
        }

        return datos;
    }

    async function cargarChatbotMenuPrincipal() {
        ocultarErrorChatbot();
        mostrarCargandoChatbot();

        try {
            const datos = await consultarChatbot();

            mostrarOpcionesChatbot(datos);
        } catch (error) {
            mostrarErrorChatbot(error.message);
        }
    }

    async function seleccionarOpcionChatbot(idOpcion, textoOpcion) {
        if (idOpcion === null || idOpcion === undefined) {
            mostrarErrorChatbot(
                "La opción seleccionada no contiene un identificador."
            );

            return;
        }

        ocultarErrorChatbot();

        agregarMensajeChatbot(textoOpcion, true);

        mostrarCargandoChatbot();

        try {
            const datos = await consultarChatbot(idOpcion);

            const seleccion =
                datos.seleccion ||
                datos.Seleccion;

            const respuesta = obtenerValor(
                seleccion,
                ["respuesta", "Respuesta"]
            );

            if (respuesta) {
                agregarMensajeChatbot(respuesta, false);
            }

            mostrarOpcionesChatbot(datos);
        } catch (error) {
            agregarMensajeChatbot(
                "No fue posible procesar la opción seleccionada.",
                false
            );

            mostrarErrorChatbot(error.message);
        }
    }

    async function cargarNivelChatbot(idOpcion) {
        ocultarErrorChatbot();
        mostrarCargandoChatbot();

        try {
            const datos = await consultarChatbot(idOpcion);

            mostrarOpcionesChatbot(datos);
        } catch (error) {
            mostrarErrorChatbot(error.message);
        }
    }

    function mostrarOpcionesChatbot(datos) {
        const contenedor =
            document.getElementById("chatbotOpciones");

        contenedor.replaceChildren();

        const opciones =
            datos?.opciones ||
            datos?.Opciones ||
            [];

        opciones.forEach(function (opcion) {
            const idOpcion = obtenerValor(
                opcion,
                ["idOpcion", "IdOpcion", "id_Opcion", "Id_Opcion"]
            );

            const textoOpcion = obtenerValor(
                opcion,
                ["textoOpcion", "TextoOpcion", "texto_Opcion", "Texto_Opcion"]
            );

            const boton =
                crearBotonOpcion(idOpcion, textoOpcion);

            contenedor.appendChild(boton);
        });

        if (opciones.length === 0) {
            contenedor.appendChild(
                crearMensajeSinOpciones()
            );
        }

        agregarNavegacionChatbot(datos);
    }

    function crearBotonOpcion(idOpcion, textoOpcion) {
        const boton = document.createElement("button");

        boton.type = "button";
        boton.className =
            "btn btn-outline-success text-start rounded-3";

        const icono = document.createElement("i");

        icono.className = "bi bi-chevron-right me-2";

        boton.appendChild(icono);
        boton.appendChild(
            document.createTextNode(textoOpcion || "Opción")
        );

        boton.addEventListener("click", function () {
            seleccionarOpcionChatbot(idOpcion, textoOpcion);
        });

        return boton;
    }

    function crearMensajeSinOpciones() {
        const mensaje = document.createElement("div");

        mensaje.className =
            "text-center text-secondary small py-2";

        const icono = document.createElement("i");

        icono.className = "bi bi-check-circle me-1";

        mensaje.appendChild(icono);
        mensaje.appendChild(
            document.createTextNode("No hay más opciones disponibles.")
        );

        return mensaje;
    }

    function agregarNavegacionChatbot(datos) {
        const contenedor =
            document.getElementById("chatbotOpciones");

        const seleccion =
            datos?.seleccion ||
            datos?.Seleccion;

        const opcionPadre =
            datos?.opcionPadre ||
            datos?.OpcionPadre;

        if (opcionPadre) {
            const idPadre = obtenerValor(
                opcionPadre,
                ["idOpcion", "IdOpcion", "id_Opcion", "Id_Opcion"]
            );

            const botonVolver = crearBotonNavegacion(
                "Volver",
                "bi bi-arrow-left me-1",
                "btn btn-outline-secondary rounded-3",
                function () {
                    cargarNivelChatbot(idPadre);
                }
            );

            contenedor.appendChild(botonVolver);
        } else if (seleccion) {
            const botonVolver = crearBotonNavegacion(
                "Volver",
                "bi bi-arrow-left me-1",
                "btn btn-outline-secondary rounded-3",
                cargarChatbotMenuPrincipal
            );

            contenedor.appendChild(botonVolver);
        }

        if (seleccion) {
            const botonPrincipal = crearBotonNavegacion(
                "Menú principal",
                "bi bi-house-door me-1",
                "btn btn-secondary rounded-3",
                cargarChatbotMenuPrincipal
            );

            contenedor.appendChild(botonPrincipal);
        }
    }

    function crearBotonNavegacion(
        texto,
        claseIcono,
        claseBoton,
        accion
    ) {
        const boton = document.createElement("button");

        boton.type = "button";
        boton.className = claseBoton;

        const icono = document.createElement("i");

        icono.className = claseIcono;

        boton.appendChild(icono);
        boton.appendChild(
            document.createTextNode(texto)
        );

        boton.addEventListener("click", accion);

        return boton;
    }

    function agregarMensajeChatbot(texto, esUsuario) {
        if (!texto) {
            return;
        }

        const contenedor =
            document.getElementById("chatbotMensajes");

        const fila =
            document.createElement("div");

        fila.className = esUsuario
            ? "d-flex justify-content-end mb-3"
            : "d-flex justify-content-start mb-3";

        const burbuja =
            document.createElement("div");

        burbuja.className = esUsuario
            ? "text-white rounded-4 px-3 py-2 shadow-sm chatbot-burbuja"
            : "bg-white border rounded-4 px-3 py-2 shadow-sm chatbot-burbuja";

        if (esUsuario) {
            burbuja.style.backgroundColor = "#0d2422";
        }

        const icono =
            document.createElement("i");

        icono.className = esUsuario
            ? "bi bi-person-fill me-2"
            : "bi bi-robot me-2";

        const contenido =
            document.createElement("span");

        contenido.textContent = texto;

        burbuja.appendChild(icono);
        burbuja.appendChild(contenido);

        fila.appendChild(burbuja);
        contenedor.appendChild(fila);

        contenedor.scrollTop =
            contenedor.scrollHeight;
    }

    function mostrarCargandoChatbot() {
        const contenedor =
            document.getElementById("chatbotOpciones");

        contenedor.replaceChildren();

        const wrapper =
            document.createElement("div");

        wrapper.className =
            "d-flex align-items-center justify-content-center text-secondary py-2";

        const spinner =
            document.createElement("div");

        spinner.className =
            "spinner-border spinner-border-sm me-2";

        spinner.setAttribute("role", "status");

        const textoAccesible =
            document.createElement("span");

        textoAccesible.className = "visually-hidden";
        textoAccesible.textContent = "Cargando...";

        spinner.appendChild(textoAccesible);

        wrapper.appendChild(spinner);
        wrapper.appendChild(
            document.createTextNode("Cargando opciones...")
        );

        contenedor.appendChild(wrapper);
    }

    function mostrarErrorChatbot(mensaje) {
        const alerta =
            document.getElementById("chatbotError");

        alerta.textContent =
            mensaje || "Ocurrió un error al cargar el chatbot.";

        alerta.classList.remove("d-none");

        const contenedor =
            document.getElementById("chatbotOpciones");

        contenedor.replaceChildren();

        const boton =
            crearBotonNavegacion(
                "Reintentar",
                "bi bi-arrow-clockwise me-1",
                "btn btn-danger rounded-3",
                cargarChatbotMenuPrincipal
            );

        contenedor.appendChild(boton);
    }

    function ocultarErrorChatbot() {
        const alerta =
            document.getElementById("chatbotError");

        alerta.textContent = "";
        alerta.classList.add("d-none");
    }

    function reiniciarChatbot() {
        chatbotCargado = false;

        const contenedorMensajes =
            document.getElementById("chatbotMensajes");

        const contenedorOpciones =
            document.getElementById("chatbotOpciones");

        if (contenedorMensajes) {
            contenedorMensajes.replaceChildren();

            const fila =
                document.createElement("div");

            fila.className =
                "d-flex justify-content-start mb-3";

            const burbuja =
                document.createElement("div");

            burbuja.className =
                "bg-white border rounded-4 px-3 py-2 shadow-sm chatbot-burbuja";

            burbuja.textContent =
                "Hola. Seleccione una opción para continuar.";

            fila.appendChild(burbuja);
            contenedorMensajes.appendChild(fila);
        }

        if (contenedorOpciones) {
            contenedorOpciones.replaceChildren();
        }

        ocultarErrorChatbot();
    }

    function ocultarBotonesFlotantes() {
        const btnChatbot =
            document.getElementById("btnAbrirChatbot");

        const btnSubir =
            document.getElementById("btnSubirPagina");

        if (btnChatbot) {
            btnChatbot.classList.add("d-none");
        }

        if (btnSubir) {
            btnSubir.classList.add("d-none");
        }
    }

    function mostrarBotonesFlotantes() {
        const btnChatbot =
            document.getElementById("btnAbrirChatbot");

        const btnSubir =
            document.getElementById("btnSubirPagina");

        if (btnChatbot) {
            btnChatbot.classList.remove("d-none");
        }

        if (btnSubir) {
            btnSubir.classList.remove("d-none");
        }
    }
})();