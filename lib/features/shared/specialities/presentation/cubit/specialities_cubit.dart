import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/specialities_repository.dart';
import 'specialities_state.dart';

class SharedSpecialitiesCubit extends Cubit<SpecialitiesState> {
  final SharedSpecialitiesRepository repository;

  SharedSpecialitiesCubit({required this.repository})
      : super(SpecialitiesInitial());

  Future<void> loadSpecialities() async {
    emit(SpecialitiesLoading());

    final result = await repository.getAllSpecialities();

    result.fold(
      (failure) => emit(SpecialitiesError(failure.message)),
      (specialities) =>
          emit(SpecialitiesLoaded(specialities: specialities)),
    );
  }
}
