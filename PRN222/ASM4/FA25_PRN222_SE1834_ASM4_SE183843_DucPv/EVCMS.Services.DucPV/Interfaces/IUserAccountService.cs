using EVCMS.Repositories.DucPV.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Services.DucPV.Interfaces
{
    public interface IUserAccountService
    {
        Task<List<UserAccount>> GetAllAsync();
        Task<UserAccount> GetByIdAsync(int id);
        Task<UserAccount> GetUserAccount(string userName, string password);
        Task<int> CreateAsync(UserAccount userAccount);
        Task<int> UpdateAsync(UserAccount userAccount);
        Task<int> DeleteAsync(UserAccount userAccount);
    }
}
