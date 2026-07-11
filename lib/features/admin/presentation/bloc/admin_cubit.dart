import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/admin_village_entity.dart';
import '../../domain/entities/daily_milk_customer_entity.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final StorageService _storageService;

  AdminCubit(this._storageService) : super(AdminInitial()) {
    loadAdminData();
  }

  /// Loads villages and daily subscribers from cache. Prefills villages if empty.
  void loadAdminData() {
    emit(AdminLoading());
    try {
      List<AdminVillageEntity> villages = _storageService.getVillages();
      
      // Check if we need to prefill the new Siddharthnagar cities
      final hasSiddharthnagar = villages.any((v) => v.district.toLowerCase() == 'siddharthnagar');
      if (!hasSiddharthnagar) {
        final List<AdminVillageEntity> defaultVillages = [
          const AdminVillageEntity(
            id: 'v_gopalpura',
            nameEnglish: 'Gopalpura',
            nameHindi: 'गोपालपुरा',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302015',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sodala',
            nameEnglish: 'Sodala',
            nameHindi: 'सोडाला',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302019',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_vaishali',
            nameEnglish: 'Vaishali Nagar',
            nameHindi: 'वैशाली नगर',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302021',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_mansarovar',
            nameEnglish: 'Mansarovar',
            nameHindi: 'मानसरोवर',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302020',
            isActive: false,
          ),
          // Siddharthnagar, UP Cities
          const AdminVillageEntity(
            id: 'v_sn_naugarh',
            nameEnglish: 'Naugarh',
            nameHindi: 'नौगढ़',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272207',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_bansi',
            nameEnglish: 'Bansi',
            nameHindi: 'बांसी',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272153',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_tetri',
            nameEnglish: 'Tetri Bazar',
            nameHindi: 'तेतरी बाज़ार',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272207',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_shohratgarh',
            nameEnglish: 'Shohratgarh',
            nameHindi: 'शोहरतगढ़',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272205',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_uska',
            nameEnglish: 'Uska Bazar',
            nameHindi: 'उसका बाज़ार',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272206',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_itwa',
            nameEnglish: 'Itwa',
            nameHindi: 'इटवा',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272192',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_domariaganj',
            nameEnglish: 'Domariaganj',
            nameHindi: 'डुमरियागंज',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272189',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_barhni',
            nameEnglish: 'Barhni',
            nameHindi: 'बढ़नी',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272201',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_birdpur',
            nameEnglish: 'Birdpur',
            nameHindi: 'बर्डपुर',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272202',
            isActive: true,
          ),
          const AdminVillageEntity(
            id: 'v_sn_khesraha',
            nameEnglish: 'Khesraha',
            nameHindi: 'खेसरहा',
            district: 'Siddharthnagar',
            state: 'Uttar Pradesh',
            pincode: '272152',
            isActive: true,
          ),
        ];

        final Map<String, AdminVillageEntity> uniqueVillages = {};
        for (var v in defaultVillages) {
          uniqueVillages[v.id] = v;
        }
        for (var v in villages) {
          uniqueVillages[v.id] = v;
        }
        villages = uniqueVillages.values.toList();
        _storageService.saveVillages(villages);
      }

      final List<DailyMilkCustomerEntity> customers = _storageService.getDailyCustomers();

      emit(AdminLoaded(
        villages: villages,
        dailyCustomers: customers,
      ));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  /// Adds a new village to the configuration database.
  Future<void> addVillage(AdminVillageEntity village) async {
    final state = this.state;
    if (state is AdminLoaded) {
      final List<AdminVillageEntity> updated = List.from(state.villages)..add(village);
      await _storageService.saveVillages(updated);
      emit(AdminSuccess('Village "${village.nameEnglish}" added successfully!'));
      loadAdminData();
    }
  }

  /// Toggles the active status of a village.
  Future<void> toggleVillageStatus(String id) async {
    final state = this.state;
    if (state is AdminLoaded) {
      final List<AdminVillageEntity> updated = state.villages.map((v) {
        if (v.id == id) {
          return v.copyWith(isActive: !v.isActive);
        }
        return v;
      }).toList();
      await _storageService.saveVillages(updated);
      emit(const AdminSuccess('Village status updated!'));
      loadAdminData();
    }
  }

  /// Registers a new daily milk delivery customer manually.
  Future<void> registerDailyCustomer(DailyMilkCustomerEntity customer) async {
    final state = this.state;
    if (state is AdminLoaded) {
      final List<DailyMilkCustomerEntity> updated = List.from(state.dailyCustomers)..add(customer);
      await _storageService.saveDailyCustomers(updated);
      emit(AdminSuccess('Customer "${customer.name}" registered successfully!'));
      loadAdminData();
    }
  }

  /// Toggles customer's subscription between Active and Paused.
  Future<void> toggleCustomerStatus(String id) async {
    final state = this.state;
    if (state is AdminLoaded) {
      final List<DailyMilkCustomerEntity> updated = state.dailyCustomers.map((c) {
        if (c.id == id) {
          final newStatus = c.status == 'Active' ? 'Paused' : 'Active';
          return c.copyWith(status: newStatus);
        }
        return c;
      }).toList();
      await _storageService.saveDailyCustomers(updated);
      emit(const AdminSuccess('Subscription status updated!'));
      loadAdminData();
    }
  }

  /// Admin operation to update user order status (syncs with user dashboard).
  Future<void> changeOrderStatus(String orderId, String newStatus) async {
    final bool success = await _storageService.updateOrderStatus(orderId, newStatus);
    if (success) {
      emit(AdminSuccess('Order #$orderId marked as $newStatus'));
      loadAdminData();
    }
  }

  /// Admin operation to update bulk order status.
  Future<void> changeBulkOrderStatus(String orderId, String newStatus) async {
    final bool success = await _storageService.updateBulkOrderStatus(orderId, newStatus);
    if (success) {
      emit(AdminSuccess('Bulk Order #$orderId status updated to $newStatus'));
      loadAdminData();
    }
  }
}
