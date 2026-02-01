import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/utils/supabase_helper.dart';
import '../model/speciality_model.dart';

abstract class SharedSpecialitiesDatasource {
  Future<List<SpecialityModel>> getAllSpecialities();
}

class SharedSpecialitiesDatasourceImpl implements SharedSpecialitiesDatasource {
  final SupabaseClient client = SupabaseHelper.client;

  static const String table = 'specialities';

  @override
  Future<List<SpecialityModel>> getAllSpecialities() async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client.from(table).select().order('idx');
      return (response as List)
          .map((json) => SpecialityModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }
}
