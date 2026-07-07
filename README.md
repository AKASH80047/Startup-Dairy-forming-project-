# 🥛 Pandey Dairy Farming

<div align="center">

# 🕉️ ॐ नमः शिवाय

## Pandey Dairy Farming

### पांडेय डेयरी फार्मिंग

**Pure • Fresh • From Our Roots**
**शुद्ध • ताज़ा • अपनी मिट्टी से**

A bilingual, village-focused dairy ordering and business management application built with Flutter and BLoC.

</div>

---

## 📌 About the Project

**Pandey Dairy Farming** is a modern dairy business application designed for customers, village-based daily milk management, dairy product ordering, bulk event orders, delivery location tracking, payments, and administration.

The project is designed as a small MVP initially, but its architecture is planned for future business-level expansion.

The application supports:

* English and Hindi
* Cow milk categories
* Buffalo milk categories
* Dairy products
* Daily milk customers
* Village-wise customer records
* Monthly milk history
* Bulk and event orders
* Large-order discounts
* Map-based delivery locations
* Free delivery within 2 km
* Cash on Delivery
* QR / UPI payment
* Admin management

---

# 📱 Application Flow

```text
App Open
   ↓
🕉️ ॐ नमः शिवाय
   ↓
Pandey Dairy Farming
पांडेय डेयरी फार्मिंग
   ↓
Choose Language
भाषा चुनें
   ↓
English / हिंदी
   ↓
Home Screen
   ↓
┌─────────────┬─────────────┐
│ 🐄 Cow      │ 🐃 Buffalo  │
│ गाय         │ भैंस        │
├─────────────┼─────────────┤
│ 🥛 Other    │ 🎉 Bulk     │
│ अन्य उत्पाद │ थोक ऑर्डर   │
└─────────────┴─────────────┘
```

---

# 🖼️ App Screenshots

> Add real application screenshots inside the `screenshots/` folder.

## Splash Screen

![Splash Screen](screenshots/splash_screen.png)

The splash screen displays:

* ॐ symbol
* ॐ नमः शिवाय
* Om Namah Shivaya
* Pandey Dairy Farming
* पांडेय डेयरी फार्मिंग
* Brand tagline

---

## 🌐 Language Selection

![Language Selection](screenshots/language_selection.png)

The application supports:

* English
* हिंदी

The selected language is saved locally.

The user can change the language later from the app.

---

# 🏠 Home Screen

![Home Screen](screenshots/home_screen.png)

The main home screen contains four primary categories:

### 1. Cow / गाय

Browse different cow breeds and milk options.

### 2. Buffalo / भैंस

Browse supported buffalo breeds.

### 3. Other Products / अन्य उत्पाद

Browse dairy products such as Paneer, Curd, Ghee, and Buttermilk.

### 4. Bulk & Event Orders / थोक एवं समारोह ऑर्डर

Place large orders for weddings, birthdays, religious functions, and other events.

---

# 🐄 Cow Breeds

![Cow Breeds](screenshots/cow_breeds.png)

When the user selects **Cow**, all available cow breeds open directly.

Supported initial breeds:

* Sahiwal / साहीवाल
* Gir / गीर
* Red Sindhi / लाल सिंधी
* Tharparkar / थारपारकर
* Rathi / राठी
* Kankrej / कांकरेज
* Jersey / जर्सी
* Holstein Friesian / होल्स्टीन फ्रिसियन

There is no separate Exotic Cow category in the initial user flow.

---

# 🐃 Buffalo Breeds

![Buffalo Breeds](screenshots/buffalo_breeds.png)

Supported initial buffalo breeds:

* Murrah / मुर्रा
* Bhadawari / भदावरी
* Jaffarabadi / जाफराबादी
* Mehsana / मेहसाना

Each breed can contain:

* Image
* English name
* Hindi name
* Origin
* Description
* Availability
* Milk information
* Price information

---

# 📖 Breed Detail Screen

![Breed Details](screenshots/breed_details.png)

When a customer selects a breed, a detailed page opens.

Example information:

```text
Breed: Gir / गीर

Origin:
Gujarat, India

Source Village:
Selected Village

Availability:
Available

Milk Price:
₹__ per litre

Fat:
Batch-tested value

Available Quantity:
__ litres
```

