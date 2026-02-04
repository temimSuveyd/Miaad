import 'package:doctorbooking/core/error/failures.dart';
import 'package:doctorbooking/core/utils/either.dart';
import 'package:doctorbooking/features/auth/data/datasources/auth_data_source.dart';
import 'package:doctorbooking/features/auth/data/models/user_model.dart';
import 'package:doctorbooking/features/auth/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email ,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.signInWithEmailAndPassword(
        email: email ,
        password: password,
      );
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOTP({
    required String email 
  }) async {
    try {
      await _authDataSource.sendOTP(email: email);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> verifyOTPAndSignIn({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.verifyOTPAndSignIn(
        email: email,
        otp: otp,
        password: password,
      );
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createUserAfterOTP({
    required String name,
    required String email ,
    required String city,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.createUserAfterOTP(
        name: name,
        email: email ,
        city: city,
        password: password,
      );
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email ,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _authDataSource.resetPassword(
        email: email ,
        otp: otp,
        newPassword: newPassword,
      );
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createUser({
    required String name,
    required String email ,
    required String city,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.createUser(
        name: name,
        email: email ,
        city: city,
        password: password,
      );
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authDataSource.signOut();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = await _authDataSource.getCurrentUser();
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('خطأ غير معروف: ${e.toString()}'));
    }
  }
}
