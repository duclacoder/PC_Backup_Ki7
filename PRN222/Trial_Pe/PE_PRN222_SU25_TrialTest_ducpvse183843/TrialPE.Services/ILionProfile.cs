using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrialPE.Models;

namespace TrialPE.Services
{
    public interface ILionProfile
    {
        Task<List<LionProfile>> GetAllAsync();
        Task<LionProfile?> GetByIdAsync(int LionProfileId);
        Task<List<LionProfile>> SearchAsync(double Weight, string LionTypeName);
        Task<int> CreateAsync(LionProfile transasion);
        Task<int> UpdateAsync(LionProfile transasion);
        Task<bool> DeleteAsync(int LionProfileId);
    }
}