Possible actions:

* Select Quantity
* Add to Cart
* Buy Now
* Start Daily Subscription

The system should avoid unsupported health or medical claims.

---

# 🥛 Other Dairy Products

![Other Products](screenshots/other_products.png)

The **Other Products** section contains:

* Paneer / पनीर
* Curd / दही
* Ghee / घी
* Buttermilk / छाछ
* Butter / मक्खन
* Lassi / लस्सी

For the first MVP, priority products are:

* Paneer
* Curd
* Ghee
* Buttermilk

---

# 🛒 Normal Customer Order Flow

```text
Select Product
      ↓
Select Quantity
      ↓
Add to Cart
      ↓
Choose Address
      ↓
Select Map Location
      ↓
Calculate Distance
      ↓
Calculate Delivery Charge
      ↓
Choose Payment
      ↓
Place Order
```

Possible milk quantities:

* 500 ml
* 1 litre
* 2 litre
* 5 litre
* Custom quantity where supported

---

# 🏘️ Village Management

![Village Management](screenshots/village_management.png)

The application supports village-wise business management.

Example:

```text
Village A
   ├── Customer 1
   ├── Customer 2
   └── Customer 3

Village B
   ├── Customer 4
   └── Customer 5
```

Village information can contain:

* Village name
* Hindi name
* District
* State
* PIN code
* Latitude
* Longitude
* Active status

The admin can:

* Add village
* Edit village
* Disable village
* View village customers
* View village orders
* View pending payments

---

# 👤 Daily Milk Customer System

![Daily Customer](screenshots/daily_customer.png)

This is one of the main business features.

If a customer takes milk every day, the admin can manually register the customer.

Example:

```text
Customer:
Ramesh Kumar

Village:
Selected Village

Product:
Buffalo Milk

Breed:
Murrah

Morning:
2 Litres

Evening:
1 Litre

Price:
₹80 per litre

Status:
Active
```

The customer record can contain:

* Name
* Mobile number
* Village
* Address
* Map location
* Milk product
* Breed
* Morning quantity
* Evening quantity
* Price
* Start date
* Payment cycle
* Notes

---

# 📅 Daily Milk History

![Daily History](screenshots/daily_history.png)

Every daily delivery can be stored.

Example:

```text
01 July → 3 L → ₹240 → Delivered
02 July → 3 L → ₹240 → Delivered
03 July → 2 L → ₹160 → Delivered
04 July → 0 L → Paused
05 July → 3 L → ₹240 → Delivered
```

Possible statuses:

* Pending
* Delivered
* Skipped
* Paused
* Cancelled

History filters:

* Daily
* Weekly
* Monthly
* Custom date range

---

# 💰 Monthly Milk हिसाब

![Monthly Bill](screenshots/monthly_bill.png)

At the end of the month, the system can calculate the customer's milk bill.

Example:

```text
Customer:
Ramesh Kumar

Month:
July 2026

Total Milk:
87 Litres

Total Amount:
₹6,960

Paid:
₹5,000

Pending:
₹1,960
```

Admin actions:

* Record Cash Payment
* Record QR Payment
* View Payment History
* Share Bill
* Download Bill
* Mark Fully Paid

Partial payments are supported.

---

# 🎉 Bulk & Event Orders

![Bulk Orders](screenshots/bulk_orders.png)

Customers can place large dairy orders for:

* Wedding / शादी
* Birthday / जन्मदिन
* Bhandara / भंडारा
* Religious Function / धार्मिक कार्यक्रम
* Family Function / पारिवारिक समारोह
* School Event / स्कूल कार्यक्रम
* Business Order / व्यावसायिक ऑर्डर
* Catering / कैटरिंग
* Other / अन्य

Example:

```text
Wedding Order

Buffalo Milk:
100 Litres

Paneer:
25 kg

Curd:
30 kg
```

Customers can select multiple products in one bulk order.

---

# 🎁 Bulk Discount System

![Discount System](screenshots/discount_system.png)

Large orders can receive discounts.

Example configuration:

