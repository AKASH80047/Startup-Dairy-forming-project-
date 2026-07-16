import '../../../../core/enum/animal_type.dart';
import '../../../../core/enum/a2_status.dart';
import '../../domain/entities/breed_entity.dart';
import '../../domain/repositories/breed_repository.dart';
import '../models/breed_model.dart';

class MockBreedRepository implements BreedRepository {
  // Static dataset containing premium real-world descriptions and details of breeds.
  static const List<BreedModel> _mockBreeds = [
    // === COW BREEDS ===
    BreedModel(
      id: 'cow_sahiwal',
      nameEnglish: 'Sahiwal',
      nameHindi: 'साहीवाल',
      animalType: AnimalType.cow,
      originEnglish: 'Montgomery, Punjab',
      originHindi: 'मोंटगोमरी, पंजाब',
      descriptionEnglish:
          'Known for high heat tolerance, tick resistance, and yieldi ng rich milk with dense fat content.',
      descriptionHindi:
          'गर्मी सहन करने की उच्च क्षमता, किलनी (टिक) प्रतिरोधक और गाढ़े वसा वाले पौष्टिक दूध के लिए प्रसिद्ध।',
      imageUrl: 'assets/images/cow_sahiwal.jpg',
      a2Status: A2Status.verified,
      averageFatMin: 4.5,
      averageFatMax: 5.2,
      averageYieldMin: 12.0,
      averageYieldMax: 18.0,
      pricePerLitre: 85.0,
      isAvailable: true,
      sourceVillageEnglish: 'Bhakra, Rajasthan',
      sourceVillageHindi: 'भाखड़ा, राजस्थान',
      availableQuantityLitre: 120.0,
    ),
    BreedModel(
      id: 'cow_gir',
      nameEnglish: 'Gir',
      nameHindi: 'गीर',
      animalType: AnimalType.cow,
      originEnglish: 'Gir Hills, Gujarat',
      originHindi: 'गीर पहाड़ियां, गुजरात',
      descriptionEnglish:
          'Highly sought-after breed known for its distinctive curved horns and dome forehead. Producer of high quality nutritious milk.',
      descriptionHindi:
          'अपनी घुमावदार सींगों और उभरे हुए माथे के लिए प्रसिद्ध। उच्च गुणवत्ता और पोषक तत्वों से भरपूर दूध का स्रोत।',
      imageUrl: 'assets/images/cow_gir.jpg',
      a2Status: A2Status.verified,
      averageFatMin: 4.4,
      averageFatMax: 4.9,
      averageYieldMin: 10.0,
      averageYieldMax: 16.0,
      pricePerLitre: 95.0,
      isAvailable: true,
      sourceVillageEnglish: 'Suratgarh, Rajasthan',
      sourceVillageHindi: 'सूरतगढ़, राजस्थान',
      availableQuantityLitre: 90.0,
    ),
    BreedModel(
      id: 'cow_red_sindhi',
      nameEnglish: 'Red Sindhi',
      nameHindi: 'लाल सिंधी',
      animalType: AnimalType.cow,
      originEnglish: 'Sindh region',
      originHindi: 'सिंध क्षेत्र',
      descriptionEnglish:
          'Distinguished deep reddish-brown cow with high capability of resisting diseases and hot climate.',
      descriptionHindi:
          'गहरे लाल-भूरे रंग की यह गाय रोगों से लड़ने और गर्म जलवायु में रहने की अद्भुत क्षमता रखती है।',
      imageUrl: 'assets/images/cow_red_sindhi.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 4.3,
      averageFatMax: 5.0,
      averageYieldMin: 11.0,
      averageYieldMax: 15.0,
      pricePerLitre: 80.0,
      isAvailable: true,
      sourceVillageEnglish: 'Kanpura, Jaipur',
      sourceVillageHindi: 'कानपुरा, जयपुर',
      availableQuantityLitre: 80.0,
    ),
    BreedModel(
      id: 'cow_tharparkar',
      nameEnglish: 'Tharparkar',
      nameHindi: 'थारपारकर',
      animalType: AnimalType.cow,
      originEnglish: 'Thar Desert, Rajasthan',
      originHindi: 'थार मरुस्थल, राजस्थान',
      descriptionEnglish:
          'Majestic white dual-purpose breed, extremely resilient to extreme desert environments.',
      descriptionHindi:
          'सफेद रंग की शानदार दोहरे उद्देश्य वाली नस्ल, जो रेगिस्तान के अत्यंत कठिन वातावरण में भी सहज रहती है।',
      imageUrl: 'assets/images/cow_tharparkar.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 4.2,
      averageFatMax: 4.8,
      averageYieldMin: 9.0,
      averageYieldMax: 14.0,
      pricePerLitre: 75.0,
      isAvailable: true,
      sourceVillageEnglish: 'Lunkaransar, Bikaner',
      sourceVillageHindi: 'लूणकरणसर, बीकानेर',
      availableQuantityLitre: 110.0,
    ),
    BreedModel(
      id: 'cow_rathi',
      nameEnglish: 'Rathi',
      nameHindi: 'राठी',
      animalType: AnimalType.cow,
      originEnglish: 'Bikaner, Rajasthan',
      originHindi: 'बीकानेर, राजस्थान',
      descriptionEnglish:
          'Docile, efficient milk producer requiring less feed maintenance, ideal for local village farms.',
      descriptionHindi:
          'शांत स्वभाव और कम चारे के रख-रखाव में भी अच्छा दूध देने वाली स्थानीय डेयरी किसानों के लिए आदर्श गाय।',
      imageUrl: 'assets/images/cow_rathi.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 4.0,
      averageFatMax: 4.7,
      averageYieldMin: 8.5,
      averageYieldMax: 13.0,
      pricePerLitre: 70.0,
      isAvailable: true,
      sourceVillageEnglish: 'Khara, Rajasthan',
      sourceVillageHindi: 'खारा, राजस्थान',
      availableQuantityLitre: 140.0,
    ),
    BreedModel(
      id: 'cow_kankrej',
      nameEnglish: 'Kankrej',
      nameHindi: 'कांकरेज',
      animalType: AnimalType.cow,
      originEnglish: 'Rann of Kutch, Gujarat',
      originHindi: 'कच्छ का रण, गुजरात',
      descriptionEnglish:
          'Known for its giant horns and unique heavy walk. Milk is rich in essential nutrients.',
      descriptionHindi:
          'विशाल सींगों और अपनी विशेष "सवाई चाल" के लिए प्रसिद्ध। इसका दूध आवश्यक पोषक तत्वों से भरपूर होता है।',
      imageUrl: 'assets/images/cow_kankrej.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 4.1,
      averageFatMax: 4.8,
      averageYieldMin: 8.0,
      averageYieldMax: 12.0,
      pricePerLitre: 75.0,
      isAvailable: false,
      sourceVillageEnglish: 'Jalore, Rajasthan',
      sourceVillageHindi: 'जालौर, राजस्थान',
      availableQuantityLitre: 0.0,
    ),
    BreedModel(
      id: 'cow_jersey',
      nameEnglish: 'Jersey',
      nameHindi: 'जर्सी',
      animalType: AnimalType.cow,
      originEnglish: 'Island of Jersey, UK',
      originHindi: 'जर्सी द्वीप, यूके',
      descriptionEnglish:
          'Exotic breed producing high-butterfat milk. Highly responsive to customized farm feeds.',
      descriptionHindi:
          'मक्खन वसा की उच्च मात्रा वाले दूध का उत्पादन करने वाली विदेशी नस्ल। संतुलित आहार से दूध उत्पादन बेहतर होता है।',
      imageUrl: 'assets/images/cow_jersey.jpg',
      a2Status: A2Status.notVerified,
      averageFatMin: 4.8,
      averageFatMax: 5.5,
      averageYieldMin: 14.0,
      averageYieldMax: 22.0,
      pricePerLitre: 65.0,
      isAvailable: true,
      sourceVillageEnglish: 'Bilwa, Rajasthan',
      sourceVillageHindi: 'बिल्वा, राजस्थान',
      availableQuantityLitre: 150.0,
    ),
    BreedModel(
      id: 'cow_hf',
      nameEnglish: 'Holstein Friesian (HF)',
      nameHindi: 'होल्स्टीन फ्रिसियन',
      animalType: AnimalType.cow,
      originEnglish: 'Netherlands',
      originHindi: 'नीदरलैंड',
      descriptionEnglish:
          'Highest milk yield volume producer globally. Striking black and white patched coat.',
      descriptionHindi:
          'दुनिया में सबसे अधिक मात्रा में दूध देने वाली नस्ल। काले और सफेद धब्बों वाला आकर्षक शरीर।',
      imageUrl: 'assets/images/cow_hf.jpg',
      a2Status: A2Status.notVerified,
      averageFatMin: 3.5,
      averageFatMax: 4.0,
      averageYieldMin: 20.0,
      averageYieldMax: 30.0,
      pricePerLitre: 60.0,
      isAvailable: true,
      sourceVillageEnglish: 'Watika, Rajasthan',
      sourceVillageHindi: 'वाटिका, राजस्थान',
      availableQuantityLitre: 250.0,
    ),

    // === BUFFALO BREEDS ===
    BreedModel(
      id: 'buffalo_murrah',
      nameEnglish: 'Murrah',
      nameHindi: 'मुर्रा',
      animalType: AnimalType.buffalo,
      originEnglish: 'Haryana / Punjab',
      originHindi: 'हरियाणा / पंजाब',
      descriptionEnglish:
          'Known as the "Black Gold" of dairy farming. Famous for curly horns and rich fat yields.',
      descriptionHindi:
          'डेयरी फार्मिंग का "काला सोना"। घुमावदार सींगों और मलाईदार उच्च वसा वाले दूध के लिए विश्व प्रसिद्ध।',
      imageUrl: 'assets/images/buffalo_murrah.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 6.8,
      averageFatMax: 7.8,
      averageYieldMin: 14.0,
      averageYieldMax: 20.0,
      pricePerLitre: 90.0,
      isAvailable: true,
      sourceVillageEnglish: 'Rohtak, Haryana',
      sourceVillageHindi: 'रोहतक, हरियाणा',
      availableQuantityLitre: 180.0,
    ),
    BreedModel(
      id: 'buffalo_bhadawari',
      nameEnglish: 'Bhadawari',
      nameHindi: 'भदावरी',
      animalType: AnimalType.buffalo,
      originEnglish: 'Yamuna Valley, UP',
      originHindi: 'यमुना घाटी, उत्तर प्रदेश',
      descriptionEnglish:
          'Famous copper-coloured body. Produces milk with exceptional fat percentage, frequently over 8%.',
      descriptionHindi:
          'प्रसिद्ध तांबे जैसी काया। दूध में अत्यधिक वसा प्रतिशत (अक्सर 8% से अधिक) के लिए प्रसिद्ध।',
      imageUrl: 'assets/images/buffalo_bhadawari.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 7.5,
      averageFatMax: 8.5,
      averageYieldMin: 8.0,
      averageYieldMax: 12.0,
      pricePerLitre: 95.0,
      isAvailable: true,
      sourceVillageEnglish: 'Etawah, UP',
      sourceVillageHindi: 'इटावा, उत्तर प्रदेश',
      availableQuantityLitre: 60.0,
    ),
    BreedModel(
      id: 'buffalo_jaffarabadi',
      nameEnglish: 'Jaffarabadi',
      nameHindi: 'जाफराबादी',
      animalType: AnimalType.buffalo,
      originEnglish: 'Saurashtra, Gujarat',
      originHindi: 'सौराष्ट्र, गुजरात',
      descriptionEnglish:
          'Giant heavy buffalo breed yielding thick milk with high butterfat content.',
      descriptionHindi:
          'भारी शरीर वाली विशाल नस्ल, जो मक्खन वसा की प्रचुरता वाला गाढ़ा दूध देती है।',
      imageUrl: 'assets/images/buffalo_jaffarabadi.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 7.0,
      averageFatMax: 8.2,
      averageYieldMin: 12.0,
      averageYieldMax: 17.0,
      pricePerLitre: 85.0,
      isAvailable: true,
      sourceVillageEnglish: 'Gir, Gujarat',
      sourceVillageHindi: 'गीर, गुजरात',
      availableQuantityLitre: 75.0,
    ),
    BreedModel(
      id: 'buffalo_mehsana',
      nameEnglish: 'Mehsana',
      nameHindi: 'मेहसाना',
      animalType: AnimalType.buffalo,
      originEnglish: 'Mehsana, Gujarat',
      originHindi: 'मेहसाना, गुजरात',
      descriptionEnglish:
          'A reliable crossbreed of Murrah and Surti known for extended lactation and gentle temperament.',
      descriptionHindi:
          'मुर्रा और सुरती का विश्वसनीय संकरण, जो लंबे समय तक नियमित दूध देने और शांत स्वभाव के लिए जाना जाता है।',
      imageUrl: 'assets/images/buffalo_mehsana.jpg',
      a2Status: A2Status.unknown,
      averageFatMin: 6.5,
      averageFatMax: 7.5,
      averageYieldMin: 10.0,
      averageYieldMax: 15.0,
      pricePerLitre: 80.0,
      isAvailable: true,
      sourceVillageEnglish: 'Palanpur, Gujarat',
      sourceVillageHindi: 'पालनपुर, गुजरात',
      availableQuantityLitre: 110.0,
    ),
  ];

  @override
  Future<List<BreedEntity>> getBreeds(AnimalType type) async {
    // Mimic API delay
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockBreeds.where((breed) => breed.animalType == type).toList();
  }

  @override
  Future<BreedEntity?> getBreedById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockBreeds.firstWhere((breed) => breed.id == id);
    } catch (_) {
      return null;
    }
  }
}
