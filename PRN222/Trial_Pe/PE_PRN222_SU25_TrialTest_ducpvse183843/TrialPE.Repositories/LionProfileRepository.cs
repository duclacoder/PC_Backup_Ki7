using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrialPE.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;
using TrialPE.Repositories.Basic;

namespace TrialPE.Repositories
{
    public class LionProfileRepository : GenericRepository<LionProfile>
    {
        public LionProfileRepository() { }
        public LionProfileRepository(SU25LionDBContext context) => _context = context;

        public async Task<List<LionProfile>> GetAllAsync()
        {
            var item = await _context.LionProfiles.Include(c => c.LionType).ToListAsync();
            return item;
        }

        public async Task<LionProfile?> GetByIdAsync(int LionProfileId)
        {
            var item = await _context.LionProfiles.FindAsync(LionProfileId);
            return item;
        }

        public async Task<List<LionProfile>> SearchAsync(double Weight, string LionTypeName)
        {
            var query = _context.LionProfiles.Include(c => c.LionType).AsQueryable();

            if (Weight > 0)
            {
                query = query.Where(c => c.Weight >= Weight);
            }

            if (!string.IsNullOrEmpty(LionTypeName))
            {
                query = query.Where(c => c.LionType.LionTypeName.Contains(LionTypeName));
            }

            return await query.ToListAsync();
        }
    }
}