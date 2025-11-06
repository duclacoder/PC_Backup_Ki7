using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    [Authorize]
    public class IndexModel : PageModel
    {
        private readonly ITransactionsServices _transactionsServices;
        private readonly IUserAccountService _userAccountService;
        private readonly IPaymentMethodsService _paymentMethodsService;

        public IndexModel(
            ITransactionsServices transactionsServices,
            IUserAccountService userAccountService,
            IPaymentMethodsService paymentMethodsService)
        {
            _transactionsServices = transactionsServices;
            _userAccountService = userAccountService;
            _paymentMethodsService = paymentMethodsService;
        }

        public IList<TransactionsDucPv> TransactionsDucPv { get; set; } = new List<TransactionsDucPv>();
        public IList<UserAccount> UserAccounts { get; set; } = new List<UserAccount>();
        public IList<PaymentMethodsDucPv> PaymentMethods { get; set; } = new List<PaymentMethodsDucPv>();

        [BindProperty(SupportsGet = true)]
        public string? SearchUser { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? SearchAmount { get; set; }

        [BindProperty(SupportsGet = true)]
        public bool? SearchStatus { get; set; }

        [BindProperty(SupportsGet = true)]
        public int PageIndex { get; set; } = 1;

        public int TotalPages { get; set; }
        public int PageSize { get; set; } = 5;

        public async Task OnGetAsync()
        {
            UserAccounts = await _userAccountService.GetAllAsync();
            PaymentMethods = await _paymentMethodsService.GetAllAsync();

            var allTransactions = !string.IsNullOrEmpty(SearchUser) || SearchAmount.HasValue || SearchStatus.HasValue
                ? await _transactionsServices.SearchAsync(SearchUser, SearchAmount, SearchStatus)
                : await _transactionsServices.GetAllAsync();
            
            foreach (var t in allTransactions)
            {
                t.UserAccount = UserAccounts.FirstOrDefault(u => u.UserAccountId == t.UserAccountId);
                t.MethodDucPv = PaymentMethods.FirstOrDefault(m => m.MethodDucPvid == t.MethodDucPvid);
            }

            var totalCount = allTransactions.Count;
            TotalPages = (int)Math.Ceiling(totalCount / (double)PageSize);
            if (TotalPages == 0) TotalPages = 1;
            if (PageIndex < 1) PageIndex = 1;
            if (PageIndex > TotalPages) PageIndex = TotalPages;

            TransactionsDucPv = allTransactions
                .Skip((PageIndex - 1) * PageSize)
                .Take(PageSize)
                .ToList();
        }
    }
}
