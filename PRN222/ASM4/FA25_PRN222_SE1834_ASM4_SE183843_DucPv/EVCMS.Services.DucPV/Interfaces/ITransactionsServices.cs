using EVCMS.Repositories.DucPV.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Services.DucPV.Interfaces
{
    public interface ITransactionsServices
    {
        Task<List<TransactionsDucPv>> GetAllAsync();
        Task<TransactionsDucPv> GetByIdAsync(int id);
        Task<List<TransactionsDucPv>> SearchAsync(string userName, int? amount, bool? status);

        Task<int> CreateAsync(TransactionsDucPv transaction);
        Task<int> UpdateAsync(TransactionsDucPv transaction);
        Task<int> DeleteAsync(TransactionsDucPv transaction);
    }
}
