using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using EVCMS.Services.DucPV;
using EVCMS.MVCWebApp.DucPv.Models; // giả sử bạn có LoginViewModel

namespace EVCMS.MVCWebApp.DucPv.Controllers
{
    public class LoginViewModel
    {
        public string UserName { get; set; }
        public string Password { get; set; }
    }

    public class AuthenController : Controller
    {
        private readonly IServiceProviders _serviceProviders;

        public AuthenController(IServiceProviders serviceProviders)
        {
            _serviceProviders = serviceProviders;
        }

        // GET: /Authen/Login
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        // POST: /Authen/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var user = await _serviceProviders.AccountService.GetUserAccount(model.UserName, model.Password);
            if (user == null)
            {
                ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không đúng.");
                return View(model);
            }

            HttpContext.Session.SetInt32("UserAccountId", user.UserAccountId);
            HttpContext.Session.SetString("UserName", user.UserName);

            return RedirectToAction("Index", "TransactionsDucPvs");
        }


        // GET: /Authen/Logout
        [HttpGet]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login");
        }
    }
}
