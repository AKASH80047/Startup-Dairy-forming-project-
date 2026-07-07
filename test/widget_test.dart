import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pandey/app/app.dart';
import 'package:pandey/core/services/storage_service.dart';
import 'package:pandey/features/breed/data/repositories/mock_breed_repository.dart';
import 'package:pandey/features/product/data/repositories/mock_product_repository.dart';

void main() {
  testWidgets('Splash Screen smoke test', (WidgetTester tester) async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final StorageService storageService = StorageService(prefs);

    // Build the app
    await tester.pumpWidget(PandeyApp(
      storageService: storageService,
      breedRepository: MockBreedRepository(),
      productRepository: MockProductRepository(),
    ));

    // Verify that the splash screen devotional symbol is rendered
    expect(find.text('ॐ'), findsOneWidget);
  });
}
