using EVCMS.Services.DucPV.Interfaces;


namespace EVCMS.Services.DucPV
{    
    public class ServiceProviders : IServiceProviders
    {
        public ServiceProviders(IUserAccountService accountService, ITransactionsServices transactionService, IPaymentMethodsService paymentMethodsService)
        {
            AccountService = accountService;
            TransactionService = transactionService;
            PaymentMethodsService = paymentMethodsService;
        }


        public ITransactionsServices TransactionService { get; }
        public IPaymentMethodsService PaymentMethodsService { get; }
        public IUserAccountService AccountService { get; }
    }
}
