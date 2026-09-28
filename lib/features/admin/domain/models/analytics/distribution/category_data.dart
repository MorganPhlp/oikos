class CategoryData {
  final String name;
  final double percentage, co2;
  const CategoryData({
    required this.name,
    required this.percentage,
    required this.co2,
  });
  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    name: json['name'] as String,
    percentage: (json['percentage'] as num).toDouble(),
    co2: (json['co2'] as num).toDouble(),
  );
}
