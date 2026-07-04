document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formCrearUsuario");

    if (!form) return;

    const identificacion = document.getElementById("Identificacion");
    const nombre = document.getElementById("Nombre");
    const correo = document.getElementById("Correo");
    const idRol = document.getElementById("Id_Rol");
    const contrasena = document.getElementById("Contrasena");
    const confirmarContrasena = document.getElementById("ConfirmarContrasena");

    const mensajeValidacion = document.getElementById("mensajeValidacion");
    const textoValidacion = document.getElementById("textoValidacion");

    function limpiarValidacion() {
        mensajeValidacion.classList.add("d-none");
        textoValidacion.textContent = "";

        const campos = [
            identificacion,
            nombre,
            correo,
            idRol,
            contrasena,
            confirmarContrasena
        ];

        campos.forEach(campo => {
            if (campo) {
                campo.classList.remove("is-invalid");
            }
        });
    }

    function mostrarError(campo, mensaje) {
        campo.classList.add("is-invalid");

        mensajeValidacion.classList.remove("d-none");
        textoValidacion.textContent = mensaje;

        campo.focus();
    }

    function correoValido(valor) {
        const expresion = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return expresion.test(valor);
    }

    form.addEventListener("submit", function (event) {
        limpiarValidacion();

        if (identificacion.value.trim() === "") {
            event.preventDefault();
            mostrarError(identificacion, "Debe ingresar la identificación.");
            return;
        }

        if (nombre.value.trim() === "") {
            event.preventDefault();
            mostrarError(nombre, "Debe ingresar el nombre completo.");
            return;
        }

        if (correo.value.trim() === "") {
            event.preventDefault();
            mostrarError(correo, "Debe ingresar el correo electrónico.");
            return;
        }

        if (!correoValido(correo.value.trim())) {
            event.preventDefault();
            mostrarError(correo, "Debe ingresar un correo electrónico válido.");
            return;
        }

        if (idRol.value === "" || idRol.value === "0") {
            event.preventDefault();
            mostrarError(idRol, "Debe seleccionar un rol.");
            return;
        }

        if (contrasena.value.trim() === "") {
            event.preventDefault();
            mostrarError(contrasena, "Debe ingresar una contraseña.");
            return;
        }

        if (confirmarContrasena.value.trim() === "") {
            event.preventDefault();
            mostrarError(confirmarContrasena, "Debe confirmar la contraseña.");
            return;
        }

        if (contrasena.value !== confirmarContrasena.value) {
            event.preventDefault();

            contrasena.classList.add("is-invalid");
            confirmarContrasena.classList.add("is-invalid");

            mensajeValidacion.classList.remove("d-none");
            textoValidacion.textContent = "Las contraseñas no coinciden.";

            confirmarContrasena.focus();
            return;
        }
    });
});