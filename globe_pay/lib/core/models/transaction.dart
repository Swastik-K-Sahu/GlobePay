enum TransactionDirection { sent, received }

class TransactionModel {
  final TransactionDirection direction;
  final String counterparty;
  final double amount;
  final double convertedAmount;
  final String currency;
  final DateTime timestamp;
  final String type;

  TransactionModel({
    required this.direction,
    required this.counterparty,
    required this.amount,
    required this.convertedAmount,
    required this.currency,
    required this.timestamp,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    direction: json['direction'] == 'SENT' ? TransactionDirection.sent : TransactionDirection.received,
    counterparty: json['counterparty'],
    amount: (json['amount'] as num).toDouble(),
    convertedAmount: (json['convertedAmount'] as num).toDouble(),
    currency: json['currency'],
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'],
  );
}
