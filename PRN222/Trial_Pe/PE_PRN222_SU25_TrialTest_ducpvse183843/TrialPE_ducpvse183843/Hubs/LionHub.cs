using Microsoft.AspNetCore.SignalR;
using TrialPE.Services;

namespace TrialPE_ducpvse183843.Hubs
{
    public class LionHub : Hub
    {
        private readonly ILionProfile _lionProfileService;
        public LionHub(ILionProfile lionProfileService)
        {
            _lionProfileService = lionProfileService;
        }
        public async Task HubDelete_ILionProfile(int lionProfileId)
        {
            await Clients.All.SendAsync("HubDelete_ILionProfile", lionProfileId);
            await _lionProfileService.DeleteAsync(lionProfileId);
        }
    }
}
