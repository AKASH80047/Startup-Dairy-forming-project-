# 🥛 Pandey Dairy Farming

<div align="center">

<img src="screenshots/banner.png" width="100%" alt="Pandey Dairy Farming Banner"/>

<br/>

# 🕉️ ॐ नमः शिवाय

## Pandey Dairy Farming

### पांडेय डेयरी फार्मिंग

**Pure • Fresh • From Our Roots**
**शुद्ध • ताज़ा • अपनी मिट्टी से**

<br/>

A modern bilingual dairy ordering and village dairy business management application built with Flutter, BLoC, Clean Architecture, Maps, and REST API-ready architecture.

</div>

---

## 📌 About the Project

**Pandey Dairy Farming** is a village-focused dairy business application designed for both customers and dairy administrators.

The application helps manage:

* 🐄 Cow breeds and milk
* 🐃 Buffalo breeds and milk
* 🥛 Other dairy products
* 🎉 Wedding and event bulk orders
* 👥 Village-wise customers
* 📅 Daily milk history
* 💰 Monthly milk हिसाब
* 📍 Map-based delivery locations
* 🚚 Free delivery within 2 km
* 💵 Cash on Delivery
* 📱 QR / UPI payments
* 🌐 Hindi and English
* 🧑‍💼 Admin management

---

# 📱 Application Preview

<div align="center">

<img src="screenshots/splash_screen.png" width="23%" alt="Splash Screen"/>
&nbsp;
<img src="screenshots/language_selection.png" width="23%" alt="Language Selection"/>
&nbsp;
<img src="screenshots/home_screen.png" width="23%" alt="Home Screen"/>
&nbsp;
<img src="screenshots/cow_breeds.png" width="23%" alt="Cow Breeds"/>

</div>

<br/>

<div align="center">

<b>Splash Screen</b>
       <b>Language</b>
       <b>Home Screen</b>
       <b>Cow Breeds</b>

</div>

---

# 🚀 Application Flow

<div align="center">

<img src="screenshots/app_flow.png" width="90%" alt="Pandey Dairy Farming App Flow"/>

</div>

```text
App Open
   ↓
🕉️ ॐ नमः शिवाय
   ↓
Pandey Dairy Farming
पांडेय डेयरी फार्मिंग
   ↓
Choose Language
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

# 🕉️ 1. Premium Splash Screen

<div align="center">

<img src="screenshots/splash_screen.png" width="280" alt="Pandey Dairy Farming Splash Screen"/>

</div>

The application starts with a premium devotional and brand-focused splash screen.

### Display Sequence

```text
🕉️
↓
ॐ नमः शिवाय
↓
OM NAMAH SHIVAYA
↓
PANDEY DAIRY FARMING
↓
पांडेय डेयरी फार्मिंग
↓
Pure • Fresh • From Our Roots
```

The animation should remain subtle, premium, and professional.

---

# 🌐 2. Hindi and English Language Support

<div align="center">

<img src="screenshots/language_selection.png" width="280" alt="Language Selection"/>

</div>

The application supports:

* 🇮🇳 हिंदी
* English

### First-Time User Flow

```text
Splash
   ↓
Choose Language
अपनी भाषा चुनें
   ↓
English / हिंदी
   ↓
Save Preference
   ↓
Open Home
```

The selected language is stored locally.

The user can change language later from:

* Home AppBar
* Profile
* Settings

### Localization Files

```text
lib/
└── l10n/
    ├── app_en.arb
    └── app_hi.arb
```

---

# 🏠 3. Premium Home Screen

<div align="center">

<img src="screenshots/home_screen.png" width="300" alt="Pandey Dairy Farming Home Screen"/>

</div>

The Home Screen contains four main visual categories.

<div align="center">

<img src="screenshots/home_cow_card.png" width="45%" alt="Cow Category"/>
&nbsp;
<img src="screenshots/home_buffalo_card.png" width="45%" alt="Buffalo Category"/>

<br/><br/>

<img src="screenshots/home_other_card.png" width="45%" alt="Other Products"/>
&nbsp;
<img src="screenshots/home_bulk_card.png" width="45%" alt="Bulk Orders"/>

</div>

### Main Categories

```text
🐄 Cow / गाय

🐃 Buffalo / भैंस

🥛 Other Products / अन्य उत्पाद

