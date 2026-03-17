class Vendor {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final double distance;
  final String imageUrl;
  final int minDelivery;
  final int maxDelivery;
  final double commission;
  final double deliveryFee;
  final List<MenuItem> menu;

  Vendor({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.imageUrl,
    required this.minDelivery,
    required this.maxDelivery,
    required this.commission,
    required this.deliveryFee,
    required this.menu,
  });

  factory Vendor.fromMap(Map<String, dynamic> map, String id) {
    return Vendor(
      id: id,
      name: map['name'] ?? '',
      cuisine: map['cuisine'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      distance: (map['distance'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      minDelivery: map['minDelivery'] ?? 15,
      maxDelivery: map['maxDelivery'] ?? 25,
      commission: (map['commission'] ?? 10).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 40).toDouble(),
      menu: (map['menu'] as List<dynamic>? ?? [])
          .map((e) => MenuItem.fromMap(e))
          .toList(),
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
