using MinisterioGosenAPI.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddScoped<IUtilesService, UtilesService>();

builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

//Middleware de Errores
app.UseExceptionHandler("/api/Error/RegistrarError");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
