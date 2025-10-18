using EVCMS.Repositories.DucPV.Models;
using EVCMS.Services.DucPV;
using EVCMS.Services.DucPV.Interfaces;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;

namespace EVCMS.RazorWebApp.DucPV.Hubs
{
    public class EVCMShub : Hub
    {
        private readonly ITransactionsServices _transactionsServices;
        private readonly IPaymentMethodsService _paymentMethosService;

        public EVCMShub(ITransactionsServices transactionsServices, IPaymentMethodsService paymentMethosService)
        {
            _transactionsServices = transactionsServices;
            _paymentMethosService = paymentMethosService;
        }

		public async Task HubDelete_TRansactionDucPVService(int transactionId)
		{
			var transaction = await _transactionsServices.GetByIdAsync(transactionId);
			if (transaction == null)
			{
				throw new HubException($"Transaction with ID {transactionId} not found.");
			}

			await _transactionsServices.DeleteAsync(transaction);

            await Clients.All.SendAsync("Receiver_DeleteTransactionDucPV", transactionId);

        }

        //public async Task NotifyTransactionDeleted(int transactionId)
        //{
        //    await Clients.All.SendAsync("HubDelete_TransactionDucPVService", transactionId);
        //}

        public async Task HubUpdate_TRansactionDucPVService(int transactionId)
        {
            var transaction = await _transactionsServices.GetByIdAsync(transactionId);
            if (transaction == null)
            {
                throw new HubException($"Transaction with ID {transactionId} not found.");
            }

            await _transactionsServices.UpdateAsync(transaction);

            await Clients.All.SendAsync("Receiver_UpdateTransactionDucPV", transactionId);
        }

        public async Task HubCreate_TransactionDucPVService(string TransactionDucPVJsonString)
        {
            var item = JsonConvert.DeserializeObject<TransactionsDucPv>(TransactionDucPVJsonString);

            var newId = await _transactionsServices.CreateAsync(item);

            var createdItem = await _transactionsServices.GetByIdAsync(newId);

            await Clients.All.SendAsync("Receiver_CreateTransactionDucPV", createdItem);
        }
    }
}
