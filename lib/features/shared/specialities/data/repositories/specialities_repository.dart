import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../datasources/specialities_datasource.dart';
import '../model/speciality_model.dart';

class SharedSpecialitiesRepository {
  final SharedSpecialitiesDatasource datasource;

  SharedSpecialitiesRepository({required this.datasource});

  Future<Either<Failure, List<SpecialityModel>>> getAllSpecialities() async {
    try {
      final result = await datasource.getAllSpecialities();
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
