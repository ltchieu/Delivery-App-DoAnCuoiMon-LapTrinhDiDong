import 'package:json_annotation/json_annotation.dart';
import 'package:do_an_cuoi_mon/model/location_dto.dart';

part 'orde_response_dto.g.dart';

@JsonSerializable(
  explicitToJson: true,
) // Sử dụng explicitToJson để xử lý nested object
class OrderResponseDto {
  final String? orderID;
  final LocationDto? sourceLocation;
  final LocationDto? destinationLocation;
  final String? vehicleType;
  final double? totalAmount;
  final String? orderStatus;
  final String? paymentStatus;
  final DateTime? createdAt;
  final String? customerId;
  final String? tenNguoiNhan;
  String? deliveryPersonId;

  OrderResponseDto({
    this.orderID,
    this.sourceLocation,
    this.destinationLocation,
    this.vehicleType,
    this.totalAmount,
    this.orderStatus,
    this.paymentStatus,
    this.createdAt,
    this.customerId,
    this.tenNguoiNhan,
    this.deliveryPersonId,
  });

  factory OrderResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseDtoToJson(this);
}
