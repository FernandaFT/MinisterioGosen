document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formCita");

    if (!form) return;

    const fecha = document.getElementById("Fecha_Cita");
    const hora = document.getElementById("Hora_Cita");
    const encargado = document.getElementById("Id_Usuario_Encargado");
    const observacion = document.getElementById("Observacion_Inicial");
    const detalle = document.getElementById("Detalle_Cita");

    const mensajeValidacion = document.getElementById("mensajeValidacion");
    const textoValidacion = document.getElementById("textoValidacion");

    function limpiarValidacion() {
        mensajeValidacion.classList.add("d-none");
        textoValidacion.textContent = "";

        [fecha, hora, encargado, observacion, detalle].forEach(campo => {
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

        if (hora.value === "") {
            event.preventDefault();
            mostrarError(hora, "Debe ingresar la hora de la cita.");
            return;
        }

        // Validar que la hora esté entre 08:00 y 17:00
        if (hora.value < "08:00" || hora.value > "17:00") {
            event.preventDefault();
            mostrarError(hora, "La hora de la cita debe estar entre las 08:00 y las 17:00.");
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