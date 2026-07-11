import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/administrative_state.dart';
import '../../domain/entities/district.dart';
import '../../domain/entities/sub_district.dart';
import '../../domain/entities/village.dart';
import '../bloc/administrative_location_bloc.dart';
import '../bloc/administrative_location_event.dart';
import '../bloc/administrative_location_state.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    context.read<AdministrativeLocationBloc>().add(LoadStatesRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<AdministrativeLocationBloc>().add(VillageSearchQueryChanged(query));
      }
    });
  }

  void _onSaveLocation(Village village, bool isHindi) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHindi
              ? 'स्थान चुना गया: ${village.nameHi ?? village.nameEn}'
              : 'Location Selected: ${village.nameEn}',
        ),
        backgroundColor: AppConstants.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'डिलीवरी स्थान चुनें' : 'Select Delivery Location'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppConstants.surfaceWhite,
        foregroundColor: AppConstants.primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: isHindi ? 'पुनः सेट करें' : 'Reset Selection',
            onPressed: () {
              _searchController.clear();
              context.read<AdministrativeLocationBloc>().add(AdministrativeLocationReset());
              context.read<AdministrativeLocationBloc>().add(LoadStatesRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<AdministrativeLocationBloc, AdministrativeLocationState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Branding logo/title card
                  _buildBrandingCard(isHindi),
                  const SizedBox(height: 24),

                  // State Dropdown (Cascading Selector 1)
                  _buildLabel(isHindi ? 'State / राज्य *' : 'State / UT *'),
                  _buildStateDropdown(state, isHindi),
                  const SizedBox(height: 16),

                  // District Dropdown (Cascading Selector 2)
                  _buildLabel(isHindi ? 'District / जिला *' : 'District *'),
                  _buildDistrictDropdown(state, isHindi),
                  const SizedBox(height: 16),

                  // Tehsil Dropdown (Cascading Selector 3)
                  _buildLabel(isHindi ? 'Tehsil / तहसील *' : 'Tehsil / Sub-District *'),
                  _buildTehsilDropdown(state, isHindi),
                  const SizedBox(height: 16),

                  // Village Dropdown/Search (Cascading Selector 4)
                  _buildLabel(isHindi ? 'Village / गाँव *' : 'Village *'),
                  _buildVillageSearchSection(state, isHindi),
                  const SizedBox(height: 24),

                  // Confirm button
                  ElevatedButton(
                    onPressed: state.selectedVillage != null
                        ? () => _onSaveLocation(state.selectedVillage!, isHindi)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryGreen,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppConstants.dividerColor,
                      disabledForegroundColor: AppConstants.textSecondary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isHindi ? 'आगे बढ़ें / सुरक्षित करें' : 'Save & Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandingCard(bool isHindi) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFFE5DCD0), width: 1.0),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on_rounded, color: AppConstants.primaryGreen, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'पांडेय डेयरी फार्मिंग' : 'Pandey Dairy Farming',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppConstants.primaryGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHindi ? 'अपना प्रशासनिक पता सेट करें' : 'Set your administrative location',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimary,
        ),
      ),
    );
  }

  Widget _buildDropdownContainer({required Widget child, bool isEnabled = true}) {
    return Container(
      decoration: BoxDecoration(
        color: isEnabled ? AppConstants.surfaceWhite : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEnabled ? const Color(0xFFE5DCD0) : Colors.grey.shade200,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: child,
    );
  }

  Widget _buildStateDropdown(AdministrativeLocationState state, bool isHindi) {
    final bool isEnabled = state.states.isNotEmpty;

    return _buildDropdownContainer(
      isEnabled: isEnabled && !state.isLoadingStates,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AdministrativeState>(
          isExpanded: true,
          value: state.selectedState,
          hint: state.isLoadingStates
              ? Row(
                  children: [
                    const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 12),
                    Text(isHindi ? 'लोड हो रहा है...' : 'Loading States...'),
                  ],
                )
              : Text(isHindi ? 'राज्य चुनें' : 'Select State / UT'),
          onChanged: isEnabled && !state.isLoadingStates
              ? (val) {
                  context.read<AdministrativeLocationBloc>().add(StateSelected(val));
                }
              : null,
          items: state.states.map((item) {
            return DropdownMenuItem<AdministrativeState>(
              value: item,
              child: Text(isHindi ? (item.nameHi ?? item.nameEn) : item.nameEn),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDistrictDropdown(AdministrativeLocationState state, bool isHindi) {
    final bool isEnabled = state.selectedState != null;

    return _buildDropdownContainer(
      isEnabled: isEnabled && !state.isLoadingDistricts,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<District>(
          isExpanded: true,
          value: state.selectedDistrict,
          hint: state.isLoadingDistricts
              ? Row(
                  children: [
                    const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 12),
                    Text(isHindi ? 'लोड हो रहा है...' : 'Loading Districts...'),
                  ],
                )
              : Text(
                  state.selectedState == null
                      ? (isHindi ? 'पहले राज्य चुनें' : 'Choose State first')
                      : (isHindi ? 'जिला चुनें' : 'Select District'),
                ),
          onChanged: isEnabled && !state.isLoadingDistricts
              ? (val) {
                  context.read<AdministrativeLocationBloc>().add(DistrictSelected(val));
                }
              : null,
          items: state.districts.map((item) {
            return DropdownMenuItem<District>(
              value: item,
              child: Text(isHindi ? (item.nameHi ?? item.nameEn) : item.nameEn),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTehsilDropdown(AdministrativeLocationState state, bool isHindi) {
    final bool isEnabled = state.selectedDistrict != null;

    return _buildDropdownContainer(
      isEnabled: isEnabled && !state.isLoadingSubDistricts,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SubDistrict>(
          isExpanded: true,
          value: state.selectedSubDistrict,
          hint: state.isLoadingSubDistricts
              ? Row(
                  children: [
                    const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 12),
                    Text(isHindi ? 'लोड हो रहा है...' : 'Loading Tehsils...'),
                  ],
                )
              : Text(
                  state.selectedDistrict == null
                      ? (isHindi ? 'पहले जिला चुनें' : 'Choose District first')
                      : (isHindi ? 'तहसील चुनें' : 'Select Tehsil'),
                ),
          onChanged: isEnabled && !state.isLoadingSubDistricts
              ? (val) {
                  context.read<AdministrativeLocationBloc>().add(SubDistrictSelected(val));
                }
              : null,
          items: state.subDistricts.map((item) {
            return DropdownMenuItem<SubDistrict>(
              value: item,
              child: Text(isHindi ? (item.nameHi ?? item.nameEn) : item.nameEn),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVillageSearchSection(AdministrativeLocationState state, bool isHindi) {
    final bool isEnabled = state.selectedSubDistrict != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search text field
        Container(
          decoration: BoxDecoration(
            color: isEnabled ? AppConstants.surfaceWhite : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEnabled
                  ? (state.selectedVillage != null ? AppConstants.primaryGreen : const Color(0xFFE5DCD0))
                  : Colors.grey.shade200,
              width: state.selectedVillage != null ? 1.5 : 1.0,
            ),
          ),
          child: TextField(
            controller: _searchController,
            enabled: isEnabled,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: isEnabled
                  ? (isHindi ? 'गाँव का नाम टाइप करें...' : 'Type village name to search...')
                  : (isHindi ? 'पहले तहसील चुनें' : 'Choose Tehsil first'),
              prefixIcon: Icon(Icons.search_rounded, color: isEnabled ? AppConstants.primaryGreen : Colors.grey),
              suffixIcon: state.isSearchingVillages
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : (_searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel_rounded),
                          color: AppConstants.textSecondary,
                          onPressed: () {
                            _searchController.clear();
                            context.read<AdministrativeLocationBloc>().add(const VillageSearchQueryChanged(''));
                          },
                        )
                      : null),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // Selected village tag details
        if (state.selectedVillage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppConstants.primaryGreen.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppConstants.primaryGreen.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: AppConstants.primaryGreen, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isHindi
                        ? 'चयनित गाँव: ${state.selectedVillage!.nameHi ?? state.selectedVillage!.nameEn} (LGD: ${state.selectedVillage!.code})'
                        : 'Selected: ${state.selectedVillage!.nameEn} (LGD: ${state.selectedVillage!.code})',
                    style: TextStyle(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],

        // Search results expandable box
        if (isEnabled && state.villages.isNotEmpty && state.selectedVillage == null) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              color: AppConstants.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5DCD0), width: 0.5),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: state.villages.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final item = state.villages[index];
                return ListTile(
                  title: Text(
                    isHindi ? (item.nameHi ?? item.nameEn) : item.nameEn,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('LGD Code: ${item.code}', style: const TextStyle(fontSize: 11)),
                  onTap: () {
                    context.read<AdministrativeLocationBloc>().add(VillageSelected(item));
                    setState(() {
                      _searchController.text = isHindi ? (item.nameHi ?? item.nameEn) : item.nameEn;
                    });
                  },
                );
              },
            ),
          ),
        ],

        // Empty state when typing but no villages match
        if (isEnabled &&
            state.villages.isEmpty &&
            !state.isSearchingVillages &&
            _searchController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5DCD0), width: 0.5),
            ),
            child: Center(
              child: Text(
                isHindi ? 'कोई गाँव नहीं मिला' : 'No villages found matching search',
                style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
              ),
            ),
          )
        ],
      ],
    );
  }
}
