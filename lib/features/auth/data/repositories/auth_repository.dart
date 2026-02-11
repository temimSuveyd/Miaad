import 'package:doctorbooking/core/error/failures.dart';
import 'package:doctorbooking/core/utils/either.dart';
import 'package:doctorbooking/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> sendOTP({
    required String email,
  });

  Future<Either<Failure, void>> verifyOTPForSession({
    required String email,
    required String otp,
  });

  Future<Either<Failure, UserModel>> verifyOTPAndSignIn({
    required String email,
    required String otp,
    required String password,
  });

  Future<Either<Failure, UserModel>> createUserAfterOTP({
    required String name,
    required String email,
    required String city,
    required String password,
    String? phone,
    String? dateOfBirth,
  });

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<Either<Failure, void>> createNewPassword({
    required String email,
    required String newPassword,
  });

  Future<Either<Failure, UserModel>> createUser({
    required String name,
    required String email,
    required String city,
    required String password,
    String? phone,
    String? dateOfBirth,
  });

  Future<Either<Failure, void>> signOut();
  
  Future<Either<Failure, UserModel?>> getCurrentUser();
}
