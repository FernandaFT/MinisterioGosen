document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formMinisterio");

    if (!form) return;

    const descripcion = document.getElementById("Descripcion_Ministerio");
    const observaciones = document.getElementById("Observaciones_Ministerio");

    const mensajeValidacion = document.getElementById("mensajeValidacion");
    const textoValidacion = document.getElementById("textoValidacion");

    function limpiarValidacion() {
        mensajeValidacion.classList.add("d-none");
        textoValidacion.textContent = "";

        descripcion.classList.remove("is-invalid");

        if (observaciones) {
            observaciones.classList.remove("is-invalid");
        }
    }

    function mostrarError(campo, mensaje) {
        campo.classList.add("is-invalid");

        mensajeValidacion.classList.remove("d-none");
        textoValidacion.textContent = mensaje;

        campo.focus();
    }

    form.addEventListener("submit", function (event) {
        limpiarValidacion();

        if (descripcion.value.trim() === "") {
            event.preventDefault();
            mostrarError(descripcion, "Debe ingresar el nombre del ministerio.");
            return;
        }

        if (descripcion.value.trim().length > 100) {
            event.preventDefault();
            mostrarError(descripcion, "El nombre del ministerio no puede superar 100 caracteres.");
            return;
        }

        if (observaciones && observaciones.value.trim().length > 200) {
            event.preventDefault();
            mostrarError(observaciones, "Las observaciones no pueden superar 200 caracteres.");
            return;
        }
    });
});