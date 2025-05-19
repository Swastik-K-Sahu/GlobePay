class HomeViewModel extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  User? user;
  List<TransactionModel> transactions = [];
  String error = '';

  Future<void> loadUser(String userId) async {
    try {
      final userJson = await _api.get('/users/$userId');
      user = User.fromJson(userJson);

      final txJson = await _api.get('/transactions/history/$userId') as List;
      transactions = txJson.map((e) => TransactionModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
