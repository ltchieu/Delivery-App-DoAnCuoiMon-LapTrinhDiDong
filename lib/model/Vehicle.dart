class Vehicle {
  final String vehicleId;
  final String vehicleType;
  final String licensePlate;
  final int capacity;
  final String status;
  final double price;

  Vehicle({
    required this.vehicleId,
    required this.vehicleType,
    required this.licensePlate,
    required this.capacity,
    required this.status,
    required this.price,
  });

  // Phương thức để ánh xạ từ JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  // Phương thức để chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'vehicleType': vehicleType,
      'licensePlate': licensePlate,
      'capacity': capacity,
      'status': status,
      'price': price,
    };
  }
}