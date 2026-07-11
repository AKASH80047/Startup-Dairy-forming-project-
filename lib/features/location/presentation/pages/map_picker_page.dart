import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pandey/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../bloc/location_cubit.dart';
import '../bloc/location_state.dart';
import '../../domain/entities/user_address.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final MapController _mapController = MapController();
  LatLng _selectedLatLng = const LatLng(
    LocationCubit.farmLatitude,
    LocationCubit.farmLongitude,
  );
  
  // Text controllers for manual address fallback
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Request location permissions and auto-center on startup
    context.read<LocationCubit>().fetchCurrentLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pincodeController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  void _updateMarker(LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
    });
  }

  void _animateToPosition(double lat, double lon) {
    _mapController.move(LatLng(lat, lon), 15.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'नक्शे पर स्थान चुनें' : 'Choose on Map'),
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationSuccess) {
              _selectedLatLng = LatLng(state.latitude, state.longitude);
              _animateToPosition(state.latitude, state.longitude);
              
              if (state.address != null) {
                _addressController.text = state.address!.addressLine;
                _pincodeController.text = state.address!.pincode;
                _villageController.text = state.address!.village;
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Top Search / Address Fallback form
                _buildAddressHeaderForm(isHindi, l10n),
                
                // Map container
                Expanded(
                  child: Stack(
                    children: [
                      _buildMapWidget(isHindi, l10n, state),
                      
                      // Floating GPS Location button
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: AppConstants.primaryGreen,
                          foregroundColor: Colors.white,
                          onPressed: () {
                            context.read<LocationCubit>().fetchCurrentLocation();
                          },
                          child: const Icon(Icons.my_location_rounded),
                        ),
                      ),
                      
                      if (state is LocationLoading)
                        Container(
                          color: Colors.black12,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Dynamic distance & confirmation details panel
                _buildDetailsFooterPanel(context, state, isHindi, l10n),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddressHeaderForm(bool isHindi, AppLocalizations l10n) {
    return Container(
      color: AppConstants.surfaceWhite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _addressController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    hintText: isHindi ? 'पता दर्ज करें' : 'Delivery Address / Road Name',
                    filled: true,
                    fillColor: AppConstants.backgroundCream,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _villageController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: isHindi ? 'गांव/कस्बा' : 'Village / Locality',
                    filled: true,
                    fillColor: AppConstants.backgroundCream,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: isHindi ? 'पिनकोड' : 'Pincode',
                    filled: true,
                    fillColor: AppConstants.backgroundCream,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapWidget(bool isHindi, AppLocalizations l10n, LocationState state) {
    if (state is LocationPermissionDenied || state is LocationPermissionPermanentlyDenied) {
      return Container(
        color: AppConstants.dividerColor.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 64,
                color: AppConstants.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                isHindi ? 'लोकेशन परमिशन अस्वीकृत है' : 'GPS Permission Denied',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primaryGreen,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isHindi
                    ? 'कृपया अपने डिवाइस की सेटिंग्स में जाकर लोकेशन परमिशन सक्षम करें या ऊपर मैन्युअल पता भरें।'
                    : 'To fetch your precise address, please enable location permission in settings, or type address details manually.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (state is LocationServicesDisabled) {
      return Container(
        color: AppConstants.dividerColor.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gps_off_rounded,
                size: 64,
                color: AppConstants.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                isHindi ? 'GPS बंद है' : 'GPS is Disabled',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primaryGreen,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isHindi
                    ? 'कृपया अपने फोन में जीपीएस ऑन करें और दोबारा प्रयास करें।'
                    : 'Please enable GPS location services in your phone setting and try again.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    // OpenStreetMap Widget using flutter_map
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _selectedLatLng,
        initialZoom: 15.0,
        onTap: (tapPosition, point) {
          _updateMarker(point);
          context
              .read<LocationCubit>()
              .updateLocationCoordinates(point.latitude, point.longitude);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.pandey',
          tileProvider: NetworkTileProvider(),
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _selectedLatLng,
              width: 50,
              height: 50,
              child: const Icon(
                Icons.location_pin,
                color: Colors.redAccent,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsFooterPanel(
    BuildContext context,
    LocationState state,
    bool isHindi,
    AppLocalizations l10n,
  ) {
    double distance = 0.0;
    bool isDeliverable = true;
    String statusMessage = '';
    Color statusColor = AppConstants.primaryGreen;

    if (state is LocationSuccess) {
      distance = state.distanceKm;
      if (distance <= 2.0) {
        statusMessage = isHindi ? 'मुफ़्त डिलीवरी (2 किमी के अंदर)' : 'Free Delivery (under 2 km)';
        statusColor = AppConstants.primaryGreen;
      } else if (distance <= 5.0) {
        statusMessage = isHindi ? 'डिलीवरी शुल्क: ₹20' : 'Delivery fee: ₹20';
        statusColor = AppConstants.accentOrange;
      } else if (distance <= 10.0) {
        statusMessage = isHindi ? 'डिलीवरी शुल्क: ₹40' : 'Delivery fee: ₹40';
        statusColor = AppConstants.accentOrange;
      } else {
        isDeliverable = false;
        statusMessage = isHindi
            ? 'क्षमा करें, हम 10 किमी से अधिक दूरी पर डिलीवरी नहीं करते हैं'
            : 'Out of Delivery Zone (> 10 km)';
        statusColor = Colors.redAccent;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
        border: Border(
          top: BorderSide(color: AppConstants.dividerColor, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Distance Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'डेयरी फार्म से दूरी:' : 'Distance from Farm:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${distance.toStringAsFixed(2)} km',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Shipping Warning
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isDeliverable ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
                  color: statusColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusMessage.isNotEmpty ? statusMessage : (isHindi ? 'लोकेशन लोड हो रही है...' : 'Resolving address...'),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final String rawAddr = _addressController.text.trim();
                final String rawVillage = _villageController.text.trim();
                final String rawPin = _pincodeController.text.trim();

                if (rawAddr.isEmpty || rawVillage.isEmpty || rawPin.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isHindi
                            ? 'कृपया पूरा पता, गांव और ६-अंकों का पिनकोड भरें!'
                            : 'Please enter full address, village, and a valid 6-digit pincode!',
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                final double finalLat = (state is LocationSuccess) ? state.latitude : LocationCubit.farmLatitude;
                final double finalLon = (state is LocationSuccess) ? state.longitude : LocationCubit.farmLongitude;
                final double finalDist = (state is LocationSuccess) ? state.distanceKm : 0.0;

                final manualAddr = UserAddress(
                  latitude: finalLat,
                  longitude: finalLon,
                  addressLine: rawAddr,
                  village: rawVillage,
                  pincode: rawPin,
                );

                context.read<LocationCubit>().setManualAddress(manualAddr);
                context.read<CartCubit>().updateDeliveryDistance(finalDist);
                Navigator.pop(context);
              },
              child: Text(isHindi ? 'लोकेशन की पुष्टि करें' : 'Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
