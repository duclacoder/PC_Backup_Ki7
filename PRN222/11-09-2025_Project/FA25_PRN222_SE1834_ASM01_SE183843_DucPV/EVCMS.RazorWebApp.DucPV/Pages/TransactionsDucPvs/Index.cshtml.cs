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

        public IndexModel(ITransactionsServices transactionsServices)
        {
            _transactionsServices = transactionsServices;
        }

        public IList<TransactionsDucPv> TransactionsDucPv { get; set; } = new List<TransactionsDucPv>();

        [BindProperty(SupportsGet = true)]
        public string? SearchUser { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? SearchAmount { get; set; }

        [BindProperty(SupportsGet = true)]
        public bool? SearchStatus { get; set; }

        // ✅ Paging
        [BindProperty(SupportsGet = true)]
        public int PageIndex { get; set; } = 1;

        public int TotalPages { get; set; }
        public int PageSize { get; set; } = 5;

        public async Task OnGetAsync()
        {
            var allTransactions = !string.IsNullOrEmpty(SearchUser) || SearchAmount.HasValue || SearchStatus.HasValue
                ? await _transactionsServices.SearchAsync(SearchUser, SearchAmount, SearchStatus)
                : await _transactionsServices.GetAllAsync();

            var totalCount = allTransactions.Count;
            TotalPages = (int)Math.Ceiling(totalCount / (double)PageSize);

            if (PageIndex < 1) PageIndex = 1;
            if (PageIndex > TotalPages) PageIndex = TotalPages;

            TransactionsDucPv = allTransactions
                .Skip((PageIndex - 1) * PageSize)
                .Take(PageSize)
                .ToList();
        }
    }
}
