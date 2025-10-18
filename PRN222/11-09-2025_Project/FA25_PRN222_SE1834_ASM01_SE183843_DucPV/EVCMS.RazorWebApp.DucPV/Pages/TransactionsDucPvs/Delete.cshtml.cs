using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;
using EVCMS.RazorWebApp.DucPV.Hubs;
using Microsoft.AspNetCore.SignalR;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    public class DeleteModel : PageModel
    {
        private readonly ITransactionsServices _service;
        private readonly IHubContext<EVCMShub> _hubContext;

        public DeleteModel(ITransactionsServices service, IHubContext<EVCMShub> hubContext)
        {
            _service = service;
            _hubContext = hubContext;
        }

        [BindProperty]
        public TransactionsDucPv TransactionsDucPv { get; set; } = default!;

        public async Task<IActionResult> OnPostAsync(int id)
        {
            var transaction = await _service.GetByIdAsync(id);
            await _service.DeleteAsync(transaction);

            await _hubContext.Clients.All.SendAsync("Receiver_DeleteTransactionDucPV", id);

            return RedirectToPage("./Index");
        }
    }
}
