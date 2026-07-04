$(function () {

    $("#RecuperarAcceso").validate({
        rules: {
            Correo: {
                required: true,
                email: true
            }
        },
        messages: {
            Correo: {
                required: "Campo obligatorio",
                email: "Formato no válido"
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

});