```text
₹2,000 – ₹4,999
→ 2% Discount

₹5,000 – ₹9,999
→ 5% Discount

₹10,000 – ₹24,999
→ 8% Discount

₹25,000+
→ Custom Quote
```

Important:

Discounts should not be permanently hardcoded.

The admin can:

* Create discount rules
* Edit rules
* Disable rules
* Add product-specific discounts
* Add quantity-based discounts
* Approve custom discounts

---

# 📍 Map & Location

![Map Location](screenshots/map_location.png)

Customers can select their delivery location using:

* Current Location
* Choose on Map
* Drop Pin
* Search Address
* Saved Address

Application flow:

```text
Dairy Location
      ↓
Customer Location
      ↓
Distance Calculation
      ↓
Delivery Eligibility
      ↓
Delivery Charge
```

Saved location data:

* Latitude
* Longitude
* Address
* Village
* Landmark
* PIN code

---

# 🚚 Delivery Charge System

The initial business rule is:

```text
0–2 km
→ FREE DELIVERY
```

Example configurable delivery rules:

```text
0–2 km
→ FREE

2–5 km
→ ₹20

5–10 km
→ ₹40

10+ km
→ Custom / Unavailable
```

These values should be configurable from the admin system.

For production use, final delivery charges should be validated by the backend.

---

# 💵 Payment Methods

![Payment Screen](screenshots/payment_screen.png)

Supported payment methods:

### 1. Cash on Delivery

```text
Order Placed
    ↓
Payment Pending
    ↓
Order Delivered
    ↓
Cash Received
    ↓
Payment Completed
```

### 2. QR / UPI Payment

```text
Order Amount
₹1,250

[ BUSINESS QR CODE ]

Scan and Pay

UTR / Transaction ID
[________________]

Upload Screenshot
[________________]

Submit Payment
```

The real business QR code can be added later.

Payment statuses:

* Pending
* Verification Pending
* Verified
* Failed
* Rejected

Uploaded screenshots should not automatically mark a payment as successful.

Admin verification is required in the MVP.

---

# 💍 Bulk Order Payment

Large event orders support advance and partial payments.

Example:

```text
Wedding Order Total:
₹50,000

Advance Paid:
₹10,000

Pending:
₹40,000
```

The system maintains a complete payment history.

---

# 🧑‍💼 Admin Panel

![Admin Dashboard](screenshots/admin_dashboard.png)

The Admin Dashboard can show:

```text
Total Customers
125

Today's Milk
240 L

Today's Orders
48

Pending Payments
₹25,000
```

Admin modules:

* Dashboard
* Villages
* Customers
* Daily Milk Customers
* Daily Delivery Records
* Cow Breeds
* Buffalo Breeds
* Products
* Normal Orders
* Bulk Orders
* Discount Rules
* Payments
* Monthly Bills
* Delivery Settings
* Reports
* Settings

---

# 📦 Order Status

Normal order statuses:

```text
Pending
   ↓
Confirmed
   ↓
Preparing
   ↓
Out for Delivery
   ↓
Delivered
```

Other possible status:

```text
Cancelled
```

Bulk order statuses:

```text
Quote Requested
      ↓
Quote Sent
      ↓
Awaiting Advance
      ↓
Confirmed
      ↓
Preparing
      ↓
Ready
      ↓
Out for Delivery
      ↓
Delivered
```

---

# 🌐 English and Hindi Support

The application supports complete bilingual navigation.

English example:

```text
Cow
Buffalo
Other Products
Add to Cart
Place Order
```

Hindi example:

```text
गाय
भैंस
अन्य उत्पाद
कार्ट में जोड़ें
ऑर्डर करें
```

Localization files:

```text
lib/
└── l10n/
    ├── app_en.arb
    └── app_hi.arb
```

The selected language is saved locally.

---

# 🧠 BLoC State Management

The application uses BLoC/Cubit for scalable state management.

Suggested modules:

```text
LanguageCubit
HomeBloc
BreedBloc
ProductBloc
VillageBloc
CartBloc
LocationBloc
OrderBloc
BulkOrderBloc
DailyCustomerBloc
DailyMilkBloc
PaymentBloc
MonthlyBillingBloc
```

Basic data flow:

