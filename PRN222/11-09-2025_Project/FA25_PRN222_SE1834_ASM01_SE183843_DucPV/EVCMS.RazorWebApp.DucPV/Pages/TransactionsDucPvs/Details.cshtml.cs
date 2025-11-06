using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Linq;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    public class DetailsModel : PageModel
    {
        private readonly ITransactionsServices _transactionsServices;
        private readonly IUserAccountService _userAccountService;
        private readonly IPaymentMethodsService _paymentMethodsService;

        public DetailsModel(
            ITransactionsServices transactionsServices,
            IUserAccountService userAccountService,
            IPaymentMethodsService paymentMethodsService)
        {
            _transactionsServices = transactionsServices;
            _userAccountService = userAccountService;
            _paymentMethodsService = paymentMethodsService;
        }

        public TransactionsDucPv TransactionsDucPv { get; set; } = default!;
        public string? UserEmail { get; set; }
        public string? PaymentMethodName { get; set; }

        public async Task<IActionResult> OnGetAsync(int? id)
        {
            if (id == null)
                return NotFound();

            var transaction = await _transactionsServices.GetByIdAsync(id.Value);
            if (transaction == null)
                return NotFound();

            TransactionsDucPv = transaction;

            var users = await _userAccountService.GetAllAsync();
            var methods = await _paymentMethodsService.GetAllAsync();

            UserEmail = users.FirstOrDefault(u => u.UserAccountId == transaction.UserAccountId)?.Email;
            PaymentMethodName = methods.FirstOrDefault(m => m.MethodDucPvid == transaction.MethodDucPvid)?.MethodType;

            return Page();
        }
    }
}
