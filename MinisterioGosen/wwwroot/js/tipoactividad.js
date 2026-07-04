document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formTipoActividad");

    if (!form) return;

    const nombreTipo = document.getElementById("Nombre_Tipo");
    const mensajeValidacion = document.getElementById("mensajeValidacion");
    const textoValidacion = document.getElementById("textoValidacion");

    function limpiarValidacion() {
        mensajeValidacion.classList.add("d-none");
        textoValidacion.textContent = "";

        nombreTipo.classList.remove("is-invalid");
    }

    function mostrarError(mensaje) {
        nombreTipo.classList.add("is-invalid");

        mensajeValidacion.classList.remove("d-none");
        textoValidacion.textContent = mensaje;

        nombreTipo.focus();
    }

    form.addEventListener("submit", function (event) {
        limpiarValidacion();

        if (nombreTipo.value.trim() === "") {
            event.preventDefault();
            mostrarError("Debe ingresar el nombre del tipo de actividad.");
            return;
        }

        if (nombreTipo.value.trim().length > 50) {
            event.preventDefault();
            mostrarError("El nombre no puede superar 50 caracteres.");
            return;
        }
    });
});