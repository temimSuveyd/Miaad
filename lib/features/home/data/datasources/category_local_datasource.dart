import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  List<CategoryModel> getCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  @override
  List<CategoryModel> getCategories() {
    return [
      const CategoryModel(id: 1, icon: "heart.png", title: "قلب"),
      const CategoryModel(id: 2, icon: "urology.png", title: "مسالك"),
      const CategoryModel(id: 3, icon: "diet.png", title: "تغذية"),
      const CategoryModel(id: 4, icon: "eye.png", title: "عيون"),
      const CategoryModel(id: 5, icon: "surgery.png", title: "جراحة"),
      const CategoryModel(id: 6, icon: "dentist.png", title: "أسنان"),
      const CategoryModel(id: 7, icon: "pediatric.png", title: "أطفال"),
      const CategoryModel(id: 8, icon: "gynecology.png", title: "نسائية"),
    ];
  }
}
