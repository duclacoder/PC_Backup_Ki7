using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Services.DucPV.Interfaces
{
    public interface IServiceProviders
    {
        IUserAccountService AccountService { get; }
        ITransactionsServices TransactionService { get; }
        IPaymentMethodsService PaymentMethodsService { get; }
    }
}
