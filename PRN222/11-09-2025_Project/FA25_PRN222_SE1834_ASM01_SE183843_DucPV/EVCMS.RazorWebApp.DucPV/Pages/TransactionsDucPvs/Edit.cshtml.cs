using EVCMS.RazorWebApp.DucPV.Hubs;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    public class EditModel : PageModel
    {
        private readonly ITransactionsServices _transactionsServices;
        private readonly IUserAccountService _userAccountService;
        private readonly IPaymentMethodsService _paymentMethodsService;
        private readonly IHubContext<EVCMShub> _hubContext;

        public EditModel(
            ITransactionsServices transactionsServices,
            IUserAccountService userAccountService,
            IPaymentMethodsService paymentMethodsService,
            IHubContext<EVCMShub> hubContext)
        {
            _transactionsServices = transactionsServices;
            _userAccountService = userAccountService;
            _paymentMethodsService = paymentMethodsService;
            _hubContext = hubContext;
        }

        [BindProperty]
        public TransactionsDucPv TransactionsDucPv { get; set; } = default!;

        public async Task<IActionResult> OnGetAsync(int? id)
        {
            if (id == null) return NotFound();

            var transaction = await _transactionsServices.GetByIdAsync(id.Value);
            if (transaction == null) return NotFound();

            TransactionsDucPv = transaction;

            await LoadDropdownsAsync();
            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                await LoadDropdownsAsync();
                return Page();
            }

            try
            {
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

        private async Task LoadDropdownsAsync()
        {
            var users = await _userAccountService.GetAllAsync();
            var methods = await _paymentMethodsService.GetAllAsync();

            ViewData["UserAccountId"] = new SelectList(users, "UserAccountId", "Email");
            ViewData["MethodDucPvid"] = new SelectList(methods, "MethodDucPvid", "MethodType");
        }
    }
}
