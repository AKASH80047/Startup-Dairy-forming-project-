import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/fodder_item_entity.dart';
import '../../domain/repositories/fodder_repository.dart';
import '../models/fodder_item_model.dart';

class FodderRepositoryImpl implements FodderRepository {
  final SharedPreferences sharedPreferences;
  static const String _keyFodderListings = 'fodder_listingsingsings';

  FodderRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<FodderItemEntity>> getFodderItems({
    String? category,
    String? search,
    String? state,
    String? district,
    String? village,
    double? maxPrice,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    final cachedStr = sharedPreferences.getString(_keyFodderListings);
    List<FodderItemModel> items = [];

    if (cachedStr != null) {
      final List<dynamic> decoded = jsonDecode(cachedStr) as List<dynamic>;
      items = decoded
          .map((item) => FodderItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Initialize pre-populated realistic listings
      items = _getPrepopulatedListings();
      await _saveToCache(items);
    }

    // Apply filters
    return items.where((item) {
      if (category != null && category.isNotEmpty) {
        if (item.categoryEn.toLowerCase() != category.toLowerCase() &&
            item.categoryHi != category) {
          return false;
        }
      }
      if (search != null && search.isNotEmpty) {
        final q = search.toLowerCase();
        if (!item.titleEn.toLowerCase().contains(q) &&
            !item.titleHi.contains(q) &&
            !item.categoryEn.toLowerCase().contains(q) &&
            !item.categoryHi.contains(q)) {
          return false;
        }
      }
      if (state != null && state.isNotEmpty && item.state.toLowerCase() != state.toLowerCase()) {
        return false;
      }
      if (district != null && district.isNotEmpty && item.district.toLowerCase() != district.toLowerCase()) {
        return false;
      }
      if (village != null && village.isNotEmpty && item.village.toLowerCase() != village.toLowerCase()) {
        return false;
      }
      if (maxPrice != null && item.price > maxPrice) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<void> uploadFodderItem(FodderItemEntity item) async {
    final cachedStr = sharedPreferences.getString(_keyFodderListings);
    List<FodderItemModel> list = [];

    if (cachedStr != null) {
      final List<dynamic> decoded = jsonDecode(cachedStr) as List<dynamic>;
      list = decoded
          .map((i) => FodderItemModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } else {
      list = _getPrepopulatedListings();
    }

    final model = FodderItemModel.fromEntity(item);
    list.insert(0, model);

    await _saveToCache(list);
  }

  Future<void> _saveToCache(List<FodderItemModel> list) async {
    final encoded = list.map((item) => item.toJson()).toList();
    await sharedPreferences.setString(_keyFodderListings, jsonEncode(encoded));
  }

  List<FodderItemModel> _getPrepopulatedListings() {
    return [
      FodderItemModel(
        id: 'fodder_1',
        titleEn: 'Fresh Wheat Straw (Bhusa)',
        titleHi: 'ताजा गेहूं का भूसा',
        categoryEn: 'Bhusa',
        categoryHi: 'भूसा',
        imageUrl: 'assets/images/cat_fodder.jpg',
        price: 850.0,
        unitEn: 'Quintal',
        unitHi: 'क्विंटल',
        quantity: 50.0,
        sellerName: 'Ramprasad Choudhary',
        sellerPhone: '9414012345',
        village: 'Gopalpura',
        district: 'Jaipur',
        state: 'Rajasthan',
        deliveryAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FodderItemModel(
        id: 'fodder_2',
        titleEn: 'Green Napier Grass',
        titleHi: 'हरी नेपियर घास',
        categoryEn: 'Napier',
        categoryHi: 'नेपियर',
        imageUrl: 'assets/images/cat_fodder.jpg',
        price: 350.0,
        unitEn: 'Quintal',
        unitHi: 'क्विंटल',
        quantity: 120.0,
        sellerName: 'Sohan Singh Mandawa',
        sellerPhone: '9928012345',
        village: 'Kanakpura',
        district: 'Jaipur',
        state: 'Rajasthan',
        deliveryAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FodderItemModel(
        id: 'fodder_3',
        titleEn: 'Premium Maize Silage (Green Farm)',
        titleHi: 'प्रीमियम मक्का साइलेज',
        categoryEn: 'Silage',
        categoryHi: 'साइलेज',
        imageUrl: 'assets/images/cat_fodder.jpg',
        price: 450.0,
        unitEn: 'Quintal',
        unitHi: 'क्विंटल',
        quantity: 300.0,
        sellerName: 'Pandey Dairy Farms',
        sellerPhone: '9918926054',
        village: 'Gopalpura',
        district: 'Jaipur',
        state: 'Rajasthan',
        deliveryAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      FodderItemModel(
        id: 'fodder_4',
        titleEn: 'Dry Grass Bundles',
        titleHi: 'सूखी घास के बंडल',
        categoryEn: 'Dry Grass',
        categoryHi: 'सूखी घास',
        imageUrl: 'assets/images/cat_fodder.jpg',
        price: 15.0,
        unitEn: 'Bundle',
        unitHi: 'बंडल',
        quantity: 1500.0,
        sellerName: 'Devendra Pandey',
        sellerPhone: '9887012345',
        village: 'Phulera',
        district: 'Jaipur',
        state: 'Rajasthan',
        deliveryAvailable: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
