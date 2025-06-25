import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
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

class _CartScreenState extends State<CartScreen> {
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

  _showNearestBranchDialog(
    BuildContext context,
    String branchAddress,
    double distance, // in kilometers
    double branchLat,
    double branchLng,
  ) {
    print('hi');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print('Dialog ....');
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 16,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon and Title.
                  const Icon(
                    Icons.location_on,
                    size: 48,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.nearbranch,
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Map preview window styled like the MapPickerScreen.
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(branchLat, branchLng),
                          initialZoom: 15,
                          // Here we allow interactions; if not desired, use InteractiveFlag.none
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Read-only field showing branch address and distance.
                  TextFormField(
                    initialValue:
                        "$branchAddress (${distance.toStringAsFixed(1)} km away)",
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.branchaddr,
                      labelStyle: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stripe Payment Button.
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Integrate your Stripe Payment functionality here.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "Pay with Stripe",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Cancel and Confirm buttons.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Add your confirm logic here.
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.confirmation,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeliveryDetailsDialog(BuildContext context) {
    // Local state for the dialog.
    LatLng? selectedLocation; // This holds the picked location.
    double? latitude; // To store the latitude of the selected location.
    double? longitude; // To store the longitude of the selected location.

    // Controllers for the address inputs.
    final TextEditingController addressController = TextEditingController();
    final TextEditingController mapController = TextEditingController();

    // Variable to hold the final price received from the backend.
    num? finalPrice;
    bool priceFetched = false; // To control whether to show price.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // If your dialog is part of a BlocListener, you could wrap it here
        // For instance, listening to PlacingOrderBloc for a DeliveryPriceSuccess state.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BlocProvider(
              create: (context) =>
                  PlacingOrderBloc(client: NetworkApiServiceHttp()),
              child: BlocListener<PlacingOrderBloc, PlacingOrderState>(
                listener: (context, state) {
                  if (state is DeliveryPriceSuccessState) {
                    setState(() {
                      finalPrice = state.deliveryPrice;
                      priceFetched = true;
                    });
                  } else if (state is PlacingOrderError) {
                    // Example: Show error via snack bar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 16,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header Icon and Title.
                              const Icon(
                                Icons.local_shipping,
                                color: Colors.deepOrange,
                                size: 48,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.deliveryinfo,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.deliverydet,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Delivery Location Field (read-only)
                              GestureDetector(
                                onTap: () async {
                                  // Navigate to your map picker screen.
                                  // Replace MapPickerScreen() with your actual map picker implementation.
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapPickerScreen(),
                                    ),
                                  );
                                  if (result != null && result is LatLng) {
                                    // Extract the latitude and longitude.
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
                                          ? "${AppLocalizations.of(context)!.location}: (${selectedLocation!.latitude.toStringAsFixed(4)}, ${selectedLocation!.longitude.toStringAsFixed(4)})"
                                          : "${AppLocalizations.of(context)!.selectonmap}",
                                      suffixIcon: const Icon(Icons.map,
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // New manual address entry field.
                              TextFormField(
                                controller: addressController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .enteraddress,
                                  hintText: "123 Main St, City, Country",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Button to check the final price.
                              ElevatedButton(
                                onPressed: () {
                                  // Ensure that a location has been selected.
                                  if (selectedLocation == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .selectloca)),
                                    );
                                    return;
                                  }
                                  // Extract the numbers from the selected LatLng.
                                  double lat = selectedLocation!.latitude;
                                  double lng = selectedLocation!.longitude;
                                  // Dispatch the event to get the delivery price.
                                  BlocProvider.of<PlacingOrderBloc>(context)
                                      .add(
                                    GetDeliveryPriceEvent(
                                      address: addressController.text,
                                      Latitude: lat,
                                      Longitude: lng,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.finalprice,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Times New Roman',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Optionally show the price once it is fetched from the backend.
                              if (priceFetched && finalPrice != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(2, 2),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "${AppLocalizations.of(context)!.finalprice}: \$${finalPrice!.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Times New Roman',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              const SizedBox(height: 20),
                              // Cancel & Confirm Order buttons.
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.cancel,
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  BlocListener<PlacingOrderBloc,
                                      PlacingOrderState>(
                                    listener: (context, state) {
                                      if (state
                                          is PlacingAnOrderWithDeliverySuccess) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                           SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!.ordersentsuccess)),
                                        );
                                      } else if (state is PlacingOrderError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(state
                                                  .message)), // assuming state.message holds the error
                                        );
                                      }
                                    },
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                   Text(AppLocalizations.of(context)!.confirmorder),
                                              content:  Text(
                                                AppLocalizations.of(context)!.alertpay,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    // Close the dialog without doing anything
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:  Text(AppLocalizations.of(context)!.cancel),
                                                ),
                                                BlocProvider(
                                                  create: (context) =>
                                                      PlacingOrderBloc(
                                                          client:
                                                              NetworkApiServiceHttp()),
                                                  child: Builder(
                                                      builder: (context) {
                                                    return TextButton(
                                                      onPressed: () {
                                                        // User agreed; first dismiss the dialog
                                                        Navigator.of(context)
                                                            .pop();
                                                        // Now trigger the event to confirm the cart / order.
                                                        BlocProvider.of<
                                                                    PlacingOrderBloc>(
                                                                context)
                                                            .add(PlacingAnOrderWithDeliveryEvent(
                                                                address:
                                                                    addressController
                                                                        .text,
                                                                latitude:
                                                                    latitude,
                                                                longitude:
                                                                    longitude));
                                                      },
                                                      child:
                                                           Text(AppLocalizations.of(context)!.yes),
                                                    );
                                                  }),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child:  Text(
                                        AppLocalizations.of(context)!.confirmation,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Times New Roman',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      // Dispose controllers when the dialog closes.
      addressController.dispose();
      mapController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(client: NetworkApiServiceHttp())
            ..add(GetCartItemsEvent()),
        ),
        // BlocProvider(
        //   create: (context) =>
        //       PlacingOrderBloc(client: NetworkApiServiceHttp()),
        // ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
            icon: Icon(
              Icons.delivery_dining_outlined,
              color: Colors.black,
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
                  color: Colors.black,
                  size: 30,
                )),
          ],
          elevation: 0,
          scrolledUnderElevation: 0,
          title:  Text(
            AppLocalizations.of(context)!.mycart,
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
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
                      child: ListView.separated(
                        itemCount: combinedList.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 20, color: Colors.grey),
                        itemBuilder: (context, index) {
                          final item = combinedList[index];
                          final key =
                              Key('//${item.runtimeType}_${item.id ?? index}');
                          return Dismissible(
                              key: key,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                      roomId: item is Rooms ? item.id : null,
                                      itemId: item is Items ? item.id : null,
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
                                    title:  Text(AppLocalizations.of(context)!.delete),
                                    content:  Text(
                                      AppLocalizations.of(context)!.removeitem,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child:  Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child:  Text(AppLocalizations.of(context)!.delete),
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
                                        BlocProvider.of<CartBloc>(context).add(
                                            AddItemToCart(
                                                itemId: item.id!, count: 1));
                                      },
                                      onDecrease: () {
                                        BlocProvider.of<CartBloc>(context).add(
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
                                            BlocProvider.of<CartBloc>(context)
                                                .add(AddRoomToCart(
                                                    roomId: item.id!,
                                                    count: 1));
                                          },
                                          onDecrease: () {
                                            BlocProvider.of<CartBloc>(context)
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
                    const SizedBox(height: 16),
                    // Total Summary container with Total Price and Total Time.
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Column displaying Total Price and Total Time.
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.total}: \$${state.item.totalPrice!.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${AppLocalizations.of(context)!.totaltime}: ${state.item.totalTime ?? '45 min'}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                            ],
                          ),
                          // Checkout button
                          ElevatedButton(
                            onPressed: () {
                              // First dialog: Confirm Order dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 16,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.grey.shade100,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.help_outline,
                                            color: Colors.deepOrange,
                                            size: 48,
                                          ),
                                          const SizedBox(height: 10),
                                           Text(
                                            AppLocalizations.of(context)!.confirmorder,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Times New Roman',
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                           Text(
                                            AppLocalizations.of(context)!.placeorder,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Times New Roman',
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${AppLocalizations.of(context)!.total}: \$${state.item.totalPrice!.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "${AppLocalizations.of(context)!.totaltime}: ${state.item.totalTime} minutes",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Dismiss first dialog
                                                },
                                                child:  Text(
                                                  AppLocalizations.of(context)!.cancel,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Times New Roman',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // First, dismiss the current confirmation dialog.
                                                  Navigator.of(context).pop();

                                                  // Then, show the second dialog with order placement options.
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return BlocProvider(
                                                        create: (context) =>
                                                            PlacingOrderBloc(
                                                                client:
                                                                    NetworkApiServiceHttp()),
                                                        child: Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          elevation: 16,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Colors.white,
                                                                  Colors.grey
                                                                      .shade100,
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .delivery_dining,
                                                                  color: Colors
                                                                      .deepOrange,
                                                                  size: 48,
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                 Text(
                                                                  AppLocalizations.of(context)!.placeorder,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Times New Roman',
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                 Text(
                                                                AppLocalizations.of(context)!.howorder,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Times New Roman',
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                // Options for the order placement.
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    _showDeliveryDetailsDialog(
                                                                        context);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .black,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            14),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12)),
                                                                  ),
                                                                  child:
                                                                       Text(
                                                                  AppLocalizations.of(context)!.companydelivery,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Times New Roman',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                BlocListener<
                                                                    PlacingOrderBloc,
                                                                    PlacingOrderState>(
                                                                  listener:
                                                                      (context,
                                                                          state) {
                                                                    print(
                                                                        'the state is : $state');
                                                                    if (state
                                                                        is LocationSendSuccess) {
                                                                      print(
                                                                          'wait what ?');
                                                                      WidgetsBinding
                                                                          .instance
                                                                          .addPostFrameCallback(
                                                                              (_) {
                                                                        _showNearestBranchDialog(
                                                                            context,
                                                                            state.nearBranch.branch!.address!,
                                                                            state.nearBranch.branch!.distanceKm!,
                                                                            double.parse(state.nearBranch.branch!.latitude!),
                                                                            double.parse(state.nearBranch.branch!.longitude!));
                                                                      });
                                                                    } else if (state
                                                                        is PlacingOrderError) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text(state.message)));
                                                                    }
                                                                  },
                                                                  child: Builder(
                                                                      builder:
                                                                          (context) {
                                                                    return ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          print(
                                                                              'trying....');
                                                                          Map<String, double>
                                                                              coordinates =
                                                                              await getUserCoordinates();
                                                                          print(
                                                                              'after getting cordinates ....');
                                                                          double
                                                                              lat =
                                                                              coordinates['latitude']!;
                                                                          double
                                                                              lng =
                                                                              coordinates['longitude']!;

                                                                          BlocProvider.of<PlacingOrderBloc>(context).add(GetNearestBranchEvent(
                                                                              longitue: lng,
                                                                              latitude: lat));
                                                                          // Navigator.of(context)
                                                                          //     .pop();
                                                                        } catch (e) {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(content: Text("Error retrieving location: $e")));
                                                                        }
                                                                        // Add functionality for "I will collect my order"
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.black,
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                12,
                                                                            vertical:
                                                                                14),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12)),
                                                                      ),
                                                                      child:
                                                                           Text(
                                                                        AppLocalizations.of(context)!.colllectorder,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Times New Roman',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                       Text(
                                                                    AppLocalizations.of(context)!.cancel,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Times New Roman',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child:  Text(
                                                  AppLocalizations.of(context)!.confirmation,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:  Text(
                              AppLocalizations.of(context)!.checkout,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Times New Roman',
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                );
              } else if (state is CartError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