```text
UI
 ↓
Event
 ↓
BLoC
 ↓
Use Case
 ↓
Repository
 ↓
REST API
 ↓
Database
```

---

# 🏗️ Application Architecture

The project follows:

* Feature-First Architecture
* Clean Architecture
* BLoC State Management
* Repository Pattern
* REST API-ready structure

Architecture flow:

```text
Flutter UI
    ↓
BLoC / Cubit
    ↓
Domain Use Case
    ↓
Repository
    ↓
Remote Data Source
    ↓
Dio
    ↓
REST API
    ↓
Backend
    ↓
Database
```

---

# 📁 Recommended Folder Structure

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router/
│   ├── theme/
│   └── localization/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── services/
│   ├── storage/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── splash/
│   ├── language/
│   ├── auth/
│   ├── home/
│   ├── animal/
│   ├── breed/
│   ├── product/
│   ├── village/
│   ├── location/
│   ├── address/
│   ├── cart/
│   ├── checkout/
│   ├── order/
│   ├── bulk_order/
│   ├── daily_customer/
│   ├── daily_milk/
│   ├── billing/
│   ├── payment/
│   ├── profile/
│   └── admin/
│
└── l10n/
    ├── app_en.arb
    └── app_hi.arb
```

---

# 🧩 Feature Structure

Each major feature follows:

```text
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

# 🛠️ Technology Stack

## Mobile Application

* Flutter
* Dart

## State Management

* flutter_bloc
* Cubit
* Equatable

## Navigation

* GoRouter

## Networking

* Dio

## Localization

* Flutter ARB Localization
* English
* Hindi

## Maps and Location

* Google Maps
* Geolocator
* Geocoding
* Permission Handler

## Local Storage

* SharedPreferences for simple preferences
* Secure Storage for sensitive local values

## Future Backend

Recommended:

* Node.js
* Express.js
* PostgreSQL
* JWT Authentication
* REST API

---

# 🔌 REST API Flow

```text
Flutter Application
        ↓
Dio API Client
        ↓
REST API
        ↓
Node.js Backend
        ↓
PostgreSQL Database
```

Example future endpoints:

```text
POST /api/auth/login
POST /api/auth/register

GET  /api/villages
GET  /api/breeds
GET  /api/products

POST /api/orders
GET  /api/orders

POST /api/bulk-orders

POST /api/daily-customers
GET  /api/daily-customers

GET  /api/customers/:id/history

POST /api/payments

POST /api/location/delivery-quote

GET  /api/admin/dashboard
```

---

# 🚀 Development Roadmap

## Phase 1 — UI Foundation

```text
Splash Screen
      ↓
ॐ नमः शिवाय Branding
      ↓
Language Selection
      ↓
English / Hindi
      ↓
Home Screen
      ↓
Cow / Buffalo / Other / Bulk
```

## Phase 2 — Product Browsing

```text
Cow Breeds
Buffalo Breeds
Breed Details
Other Products
```

## Phase 3 — Ordering

```text
Cart
Address
Map
Location
Distance
Delivery Fee
```

## Phase 4 — Checkout

```text
Cash on Delivery
QR / UPI
Orders
Order History
```

## Phase 5 — Village Business

```text
Villages
Daily Customers
Daily Milk Records
Monthly हिसाब
Payments
```

## Phase 6 — Bulk Business

```text
Wedding Orders
Birthday Orders
Function Orders
Bulk Discounts
Advance Payments
Pending Balance
```

## Phase 7 — Administration

```text
Admin Dashboard
Reports
Business Analytics
Production Hardening
```

---

# 🎯 Project Vision

The long-term goal of **Pandey Dairy Farming** is to become more than a basic milk delivery application.

It is designed as a:

> **Bilingual village dairy commerce, daily milk ledger, customer management, breed catalog, bulk event ordering, location-based delivery, payment, and administration platform.**

The application starts small but is designed to grow into a real dairy business management ecosystem.

---

<div align="center">

## 🕉️ ॐ नमः शिवाय

### Pandey Dairy Farming

### पांडेय डेयरी फार्मिंग

**Pure • Fresh • From Our Roots**
**शुद्ध • ताज़ा • अपनी मिट्टी से**

</div>
