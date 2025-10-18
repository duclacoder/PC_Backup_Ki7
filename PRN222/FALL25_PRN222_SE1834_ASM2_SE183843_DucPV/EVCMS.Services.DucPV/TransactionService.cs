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
    public class TransactionService : ITransactionsServices
    {
        private readonly IUnitOfWork _unitOfWork ;

        public TransactionService()
        {
        }

        public TransactionService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }



        public async Task<int> CreateAsync(TransactionsDucPv transaction)
        {
            try
            {
                return await _unitOfWork.TransactionsDucPvRepository.CreateAsync(transaction);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<int> DeleteAsync(TransactionsDucPv transaction)
        {
            try
            {
                return await _unitOfWork.TransactionsDucPvRepository.DeleteAsync(transaction.TransactionTransactionsDucPvid);
            }
            catch (Exception)
            {

                throw;
            }
        }

        public async Task<List<TransactionsDucPv>> GetAllAsync()
        {
           return await _unitOfWork.TransactionsDucPvRepository.GetAllAsync();
        }

        public async Task<TransactionsDucPv> GetByIdAsync(int id)
        {
            return await (_unitOfWork.TransactionsDucPvRepository.GetByIdAsync(id));
        }

        public async Task<List<TransactionsDucPv>> SearchAsync(string userName, int? amount, bool? status)

        {
            return await _unitOfWork.TransactionsDucPvRepository.SearchAsync(userName, amount, status);
        }

        public Task<int> UpdateAsync(TransactionsDucPv transaction)
        {
            return _unitOfWork.TransactionsDucPvRepository.UpdateAsync(transaction);
        }
    }
}
