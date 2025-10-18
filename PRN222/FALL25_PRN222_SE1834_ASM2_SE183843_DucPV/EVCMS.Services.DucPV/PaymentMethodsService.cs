using EVCMS.Repositories.DucPV;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Repositories.DucPV.Repositories;
using EVCMS.Services.DucPV.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Services.DucPV
{
    public class PaymentMethodsService : IPaymentMethodsService
    {
        private readonly IUnitOfWork _unitOfWork;

        public PaymentMethodsService()
        {
        }

        public PaymentMethodsService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public Task<int> CreateAsync(PaymentMethodsDucPv paymentMethod)
        {
            throw new NotImplementedException();
        }

        public Task<int> DeleteAsync(PaymentMethodsDucPv paymentMethod)
        {
            throw new NotImplementedException();
        }

        public async Task<List<PaymentMethodsDucPv>> GetAllAsync()
        {
            try
            {
                return await _unitOfWork.PaymentMethodsDucPvRepository.getAllAsync();
            }
            catch (Exception)
            {

                throw;
            }
        }

        public Task<PaymentMethodsDucPv> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<int> UpdateAsync(PaymentMethodsDucPv paymentMethod)
        {
            throw new NotImplementedException();
        }
    }
}
