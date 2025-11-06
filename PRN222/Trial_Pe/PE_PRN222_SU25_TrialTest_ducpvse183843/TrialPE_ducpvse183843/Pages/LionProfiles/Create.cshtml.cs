using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TrialPE.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using TrialPE.Services;

namespace TrialPE_ducpvse183843.Pages.LionProfiles
{
    [Authorize(Roles = "2")]
    public class CreateModel : PageModel
    {
        private readonly ILionProfile _context;
        private readonly LionTypeService _type;
        public CreateModel(ILionProfile context, LionTypeService type)
        {
            _context = context;
            _type = type;
        }
        public async Task<IActionResult> OnGet()
        {
            if (LionProfile == null)
            {
                LionProfile = new LionProfile();
            }

            var typeQueryable = (await _type.GetAllAsync()).AsQueryable();
            ViewData["LionTypeId"] = new SelectList(typeQueryable, "LionTypeId", "LionTypeName");
            return Page();
        }

        [BindProperty]
        public LionProfile LionProfile { get; set; } = default!;

        // For more information, see https://aka.ms/RazorPagesCRUD.
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                var typeQueryable = (await _type.GetAllAsync()).AsQueryable();
                ViewData["LionTypeId"] = new SelectList(typeQueryable, "LionTypeId", "LionTypeName");
                return Page();
            }
            LionProfile.ModifiedDate = DateTime.Now;

            await _context.CreateAsync(LionProfile);
            int newId = LionProfile.LionProfileId;
            return RedirectToPage("./Details", new { id = newId });
        }
    }
}