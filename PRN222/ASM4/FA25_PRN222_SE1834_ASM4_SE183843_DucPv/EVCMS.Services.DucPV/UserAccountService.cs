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
    public class UserAccountService : IUserAccountService
    {
        private readonly IUnitOfWork _unitOfWork;

        public UserAccountService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public UserAccountService()
        {
        }

        public async Task<UserAccount> GetUserAccount(string userName, string password)
        {
            try
            {
                return await _unitOfWork.UserAccountRepository.GetUserAccount(userName, password);
            }
            catch (Exception ex)
            {
            }
            return null;
        }

        public async Task<List<UserAccount>> GetAllAsync()
        {
            return await _unitOfWork.UserAccountRepository.GetAllAsync();
        }

        public Task<UserAccount> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<int> CreateAsync(UserAccount userAccount)
        {
            throw new NotImplementedException();
        }

        public Task<int> UpdateAsync(UserAccount userAccount)
        {
            throw new NotImplementedException();
        }

        public Task<int> DeleteAsync(UserAccount userAccount)
        {
            throw new NotImplementedException();
        }

    }
}
