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
    [Authorize(Roles = "2")]
    public class DeleteModel : PageModel
    {
        private readonly ILionProfile _context;
        private readonly LionTypeService _type;

        public DeleteModel(ILionProfile context, LionTypeService type )
        {
            _context = context;
            _type = type;
        }

        [BindProperty]
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

        public async Task<IActionResult> OnPostAsync(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var lionprofile = await _context.DeleteAsync(id.Value);
            return RedirectToPage("./Index");
        }
    }
}
