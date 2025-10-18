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
        private readonly TransactionsDucPvRepository _repository;

        public TransactionService(TransactionsDucPvRepository repository)
        {
            _repository = repository;
        }

        public async Task<int> CreateAsync(TransactionsDucPv transaction)
        {
            try
            {
                return await _repository.CreateAsync(transaction);
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
                return await _repository.DeleteAsync(transaction.TransactionTransactionsDucPvid);
            }
            catch (Exception)
            {

                throw;
            }
        }

        public async Task<List<TransactionsDucPv>> GetAllAsync()
        {
           return await _repository.GetAllAsync();
        }

        public async Task<TransactionsDucPv> GetByIdAsync(int id)
        {
            return await (_repository.GetByIdAsync(id));
        }

        public async Task<List<TransactionsDucPv>> SearchAsync(string userName, int? amount, bool? status)

        {
            return await _repository.SearchAsync(userName, amount, status);
        }

        public Task<int> UpdateAsync(TransactionsDucPv transaction)
        {
            return _repository.UpdateAsync(transaction);
        }
    }
}
