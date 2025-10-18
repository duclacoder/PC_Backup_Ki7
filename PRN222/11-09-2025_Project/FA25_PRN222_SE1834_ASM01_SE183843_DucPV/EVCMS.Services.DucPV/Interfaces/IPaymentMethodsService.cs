using EVCMS.Repositories.DucPV.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Services.DucPV.Interfaces
{
    public interface IPaymentMethodsService
    {
        Task<List<PaymentMethodsDucPv>> GetAllAsync();
        Task<PaymentMethodsDucPv> GetByIdAsync(int id);
        Task<int> CreateAsync(PaymentMethodsDucPv paymentMethod);
        Task<int> UpdateAsync(PaymentMethodsDucPv paymentMethod);
        Task<int> DeleteAsync(PaymentMethodsDucPv paymentMethod);
    }
}
