using EVCMS.Repositories.DucPV.DBContext;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Repositories.DucPV.Repositories;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Services.DucPV
{
    public class ChargingSessionService : IChargingSessionService
    {
        private readonly ChargingSessionRepository _chargingSessionRepository;

        public ChargingSessionService(ChargingSessionRepository chargingSessionRepository)
        {
            _chargingSessionRepository = chargingSessionRepository;
        }

        public Task<int> CreateAsync(ChargingSession chargingSession)
        {
            throw new NotImplementedException();
        }

        public Task<int> CreateAsync(PaymentMethodsDucPv paymentMethod)
        {
            throw new NotImplementedException();
        }

        public Task<int> DeleteAsync(ChargingSession chargingSession)
        {
            throw new NotImplementedException();
        }

        public Task<int> DeleteAsync(PaymentMethodsDucPv paymentMethod)
        {
            throw new NotImplementedException();
        }

        public async Task<List<ChargingSession>> GetAllAsync()
        {
            return await _chargingSessionRepository.getAllAsync();
        }

        public Task<ChargingSession> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<int> UpdateAsync(ChargingSession chargingSession)
        {
            throw new NotImplementedException();
        }

        public Task<int> UpdateAsync(PaymentMethodsDucPv paymentMethod)
        {
            throw new NotImplementedException();
        }

        Task<PaymentMethodsDucPv> IChargingSessionService.GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }
    }
}
