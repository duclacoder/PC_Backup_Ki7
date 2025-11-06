using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrialPE.Models;
using TrialPE.Repositories;

namespace TrialPE.Services
{
    public class LionProfileService : ILionProfile
    {
        private readonly LionProfileRepository _lionProfileRepository;
        public LionProfileService() => _lionProfileRepository = new LionProfileRepository();
        public async Task<int> CreateAsync(LionProfile transasion)
        {
            try
            {
                return await _lionProfileRepository.CreateAsync(transasion);
            }
            catch (Exception ex) { }
            return 0;
        }
          

        public async Task<bool> DeleteAsync(int LionProfileId)
        {
            try
            {
                var item = await _lionProfileRepository.GetByIdAsync(LionProfileId);
                if (item != null)
                {
                    return await _lionProfileRepository.RemoveAsync(item);
                }
            }
            catch (Exception ex) { }
            return false;
        }

        public async Task<List<LionProfile>> GetAllAsync()
        {
            try
            {
                var item = await _lionProfileRepository.GetAllAsync();
                return item;

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<LionProfile?> GetByIdAsync(int LionProfileId)
        {
            try
            {
                var item = await _lionProfileRepository.GetByIdAsync(LionProfileId);
                return item;

            }
            catch (Exception ex) { }
            return null;
            throw new NotImplementedException();
        }

        public async Task<List<LionProfile>> SearchAsync(double Weight, string LionTypeName)
        {
            try
            {
                var items = await _lionProfileRepository.GetAllAsync();
                bool searchByWeight = Weight > 0;
                bool searchByTypeName = !string.IsNullOrEmpty(LionTypeName);

                if (!searchByWeight && !searchByTypeName)
                {
                    return items; 
                }

                var filteredItems = items.Where(item =>
                {
                    bool weightMatch = searchByWeight && item.Weight == Weight;

                    bool typeNameMatch = searchByTypeName && item.LionType.LionTypeName
                        .Contains(LionTypeName, StringComparison.OrdinalIgnoreCase);

                    return weightMatch || typeNameMatch;
                }).ToList();

                return filteredItems;
            }
            catch (Exception ex) { }

            return new List<LionProfile>();
        }

        public async Task<int> UpdateAsync(LionProfile transasion)
        {
            try
            {
                var item = await _lionProfileRepository.UpdateAsync(transasion);
                return item;

            }
            catch (Exception ex) { }
            return 0;
        }
    }
}
