class SendPaymentScreen extends StatelessWidget {
  final String senderId;
  final String senderCurrency;
  final double senderBalance;

  const SendPaymentScreen({
    required this.senderId,
    required this.senderCurrency,
    required this.senderBalance,
  });

  @override
  Widget build(BuildContext context) {
    final vm = TransferViewModel();
    final recipientController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCurrency = senderCurrency;
    double? convertedAmount;

    return ChangeNotifierProvider(
      create: (_) => vm,
      child: Consumer<TransferViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text("Send Payment")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Available Balance: $senderBalance $senderCurrency"),
                  const SizedBox(height: 12),
                  TextField(
                    controller: recipientController,
                    decoration: const InputDecoration(labelText: "Recipient ID"),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: "Amount"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCurrency,
                    items: ['USD', 'EUR', 'INR', 'JPY']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        selectedCurrency = val;
                      }
                    },
                    decoration: const InputDecoration(labelText: "Target Currency"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final recipientId = recipientController.text;
                      final amount = double.tryParse(amountController.text);

                      if (recipientId == senderId) {
                        showError(context, "You cannot send money to yourself.");
                        return;
                      }

                      if (amount == null || amount <= 0) {
                        showError(context, "Please enter a valid amount.");
                        return;
                      }

                      if (amount > senderBalance) {
                        showError(context, "Insufficient balance.");
                        return;
                      }

                      if (selectedCurrency != senderCurrency) {
                        final api = ApiClient();
                        try {
                          final rate = await api.get(
                              '/currency/rate?from=$senderCurrency&to=$selectedCurrency');
                          convertedAmount = amount * (rate as num).toDouble();
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Confirm Exchange"),
                              content: Text(
                                  "$amount $senderCurrency will be converted to ${convertedAmount!.toStringAsFixed(2)} $selectedCurrency"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirm")),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                        } catch (e) {
                          showError(context, "Failed to fetch exchange rate.");
                          return;
                        }
                      }

                      await vm.sendPayment(
                        senderId,
                        recipientId,
                        amount,
                        senderCurrency,
                        selectedCurrency,
                      );

                      if (vm.success) {
                        Navigator.pop(context); // go back to home
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Payment sent successfully!")),
                        );
                      } else if (vm.error.isNotEmpty) {
                        showError(context, vm.error);
                      }
                    },
                    child: const Text("Send Money"),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    label: const Text("Back"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }
}