🎉 Bulk & Event Orders / थोक एवं समारोह ऑर्डर
```

The final production UI should use real high-quality images instead of emoji-based cards.

---

# 🐄 4. Cow Breeds

<div align="center">

<img src="screenshots/cow_breeds.png" width="300" alt="Cow Breeds Screen"/>
&nbsp;&nbsp;
<img src="screenshots/cow_breed_details.png" width="300" alt="Cow Breed Details"/>

</div>

When the user selects **Cow / गाय**, all cow breeds open directly.

### Supported Cow Breeds

```text
🐄 Sahiwal / साहीवाल
🐄 Gir / गीर
🐄 Red Sindhi / लाल सिंधी
🐄 Tharparkar / थारपारकर
🐄 Rathi / राठी
🐄 Kankrej / कांकरेज
🐄 Jersey / जर्सी
🐄 Holstein Friesian / HF
```

There is no unnecessary separate Exotic Cow category in the main user flow.

Each breed card can show:

* Real breed image
* English name
* Hindi name
* Origin
* Short description
* Availability
* Price
* View Details

---

# 🐃 5. Buffalo Breeds

<div align="center">

<img src="screenshots/buffalo_breeds.png" width="300" alt="Buffalo Breeds"/>
&nbsp;&nbsp;
<img src="screenshots/buffalo_details.png" width="300" alt="Buffalo Details"/>

</div>

### Supported Buffalo Breeds

```text
🐃 Murrah / मुर्रा
🐃 Bhadawari / भदावरी
🐃 Jaffarabadi / जाफराबादी
🐃 Mehsana / मेहसाना
```

Each buffalo breed can contain:

* Breed image
* English name
* Hindi name
* Origin
* Description
* Availability
* Milk information
* Price information

---

# 📖 6. Breed Detail Screen

<div align="center">

<img src="screenshots/breed_details.png" width="300" alt="Breed Detail Screen"/>

</div>

Example:

```text
Gir / गीर

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

### Customer Actions

```text
[ Select Quantity ]

[ Add to Cart ]

[ Buy Now ]

[ Start Daily Subscription ]
```

---

# 🥛 7. Other Dairy Products

<div align="center">

<img src="screenshots/other_products.png" width="300" alt="Other Dairy Products"/>
&nbsp;&nbsp;
<img src="screenshots/product_details.png" width="300" alt="Product Details"/>

</div>

### Products

```text
🥣 Curd / दही

🧀 Paneer / पनीर

🧈 Ghee / घी

🥛 Buttermilk / छाछ

🧈 Butter / मक्खन

🥤 Lassi / लस्सी
```

For the first MVP, priority products are:

* Paneer
* Curd
* Ghee
* Buttermilk

---

# 🛒 8. Customer Ordering System

<div align="center">

<img src="screenshots/cart_screen.png" width="30%" alt="Cart"/>
&nbsp;
<img src="screenshots/checkout_screen.png" width="30%" alt="Checkout"/>
&nbsp;
<img src="screenshots/order_success.png" width="30%" alt="Order Success"/>

</div>

### Order Flow

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
Delivery Charge
      ↓
Choose Payment
      ↓
Place Order
```

---

# 🏘️ 9. Village Management

<div align="center">

<img src="screenshots/village_management.png" width="300" alt="Village Management"/>
&nbsp;&nbsp;
<img src="screenshots/village_customers.png" width="300" alt="Village Customers"/>

</div>

The system supports village-wise business management.

```text
Village A
   ├── Customer 1
   ├── Customer 2
   └── Customer 3

Village B
   ├── Customer 4
   └── Customer 5
```

Admin can:

* Add village
* Edit village
* Disable village
* View customers
* View daily milk customers
* View village orders
* View pending payments

---

# 👤 10. Daily Milk Customer System

<div align="center">

<img src="screenshots/daily_customer.png" width="300" alt="Daily Customer"/>
&nbsp;&nbsp;
<img src="screenshots/add_daily_customer.png" width="300" alt="Add Daily Customer"/>

</div>

This is one of the strongest real-business features.

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

Admin can manually add village customers who take milk every day.

---

# 📅 11. Daily Milk History

<div align="center">

<img src="screenshots/daily_history.png" width="300" alt="Daily Milk History"/>

</div>

Every delivery record is stored.

```text
01 July → 3 L → ₹240 → Delivered

02 July → 3 L → ₹240 → Delivered

