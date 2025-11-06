using EVCMS.Repositories.DucPV;
using EVCMS.Repositories.DucPV.DBContext;
using EVCMS.Repositories.DucPV.Repositories;
using EVCMS.Services.DucPV;
using EVCMS.Services.DucPV.Interfaces;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.AddDbContext<FA25_PRN222_SE1834_G2_EVCMSContext>();

builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<TransactionsDucPvRepository>();
builder.Services.AddScoped<ChargingSessionRepository>();
builder.Services.AddScoped<ITransactionsServices, TransactionService>();
builder.Services.AddScoped<IServiceProviders, ServiceProviders>();
builder.Services.AddScoped<IChargingSessionService, ChargingSessionService>();
builder.Services.AddScoped<IPaymentMethodsService, PaymentMethodsService>();
builder.Services.AddScoped<IUserAccountService, UserAccountService>();

builder.Services.AddDistributedMemoryCache();

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

var app = builder.Build();


// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}



app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.UseSession();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
