using EVCMS.RazorWebApp.DucPV.Hubs;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    public class CreateModel : PageModel
    {
        private readonly ITransactionsServices _service;
        private readonly IHubContext<EVCMShub> _hubContext;

        public CreateModel(ITransactionsServices service, IHubContext<EVCMShub> hubContext)
        {
            _service = service;
            _hubContext = hubContext;
        }

        [BindProperty]
        public TransactionsDucPv TransactionsDucPv { get; set; } = default!;

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
                return Page();

            var createdItem = await _service.CreateAsync(TransactionsDucPv);

            var fullItem = await _service.GetByIdAsync(TransactionsDucPv.TransactionTransactionsDucPvid);

            await _hubContext.Clients.All.SendAsync("Receiver_CreateTransactionDucPV", fullItem);

            return RedirectToPage("./Index");
        }
    }
}
