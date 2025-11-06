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
    public class TransactionsDucPvRepository : GenericRepository<TransactionsDucPv>
    {
        public TransactionsDucPvRepository(FA25_PRN222_SE1834_G2_EVCMSContext context) : base(context) => _context = context;

        public async Task<List<TransactionsDucPv>> getAllAsync()
        {
            var item = await  _context.TransactionsDucPvs
            .Include(t => t.UserAccount)
            .Include(t => t.MethodDucPv)
            .Include(t => t.Session)
            .AsNoTracking()
            .ToListAsync();

            return item;
        }

        public async Task<TransactionsDucPv> getByIdAsync(Guid transactionId)
        {
            var transaction = await _context.TransactionsDucPvs.FindAsync(transactionId);
            return transaction ?? new TransactionsDucPv();
        }

        public async Task<List<TransactionsDucPv>> SearchAsync(string userName, int? amount, bool? status)

        {
            var items = await _context.TransactionsDucPvs
        .Include(c => c.MethodDucPv)
        .Where(c => (c.Amount == amount || amount == null)
                 && (c.UserAccount.UserName.Contains(userName) || string.IsNullOrEmpty(userName))
                 && (c.Status == status)).OrderByDescending(c => c.CreatedAt).ToListAsync();

            return items ?? new List<TransactionsDucPv>();
        }

        public async Task<int> DeleteAsync(int id)
        {
            var entity = await _context.TransactionsDucPvs.FindAsync(id);
            if (entity == null) return 0;

            _context.TransactionsDucPvs.Remove(entity);
            return await _context.SaveChangesAsync();
        }

    }
}
