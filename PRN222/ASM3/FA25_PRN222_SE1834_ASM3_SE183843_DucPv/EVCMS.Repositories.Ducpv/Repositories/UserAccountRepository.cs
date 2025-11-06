using EVCMS.Repositories.DucPV.Basic;
using EVCMS.Repositories.DucPV.DBContext;
using EVCMS.Repositories.DucPV.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Repositories.DucPV.Repositories
{
    public class UserAccountRepository : GenericRepository<UserAccount>
    {
        public UserAccountRepository() { }

        public UserAccountRepository(FA25_PRN222_SE1834_G2_EVCMSContext context) : base(context)
        {
            _context = context;
        }

        public async Task<UserAccount> GetUserAccount (string userName, string password)
        {
            //return await _context.UserAccounts.FirstOrDefaultAsync(u => u.Email == Email && u.Password == password && u.IsActive == true);

            //return await _context.UserAccounts.FirstOrDefaultAsync(u => u.Phone == Phone && u.Password == password && u.IsActive == true);
            //return await _context.UserAccounts.FirstOrDefaultAsync(u => u.EmployeeCode == userName && u.Password == password && u.IsActive == true);
            return await _context.UserAccounts.FirstOrDefaultAsync(u => u.UserName == userName && u.Password == password && u.IsActive == true);
        }

        public async Task<List<UserAccount>> getAllAsync()
        {
            return await _context.UserAccounts.ToListAsync();
        }

    }
}
