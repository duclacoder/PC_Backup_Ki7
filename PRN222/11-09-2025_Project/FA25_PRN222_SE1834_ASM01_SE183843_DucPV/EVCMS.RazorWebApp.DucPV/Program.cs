using EVCMS.Repositories.DucPV.Repositories;
using EVCMS.Services.DucPV.Interfaces;
using EVCMS.Services.DucPV;
using Microsoft.AspNetCore.Authentication.Cookies;
using EVCMS.RazorWebApp.DucPV.Hubs;
using EVCMS.Repositories.DucPV.DBContext;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();

builder.Services.AddDbContext<FA25_PRN222_SE1834_G2_EVCMSContext>();


builder.Services.AddScoped<TransactionsDucPvRepository>();
builder.Services.AddScoped<ChargingSessionRepository>();
builder.Services.AddScoped<ITransactionsServices, TransactionService>();
builder.Services.AddScoped<IPaymentMethodsService,PaymentMethodsService>();
builder.Services.AddScoped<IUserAccountService, UserAccountService>();
builder.Services.AddScoped<IChargingSessionService, ChargingSessionService>();
builder.Services.AddSignalR();

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.AccessDeniedPath = "/Account/Forbidden";
        options.ExpireTimeSpan = TimeSpan.FromMinutes(30);
    });
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}


app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();


app.UseAuthorization();
app.MapHub<EVCMShub>("/EVCMShub");

app.MapRazorPages().RequireAuthorization();

app.Run();