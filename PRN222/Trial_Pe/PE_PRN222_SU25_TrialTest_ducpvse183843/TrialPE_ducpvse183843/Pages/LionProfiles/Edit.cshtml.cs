using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TrialPE.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TrialPE.Services;

namespace TrialPE_ducpvse183843.Pages.LionProfiles
{
    [Authorize(Roles = "2")]
    public class EditModel : PageModel
    {
        private readonly ILionProfile _context;
        private readonly LionTypeService _type;

        public EditModel(ILionProfile context, LionTypeService type)
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

            var lionprofile =  await _context.GetByIdAsync(id.Value);
            if (lionprofile == null)
            {
                return NotFound();
            }
            LionProfile = lionprofile;
            var typeQueryable = (await _type.GetAllAsync()).AsQueryable();

            ViewData["LionTypeId"] = new SelectList(typeQueryable, "LionTypeId", "LionTypeName");
            return Page();
        }

        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more information, see https://aka.ms/RazorPagesCRUD.
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }
            try
            {
                await _context.UpdateAsync(LionProfile);
            }
            catch (Exception ex)
            {
               throw new Exception(ex.Message);
            }

            return RedirectToPage("./Index");
        }
    }
}
