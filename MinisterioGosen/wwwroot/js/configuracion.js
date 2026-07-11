$(function () {

  $.validator.addMethod("caracterEspecial", function (value, element) {
    return this.optional(element) || /[!@#$%^&*(),.?":{}|<>]/.test(value);
  }, "");

  $("#ConfirmarContrasena").validate({
    rules: {
      Contrasena: {
        required: true,
        minlength: 5,
        caracterEspecial: true
      },
      ConfirmarContrasena: {
        required: true,
        equalTo: "#Contrasena"
      }
    },
    messages: {
        Contrasena: {
        required: "Campo obligatorio",
        minlength: "Mínimo 5 caracteres",
        caracterEspecial: "Al menos 1 caracter especial"
      },
        ConfirmarContrasena: {
        required: "Campo obligatorio",
        equalTo: "Las contraseñas no coinciden"
      }
      },
      errorElement: "span",
      errorPlacement: function (error, element) {
          error.addClass("text-danger small d-block mt-1");
          element.closest(".form-floating").after(error);
      },
      highlight: function (element) {
          $(element).addClass("is-invalid");
          $(element).removeClass("is-valid");
      },
      unhighlight: function (element) {
          $(element).removeClass("is-invalid");
          $(element).addClass("is-valid");
      },
      submitHandler: function (form) {
          form.submit();
      }
  });

    $("#ConfirmarInfoPersonal").validate({
        rules: {
            Identificacion: {
                required: true
            },
            Nombre: {
                required: true
            },
            Correo: {
                required: true,
                email: true
            }
        },
        messages: {
            Identificacion: {
                required: "Campo obligatorio"
            },
            Nombre: {
                required: "Campo obligatorio"
            },
            Correo: {
                required: "Campo obligatorio",
                email: "Formato no válido"
            }
        },
        errorElement: "span",
        errorPlacement: function (error, element) {
            error.addClass("text-danger small d-block");
            element.closest(".form-group").append(error);
        },
        errorElement: "span",
        errorPlacement: function (error, element) {
            error.addClass("text-danger small d-block mt-1");
            element.closest(".form-floating").after(error);
        },
        highlight: function (element) {
            $(element).addClass("is-invalid");
            $(element).removeClass("is-valid");
        },
        unhighlight: function (element) {
            $(element).removeClass("is-invalid");
            $(element).addClass("is-valid");
        },
        submitHandler: function (form) {
            form.submit();
        }
    });

});