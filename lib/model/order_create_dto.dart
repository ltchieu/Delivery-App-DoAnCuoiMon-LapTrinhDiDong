import 'package:do_an_cuoi_mon/model/location_dto.dart';
import 'package:do_an_cuoi_mon/model/order_item_dto.dart';
import 'package:do_an_cuoi_mon/model/payment_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_create_dto.g.dart';

@JsonSerializable()
class OrderCreateDto {
  @JsonKey(name: 'CustomerId')
  final String customerId;

  @JsonKey(name: 'Serviceid')
  final String? serviceId;

  @JsonKey(name: 'DeliveryPersonId')
  final String? deliveryPersonId;

  @JsonKey(name: 'TotalAmount')
  final double totalAmount;

  @JsonKey(name: 'SourceLocation')
  final LocationDto? sourceLocation;

  @JsonKey(name: 'DestinationLocation')
  final LocationDto? destinationLocation;

  @JsonKey(name: 'EstimatedDeliveryTime')
  final DateTime? estimatedDeliveryTime;

  @JsonKey(name: 'ActualDeliveryTime')
  final DateTime? actualDeliveryTime;

  @JsonKey(name: 'PickupTime')
  final DateTime? pickupTime;

  @JsonKey(name: 'TenNguoiNhan')
  final String? tenNguoiNhan;

  @JsonKey(name: 'SdtnguoiNhan')
  final String? sdtNguoiNhan;

  @JsonKey(name: 'OrderItems')
  final List<OrderItemDto> orderItems;

  @JsonKey(name: 'Payment')
  final PaymentDto? payment;

  @JsonKey(name: 'VehicleId')
  final String? vehicleId;

  OrderCreateDto({
    required this.customerId,
    this.serviceId,
    this.deliveryPersonId,
    required this.totalAmount,
    this.sourceLocation,
    this.destinationLocation,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.pickupTime,
    this.tenNguoiNhan,
    this.sdtNguoiNhan,
    required this.orderItems,
    this.payment,
    this.vehicleId,
  });

  factory OrderCreateDto.fromJson(Map<String, dynamic> json) =>
      _$OrderCreateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCreateDtoToJson(this);
}
