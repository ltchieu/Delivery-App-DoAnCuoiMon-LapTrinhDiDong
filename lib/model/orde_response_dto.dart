import 'package:do_an_cuoi_mon/model/location_dto.dart';

class OrderResponseDto {
  String? orderID;
  LocationDto? sourceLocation;
  LocationDto? destinationLocation;
  String? vehicleType;
  double? totalAmount;
  String? orderStatus;
  String? paymentStatus;
  DateTime? createdAt;

  OrderResponseDto({
    this.orderID,
    this.sourceLocation,
    this.destinationLocation,
    this.vehicleType,
    this.totalAmount,
    this.orderStatus,
    this.paymentStatus,
    this.createdAt,
  });

  factory OrderResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderResponseDto(
      orderID: json['orderID'] as String?,
      sourceLocation:
          json['sourceLocation'] != null
              ? LocationDto.fromJson(
                json['sourceLocation'] as Map<String, dynamic>,
              )
              : null,
      destinationLocation:
          json['destinationLocation'] != null
              ? LocationDto.fromJson(
                json['destinationLocation'] as Map<String, dynamic>,
              )
              : null,
      vehicleType: json['vehicleType'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      orderStatus: json['orderStatus'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
    );
  }
}
