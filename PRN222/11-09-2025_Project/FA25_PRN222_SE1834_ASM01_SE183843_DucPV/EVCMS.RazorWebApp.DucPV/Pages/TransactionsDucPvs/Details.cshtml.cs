using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using EVCMS.Repositories.DucPV.DBContext;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV.Interfaces;

namespace EVCMS.RazorWebApp.DucPV.Pages.TransactionsDucPvs
{
    public class DetailsModel : PageModel
    {
        //private readonly EVCMS.Repositories.DucPV.DBContext.FA25_PRN222_SE1834_G2_EVCMSContext _context;

        //public DetailsModel(EVCMS.Repositories.DucPV.DBContext.FA25_PRN222_SE1834_G2_EVCMSContext context)
        //{
        //    _context = context;
        //}

        private readonly ITransactionsServices _transactionsServices;

        public DetailsModel(ITransactionsServices transactionsServices)
        {
            _transactionsServices = transactionsServices;
        }

        public TransactionsDucPv TransactionsDucPv { get; set; } = default!;

        public async Task<IActionResult> OnGetAsync(int id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var transactionsducpv = await _transactionsServices.GetByIdAsync(id);

            if (transactionsducpv == null)
            {
                return NotFound();
            }
            else
            {
                TransactionsDucPv = transactionsducpv;
            }
            return Page();
        }
    }
}
