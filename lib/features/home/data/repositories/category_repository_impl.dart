import '../datasources/category_local_datasource.dart';
import '../models/category_model.dart';

class CategoryService {
  final CategoryLocalDataSource localDataSource;

  CategoryService({required this.localDataSource});

  List<CategoryModel> getCategories() {
    return localDataSource.getCategories();
  }
}
