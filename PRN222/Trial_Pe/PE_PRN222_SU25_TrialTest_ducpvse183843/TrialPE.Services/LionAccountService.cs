using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrialPE.Models;
using TrialPE.Repositories;

namespace TrialPE.Services
{
    public class LionAccountService
    {
        private readonly LionAccountRepository _user;
        public LionAccountService() => _user = new LionAccountRepository();
        public async Task<LionAccount> GetUserAccount(string username, string password)
        {
            try
            {
                return await _user.GetByUserNameAsync(username, password);
            } 
            catch (Exception ex) { }
            return null;
        }
    }
}
