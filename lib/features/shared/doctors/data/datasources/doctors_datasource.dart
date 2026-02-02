import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/doctor_model.dart';
import '../../../../../core/utils/supabase_helper.dart';

// مصدر بيانات الأطباء المشترك
abstract class SharedDoctorsDatasource {
  // الحصول على جميع الأطباء
  Future<List<DoctorModel>> getAllDoctors();

  // الحصول على الأطباء المشهورين (أعلى تقييم)
  Future<List<DoctorModel>> getPopularDoctors({int limit = 10});

  // الحصول على طبيب بواسطة المعرف
  Future<DoctorModel> getDoctorById(String id);

  // البحث عن الأطباء
  Future<List<DoctorModel>> searchDoctors(String query);

  // الحصول على الأطباء حسب التخصص
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty);

  // البحث حسب الموقع
  Future<List<DoctorModel>> searchDoctorsByLocation(String location);

  // البحث حسب المستشفى
  Future<List<DoctorModel>> searchDoctorsByHospital(String hospital);
}

class SharedDoctorsDatasourceImpl implements SharedDoctorsDatasource {
  final SupabaseClient client = SupabaseHelper.client;

  // اسم الـ view في قاعدة البيانات
  static const String viewTable = 'doctor_with_review_stats';

  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          // .order('avg_review_rating', ascending: false)
          ;
      return (response as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<DoctorModel>> getPopularDoctors({int limit = 10}) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          // .order('avg_review_rating', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<DoctorModel> getDoctorById(String id) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .eq('doctor_id', id)
          .single();

      return DoctorModel.fromJson(response);
    });
  }

  @override
  Future<List<DoctorModel>> searchDoctors(String query) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .or(
            'doctor_name.ilike.%$query%,speciality_name.ilike.%$query%,hospital.ilike.%$query%,location.ilike.%$query%',
          )
          /// TODO : bu sorunu çöz
          // .order('avg_review_rating', ascending: false)
          ;

      return (response as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .eq('speciality_name', specialty)
          // .order('avg_review_rating', ascending: false)
          ;

      return (response as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<DoctorModel>> searchDoctorsByLocation(String location) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .ilike('location', '%$location%')
          // .order('avg_review_rating', ascending: false)
          ;

      return (response as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<DoctorModel>> searchDoctorsByHospital(String hospital) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .ilike('hospital', '%$hospital%')
          // .order('avg_review_rating', ascending: false)
          ;

      return (response as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    });
  }
}
