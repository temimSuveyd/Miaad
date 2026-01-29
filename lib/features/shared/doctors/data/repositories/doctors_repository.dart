import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../model/doctor_model.dart';
import '../datasources/doctors_datasource.dart';

// مستودع الأطباء المشترك - إدارة العمليات مع معالجة الأخطاء
class SharedDoctorsRepository {
  final SharedDoctorsDatasource datasource;

  SharedDoctorsRepository({required this.datasource});

  // الحصول على جميع الأطباء
  Future<Either<Failure, List<DoctorModel>>> getAllDoctors() async {
    try {
      final result = await datasource.getAllDoctors();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على الأطباء المشهورين
  Future<Either<Failure, List<DoctorModel>>> getPopularDoctors({
    int limit = 10,
  }) async {
    try {
      final result = await datasource.getPopularDoctors(limit: limit);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على طبيب بواسطة المعرف
  Future<Either<Failure, DoctorModel>> getDoctorById(String id) async {
    try {
      final result = await datasource.getDoctorById(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // البحث عن الأطباء
  Future<Either<Failure, List<DoctorModel>>> searchDoctors(String query) async {
    try {
      final result = await datasource.searchDoctors(query);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على الأطباء حسب التخصص
  Future<Either<Failure, List<DoctorModel>>> getDoctorsBySpecialty(
    String specialty,
  ) async {
    try {
      final result = await datasource.getDoctorsBySpecialty(specialty);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // البحث حسب الموقع
  Future<Either<Failure, List<DoctorModel>>> searchDoctorsByLocation(
    String location,
  ) async {
    try {
      final result = await datasource.searchDoctorsByLocation(location);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // البحث حسب المستشفى
  Future<Either<Failure, List<DoctorModel>>> searchDoctorsByHospital(
    String hospital,
  ) async {
    try {
      final result = await datasource.searchDoctorsByHospital(hospital);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }
}
