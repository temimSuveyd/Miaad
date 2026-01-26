import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/theme/app_theme.dart';

class SearchResultsHeaderWidget extends StatelessWidget {
  final String query;
  final int resultsCount;
  final bool isShowingAllDoctors;
  final bool isSearchResult;

  const SearchResultsHeaderWidget({
    super.key,
    required this.query,
    required this.resultsCount,
    required this.isShowingAllDoctors,
    required this.isSearchResult,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16.dp,
        vertical: AppTheme.spacing8.dp,
      ),
      child: Row(
        children: [
          Text(
            isShowingAllDoctors && !isSearchResult
                ? 'جميع الأطباء المتاحين'
                : 'نتائج البحث عن: "$query"',
            style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
          ),
          const Spacer(),
          Text(
            '$resultsCount ${isShowingAllDoctors && !isSearchResult ? 'طبيب' : 'نتيجة'}',
            style: AppTheme.caption.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
