using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace MinisterioGosen.Helpers
{
    public class ValidarSesionAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var autenticado =
                context.HttpContext.Session.GetString("Autenticado");

            if (autenticado != "1")
            {
                context.Result = new RedirectToActionResult(
                    "Index",
                    "Home",
                    null
                );
            }
        }
    }
}