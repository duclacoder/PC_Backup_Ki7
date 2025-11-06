using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrialPE.Models;
using Microsoft.EntityFrameworkCore;
using TrialPE.Repositories.Basic;

namespace TrialPE.Repositories
{
    public class LionAccountRepository : GenericRepository<LionAccount>
    {
        public LionAccountRepository() { }
        public async Task<LionAccount> GetByUserNameAsync(string userName, string password)
        {
            return await _context.LionAccounts
                .FirstOrDefaultAsync(c => c.UserName == userName && c.Password == password);
               
        }
    }
}
