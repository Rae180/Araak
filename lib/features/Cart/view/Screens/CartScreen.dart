import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Cart/Bloc/placingOrderBloc/placing_order_bloc.dart';
import 'package:start/features/Cart/Models/CartItem.dart';
import 'package:start/features/Cart/view/Screens/MapPickerScreen.dart';
import 'package:start/features/Cart/view/widgets/CartItemWidget.dart';
import 'package:start/features/Cart/view/widgets/CartRoomWidget.dart';
import 'package:start/features/Orders/view/screens/Orders_Screen.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ProductDetails.dart';
import 'package:start/features/Wallet/view/Screens/Wallet_Screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _emptyCartController;
  late Animation<double> _emptyCartAnimation;
  bool _isCheckoutLoading = false;
  bool _isLocationLoading = false;
  bool _isPaymentProcessing = false;

  @override
  void initState() {
    super.initState();
    _emptyCartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _emptyCartAnimation = CurvedAnimation(
      parent: _emptyCartController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _emptyCartController.dispose();
    super.dispose();
  }

  Future<Map<String, double>> getUserCoordinates() async {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(AppLocalizations.of(context)!.locationdis);
    }

    // Check for location permissions.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(AppLocalizations.of(context)!.locationdis);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(AppLocalizations.of(context)!.locationden);
    }

    // Get the current position of the user.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Return the latitude and longitude as a Map.
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }

  void _showNearestBranchDialog(
    BuildContext context,
    String branchAddress,
    double distance,
    double branchLat,
    double branchLng,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
        backgroundColor: colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.sectionPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Icon(
                Icons.location_on,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.nearbranch,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Map preview
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(branchLat, branchLng),
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(branchLat, branchLng),
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_pin,
                              color: colorScheme.error,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Address and distance
              ListTile(
                leading: Icon(Icons.place, color: colorScheme.primary),
                title: Text(
                  branchAddress,
                  style: theme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "${distance.toStringAsFixed(1)} ${'l10n.kmaway'}",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),

              // Payment button with loading state
              StatefulBuilder(
                builder: (context, setState) {
                  return ElevatedButton(
                    onPressed: _isPaymentProcessing
                        ? null
                        : () async {
                            setState(() => _isPaymentProcessing = true);
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() => _isPaymentProcessing = false);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('l10n.paymentsuccess'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isPaymentProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('l10n.paywithstripe'),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.surfaceVariant,
                    ),
                    child: Text(l10n.confirmation),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeliveryDetailsDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Local state for the dialog
    LatLng? selectedLocation;
    double? latitude;
    double? longitude;
    final TextEditingController addressController = TextEditingController();
    final TextEditingController mapController = TextEditingController();
    num? finalPrice;
    bool priceFetched = false;
    bool isCalculatingPrice = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocProvider(
              create: (context) =>
                  PlacingOrderBloc(client: NetworkApiServiceHttp()),
              child: BlocListener<PlacingOrderBloc, PlacingOrderState>(
                listener: (context, state) {
                  if (state is DeliveryPriceSuccessState) {
                    setState(() {
                      finalPrice = state.deliveryPrice;
                      priceFetched = true;
                      isCalculatingPrice = false;
                    });
                  } else if (state is PlacingOrderError) {
                    setState(() => isCalculatingPrice = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: Dialog(
                  backgroundColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.cardRadius),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.all(AppConstants.sectionPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Icon(
                                Icons.local_shipping,
                                size: 32,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.deliveryinfo,
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.deliverydet,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),

                          // Map selection field
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapPickerScreen(),
                                ),
                              );
                              if (result != null && result is LatLng) {
                                setState(() {
                                  selectedLocation = result;
                                  latitude = result.latitude;
                                  longitude = result.longitude;
                                  mapController.text = result.toString();
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                controller: mapController,
                                decoration: InputDecoration(
                                  labelText: selectedLocation != null
                                      ? 'l10n.locationselected'
                                      : l10n.selectonmap,
                                  suffixIcon: const Icon(Icons.map),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.cardRadius),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Address input
                          TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: l10n.enteraddress,
                              hintText: 'l10n.addresshint',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.cardRadius),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Calculate price button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isCalculatingPrice
                                  ? null
                                  : () {
                                      if (selectedLocation == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(l10n.selectloca)),
                                        );
                                        return;
                                      }
                                      setState(() => isCalculatingPrice = true);
                                      BlocProvider.of<PlacingOrderBloc>(context)
                                          .add(
                                        GetDeliveryPriceEvent(
                                          address: addressController.text,
                                          Latitude: latitude!,
                                          Longitude: longitude!,
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: isCalculatingPrice
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    )
                                  : Text(l10n.finalprice),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Price display
                          if (priceFetched && finalPrice != null)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.cardRadius),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${'l10n.deliveryprice'}: ",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Text(
                                    "\$${finalPrice!.toStringAsFixed(2)}",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),

                          // Map preview
                          if (selectedLocation != null)
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.cardRadius),
                                border: Border.all(color: colorScheme.outline),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.cardRadius),
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: selectedLocation!,
                                    initialZoom: 15,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: selectedLocation!,
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Icons.location_pin,
                                            color: colorScheme.error,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),

                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.cancel),
                              ),
                              const SizedBox(width: 12),
                              BlocListener<PlacingOrderBloc, PlacingOrderState>(
                                listener: (context, state) {
                                  if (state
                                      is PlacingAnOrderWithDeliverySuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(l10n.ordersentsuccess)),
                                    );
                                    Navigator.pop(context);
                                  } else if (state is PlacingOrderError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!priceFetched || finalPrice == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('l10n.calculatefirst')),
                                      );
                                      return;
                                    }

                                    // Confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(l10n.confirmorder),
                                        content: Text(l10n.alertpay),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(l10n.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              BlocProvider.of<PlacingOrderBloc>(
                                                      context)
                                                  .add(
                                                      PlacingAnOrderWithDeliveryEvent(
                                                          address:
                                                              addressController
                                                                  .text,
                                                          latitude: latitude,
                                                          longitude:
                                                              longitude));
                                            },
                                            child: Text(l10n.yes),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                  ),
                                  child: Text(l10n.confirmation),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      addressController.dispose();
      mapController.dispose();
    });
  }

  Future<void> _refreshCart(BuildContext context) async {
    BlocProvider.of<CartBloc>(context).add(GetCartItemsEvent());
    await Future.delayed(
        const Duration(milliseconds: 800)); // Simulate network delay
  }

  void _handleCheckout() async {
    setState(() => _isCheckoutLoading = true);
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate processing
    setState(() => _isCheckoutLoading = false);

    // ... existing checkout logic ...
  }

  void _showOrderMethodDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => PlacingOrderBloc(client: NetworkApiServiceHttp()),
        child: Dialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.sectionPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.placeorder,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.howorder,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Delivery options
                Column(
                  children: [
                    // Company delivery button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeliveryDetailsDialog(context);
                        },
                        icon: Icon(Icons.local_shipping,
                            color: colorScheme.primary),
                        label: Text(l10n.companydelivery),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Self-collect button
                    BlocListener<PlacingOrderBloc, PlacingOrderState>(
                      listener: (context, state) {
                        if (state is LocationSendSuccess) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _showNearestBranchDialog(
                              context,
                              state.nearBranch.branch!.address!,
                              state.nearBranch.branch!.distanceKm!,
                              double.parse(state.nearBranch.branch!.latitude!),
                              double.parse(state.nearBranch.branch!.longitude!),
                            );
                          });
                        } else if (state is PlacingOrderError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)));
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            try {
                              Map<String, double> coordinates =
                                  await getUserCoordinates();
                              double lat = coordinates['latitude']!;
                              double lng = coordinates['longitude']!;

                              BlocProvider.of<PlacingOrderBloc>(context).add(
                                  GetNearestBranchEvent(
                                      longitue: lng, latitude: lat));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("$e")));
                            }
                          },
                          icon: Icon(Icons.person_pin_circle,
                              color: colorScheme.primary),
                          label: Text(l10n.colllectorder),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: colorScheme.outline),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCheckoutConfirmationDialog(
      BuildContext context, GetCartItemsSuccess state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.sectionPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart_checkout,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.confirmorder,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.placeorder,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Order summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('l10n.subtotal',
                            style: theme.textTheme.bodyMedium),
                        Text(
                          "\$${state.item.totalPrice!.toStringAsFixed(2)}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.totaltime, style: theme.textTheme.bodyMedium),
                        Text(
                          "${state.item.totalTime ?? '45'} ${'l10n.minutes'}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showOrderMethodDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: Text(l10n.confirmation),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(client: NetworkApiServiceHttp())
            ..add(GetCartItemsEvent()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
            icon: Icon(
              Icons.delivery_dining_outlined,
              color: colorScheme.onSurface,
              size: 30,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(WalletScreen.routeName);
                },
                icon: Icon(
                  Icons.wallet_outlined,
                  color: colorScheme.onSurface,
                  size: 30,
                )),
          ],
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            l10n.mycart,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Times new Roman',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ));
              } else if (state is GetCartItemsSuccess) {
                final cartRooms = state.item.rooms ?? [];
                final cartItems = state.item.items ?? [];
                final combinedList = <dynamic>[];
                combinedList.addAll(cartRooms);
                combinedList.addAll(cartItems);

                return Column(
                  children: [
                    // Expanded list of cart items.
                    Expanded(
                      child: combinedList.isEmpty
                          ? _buildEmptyCart(context, l10n, colorScheme)
                          : ListView.separated(
                              itemCount: combinedList.length,
                              separatorBuilder: (context, index) => Divider(
                                  height: AppConstants.elementSpacing,
                                  color: colorScheme.outline.withOpacity(0.2)),
                              itemBuilder: (context, index) {
                                final item = combinedList[index];
                                final key = Key(
                                    '//${item.runtimeType}_${item.id ?? index}');
                                return Dismissible(
                                    key: key,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      color: Colors.redAccent,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      BlocProvider.of<CartBloc>(context).add(
                                        RemoveFromCartEvent(
                                            roomId:
                                                item is Rooms ? item.id : null,
                                            itemId:
                                                item is Items ? item.id : null,
                                            custId: null,
                                            roomCustId: null,
                                            count: item is Rooms
                                                ? item.count
                                                : item is Items
                                                    ? item.count
                                                    : null),
                                      );
                                    },
                                    confirmDismiss: (direction) async {
                                      final result = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .delete),
                                          content: Text(
                                            AppLocalizations.of(context)!
                                                .removeitem,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .cancel),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .delete),
                                            ),
                                          ],
                                        ),
                                      );
                                      return result;
                                    },
                                    child: item is Items
                                        ? CartItemWidget(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItemDetailesPage(
                                                            itemId: item.id,
                                                          )));
                                            },
                                            imageUrl: item.imageUrl!,
                                            name: item.name!,
                                            price: 10.2,
                                            count: item.count!,
                                            onIncrease: () {
                                              BlocProvider.of<CartBloc>(context)
                                                  .add(AddItemToCart(
                                                      itemId: item.id!,
                                                      count: 1));
                                            },
                                            onDecrease: () {
                                              BlocProvider.of<CartBloc>(context)
                                                  .add(
                                                RemoveFromCartEvent(
                                                    roomId: null,
                                                    itemId: item.id,
                                                    custId: null,
                                                    roomCustId: null,
                                                    count: 1),
                                              );
                                            })
                                        : item is Rooms
                                            ? CartRoomWidget(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailsPage(
                                                                roomId: item.id,
                                                              )));
                                                },
                                                imageUrl: item.imageUrl!,
                                                name: item.name!,
                                                price: 10,
                                                count: item.count!,
                                                onIncrease: () {
                                                  BlocProvider.of<CartBloc>(
                                                          context)
                                                      .add(AddRoomToCart(
                                                          roomId: item.id!,
                                                          count: 1));
                                                },
                                                onDecrease: () {
                                                  BlocProvider.of<CartBloc>(
                                                          context)
                                                      .add(RemoveFromCartEvent(
                                                          roomId: item.id,
                                                          itemId: null,
                                                          custId: null,
                                                          roomCustId: null,
                                                          count: 1));
                                                })
                                            : const SizedBox());
                              },
                            ),
                    ),
                    if (combinedList.isNotEmpty) ...[
                      const SizedBox(
                        height: AppConstants.elementSpacing,
                      ),
                      _buildCartSummary(context, state, l10n, colorScheme),
                      const SizedBox(
                        height: 70,
                      )
                    ],
                  ],
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(
                    state.message,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(
      BuildContext context, AppLocalizations l10n, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'l10n.cartempty',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'l10n.additemstocart',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              ),
            ),
            child: Text(
              'l10n.continueshopping',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, GetCartItemsSuccess state,
      AppLocalizations l10n, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.elementSpacing),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'l10n.subtotal',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${state.item.totalPrice!.toStringAsFixed(2)}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.totaltime,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${state.item.totalTime ?? '45'} ${'l10n.minutes'}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppConstants.elementSpacing),

          // Checkout button
          ElevatedButton(
            onPressed: () {
              _showCheckoutConfirmationDialog(context, state);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              l10n.checkout,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
