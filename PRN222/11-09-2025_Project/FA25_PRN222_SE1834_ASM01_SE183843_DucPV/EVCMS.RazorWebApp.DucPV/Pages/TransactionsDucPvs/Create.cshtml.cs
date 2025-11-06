using EVCMS.RazorWebApp.DucPV.Hubs;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    public class CreateModel : PageModel
    {
        private readonly ITransactionsServices _transactionsService;
        private readonly IUserAccountService _userAccountService;
        private readonly IPaymentMethodsService _paymentMethodsService;
        private readonly IHubContext<EVCMShub> _hubContext;

        public CreateModel(
            ITransactionsServices transactionsService,
            IUserAccountService userAccountService,
            IPaymentMethodsService paymentMethodsService,
            IHubContext<EVCMShub> hubContext)
        {
            _transactionsService = transactionsService;
            _userAccountService = userAccountService;
            _paymentMethodsService = paymentMethodsService;
            _hubContext = hubContext;
        }

        [BindProperty]
        public TransactionsDucPv TransactionsDucPv { get; set; } = new();

        public async Task<IActionResult> OnGetAsync()
        {
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

            var createdItem = await _transactionsService.CreateAsync(TransactionsDucPv);

            var fullItem = await _transactionsService.GetByIdAsync(TransactionsDucPv.TransactionTransactionsDucPvid);

            await _hubContext.Clients.All.SendAsync("Receiver_CreateTransactionDucPV", fullItem);

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
