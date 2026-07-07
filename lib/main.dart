import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'core/services/storage_service.dart';
import 'features/breed/data/repositories/mock_breed_repository.dart';
import 'features/breed/domain/repositories/breed_repository.dart';
import 'features/product/data/repositories/mock_product_repository.dart';
import 'features/product/domain/repositories/product_repository.dart';

void main() async {
  // Ensure that widget binding is initialized before SharedPreferences starts
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences instances for the local storage service
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final StorageService storageService = StorageService(prefs);

  // Initialize repositories
  final BreedRepository breedRepository = MockBreedRepository();
  final ProductRepository productRepository = MockProductRepository();

  runApp(
    PandeyApp(
      storageService: storageService,
      breedRepository: breedRepository,
      productRepository: productRepository,
    ),
  );
}
