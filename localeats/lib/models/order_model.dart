enum OrderStatus { placed, preparing, onTheWay, delivered }

class Order {
  final String id;
  final String vendorName;
  final List<Map<String, dynamic>> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String riderName;
  final String riderVehicle;
  final double riderRating;

  Order({
    required this.id,
    required this.vendorName,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.riderName,
    required this.riderVehicle,
    required this.riderRating,
  });
}
