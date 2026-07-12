document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formCita");

    if (!form) return;

    const fecha = document.getElementById("Fecha_Cita");
    const encargado = document.getElementById("Id_Usuario_Encargado");
    const observacion = document.getElementById("Observacion_Inicial");
    const detalle = document.getElementById("Detalle_Cita");

    const mensajeValidacion = document.getElementById("mensajeValidacion");
    const textoValidacion = document.getElementById("textoValidacion");

    function limpiarValidacion() {
        mensajeValidacion.classList.add("d-none");
        textoValidacion.textContent = "";

        [fecha, encargado, observacion, detalle].forEach(campo => {
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

    form.addEventListener("submit", function (event) {
        limpiarValidacion();

        if (fecha.value === "") {
            event.preventDefault();
            mostrarError(fecha, "Debe ingresar la fecha de la cita.");
            return;
        }

        const hoy = new Date().toISOString().split("T")[0];
        if (fecha.value < hoy) {
            event.preventDefault();
            mostrarError(fecha, "La fecha de la cita no puede ser anterior a la fecha actual.");
            return;
        }

        if (encargado.value === "" || encargado.value === "0") {
            event.preventDefault();
            mostrarError(encargado, "Debe seleccionar un encargado.");
            return;
        }

        if (observacion && observacion.value.trim().length > 200) {
            event.preventDefault();
            mostrarError(observacion, "La observación inicial no puede superar 200 caracteres.");
            return;
        }

        if (detalle && detalle.value.trim().length > 500) {
            event.preventDefault();
            mostrarError(detalle, "El detalle no puede superar 500 caracteres.");
            return;
        }
    });
});