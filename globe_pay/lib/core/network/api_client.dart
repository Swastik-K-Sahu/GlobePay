class ApiClient {
  final _baseUrl = 'http://localhost:8080/api'; // Change if hosted

  Future<dynamic> get(String path) async {
    final response = await http.get(Uri.parse('$_baseUrl$path'));
    _check(response);
    return json.decode(response.body);
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    _check(response);
    return json.decode(response.body);
  }

  void _check(http.Response r) {
    if (r.statusCode >= 400) {
      throw Exception(json.decode(r.body)['error']);
    }
  }
}
