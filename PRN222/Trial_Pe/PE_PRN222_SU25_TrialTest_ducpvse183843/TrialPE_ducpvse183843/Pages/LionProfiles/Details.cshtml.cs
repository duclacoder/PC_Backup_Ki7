using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TrialPE.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using TrialPE.Services;

namespace TrialPE_ducpvse183843.Pages.LionProfiles
{
    public class DetailsModel : PageModel
    {
        private readonly ILionProfile _context;
        private readonly LionTypeService _type;
        public DetailsModel(ILionProfile context, LionTypeService type)
        {
            _context = context;
            _type = type;
        }

        public LionProfile LionProfile { get; set; } = default!;

        public async Task<IActionResult> OnGetAsync(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var lionprofile = await _context.GetByIdAsync(id.Value);
            if (lionprofile == null)
            {
                return NotFound();
            }
            else
            {
                LionProfile = lionprofile;
            }
            return Page();
        }
    }
}
