document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formActividad");

    if (!form) return;

    const nombre = document.getElementById("Nombre_Actividad");
    const tipo = document.getElementById("Id_Tipo_Actividad");
    const fechaInicio = document.getElementById("Fecha_Ini");
    const fechaFin = document.getElementById("Fecha_Fin");
    const horaInicio = document.getElementById("Hora_Ini");
    const horaFin = document.getElementById("Hora_Fin");
    const lugar = document.getElementById("Lugar");

    const mensajeValidacion = document.getElementById("mensajeValidacion");
    const textoValidacion = document.getElementById("textoValidacion");

    function limpiarValidacion() {
        mensajeValidacion.classList.add("d-none");
        textoValidacion.textContent = "";

        [nombre, tipo, fechaInicio, fechaFin, horaInicio, horaFin, lugar].forEach(campo => {
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

        if (nombre.value.trim() === "") {
            event.preventDefault();
            mostrarError(nombre, "Debe ingresar el nombre de la actividad.");
            return;
        }

        if (nombre.value.trim().length > 100) {
            event.preventDefault();
            mostrarError(nombre, "El nombre no puede superar 100 caracteres.");
            return;
        }

        if (tipo.value === "" || tipo.value === "0") {
            event.preventDefault();
            mostrarError(tipo, "Debe seleccionar un tipo de actividad.");
            return;
        }

        if (fechaInicio.value === "") {
            event.preventDefault();
            mostrarError(fechaInicio, "Debe ingresar la fecha de inicio.");
            return;
        }

        if (fechaFin.value !== "" && fechaFin.value < fechaInicio.value) {
            event.preventDefault();
            mostrarError(fechaFin, "La fecha de finalización no puede ser menor que la fecha de inicio.");
            return;
        }

        if (horaInicio.value !== "" && horaFin.value !== "" && horaFin.value <= horaInicio.value) {
            event.preventDefault();
            mostrarError(horaFin, "La hora de finalización debe ser mayor que la hora de inicio.");
            return;
        }

        if (lugar && lugar.value.trim().length > 100) {
            event.preventDefault();
            mostrarError(lugar, "El lugar no puede superar 100 caracteres.");
            return;
        }
    });
});