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
    public class PaymentMethodsDucPvRepository : GenericRepository<PaymentMethodsDucPvRepository>
    {
        public PaymentMethodsDucPvRepository()
        {
        }

        public PaymentMethodsDucPvRepository(FA25_PRN222_SE1834_G2_EVCMSContext context) : base(context) => _context = context;

        public async Task<List<PaymentMethodsDucPv>> getAllAsync()
        {
            return await _context.PaymentMethodsDucPvs.ToListAsync();
        }
        
    }
}
