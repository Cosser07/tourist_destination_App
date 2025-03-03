class TouristDestination {
  final String name;
  final double rating;
  final DateTime visitDate;
  final String category;

  TouristDestination({
    required this.name,
    required this.rating,
    required this.visitDate,
    required this.category,
  });

  // ✅ แปลงเป็น JSON สำหรับบันทึก
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'visitDate': visitDate.toIso8601String(),
      'category': category,
    };
  }

  // ✅ แปลงจาก JSON กลับเป็น Object
  factory TouristDestination.fromJson(Map<String, dynamic> json) {
    return TouristDestination(
      name: json['name'],
      rating: json['rating'],
      visitDate: DateTime.parse(json['visitDate']),
      category: json['category'],
    );
  }
}