03 July → 2 L → ₹160 → Delivered

04 July → 0 L → Paused

05 July → 3 L → ₹240 → Delivered
```

### Delivery Status

```text
Pending
Delivered
Skipped
Paused
Cancelled
```

---

# 💰 12. Monthly Milk हिसाब

<div align="center">

<img src="screenshots/monthly_bill.png" width="300" alt="Monthly Bill"/>
&nbsp;&nbsp;
<img src="screenshots/payment_history.png" width="300" alt="Payment History"/>

</div>

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

### Admin Actions

* Record Cash Payment
* Record QR Payment
* View Payment History
* Share Bill
* Download Bill
* Mark Fully Paid

---

# 🎉 13. Bulk & Event Orders

<div align="center">

<img src="screenshots/bulk_orders.png" width="300" alt="Bulk Orders"/>
&nbsp;&nbsp;
<img src="screenshots/bulk_order_form.png" width="300" alt="Bulk Order Form"/>

</div>

Customers can place large orders for:

```text
💍 Wedding / शादी

🎂 Birthday / जन्मदिन

🙏 Bhandara / भंडारा

🛕 Religious Function / धार्मिक कार्यक्रम

🎊 Family Function / पारिवारिक समारोह

🏫 School Event / स्कूल कार्यक्रम

🏢 Business Order / व्यावसायिक ऑर्डर

🍽️ Catering / कैटरिंग
```

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

---

# 🎁 14. Bulk Discount System

<div align="center">

<img src="screenshots/discount_system.png" width="300" alt="Bulk Discount System"/>

</div>

Example configurable rules:

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

Admin can:

* Create discount rules
* Edit rules
* Disable rules
* Create quantity discounts
* Create product discounts
* Approve custom quotes

---

# 📍 15. Map and Live Location

<div align="center">

<img src="screenshots/map_location.png" width="300" alt="Map Location"/>
&nbsp;&nbsp;
<img src="screenshots/location_confirm.png" width="300" alt="Confirm Location"/>

</div>

Customer options:

```text
📍 Use Current Location

🗺️ Choose on Map

📌 Drop Pin

🔍 Search Address

🏠 Saved Address
```

### Location Flow

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

---

# 🚚 16. Free Delivery System

<div align="center">

<img src="screenshots/free_delivery.png" width="300" alt="Free Delivery System"/>

</div>

### Main Business Rule

```text
0–2 KM
   ↓
FREE DELIVERY
```

Example configuration:

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

These values should be configurable from the Admin Panel.

---

# 💵 17. Payment System

<div align="center">

<img src="screenshots/payment_method.png" width="30%" alt="Payment Method"/>
&nbsp;
<img src="screenshots/qr_payment.png" width="30%" alt="QR Payment"/>
&nbsp;
<img src="screenshots/payment_status.png" width="30%" alt="Payment Status"/>

</div>

### Supported Payment Methods

```text
💵 Cash on Delivery

📱 QR / UPI Payment
```

### QR Payment Flow

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

Payment statuses:

```text
Pending
Verification Pending
Verified
Failed
Rejected
```

---

# 💍 18. Bulk Order Payment

<div align="center">

<img src="screenshots/bulk_payment.png" width="300" alt="Bulk Payment"/>

</div>

Example:

```text
Wedding Order Total:
₹50,000

Advance Paid:
₹10,000

Pending:
₹40,000
```

The system supports:

* Advance payment
* Partial payment
* Final payment
* Payment history

---

# 🧑‍💼 19. Admin Panel

<div align="center">

<img src="screenshots/admin_dashboard.png" width="300" alt="Admin Dashboard"/>
&nbsp;&nbsp;
<img src="screenshots/admin_orders.png" width="300" alt="Admin Orders"/>

</div>

Admin Dashboard can show:

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

### Admin Modules

```text
Dashboard
├── Villages
├── Customers
├── Daily Milk Customers
├── Daily Delivery Records
├── Cow Breeds
├── Buffalo Breeds
├── Products
├── Normal Orders
├── Bulk Orders
├── Discount Rules
├── Payments
├── Monthly Bills
├── Delivery Settings
├── Reports
└── Settings
```

---

# 🧠 20. BLoC Architecture

<div align="center">

<img src="screenshots/bloc_architecture.png" width="85%" alt="BLoC Architecture"/>

</div>

```text
User Interface
      ↓
