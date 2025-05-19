class User {
  final String id;
  final String name;
  final String currency;
  final double balance;

  User({required this.id, required this.name, required this.currency, required this.balance});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    currency: json['currency'],
    balance: (json['balance'] as num).toDouble(),
  );
}
