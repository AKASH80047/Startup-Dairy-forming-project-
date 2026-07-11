import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../admin/presentation/bloc/admin_cubit.dart';
import '../../../admin/domain/entities/admin_village_entity.dart';
import '../bloc/lgd_villages_cubit.dart';
import '../bloc/lgd_villages_state.dart';

class LgdVillagesPage extends StatefulWidget {
  const LgdVillagesPage({super.key});

  @override
  State<LgdVillagesPage> createState() => _LgdVillagesPageState();
}

class _LgdVillagesPageState extends State<LgdVillagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedBlock = 'all'; // 'all', 'Naugarh', 'Bansi', 'Shohratgarh', 'Itwa', 'Dumariyaganj'

  @override
  void initState() {
    super.initState();
    context.read<LgdVillagesCubit>().fetchVillages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addVillageToDelivery(LgdVillageModel village, bool isHindi) {
    // Add LGD village to admin active delivery list
    final newAdminVillage = AdminVillageEntity(
      id: 'v_lgd_${village.villageCode}',
      nameEnglish: village.villageNameEnglish,
      nameHindi: village.villageNameLocal,
      district: village.districtName,
      state: village.stateName,
      pincode: village.pincode,
      isActive: true,
    );

    context.read<AdminCubit>().addVillage(newAdminVillage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHindi
              ? '${village.villageNameLocal} को सक्रिय डिलीवरी क्षेत्र में जोड़ा गया!'
              : '${village.villageNameEnglish} added to active delivery zones!',
        ),
        backgroundColor: AppConstants.primaryGreen,
        action: SnackBarAction(
          label: isHindi ? 'देखें' : 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            context.push('/admin');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'ग्राम निर्देशिका (LGD)' : 'LGD Villages Directory'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppConstants.surfaceWhite,
        foregroundColor: AppConstants.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: isHindi ? 'पुनः लोड करें' : 'Refresh List',
            onPressed: () => context.read<LgdVillagesCubit>().fetchVillages(),
          ),
        ],
      ),
      body: BlocBuilder<LgdVillagesCubit, LgdVillagesState>(
        builder: (context, state) {
          if (state is LgdVillagesLoading) {
            return _buildShimmerLoader();
          }

          if (state is LgdVillagesError) {
            return _buildErrorState(state.message, isHindi);
          }

          if (state is LgdVillagesSuccess) {
            final filteredList = state.villages.where((item) {
              final nameMatch = item.villageNameEnglish.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  item.villageNameLocal.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  item.pincode.contains(_searchQuery) ||
                  item.villageCode.contains(_searchQuery);
              if (!nameMatch) return false;

              if (_selectedBlock == 'all') return true;
              return item.blockName.toLowerCase() == _selectedBlock.toLowerCase();
            }).toList();

            final blockList = state.villages.map((v) => v.blockName).toSet().toList();

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // LGD Summary dashboard card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: _buildSummaryCard(state.isLive, state.villages.length, isHindi),
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
                          _buildFilterChips(blockList, isHindi),
                        ],
                      ),
                    ),
                  ),

                  // List of villages
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
                                    isHindi ? 'कोई गाँव नहीं मिला' : 'No villages matched your search',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.textPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isHindi ? 'कृपया दूसरा नाम या ब्लॉक फ़िल्टर आज़माएँ' : 'Try modifying your search or block filters',
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
                                return _buildVillageCard(item, isHindi);
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

  Widget _buildSummaryCard(bool isLive, int totalCount, bool isHindi) {
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
                isHindi ? 'सिद्धार्थनगर • उत्तर प्रदेश' : 'Siddharthnagar • Uttar Pradesh',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
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
                          : (isHindi ? 'स्थानीय डेटाबेस' : 'Demo DB'),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isHindi ? 'निर्देशिका में गाँव' : 'Villages Indexed',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Icon(Icons.villa_rounded, color: Colors.white24, size: 52),
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
          hintText: isHindi ? 'गाँव, पिनकोड या कोड खोजें...' : 'Search villages by name, pin, code...',
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

  Widget _buildFilterChips(List<String> blocks, bool isHindi) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            label: isHindi ? 'सभी ब्लॉक' : 'All Blocks',
            filterVal: 'all',
          ),
          ...blocks.map((block) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildChip(
                  label: block,
                  filterVal: block,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildChip({required String label, required String filterVal}) {
    final bool isSelected = _selectedBlock.toLowerCase() == filterVal.toLowerCase();
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedBlock = filterVal;
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

  Widget _buildVillageCard(LgdVillageModel item, bool isHindi) {
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
          child: const Icon(
            Icons.villa_outlined,
            color: Colors.green,
          ),
        ),
        title: Text(
          item.villageNameEnglish,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppConstants.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${isHindi ? "ब्लॉक" : "Block"}: ${item.blockName} • Pin ${item.pincode}',
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondary,
            ),
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_down_rounded, color: AppConstants.textSecondary),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 16),
                _buildDetailRow(
                  isHindi ? 'गाँव का नाम (Local)' : 'Local Name',
                  item.villageNameLocal,
                ),
                _buildDetailRow(
                  isHindi ? 'गाँव एलजीडी कोड' : 'LGD Village Code',
                  item.villageCode,
                ),
                _buildDetailRow(
                  isHindi ? 'ग्राम पंचायत (GP)' : 'Gram Panchayat',
                  item.gramPanchayatName,
                ),
                _buildDetailRow(
                  isHindi ? 'तहसील (Tehsil)' : 'Tehsil',
                  item.tehsilName,
                ),
                _buildDetailRow(
                  isHindi ? 'पिनकोड' : 'Pincode',
                  item.pincode,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _addVillageToDelivery(item, isHindi),
                  icon: const Icon(Icons.add_location_alt_rounded, size: 18, color: Colors.white),
                  label: Text(
                    isHindi ? 'सक्रिय डिलीवरी क्षेत्र में जोड़ें' : 'Add to Active Delivery Area',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
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
              onPressed: () => context.read<LgdVillagesCubit>().fetchVillages(),
              child: Text(isHindi ? 'पुनः प्रयास करें' : 'Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