Event
      ↓
BLoC / Cubit
      ↓
Use Case
      ↓
Repository
      ↓
Remote Data Source
      ↓
Dio
      ↓
REST API
      ↓
Database
```

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

---

# 🏗️ 21. Complete System Architecture

<div align="center">

<img src="screenshots/system_architecture.png" width="90%" alt="System Architecture"/>

</div>

```text
Flutter Mobile App
        ↓
Presentation Layer
        ↓
BLoC / Cubit
        ↓
Domain Layer
        ↓
Use Cases
        ↓
Repository
        ↓
Data Layer
        ↓
Dio API Client
        ↓
REST API
        ↓
Backend Server
        ↓
PostgreSQL Database
```

---

# 📁 22. Recommended Project Structure

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

# 🛠️ 23. Technology Stack

| Area              | Technology         |
| ----------------- | ------------------ |
| Mobile            | Flutter            |
| Language          | Dart               |
| State Management  | BLoC / Cubit       |
| Architecture      | Clean Architecture |
| Navigation        | GoRouter           |
| Networking        | Dio                |
| Localization      | ARB                |
| Maps              | Google Maps        |
| Location          | Geolocator         |
| Permissions       | Permission Handler |
| Local Preferences | SharedPreferences  |
| Future Backend    | Node.js            |
| Backend Framework | Express.js         |
| Database          | PostgreSQL         |
| Authentication    | JWT                |
| API               | REST API           |

---

# 🚀 24. Development Roadmap

<div align="center">

<img src="screenshots/development_roadmap.png" width="90%" alt="Development Roadmap"/>

</div>

### Phase 1

```text
Splash
↓
ॐ नमः शिवाय
↓
Language Selection
↓
Home Screen
↓
Cow / Buffalo / Other / Bulk
```

### Phase 2

```text
Cow Breeds
↓
Buffalo Breeds
↓
Breed Details
↓
Other Products
```

### Phase 3

```text
Cart
↓
Address
↓
Map
↓
Location
↓
Distance
↓
Delivery Fee
```

### Phase 4

```text
COD
↓
QR / UPI
↓
Orders
↓
Order History
```

### Phase 5

```text
Villages
↓
Daily Customers
↓
Daily Milk History
↓
Monthly हिसाब
```

### Phase 6

```text
Wedding Orders
↓
Birthday Orders
↓
Bulk Discounts
↓
Advance Payments
```

### Phase 7

```text
Admin Dashboard
↓
Reports
↓
Analytics
↓
Production Hardening
```

---

# 📂 Screenshot Folder Structure

Create this folder in the project root:

```text
screenshots/
├── banner.png
├── app_flow.png
├── splash_screen.png
├── language_selection.png
├── home_screen.png
├── home_cow_card.png
├── home_buffalo_card.png
├── home_other_card.png
├── home_bulk_card.png
├── cow_breeds.png
├── cow_breed_details.png
├── buffalo_breeds.png
├── buffalo_details.png
├── breed_details.png
├── other_products.png
├── product_details.png
├── cart_screen.png
├── checkout_screen.png
├── order_success.png
├── village_management.png
├── village_customers.png
├── daily_customer.png
├── add_daily_customer.png
├── daily_history.png
├── monthly_bill.png
├── payment_history.png
├── bulk_orders.png
├── bulk_order_form.png
├── discount_system.png
├── map_location.png
├── location_confirm.png
├── free_delivery.png
├── payment_method.png
├── qr_payment.png
├── payment_status.png
├── bulk_payment.png
├── admin_dashboard.png
├── admin_orders.png
├── bloc_architecture.png
├── system_architecture.png
└── development_roadmap.png
```

---

# 🎯 Project Vision

**Pandey Dairy Farming** is not designed as a basic student milk-delivery application.

It is designed as a:

> **Bilingual village dairy commerce, breed catalog, daily milk ledger, customer management, monthly billing, bulk event ordering, map-based delivery, payment, and administration platform.**

The application starts small but can grow into a complete real-world dairy business ecosystem.

---

<div align="center">

# 🕉️ ॐ नमः शिवाय

## Pandey Dairy Farming

### पांडेय डेयरी फार्मिंग

**Pure • Fresh • From Our Roots**
**शुद्ध • ताज़ा • अपनी मिट्टी से**

</div>
