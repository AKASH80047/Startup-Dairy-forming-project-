import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../../../bulk_order/domain/entities/bulk_order_entity.dart';
import '../../domain/entities/admin_village_entity.dart';
import '../../domain/entities/daily_milk_customer_entity.dart';
import '../bloc/admin_cubit.dart';
import '../bloc/admin_state.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Add Village Controllers
  final _villageFormKey = GlobalKey<FormState>();
  final _vNameEnController = TextEditingController();
  final _vNameHiController = TextEditingController();
  final _vDistrictController = TextEditingController(text: 'Jaipur');
  final _vStateController = TextEditingController(text: 'Rajasthan');
  final _vPincodeController = TextEditingController();

  // Register Customer Controllers
  final _custFormKey = GlobalKey<FormState>();
  final _cNameController = TextEditingController();
  final _cPhoneController = TextEditingController();
  final _cAddressController = TextEditingController();
  final _cMorningController = TextEditingController(text: '1.0');
  final _cEveningController = TextEditingController(text: '0.0');
  final _cPriceController = TextEditingController(text: '70');
  final _cNotesController = TextEditingController();
  String _selectedVillage = '';
  String _cAnimalType = 'Cow';
  final String _cPaymentCycle = 'Monthly';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _vNameEnController.dispose();
    _vNameHiController.dispose();
    _vDistrictController.dispose();
    _vStateController.dispose();
    _vPincodeController.dispose();
    _cNameController.dispose();
    _cPhoneController.dispose();
    _cAddressController.dispose();
    _cMorningController.dispose();
    _cEveningController.dispose();
    _cPriceController.dispose();
    _cNotesController.dispose();
    super.dispose();
  }

  // Calculation helpers for KPIs
  double _calculateTotalRevenue(List<OrderEntity> orders, List<BulkOrderEntity> bulkOrders, List<DailyMilkCustomerEntity> customers) {
    double total = 0.0;
    // User orders
    for (var o in orders) {
      if (o.status == 'Delivered') {
        total += o.grandTotal;
      }
    }
    // Bulk orders advance payments
    for (var bo in bulkOrders) {
      total += bo.advancePaid;
    }
    // Daily subscribers revenue (simulate 30 days of active deliveries)
    for (var c in customers) {
      if (c.status == 'Active') {
        final dailyLitres = c.morningQty + c.eveningQty;
        total += dailyLitres * c.pricePerLitre * 30; // 1 month हिसाब estimate
      }
    }
    return total;
  }

  double _calculateTodayMilk(List<DailyMilkCustomerEntity> customers) {
    double total = 0.0;
    for (var c in customers) {
      if (c.status == 'Active') {
        total += c.morningQty + c.eveningQty;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final storage = context.read<StorageService>();

    final userOrders = storage.getOrderHistory();
    final bulkOrders = storage.getBulkOrderHistory();

    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppConstants.primaryGreen),
          );
        } else if (state is AdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
          );
        }
      },
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        List<AdminVillageEntity> villages = [];
        List<DailyMilkCustomerEntity> customers = [];

        if (state is AdminLoaded) {
          villages = state.villages;
          customers = state.dailyCustomers;
        }

        final double revenue = _calculateTotalRevenue(userOrders, bulkOrders, customers);
        final double milkLitres = _calculateTodayMilk(customers);

        return Scaffold(
          backgroundColor: AppConstants.backgroundCream,
          appBar: AppBar(
            title: Text(l10n.adminModeTitle),
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppConstants.primaryGreen,
              unselectedLabelColor: AppConstants.textSecondary,
              indicatorColor: AppConstants.primaryGreen,
              tabs: [
                Tab(text: isHindi ? 'डैशबोर्ड' : 'Dashboard'),
                Tab(text: l10n.villagesTab),
                Tab(text: l10n.dailyCustomersTab),
                Tab(text: l10n.ordersTab),
                Tab(text: l10n.bulkOrdersTab),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDashboardTab(context, isHindi, l10n, userOrders, bulkOrders, customers, revenue, milkLitres),
              _buildVillagesTab(context, isHindi, l10n, villages),
              _buildCustomersTab(context, isHindi, l10n, customers, villages),
              _buildOrdersTab(context, isHindi, l10n, userOrders),
              _buildBulkOrdersTab(context, isHindi, l10n, bulkOrders),
            ],
          ),
        );
      },
    );
  }

  // Dashboard Overview Tab
  Widget _buildDashboardTab(
    BuildContext context,
    bool isHindi,
    AppLocalizations l10n,
    List<OrderEntity> orders,
    List<BulkOrderEntity> bulkOrders,
    List<DailyMilkCustomerEntity> customers,
    double totalRevenue,
    double milkLitres,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHindi ? 'आज के मुख्य आंकड़े' : 'Today\'s Business Metrics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.primaryGreen),
          ),
          const SizedBox(height: 16),

          // KPIs Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              _buildKpiCard(
                isHindi ? 'कुल राजस्व' : 'Total Revenue',
                '₹${totalRevenue.toStringAsFixed(0)}',
                Icons.currency_rupee_rounded,
                Colors.green,
              ),
              _buildKpiCard(
                isHindi ? 'दैनिक दूध मात्रा' : 'Daily Milk Vol',
                '${milkLitres.toStringAsFixed(1)} L',
                Icons.opacity_rounded,
                Colors.blue,
              ),
              _buildKpiCard(
                l10n.totalCustomersLabel,
                '${customers.length}',
                Icons.people_rounded,
                AppConstants.primaryGreen,
              ),
              _buildKpiCard(
                isHindi ? 'सक्रिय सदस्य' : 'Active Members',
                '${customers.where((c) => c.status == 'Active').length}',
                Icons.star_rounded,
                AppConstants.accentGold,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Subtotals lists
          _buildQuickReportSection(context, isHindi, orders, bulkOrders),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                const Icon(Icons.trending_up, color: Colors.green, size: 16),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.textPrimary),
                ),
                Text(
                  label,
                  style: TextStyle(color: AppConstants.textSecondary, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReportSection(
    BuildContext context,
    bool isHindi,
    List<OrderEntity> orders,
    List<BulkOrderEntity> bulkOrders,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHindi ? 'हालिया बुकिंग्स' : 'Recent Bookings & Sales',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            if (orders.isEmpty && bulkOrders.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    isHindi ? 'कोई सक्रिय बुकिंग रिकॉर्ड नहीं मिला।' : 'No active orders registered.',
                    style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
                  ),
                ),
              )
            else ...[
              ...orders.take(3).map((o) => _buildRecentBookingRow(o.id, o.customerName, o.grandTotal, o.status, isHindi)),
              ...bulkOrders.take(3).map((bo) => _buildRecentBookingRow(bo.id, bo.customerName, bo.grandTotal, bo.status, isHindi)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookingRow(String id, String name, double total, String status, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(name, style: TextStyle(fontSize: 10, color: AppConstants.textSecondary)),
            ],
          ),
          Row(
            children: [
              Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'Delivered' || status == 'Confirmed' ? Colors.green.withValues(alpha: 0.08) : Colors.amber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: status == 'Delivered' || status == 'Confirmed' ? Colors.green : Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Villages Management Tab
  Widget _buildVillagesTab(BuildContext context, bool isHindi, AppLocalizations l10n, List<AdminVillageEntity> villages) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.primaryGreen,
        icon: const Icon(Icons.add),
        label: Text(l10n.addVillageLabel),
        onPressed: () => _showAddVillageDialog(context, isHindi),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: villages.length,
        itemBuilder: (context, index) {
          final village = villages[index];
          final String name = isHindi ? village.nameHindi : village.nameEnglish;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
            ),
            child: ListTile(
              leading: Icon(
                Icons.location_on_outlined,
                color: village.isActive ? AppConstants.primaryGreen : AppConstants.textSecondary,
              ),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(
                'Pincode: ${village.pincode} • ${village.district}, ${village.state}',
                style: TextStyle(fontSize: 10, color: AppConstants.textSecondary),
              ),
              trailing: Switch(
                value: village.isActive,
                activeThumbColor: AppConstants.primaryGreen,
                onChanged: (_) {
                  context.read<AdminCubit>().toggleVillageStatus(village.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddVillageDialog(BuildContext context, bool isHindi) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isHindi ? 'नया गाँव जोड़ें' : 'Add New Village'),
          content: Form(
            key: _villageFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _vNameEnController,
                    decoration: const InputDecoration(labelText: 'Village Name (English)'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter English name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _vNameHiController,
                    decoration: const InputDecoration(labelText: 'गांव का नाम (Hindi)'),
                    validator: (v) => v == null || v.isEmpty ? 'हिंदी नाम दर्ज करें' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _vPincodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Pincode'),
                    validator: (v) => v == null || v.length != 6 ? 'Enter 6 digit pincode' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_villageFormKey.currentState!.validate()) {
                  final newVillage = AdminVillageEntity(
                    id: 'v_${_vNameEnController.text.trim().toLowerCase().replaceAll(' ', '_')}',
                    nameEnglish: _vNameEnController.text.trim(),
                    nameHindi: _vNameHiController.text.trim(),
                    district: 'Jaipur',
                    state: 'Rajasthan',
                    pincode: _vPincodeController.text.trim(),
                    isActive: true,
                  );
                  this.context.read<AdminCubit>().addVillage(newVillage);
                  _vNameEnController.clear();
                  _vNameHiController.clear();
                  _vPincodeController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text(isHindi ? 'जोड़ें' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  // Daily customers manually added
  Widget _buildCustomersTab(
    BuildContext context,
    bool isHindi,
    AppLocalizations l10n,
    List<DailyMilkCustomerEntity> customers,
    List<AdminVillageEntity> villages,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.primaryGreen,
        icon: const Icon(Icons.add),
        label: Text(l10n.registerSubscriberLabel),
        onPressed: () {
          if (villages.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please add at least one active village first.')),
            );
          } else {
            _showRegisterCustomerDialog(context, isHindi, villages);
          }
        },
      ),
      body: customers.isEmpty
          ? Center(
              child: Text(
                isHindi ? 'कोई पंजीकृत दैनिक ग्राहक नहीं मिला।' : 'No registered daily subscribers.',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                final dailyLitre = c.morningQty + c.eveningQty;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: c.status == 'Active' ? Colors.green.withValues(alpha: 0.08) : Colors.red.withValues(alpha: 0.08),
                      child: Icon(
                        c.animalType == 'Cow' ? Icons.water_drop_outlined : Icons.opacity_rounded,
                        color: c.status == 'Active' ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(
                      '${c.village} • Qty: $dailyLitre L • Rate: ₹${c.pricePerLitre}/L • ${c.paymentCycle}',
                      style: TextStyle(fontSize: 10, color: AppConstants.textSecondary),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<AdminCubit>().toggleCustomerStatus(c.id);
                          },
                          child: Text(
                            c.status == 'Active' ? 'Pause' : 'Resume',
                            style: TextStyle(
                              color: c.status == 'Active' ? Colors.redAccent : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showRegisterCustomerDialog(BuildContext context, bool isHindi, List<AdminVillageEntity> villages) {
    if (_selectedVillage.isEmpty && villages.isNotEmpty) {
      _selectedVillage = isHindi ? villages.first.nameHindi : villages.first.nameEnglish;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(isHindi ? 'दैनिक ग्राहक पंजीकरण' : 'Register Daily Milk Subscriber'),
              content: Form(
                key: _custFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _cNameController,
                        decoration: const InputDecoration(labelText: 'Customer Name'),
                        validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cPhoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        validator: (v) => v == null || v.length != 10 ? 'Enter 10-digit phone' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedVillage,
                        decoration: const InputDecoration(labelText: 'Select Village'),
                        items: villages.map((v) {
                          final name = isHindi ? v.nameHindi : v.nameEnglish;
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => _selectedVillage = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cAddressController,
                        decoration: const InputDecoration(labelText: 'Street Address'),
                        validator: (v) => v == null || v.isEmpty ? 'Enter street address' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cMorningController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Morning Qty (L)'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cEveningController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Evening Qty (L)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Price Per Litre (₹)'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Animal Type:', style: TextStyle(fontSize: 12)),
                          RadioGroup<String>(
                            groupValue: _cAnimalType,
                            onChanged: (v) {
                              if (v != null) setDialogState(() => _cAnimalType = v);
                            },
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'Cow',
                                  groupValue: _cAnimalType,
                                  onChanged: (v) {
                                    if (v != null) setDialogState(() => _cAnimalType = v);
                                  },
                                  activeColor: AppConstants.primaryGreen,
                                ),
                                const Text('Cow', style: TextStyle(fontSize: 12)),
                                Radio<String>(
                                  value: 'Buffalo',
                                  groupValue: _cAnimalType,
                                  onChanged: (v) {
                                    if (v != null) setDialogState(() => _cAnimalType = v);
                                  },
                                  activeColor: AppConstants.primaryGreen,
                                ),
                                const Text('Buffalo', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_custFormKey.currentState!.validate()) {
                      final newCust = DailyMilkCustomerEntity(
                        id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                        name: _cNameController.text.trim(),
                        phone: _cPhoneController.text.trim(),
                        village: _selectedVillage,
                        address: _cAddressController.text.trim(),
                        morningQty: double.tryParse(_cMorningController.text) ?? 1.0,
                        eveningQty: double.tryParse(_cEveningController.text) ?? 0.0,
                        pricePerLitre: double.tryParse(_cPriceController.text) ?? 70.0,
                        startDate: DateTime.now(),
                        status: 'Active',
                        animalType: _cAnimalType,
                        paymentCycle: _cPaymentCycle,
                        notes: _cNotesController.text.trim(),
                      );
                      this.context.read<AdminCubit>().registerDailyCustomer(newCust);
                      _cNameController.clear();
                      _cPhoneController.clear();
                      _cAddressController.clear();
                      _cNotesController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isHindi ? 'पंजीकृत करें' : 'Register'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Placed normal orders list
  Widget _buildOrdersTab(BuildContext context, bool isHindi, AppLocalizations l10n, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          isHindi ? 'कोई ऑर्डर इतिहास नहीं मिला।' : 'No regular orders logged.',
          style: TextStyle(color: AppConstants.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    DropdownButton<String>(
                      value: order.status,
                      iconEnabledColor: AppConstants.primaryGreen,
                      underline: Container(),
                      style: TextStyle(color: AppConstants.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
                      items: ['Pending', 'Confirmed', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled']
                          .map((st) => DropdownMenuItem<String>(value: st, child: Text(st)))
                          .toList(),
                      onChanged: (newVal) {
                        if (newVal != null) {
                          context.read<AdminCubit>().changeOrderStatus(order.id, newVal);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Customer: ${order.customerName} (${order.customerPhone})', style: const TextStyle(fontSize: 12)),
                Text('Address: ${order.address.addressLine}, ${order.address.village}', style: TextStyle(fontSize: 11, color: AppConstants.textSecondary)),
                const SizedBox(height: 8),
                Divider(color: AppConstants.dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ₹${order.grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Paid Via: ${order.paymentMethod.toUpperCase()}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppConstants.accentGold)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Placed event orders list
  Widget _buildBulkOrdersTab(BuildContext context, bool isHindi, AppLocalizations l10n, List<BulkOrderEntity> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          isHindi ? 'कोई थोक ऑर्डर इतिहास नहीं मिला।' : 'No bulk event orders logged.',
          style: TextStyle(color: AppConstants.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.id, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.primaryGreen)),
                    DropdownButton<String>(
                      value: order.status,
                      iconEnabledColor: AppConstants.primaryGreen,
                      underline: Container(),
                      style: TextStyle(color: AppConstants.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
                      items: ['Awaiting Advance', 'Confirmed', 'Out for Delivery', 'Delivered', 'Cancelled']
                          .map((st) => DropdownMenuItem<String>(value: st, child: Text(st)))
                          .toList(),
                      onChanged: (newVal) {
                        if (newVal != null) {
                          context.read<AdminCubit>().changeBulkOrderStatus(order.id, newVal);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Event: ${order.eventType} • Expected Guests: ${order.expectedGuests}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text('Customer: ${order.customerName} (${order.customerPhone})', style: const TextStyle(fontSize: 11)),
                Text('Address: ${order.address.addressLine}, ${order.address.village}', style: TextStyle(fontSize: 11, color: AppConstants.textSecondary)),
                const SizedBox(height: 8),
                Divider(color: AppConstants.dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: ₹${order.grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Advance Paid: ₹${order.advancePaid.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text('Balance Due: ₹${order.pendingBalance.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.redAccent)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
