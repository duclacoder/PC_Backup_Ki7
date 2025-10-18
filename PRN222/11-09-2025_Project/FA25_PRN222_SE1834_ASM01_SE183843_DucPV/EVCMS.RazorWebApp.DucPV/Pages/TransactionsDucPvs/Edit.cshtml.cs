using EVCMS.RazorWebApp.DucPV.Hubs;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    public class EditModel : PageModel
    {
        private readonly ITransactionsServices _transactionsServices;
        private readonly IHubContext<EVCMShub> _hubContext;

        public EditModel(ITransactionsServices transactionsServices, IHubContext<EVCMShub> hubContext)
        {
            _transactionsServices = transactionsServices;
            _hubContext = hubContext;
        }

        [BindProperty]
        public TransactionsDucPv TransactionsDucPv { get; set; } = default!;

        public async Task<IActionResult> OnGetAsync(int? id)
        {
            if (id == null)
                return NotFound();

            var transaction = await _transactionsServices.GetByIdAsync(id.Value);
            if (transaction == null)
                return NotFound();

            TransactionsDucPv = transaction;
            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
                return Page();

            try
            {
                // Cập nhật
                await _transactionsServices.UpdateAsync(TransactionsDucPv);

                var updatedItem = await _transactionsServices.GetByIdAsync(TransactionsDucPv.TransactionTransactionsDucPvid);

                await _hubContext.Clients.All.SendAsync("Receiver_UpdateTransactionDucPV", updatedItem);
            }
            catch (DbUpdateConcurrencyException)
            {
                var exists = await _transactionsServices.GetByIdAsync(TransactionsDucPv.TransactionTransactionsDucPvid);
                if (exists == null)
                    return NotFound();
                else
                    throw;
            }

            return RedirectToPage("./Index");
        }
    }
}
