using Microsoft.EntityFrameworkCore;
using sanitation_web_api;
using sanitation_web_api.helpers;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped((x) => new ClickhouseClientDecorator(builder.Configuration.GetValue<string>("ClickhouseHost")));
builder.Services.AddDbContext<SanitationDbContext>(x => x.UseNpgsql(builder.Configuration.GetValue<string>("PostgresDSN")),
    ServiceLifetime.Scoped);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapControllers();

app.Run();
