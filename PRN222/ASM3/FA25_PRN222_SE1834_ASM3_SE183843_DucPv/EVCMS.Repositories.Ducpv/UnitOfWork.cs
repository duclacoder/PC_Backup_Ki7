using EVCMS.Repositories.DucPV.DBContext;
using EVCMS.Repositories.DucPV.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EVCMS.Repositories.DucPV
{
    public interface IUnitOfWork
    {
        UserAccountRepository UserAccountRepository { get; }
        TransactionsDucPvRepository TransactionsDucPvRepository { get; }
        PaymentMethodsDucPvRepository PaymentMethodsDucPvRepository { get; }

        int SaveChange();
        Task<int> SaveChangesAsync();
    }
    public class UnitOfWork : IUnitOfWork
    {
        private readonly FA25_PRN222_SE1834_G2_EVCMSContext _context;
        private TransactionsDucPvRepository _transactionsDucPvRepository;
        private PaymentMethodsDucPvRepository _paymentMethodsDucPvRepository;
        private UserAccountRepository _userAccountRepository;

        public UnitOfWork() => _context ??= new FA25_PRN222_SE1834_G2_EVCMSContext();

		public UnitOfWork(FA25_PRN222_SE1834_G2_EVCMSContext context, TransactionsDucPvRepository transactionsDucPvRepository, PaymentMethodsDucPvRepository paymentMethodsDucPvRepository, UserAccountRepository userAccountRepository)
		{
			_context = context;
			_transactionsDucPvRepository = transactionsDucPvRepository;
			_paymentMethodsDucPvRepository = paymentMethodsDucPvRepository;
			_userAccountRepository = userAccountRepository;
		}

		public UserAccountRepository UserAccountRepository
        {
            get { return _userAccountRepository ?? new UserAccountRepository(_context); }
        }

        public TransactionsDucPvRepository TransactionsDucPvRepository
        {
            get { return _transactionsDucPvRepository ?? new TransactionsDucPvRepository(_context); }
        }

        public PaymentMethodsDucPvRepository PaymentMethodsDucPvRepository
        {
            get { return _paymentMethodsDucPvRepository ?? new PaymentMethodsDucPvRepository(_context); }
        }

        public int SaveChange()
        {
            int result = -1;
            using (var DbContextTransaction = _context.Database.BeginTransaction())
            {
                try
                {
                    result = _context.SaveChanges();
                    DbContextTransaction.Commit();
                }
                catch (Exception)
                {
                    result = -1;
                    DbContextTransaction.Rollback();
                }                
            }

            return result;
        }

        public async Task<int> SaveChangesAsync()
        {
            int result = -1;

            using(var DbContextTransaction = _context.Database.BeginTransactionAsync())
            {
                try
                {
                    result = await _context.SaveChangesAsync();
                    await DbContextTransaction.Result.CommitAsync();
                }
                catch (Exception)
                {
                    result = 0;
                    await DbContextTransaction.Result.RollbackAsync();
                }
            }

            return result;
        }
    }
}
