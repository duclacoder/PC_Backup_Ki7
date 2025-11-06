using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrialPE.Models;
using TrialPE.Repositories.Basic;

namespace TrialPE.Repositories
{
    public class LionTypeRepository : GenericRepository<LionType>
    {
        public LionTypeRepository() { }
        public LionTypeRepository(SU25LionDBContext context) => _context = context;
    }
}
