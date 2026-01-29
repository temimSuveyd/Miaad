import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/error_state_widget.dart';
import '../../../../home/presentation/widgets/home/doctor_card_shimmer.dart';
import '../../../../shared/doctors/presentation/cubit/doctors_state.dart';
import '../../cubit/search_cubit.dart';
import 'search_results_header_widget.dart';
import 'search_results_list_widget.dart';

class SearchResultsWidget extends StatelessWidget {
  final TextEditingController searchController;

  const SearchResultsWidget({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, DoctorsState>(
      builder: (context, state) {
        if (state is DoctorsInitial) {
          return _buildEmptyState(
            context,
            'ابدأ البحث عن طبيبك المفضل',
            isSearching: false,
          );
        }

        if (state is DoctorsLoading) {
          return Column(
            children: [
              // Show search query while loading
              if (searchController.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16.dp,
                    vertical: AppTheme.spacing8.dp,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'البحث عن: "${searchController.text}"',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Expanded(child: DoctorCardsShimmerList(itemCount: 5)),
              ),
            ],
          );
        }

        if (state is DoctorsError) {
          return ErrorStateWidget(
            title: 'خطأ في البحث',
            message: state.message,
            onRetry: () {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                context.read<SearchCubit>().retry(query);
              } else {
                context.read<SearchCubit>().loadAllDoctors();
              }
            },
          );
        }

        if (state is DoctorsSearchEmpty) {
          return _buildEmptyState(
            context,
            'لم يتم العثور على نتائج للبحث "${state.query}"',
            isSearching: true,
          );
        }

        if (state is DoctorsSearchLoaded) {
          final isShowingAllDoctors = state.query == 'جميع الأطباء';
          final isSearchResult = searchController.text.isNotEmpty;

          return Column(
            children: [
              // Search results header
              SearchResultsHeaderWidget(
                query: state.query,
                resultsCount: state.searchResults.length,
                isShowingAllDoctors: isShowingAllDoctors,
                isSearchResult: isSearchResult,
              ),

              // Results list
              Expanded(
                child: SearchResultsListWidget(doctors: state.searchResults),
              ),
            ],
          );
        }

        if (state is DoctorsLoaded) {
          // When showing all doctors (initial load)
          final isShowingAllDoctors = searchController.text.isEmpty;

          return Column(
            children: [
              // Search results header
              SearchResultsHeaderWidget(
                query: 'جميع الأطباء',
                resultsCount: state.doctors.length,
                isShowingAllDoctors: isShowingAllDoctors,
                isSearchResult: false,
              ),

              // Results list
              Expanded(child: SearchResultsListWidget(doctors: state.doctors)),
            ],
          );
        }

        return _buildEmptyState(
          context,
          'ابدأ البحث عن طبيبك المفضل',
          isSearching: false,
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String message, {
    required bool isSearching,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacing24.dp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.search,
              size: 64.dp,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: AppTheme.spacing16.dp),
            Text(
              message,
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.spacing12.dp),
            Text(
              isSearching
                  ? 'جرب البحث بكلمات مختلفة أو تحقق من الإملاء'
                  : 'يمكنك البحث عن طبيب بالاسم أو التخصص أو المستشفى',
              style: AppTheme.caption.copyWith(
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
