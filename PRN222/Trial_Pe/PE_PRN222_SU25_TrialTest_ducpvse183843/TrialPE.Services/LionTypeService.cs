using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrialPE.Models;
using Microsoft.IdentityModel.Tokens;
using TrialPE.Repositories;

namespace TrialPE.Services
{
    public class LionTypeService
    {
        private readonly LionTypeRepository _lionTypeRepository;

        public LionTypeService() => _lionTypeRepository = new LionTypeRepository();
        public async Task<List<LionType>> GetAllAsync()
        {
            try
            {
                return await _lionTypeRepository.GetAllAsync();
            }
            catch (Exception ex) {}
            return new List<LionType>();
        }
    }
}
