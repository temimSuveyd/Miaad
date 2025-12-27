class CategoryModel {
  final int id;
  final String icon;
  final String title;
  const CategoryModel({
    required this.id,
    required this.icon,
    required this.title,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel &&
        other.id == id &&
        other.icon == icon &&
        other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ icon.hashCode ^ title.hashCode;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      icon: json['icon'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'icon': icon, 'title': title};
  }

  factory CategoryModel.fromCategory(CategoryModel category) {
    return CategoryModel(
      id: category.id,
      icon: category.icon,
      title: category.title,
    );
  }
}
