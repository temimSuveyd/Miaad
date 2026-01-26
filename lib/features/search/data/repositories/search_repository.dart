import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/doctor_model.dart';
import '../datasources/search_datasource.dart';

// مستودع البحث - إدارة العمليات مع معالجة الأخطاء
class SearchRepository {
  final SearchDatasource datasource;

  SearchRepository({required this.datasource});

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
