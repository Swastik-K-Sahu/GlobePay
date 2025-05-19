class TransferViewModel extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  bool success = false;
  String error = '';

  Future<void> sendPayment(String senderId, String recipientId, double amount, String fromCurrency, String toCurrency) async {
    try {
      await _api.post('/transactions/send', {
        'senderId': senderId,
        'recipientId': recipientId,
        'amount': amount,
        'sourceCurrency': fromCurrency,
        'targetCurrency': toCurrency
      });
      success = true;
    } catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
