import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/search_cubit.dart';
import '../widgets/search/search_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = sl<SearchCubit>();

    // Load all doctors initially
    _searchCubit.loadAllDoctors();

    // Auto focus on search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Listen to search controller changes for real-time search
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      // If search is cleared, load all doctors
      _searchCubit.loadAllDoctors();
    } else {
      // Otherwise search with the query
      _searchCubit.searchDoctors(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    // Load all doctors when search is cleared
    _searchCubit.loadAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              focusNode: _focusNode,
              onClear: _clearSearch,
            ),

            // Search Results
            Expanded(
              child: SearchResultsWidget(searchController: _searchController),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppTheme.textPrimary,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('البحث عن طبيب', style: AppTheme.heading2),
      centerTitle: true,
    );
  }
}
