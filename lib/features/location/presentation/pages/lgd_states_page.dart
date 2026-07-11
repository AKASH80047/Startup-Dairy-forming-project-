import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/lgd_cubit.dart';
import '../bloc/lgd_state.dart';

class LgdStatesPage extends StatefulWidget {
  const LgdStatesPage({super.key});

  @override
  State<LgdStatesPage> createState() => _LgdStatesPageState();
}

class _LgdStatesPageState extends State<LgdStatesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all'; // 'all', 'S', 'U'

  @override
  void initState() {
    super.initState();
    context.read<LgdCubit>().fetchStates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'राज्य निर्देशिका (LGD)' : 'LGD States Directory'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppConstants.surfaceWhite,
        foregroundColor: AppConstants.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: isHindi ? 'पुनः लोड करें' : 'Refresh List',
            onPressed: () => context.read<LgdCubit>().fetchStates(),
          ),
        ],
      ),
      body: BlocBuilder<LgdCubit, LgdState>(
        builder: (context, state) {
          if (state is LgdLoading) {
            return _buildShimmerLoader();
          }

          if (state is LgdError) {
            return _buildErrorState(state.message, isHindi);
          }

          if (state is LgdSuccess) {
            final filteredList = state.states.where((item) {
              final nameMatch = item.stateNameEnglish.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  item.stateNameLocal.toLowerCase().contains(_searchQuery.toLowerCase());
              if (!nameMatch) return false;

              if (_selectedFilter == 'all') return true;
              return item.stateOrUt.toUpperCase() == _selectedFilter;
            }).toList();

            final int stateCount = state.states.where((s) => s.stateOrUt.toUpperCase() == 'S').length;
            final int utCount = state.states.where((s) => s.stateOrUt.toUpperCase() == 'U').length;

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // LGD Summary dashboard card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: _buildSummaryCard(state.isLive, stateCount, utCount, isHindi),
                    ),
                  ),

                  // Search and filter panel
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchField(isHindi),
                          const SizedBox(height: 12),
                          _buildFilterChips(isHindi),
                        ],
                      ),
                    ),
                  ),

                  // List of states
                  filteredList.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_rounded, size: 64, color: AppConstants.textSecondary),
                                  const SizedBox(height: 16),
                                  Text(
                                    isHindi ? 'कोई परिणाम नहीं मिला' : 'No states matched your query',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.textPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isHindi ? 'कृपया दूसरा नाम या फ़िल्टर आज़माएँ' : 'Try modifying your search query or filters',
                                    style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = filteredList[index];
                                return _buildStateCard(item, isHindi);
                              },
                              childCount: filteredList.length,
                            ),
                          ),
                        ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryCard(bool isLive, int stateCount, int utCount, bool isHindi) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.primaryGreen, const Color(0xFF165933)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGreen.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'भारत का प्रशासनिक ढांचा' : 'LGD Administrative Directory',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              // Live/Local indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isLive ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isLive ? Colors.greenAccent : Colors.orangeAccent,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isLive ? Colors.greenAccent : Colors.orangeAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLive
                          ? (isHindi ? 'लाइव डेटा' : 'Live API')
                          : (isHindi ? 'स्थानीय सूची' : 'Demo DB'),
                      style: TextStyle(
                        color: isLive ? Colors.greenAccent : Colors.orangeAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$stateCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isHindi ? 'कुल राज्य' : 'Total States',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$utCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isHindi ? 'केंद्र शासित प्रदेश' : 'Union Territories',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isHindi) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: isHindi ? 'राज्य या कोड खोजें...' : 'Search states by name or code...',
          hintStyle: TextStyle(color: AppConstants.textSecondary.withValues(alpha: 0.6), fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: AppConstants.primaryGreen),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.cancel_rounded),
                  color: AppConstants.textSecondary,
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isHindi) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            label: isHindi ? 'सभी' : 'All',
            filterVal: 'all',
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: isHindi ? 'राज्य' : 'States',
            filterVal: 'S',
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: isHindi ? 'केंद्र शासित प्रदेश' : 'Union Territories',
            filterVal: 'U',
          ),
        ],
      ),
    );
  }

  Widget _buildChip({required String label, required String filterVal}) {
    final bool isSelected = _selectedFilter == filterVal;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filterVal;
          });
        }
      },
      selectedColor: AppConstants.primaryGreen.withValues(alpha: 0.12),
      checkmarkColor: AppConstants.primaryGreen,
      labelStyle: TextStyle(
        color: isSelected ? AppConstants.primaryGreen : AppConstants.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      backgroundColor: AppConstants.surfaceWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppConstants.primaryGreen : AppConstants.dividerColor,
          width: isSelected ? 1.0 : 0.5,
        ),
      ),
    );
  }

  Widget _buildStateCard(LgdStateModel item, bool isHindi) {
    final isUt = item.stateOrUt.toUpperCase() == 'U';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
      ),
      color: AppConstants.surfaceWhite,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryGreen.withValues(alpha: 0.08),
          child: Text(
            item.stateCode,
            style: TextStyle(
              color: AppConstants.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          item.stateNameEnglish,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppConstants.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            item.stateNameLocal,
            style: TextStyle(
              fontSize: 13,
              color: AppConstants.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isUt
                ? Colors.blue.withValues(alpha: 0.08)
                : AppConstants.primaryGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isUt
                ? (isHindi ? 'केंद्र शासित प्रदेश' : 'UT')
                : (isHindi ? 'राज्य' : 'State'),
            style: TextStyle(
              color: isUt ? Colors.blue.shade700 : AppConstants.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 16),
                _buildDetailRow(
                  isHindi ? 'एलजीडी स्टेट कोड (LGD Code)' : 'LGD Code',
                  item.stateCode,
                ),
                _buildDetailRow(
                  isHindi ? 'स्थानीय भाषा नाम' : 'Local Name',
                  item.stateNameLocal,
                ),
                _buildDetailRow(
                  isHindi ? 'जनगणना 2011 कोड (Census 2011)' : 'Census 2011 Code',
                  item.stateCensus2011Code.isEmpty ? 'N/A' : item.stateCensus2011Code,
                ),
                _buildDetailRow(
                  isHindi ? 'अंतिम अद्यतन तिथि' : 'Last Updated',
                  item.lastUpdated,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => Container(
                height: 72,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, bool isHindi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              isHindi ? 'लोड करने में विफल' : 'Failed to fetch directory',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<LgdCubit>().fetchStates(),
              child: Text(isHindi ? 'पुनः प्रयास करें' : 'Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
