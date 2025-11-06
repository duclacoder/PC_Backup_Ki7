using EVCMS.Repositories.DucPV;
using EVCMS.Repositories.DucPV.DBContext;
using EVCMS.Repositories.DucPV.Repositories;
using EVCMS.Services.DucPV;
using EVCMS.Services.DucPV.Interfaces;
using EVCMS.WorkerService.DucPv;


var builder = Host.CreateApplicationBuilder(args);

builder.Services.AddHostedService<Worker>();

builder.Services.AddWindowsService(options =>
{
    options.ServiceName = "EVCMS Worker Service DucPv";
});

builder.Services.AddDbContext<FA25_PRN222_SE1834_G2_EVCMSContext>();

builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<TransactionsDucPvRepository>();
builder.Services.AddScoped<ChargingSessionRepository>();
builder.Services.AddScoped<ITransactionsServices, TransactionService>();
builder.Services.AddScoped<IChargingSessionService, ChargingSessionService>();
builder.Services.AddScoped<IPaymentMethodsService, PaymentMethodsService>();
builder.Services.AddScoped<IUserAccountService, UserAccountService>();
builder.Services.AddScoped<IServiceProviders, ServiceProviders>();
builder.Services.AddScoped<TransactionsDucPvRepository>();
builder.Services.AddScoped<ChargingSessionRepository>();
builder.Services.AddScoped<UserAccountRepository>();


var host = builder.Build();
host.Run();
