class Order {
  final String type;
  final String fromAddress;
  final String toAddress;
  final String dateTime;
  final String status;

  Order({
    required this.type,
    required this.fromAddress,
    required this.toAddress,
    required this.dateTime,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      type: json['type'] ?? '',
      fromAddress: json['fromAddress'] ?? '',
      toAddress: json['toAddress'] ?? '',
      dateTime: json['dateTime'] ?? '',
      status: json['status'] ?? '',
    );
  }
}