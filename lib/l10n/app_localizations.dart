import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Pandey Dairy Farming'**
  String get appName;

  /// The brand tagline
  ///
  /// In en, this message translates to:
  /// **'Pure • Fresh • From Our Roots'**
  String get tagline;

  /// The brand devotional line
  ///
  /// In en, this message translates to:
  /// **'Om Namah Shivaya'**
  String get omNamahShivaya;

  /// Title of the language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// Description of the language selection screen
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred language to continue.'**
  String get selectLanguageDesc;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Hindi language name
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// Cow category title
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get cow;

  /// Buffalo category title
  ///
  /// In en, this message translates to:
  /// **'Buffalo'**
  String get buffalo;

  /// Other dairy products category title
  ///
  /// In en, this message translates to:
  /// **'Other Products'**
  String get otherProducts;

  /// Bulk and event orders category title
  ///
  /// In en, this message translates to:
  /// **'Bulk & Event Orders'**
  String get bulkOrders;

  /// Free delivery details badge message
  ///
  /// In en, this message translates to:
  /// **'Free delivery within 2 km'**
  String get freeDeliveryMsg;

  /// Label for the current delivery location
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get deliveryLocation;

  /// Default placeholder text for delivery location
  ///
  /// In en, this message translates to:
  /// **'Select Location...'**
  String get defaultLocation;

  /// Label for standard continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for changing language option
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @originLabel.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get originLabel;

  /// No description provided for @sourceVillageLabel.
  ///
  /// In en, this message translates to:
  /// **'Source Village'**
  String get sourceVillageLabel;

  /// No description provided for @fatPercentageLabel.
  ///
  /// In en, this message translates to:
  /// **'Average Fat Content'**
  String get fatPercentageLabel;

  /// No description provided for @yieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg Yield per Day'**
  String get yieldLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @availableQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Quantity'**
  String get availableQtyLabel;

  /// No description provided for @a2StatusLabel.
  ///
  /// In en, this message translates to:
  /// **'A2 Milk Certification'**
  String get a2StatusLabel;

  /// No description provided for @verifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified A2'**
  String get verifiedLabel;

  /// No description provided for @notVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Not A2 Certified'**
  String get notVerifiedLabel;

  /// No description provided for @unknownLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLabel;

  /// No description provided for @addToCartLabel.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCartLabel;

  /// No description provided for @buyNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNowLabel;

  /// No description provided for @subscribeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Subscription'**
  String get subscribeLabel;

  /// No description provided for @selectQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Quantity'**
  String get selectQuantityLabel;

  /// No description provided for @availableLabel.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableLabel;

  /// No description provided for @outOfStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStockLabel;

  /// No description provided for @cowBreedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cow Breeds'**
  String get cowBreedsTitle;

  /// No description provided for @buffaloBreedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Buffalo Breeds'**
  String get buffaloBreedsTitle;

  /// No description provided for @otherProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Other Products'**
  String get otherProductsTitle;

  /// No description provided for @litresLabel.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get litresLabel;

  /// No description provided for @customQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter custom qty (ml)'**
  String get customQuantityHint;

  /// No description provided for @noBreedsMessage.
  ///
  /// In en, this message translates to:
  /// **'No breeds found.'**
  String get noBreedsMessage;

  /// No description provided for @noProductsMessage.
  ///
  /// In en, this message translates to:
  /// **'No dairy products catalog available.'**
  String get noProductsMessage;

  /// No description provided for @productAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart!'**
  String get productAdded;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout Details'**
  String get checkoutTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get nameEmptyError;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get phoneInvalidError;

  /// No description provided for @deliverySlotLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Slot'**
  String get deliverySlotLabel;

  /// No description provided for @morningSlotLabel.
  ///
  /// In en, this message translates to:
  /// **'Morning (6:00 AM - 9:00 AM)'**
  String get morningSlotLabel;

  /// No description provided for @eveningSlotLabel.
  ///
  /// In en, this message translates to:
  /// **'Evening (5:00 PM - 8:00 PM)'**
  String get eveningSlotLabel;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @codLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery (COD)'**
  String get codLabel;

  /// No description provided for @creditLabel.
  ///
  /// In en, this message translates to:
  /// **'Village Credit (खाता)'**
  String get creditLabel;

  /// No description provided for @placeOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrderLabel;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully!'**
  String get orderSuccessTitle;

  /// No description provided for @orderNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumberLabel;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for choosing Pandey Dairy Farming. Your fresh dairy delivery is scheduled.'**
  String get thankYouMessage;

  /// No description provided for @estimatedDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDeliveryLabel;

  /// No description provided for @backToHomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHomeLabel;

  /// No description provided for @itemsOrderedLabel.
  ///
  /// In en, this message translates to:
  /// **'Items Ordered'**
  String get itemsOrderedLabel;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmountLabel;

  /// No description provided for @orderHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistoryTitle;

  /// No description provided for @noOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'No past orders logged.'**
  String get noOrdersMessage;

  /// No description provided for @clearHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistoryLabel;

  /// No description provided for @clearHistorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Order history cleared successfully!'**
  String get clearHistorySuccess;

  /// No description provided for @placedOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Placed on'**
  String get placedOnLabel;

  /// No description provided for @bulkOrderFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Bulk / Event Order'**
  String get bulkOrderFormTitle;

  /// No description provided for @customerDetailsStep.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get customerDetailsStep;

  /// No description provided for @productsSelectionStep.
  ///
  /// In en, this message translates to:
  /// **'Select Products'**
  String get productsSelectionStep;

  /// No description provided for @deliveryDetailsStep.
  ///
  /// In en, this message translates to:
  /// **'Delivery & Slot'**
  String get deliveryDetailsStep;

  /// No description provided for @paymentConfirmationStep.
  ///
  /// In en, this message translates to:
  /// **'Advance & Confirm'**
  String get paymentConfirmationStep;

  /// No description provided for @eventTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get eventTypeLabel;

  /// No description provided for @eventDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDateLabel;

  /// No description provided for @expectedGuestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Guests'**
  String get expectedGuestsLabel;

  /// No description provided for @minimumAdvanceWarning.
  ///
  /// In en, this message translates to:
  /// **'Minimum 20% advance required'**
  String get minimumAdvanceWarning;

  /// No description provided for @advancePaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Advance Payment (₹)'**
  String get advancePaymentLabel;

  /// No description provided for @pendingBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending Balance (₹)'**
  String get pendingBalanceLabel;

  /// No description provided for @bulkDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Bulk Discount'**
  String get bulkDiscountLabel;

  /// No description provided for @minAdvanceRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Advance must be at least 20% of grand total'**
  String get minAdvanceRequiredError;

  /// No description provided for @bulkOrderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Booking Successful!'**
  String get bulkOrderSuccessTitle;

  /// No description provided for @bulkOrderSuccessSub.
  ///
  /// In en, this message translates to:
  /// **'Your bulk event order has been logged and is awaiting dispatch confirmation.'**
  String get bulkOrderSuccessSub;

  /// No description provided for @advancePaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Advance Paid'**
  String get advancePaidLabel;

  /// No description provided for @balanceDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get balanceDueLabel;

  /// No description provided for @adminModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminModeTitle;

  /// No description provided for @adminToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminToggleLabel;

  /// No description provided for @totalCustomersLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Subscribers'**
  String get totalCustomersLabel;

  /// No description provided for @activeSubscribersLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Subscribers'**
  String get activeSubscribersLabel;

  /// No description provided for @dailyMilkQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Milk (L)'**
  String get dailyMilkQtyLabel;

  /// No description provided for @totalRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue (₹)'**
  String get totalRevenueLabel;

  /// No description provided for @villagesTab.
  ///
  /// In en, this message translates to:
  /// **'Villages'**
  String get villagesTab;

  /// No description provided for @dailyCustomersTab.
  ///
  /// In en, this message translates to:
  /// **'Subscribers'**
  String get dailyCustomersTab;

  /// No description provided for @ordersTab.
  ///
  /// In en, this message translates to:
  /// **'User Orders'**
  String get ordersTab;

  /// No description provided for @bulkOrdersTab.
  ///
  /// In en, this message translates to:
  /// **'Bulk Orders'**
  String get bulkOrdersTab;

  /// No description provided for @reportsTab.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get reportsTab;

  /// No description provided for @addVillageLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Village'**
  String get addVillageLabel;

  /// No description provided for @villageNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Village Name'**
  String get villageNameLabel;

  /// No description provided for @registerSubscriberLabel.
  ///
  /// In en, this message translates to:
  /// **'Register Subscriber'**
  String get registerSubscriberLabel;

  /// No description provided for @choosePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get choosePaymentMethod;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashOnDelivery;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get onlinePayment;

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upi;

  /// No description provided for @payViaBusinessQR.
  ///
  /// In en, this message translates to:
  /// **'Pay via Business QR'**
  String get payViaBusinessQR;

  /// No description provided for @payAdvance.
  ///
  /// In en, this message translates to:
  /// **'Pay Advance'**
  String get payAdvance;

  /// No description provided for @payPartialAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay Partial Amount'**
  String get payPartialAmount;

  /// No description provided for @payRemainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Pay Remaining Balance'**
  String get payRemainingBalance;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessful;

  /// No description provided for @paymentProcessing.
  ///
  /// In en, this message translates to:
  /// **'Payment Processing'**
  String get paymentProcessing;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @orderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderIdLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @paidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidLabel;

  /// No description provided for @paymentConfirmingDesc.
  ///
  /// In en, this message translates to:
  /// **'We are confirming your payment.'**
  String get paymentConfirmingDesc;

  /// No description provided for @doNotPayAgainDesc.
  ///
  /// In en, this message translates to:
  /// **'Please do not pay again immediately.'**
  String get doNotPayAgainDesc;

  /// No description provided for @checkStatusButton.
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatusButton;

  /// No description provided for @paymentFailedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your payment could not be confirmed.'**
  String get paymentFailedDesc;

  /// No description provided for @retryPaymentButton.
  ///
  /// In en, this message translates to:
  /// **'Retry Payment'**
  String get retryPaymentButton;

  /// No description provided for @chooseAnotherMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Another Method'**
  String get chooseAnotherMethod;

  /// No description provided for @backToOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Order'**
  String get backToOrderButton;

  /// No description provided for @utrLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction UTR Number'**
  String get utrLabel;

  /// No description provided for @uploadScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Upload Payment Screenshot'**
  String get uploadScreenshot;

  /// No description provided for @submitVerification.
  ///
  /// In en, this message translates to:
  /// **'Submit for Verification'**
  String get submitVerification;

  /// No description provided for @verificationPending.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verificationPending;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatusLabel;

  /// No description provided for @selectDeliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Location'**
  String get selectDeliveryLocation;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State / UT'**
  String get stateLabel;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtLabel;

  /// No description provided for @tehsilLabel.
  ///
  /// In en, this message translates to:
  /// **'Tehsil / Sub-District'**
  String get tehsilLabel;

  /// No description provided for @villageLabel.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get villageLabel;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
