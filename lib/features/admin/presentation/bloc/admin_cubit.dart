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
      if (villages.isEmpty) {
        // Prefill default villages for mock database
        villages = const [
          AdminVillageEntity(
            id: 'v_gopalpura',
            nameEnglish: 'Gopalpura',
            nameHindi: 'गोपालपुरा',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302015',
            isActive: true,
          ),
          AdminVillageEntity(
            id: 'v_sodala',
            nameEnglish: 'Sodala',
            nameHindi: 'सोडाला',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302019',
            isActive: true,
          ),
          AdminVillageEntity(
            id: 'v_vaishali',
            nameEnglish: 'Vaishali Nagar',
            nameHindi: 'वैशाली नगर',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302021',
            isActive: true,
          ),
          AdminVillageEntity(
            id: 'v_mansarovar',
            nameEnglish: 'Mansarovar',
            nameHindi: 'मानसरोवर',
            district: 'Jaipur',
            state: 'Rajasthan',
            pincode: '302020',
            isActive: false, // Disabled by default to demo disable status
          ),
        ];
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
