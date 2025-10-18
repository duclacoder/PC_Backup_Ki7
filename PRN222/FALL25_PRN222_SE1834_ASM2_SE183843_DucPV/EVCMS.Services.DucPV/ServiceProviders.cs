using EVCMS.Services.DucPV.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Services.DucPV
{
    public interface IServiceProviders
    {
        IUserAccountService AccountService { get; }
        ITransactionsServices TransactionService { get; }
        IPaymentMethodsService PaymentMethodsService { get; }
    }

    public class ServiceProviders : IServiceProviders
    {
        public IUserAccountService AccountService { get; }
        public ITransactionsServices TransactionService { get; }
        public IPaymentMethodsService PaymentMethodsService { get; }

        public ServiceProviders(
            IUserAccountService accountService,
            ITransactionsServices transactionService,
            IPaymentMethodsService paymentMethodsService)
        {
            AccountService = accountService;
            TransactionService = transactionService;
            PaymentMethodsService = paymentMethodsService;
        }
    }
}
