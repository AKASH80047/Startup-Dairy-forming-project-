import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../features/location/domain/entities/user_address.dart';
import '../../features/location/data/models/user_address_model.dart';
import '../../features/checkout/domain/entities/order_entity.dart';
import '../../features/bulk_order/domain/entities/bulk_order_entity.dart';
import '../../features/admin/domain/entities/admin_village_entity.dart';
import '../../features/admin/domain/entities/daily_milk_customer_entity.dart';

class StorageService {
  final SharedPreferences _prefs;

  static const String _keyCachedAddress = 'cached_address';
  static const String _keyOrderHistory = 'order_history';
  static const String _keyBulkOrderHistory = 'bulk_order_history';
  static const String _keyAdminVillages = 'admin_villages';
  static const String _keyAdminDailyCustomers = 'admin_daily_customers';

  StorageService(this._prefs);

  SharedPreferences get prefs => _prefs;

  static const String _keyThemeType = 'selected_theme_type';

  /// Saves the selected language code ('en' or 'hi') to local storage.
  Future<bool> saveLanguageCode(String languageCode) async {
    return await _prefs.setString(AppConstants.keyLanguageCode, languageCode);
  }

  /// Retrieves the selected language code from local storage. Returns null if not set.
  String? getLanguageCode() {
    return _prefs.getString(AppConstants.keyLanguageCode);
  }

  /// Saves the selected theme type to local storage.
  Future<bool> saveThemeType(String themeType) async {
    return await _prefs.setString(_keyThemeType, themeType);
  }

  /// Retrieves the selected theme type from local storage.
  String? getThemeType() {
    return _prefs.getString(_keyThemeType);
  }

  /// Caches the delivery address to restore on next startup.
  Future<bool> cacheAddress(UserAddress address) async {
    final String jsonString = jsonEncode(UserAddressModel.fromEntity(address).toJson());
    return await _prefs.setString(_keyCachedAddress, jsonString);
  }

  /// Retrieves the cached delivery address.
  UserAddress? getCachedAddress() {
    final String? jsonString = _prefs.getString(_keyCachedAddress);
    if (jsonString == null) return null;
    try {
      return UserAddressModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Removes the cached address from local storage.
  Future<bool> clearAddressCache() async {
    return await _prefs.remove(_keyCachedAddress);
  }

  /// Adds a new order to the offline history logs.
  Future<bool> saveOrderToHistory(OrderEntity order) async {
    final List<OrderEntity> history = getOrderHistory();
    history.insert(0, order); // Prepend so newest is at the top
    final List<String> listJson = history.map((o) => jsonEncode(o.toJson())).toList();
    return await _prefs.setStringList(_keyOrderHistory, listJson);
  }

  /// Retrieves all offline orders history logs.
  List<OrderEntity> getOrderHistory() {
    final List<String>? listJson = _prefs.getStringList(_keyOrderHistory);
    if (listJson == null) return [];
    return listJson.map((str) {
      try {
        return OrderEntity.fromJson(jsonDecode(str) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<OrderEntity>().toList();
  }

  /// Updates status of a normal order in cache.
  Future<bool> updateOrderStatus(String id, String newStatus) async {
    final List<OrderEntity> history = getOrderHistory();
    final int index = history.indexWhere((o) => o.id == id);
    if (index != -1) {
      history[index] = history[index].copyWith(status: newStatus);
      final List<String> listJson = history.map((o) => jsonEncode(o.toJson())).toList();
      return await _prefs.setStringList(_keyOrderHistory, listJson);
    }
    return false;
  }

  /// Clears the past orders cache.
  Future<bool> clearOrderHistory() async {
    return await _prefs.remove(_keyOrderHistory);
  }

  /// Adds a new bulk order to the offline history logs.
  Future<bool> saveBulkOrderToHistory(BulkOrderEntity order) async {
    final List<BulkOrderEntity> history = getBulkOrderHistory();
    history.insert(0, order); // Prepend so newest is at the top
    final List<String> listJson = history.map((o) => jsonEncode(o.toJson())).toList();
    return await _prefs.setStringList(_keyBulkOrderHistory, listJson);
  }

  /// Retrieves all offline bulk orders history logs.
  List<BulkOrderEntity> getBulkOrderHistory() {
    final List<String>? listJson = _prefs.getStringList(_keyBulkOrderHistory);
    if (listJson == null) return [];
    return listJson.map((str) {
      try {
        return BulkOrderEntity.fromJson(jsonDecode(str) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<BulkOrderEntity>().toList();
  }

  /// Updates status of a bulk order in cache.
  Future<bool> updateBulkOrderStatus(String id, String newStatus) async {
    final List<BulkOrderEntity> history = getBulkOrderHistory();
    final int index = history.indexWhere((o) => o.id == id);
    if (index != -1) {
      final old = history[index];
      history[index] = BulkOrderEntity(
        id: old.id,
        customerName: old.customerName,
        customerPhone: old.customerPhone,
        eventType: old.eventType,
        eventDate: old.eventDate,
        expectedGuests: old.expectedGuests,
        address: old.address,
        items: old.items,
        subtotal: old.subtotal,
        discountAmount: old.discountAmount,
        deliveryCharge: old.deliveryCharge,
        advancePaid: old.advancePaid,
        pendingBalance: old.pendingBalance,
        grandTotal: old.grandTotal,
        notes: old.notes,
        paymentMethod: old.paymentMethod,
        status: newStatus,
        createdAt: old.createdAt,
      );
      final List<String> listJson = history.map((o) => jsonEncode(o.toJson())).toList();
      return await _prefs.setStringList(_keyBulkOrderHistory, listJson);
    }
    return false;
  }

  /// Clears the past bulk orders cache.
  Future<bool> clearBulkOrderHistory() async {
    return await _prefs.remove(_keyBulkOrderHistory);
  }

  /// Saves the list of admin villages.
  Future<bool> saveVillages(List<AdminVillageEntity> villages) async {
    final List<String> listJson = villages.map((v) => jsonEncode(v.toJson())).toList();
    return await _prefs.setStringList(_keyAdminVillages, listJson);
  }

  /// Retrieves the list of admin villages.
  List<AdminVillageEntity> getVillages() {
    final List<String>? listJson = _prefs.getStringList(_keyAdminVillages);
    if (listJson == null) return [];
    return listJson.map((str) {
      try {
        return AdminVillageEntity.fromJson(jsonDecode(str) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<AdminVillageEntity>().toList();
  }

  /// Saves the list of daily milk customers.
  Future<bool> saveDailyCustomers(List<DailyMilkCustomerEntity> customers) async {
    final List<String> listJson = customers.map((c) => jsonEncode(c.toJson())).toList();
    return await _prefs.setStringList(_keyAdminDailyCustomers, listJson);
  }

  /// Retrieves the list of daily milk customers.
  List<DailyMilkCustomerEntity> getDailyCustomers() {
    final List<String>? listJson = _prefs.getStringList(_keyAdminDailyCustomers);
    if (listJson == null) return [];
    return listJson.map((str) {
      try {
        return DailyMilkCustomerEntity.fromJson(jsonDecode(str) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<DailyMilkCustomerEntity>().toList();
  }

  /// Clears all stored data (useful for testing or profile reset).
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
