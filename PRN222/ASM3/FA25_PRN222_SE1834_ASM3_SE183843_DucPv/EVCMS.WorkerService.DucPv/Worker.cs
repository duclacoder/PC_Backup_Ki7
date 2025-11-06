using EVCMS.Services.DucPV.Interfaces;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace EVCMS.WorkerService.DucPv
{
    //D:\Ki7\PRN222\ASM3\FA25_PRN222_SE1834_ASM3_SE183843_DucPv\EVCMS.WorkerService.DucPv\bin\Debug\net8.0\EVCMS.WorkerService.DucPv.exe
    //sc create "PrintLogFileASM3_Service" BinPath="D:\Ki7\PRN222\ASM3\FA25_PRN222_SE1834_ASM3_SE183843_DucPv\EVCMS.WorkerService.DucPv\bin\Debug\net8.0\EVCMS.WorkerService.DucPv.exe"
    //sc delete "PrintLogFileASM3_Service"
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IServiceProvider _servicesProviders;

        public Worker(ILogger<Worker> logger, IServiceProvider services)
        {
            _logger = logger;
            _servicesProviders = services;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                await WriteLogFile();
                await Task.Delay(7000, stoppingToken);
            }
        }

        private async Task WriteLogFile()
        {
            try
            {
                // Tạo scope để sử dụng các service scoped
                using var scope = _servicesProviders.CreateScope();
                var serviceProvider = scope.ServiceProvider;

                var transactionService = serviceProvider.GetRequiredService<ITransactionsServices>();

                var items = await transactionService.GetAllAsync();

                var opt = new JsonSerializerOptions()
                {
                    ReferenceHandler = ReferenceHandler.IgnoreCycles,
                    DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
                };

                var content = JsonSerializer.Serialize(items, opt);
                var logFilePath = @"D:\DataLog_P.txt";
                Console.WriteLine($"Writing log to {logFilePath}");

                using var file = File.Open(logFilePath, FileMode.Append, FileAccess.Write);
                using var writer = new StreamWriter(file);
                await writer.WriteLineAsync(DateTimeOffset.Now.ToString() + ": " + content);
                await writer.WriteLineAsync("--------------------------------------------------");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error writing log file");
            }
        }
    }
}
