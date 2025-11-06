using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using EVCMS.Repositories.DucPV.DBContext;
using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV;

namespace EVCMS.MVCWebApp.DucPv.Controllers
{
    public class TransactionsDucPvsController : Controller
    {
        private readonly IServiceProviders _serviceProviders;

        public TransactionsDucPvsController(IServiceProviders serviceProviders)
        {
            _serviceProviders = serviceProviders;
        }


        public async Task<IActionResult> Index(
            string searchDescription,
            string searchAmount,
            string searchStatus, // "true", "false", hoặc null
            int page = 1,
            int pageSize = 10)
        {
            if (!IsLoggedIn())
                return RedirectToAction("Login", "Authen");

            var allTransactions = await _serviceProviders.TransactionService.GetAllAsync();

            // Filter an toàn
            if (!string.IsNullOrWhiteSpace(searchDescription))
                allTransactions = allTransactions
                    .Where(t => !string.IsNullOrEmpty(t.Description) && t.Description.Contains(searchDescription, StringComparison.OrdinalIgnoreCase))
                    .ToList();

            if (!string.IsNullOrWhiteSpace(searchAmount) && decimal.TryParse(searchAmount, out var amount))
                allTransactions = allTransactions
                    .Where(t => t.Amount == amount)
                    .ToList();

            if (!string.IsNullOrWhiteSpace(searchStatus) && bool.TryParse(searchStatus, out var statusBool))
                allTransactions = allTransactions
                    .Where(t => t.Status == statusBool)
                    .ToList();

            // Pagination
            var totalItems = allTransactions.Count;
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            var pagedTransactions = allTransactions
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewData["CurrentPage"] = page;
            ViewData["TotalPages"] = totalPages;
            ViewData["SearchDescription"] = searchDescription;
            ViewData["SearchAmount"] = searchAmount;
            ViewData["SearchStatus"] = searchStatus;

            return View(pagedTransactions);
        }


        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Authen");
        }

        private bool IsLoggedIn()
        {
            return HttpContext.Session.GetInt32("UserAccountId") != null;
        }

        public async Task<IActionResult> Details(int id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var transactionsDucPv = await _serviceProviders.TransactionService.GetByIdAsync(id);
            if (transactionsDucPv == null)
            {
                return NotFound();
            }

            return View(transactionsDucPv);
        }

        public async Task<IActionResult> Create()
        {
            ViewData["MethodDucPvid"] = new SelectList(await _serviceProviders.PaymentMethodsService.GetAllAsync(), "MethodDucPvid", "MethodType");
            ViewData["UserAccountId"] = new SelectList(await _serviceProviders.AccountService.GetAllAsync(), "UserAccountId", "Email");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("TransactionTransactionsDucPvid,UserAccountId,Amount,MethodDucPvid,Description,TransactionDate,Status,CreatedAt,UpdatedAt")] TransactionsDucPv transactionsDucPv)
        {
            if (ModelState.IsValid)
            {
                await _serviceProviders.TransactionService.CreateAsync(transactionsDucPv);
                return RedirectToAction(nameof(Index));
            }
            ViewData["MethodDucPvid"] = new SelectList(await _serviceProviders.PaymentMethodsService.GetAllAsync(), "MethodDucPvid", "MethodType", transactionsDucPv.MethodDucPvid);
            ViewData["UserAccountId"] = new SelectList(await _serviceProviders.AccountService.GetAllAsync(), "UserAccountId", "Email", transactionsDucPv.UserAccountId);
            return View(transactionsDucPv);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var transactionsDucPv = await _serviceProviders.TransactionService.GetByIdAsync(id);
            if (transactionsDucPv == null)
            {
                return NotFound();
            }
            ViewData["MethodDucPvid"] = new SelectList(await _serviceProviders.PaymentMethodsService.GetAllAsync(), "MethodDucPvid", "MethodType", transactionsDucPv.MethodDucPvid);
            ViewData["UserAccountId"] = new SelectList(await _serviceProviders.AccountService.GetAllAsync(), "UserAccountId", "Email", transactionsDucPv.UserAccountId);
            return View(transactionsDucPv);
        }


        [HttpPatch]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("TransactionTransactionsDucPvid,UserAccountId,Amount,MethodDucPvid,Description,TransactionDate,Status,CreatedAt,UpdatedAt")] TransactionsDucPv transactionsDucPv)
        {
            if (id != transactionsDucPv.TransactionTransactionsDucPvid)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    await _serviceProviders.TransactionService.UpdateAsync(transactionsDucPv);
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!TransactionsDucPvExists(transactionsDucPv.TransactionTransactionsDucPvid))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["MethodDucPvid"] = new SelectList(await _serviceProviders.PaymentMethodsService.GetAllAsync(), "MethodDucPvid", "MethodType", transactionsDucPv.MethodDucPvid);
            ViewData["UserAccountId"] = new SelectList(await _serviceProviders.AccountService.GetAllAsync(), "UserAccountId", "Email", transactionsDucPv.UserAccountId);
            return View(transactionsDucPv);
        }

        public async Task<IActionResult> Delete(int id)
        {
            var selectedTransaction = await _serviceProviders.TransactionService.GetByIdAsync(id);
            if (selectedTransaction == null)
            {
                return NotFound();
            }

            return View(selectedTransaction);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var selectedTransaction = await _serviceProviders.TransactionService.GetByIdAsync(id);
            if (selectedTransaction == null)
            {
                return NotFound();
            }

            await _serviceProviders.TransactionService.DeleteAsync(selectedTransaction);
            return RedirectToAction(nameof(Index));
        }

        private bool TransactionsDucPvExists(int id)
        {
            return _serviceProviders.TransactionService.GetByIdAsync(id) != null;
        }
    }
}
