using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TrialPE.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using TrialPE.Services;

namespace TrialPE_ducpvse183843.Pages.LionProfiles
{
    [Authorize(Roles = "2,3")]
    public class IndexModel : PageModel
    {
        private readonly ILionProfile _lionProfileService;

        public IndexModel(ILionProfile context)
        {
            _lionProfileService = context;
        }
        [BindProperty(SupportsGet = true)]
        public int PageNumber { get; set; } = 1;
        public int TotalPages { get; set; }
        public int PageSize { get; set; } = 3;


        [BindProperty(SupportsGet = true)]
        public double Weight { get; set; } = default!;

        [BindProperty(SupportsGet = true)]
        public string LionTypeName { get; set; } = default!;
        public IList<LionProfile> LionProfile { get;set; } = default!;

        public async Task OnGetAsync()
        {
            var filteredItems = await _lionProfileService.SearchAsync(Weight, LionTypeName);

            TotalPages = (int)Math.Ceiling(filteredItems.Count / (double)PageSize);

            LionProfile = filteredItems
                .OrderByDescending(l => l.ModifiedDate) 
                .Skip((PageNumber - 1) * PageSize)
                .Take(PageSize)
                .ToList();
        }
    }
}
