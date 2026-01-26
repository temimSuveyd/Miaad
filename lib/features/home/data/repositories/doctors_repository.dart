import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/doctor_model.dart';
import '../datasources/doctors_datasource.dart';

// مستودع الأطباء - إدارة العمليات مع معالجة الأخطاء
class DoctorsRepository {
  final DoctorsDatasource datasource;

  DoctorsRepository({required this.datasource});

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
}
