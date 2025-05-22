import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Cart/Models/CartItem.dart';
import 'package:start/features/Cart/view/Screens/MapPickerScreen.dart';
import 'package:start/features/Cart/view/widgets/CartItemWidget.dart';
import 'package:start/features/Cart/view/widgets/CartRoomWidget.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ProductDetails.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart_screen';
  const CartScreen({super.key});

  void _showDeliveryDetailsDialog(BuildContext context) {
    // Local state for the dialog.
    String?
        selectedLocation; // Holds the selected location string (address or coordinates).
    List<Map<String, String>> freeTimes =
        []; // Each free time slot stored as: { 'date': 'yyyy-MM-dd', 'start': 'HH:MM', 'end': 'HH:MM' }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
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
                    colors: [
                      Colors.white,
                      Colors.grey.shade100,
                    ],
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
                      const Text(
                        "Delivery Information",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter your delivery details to proceed with the order.",
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
                                builder: (context) => MapPickerScreen()),
                          );
                          if (result != null) {
                            setState(() {
                              selectedLocation = result as String;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Delivery Location",
                              hintText:
                                  selectedLocation ?? "Select location on map",
                              suffixIcon:
                                  const Icon(Icons.map, color: Colors.grey),
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
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Available Times Section with an IconButton to add slot.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Available Times",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Times New Roman',
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.add, color: Colors.deepOrange),
                            tooltip: "Add Available Time",
                            onPressed: () async {
                              // Pick a date.
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                // Pick the start time.
                                final TimeOfDay? startTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (startTime != null) {
                                  // Pick the end time.
                                  final TimeOfDay? endTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: startTime,
                                  );
                                  if (endTime != null) {
                                    setState(() {
                                      freeTimes.add({
                                        'date': date
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                        'start': startTime.format(context),
                                        'end': endTime.format(context),
                                      });
                                    });
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Display every free time slot the user has chosen.
                      if (freeTimes.isNotEmpty)
                        Column(
                          children: freeTimes.map((freeTime) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                freeTime['date'] ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                "From ${freeTime['start']} to ${freeTime['end']}",
                                style: const TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),
                      // Stripe Payment Button remains similar.
                      ElevatedButton(
                        onPressed: () {
                          // Implement your Stripe integration here.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Pay 50% via Stripe",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Times New Roman',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Cancel & Confirm Order buttons.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Proceed with placing the order using the collected info.
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CartBloc(client: NetworkApiServiceHttp())..add(GetCartItemsEvent()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'MY CART',
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
                              Key('${item.runtimeType}_${item.id ?? index}');
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
                                    title: const Text('Delete confirmation'),
                                    content: const Text(
                                      'Are you sure you want to remove this item ?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Delete'),
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
                                "Total: \$${state.item.totalPrice!.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Total Time: ${state.item.totalTime ?? '45 min'}",
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
                                          const Text(
                                            "Confirm Order",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Times New Roman',
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Are you sure you want to place this order?",
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
                                                  "Total Price: \$${state.item.totalPrice!.toStringAsFixed(2)}",
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
                                                  "Total Time: ${state.item.totalTime} minutes",
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
                                                child: const Text(
                                                  "Cancel",
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
                                                      return Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        elevation: 16,
                                                        backgroundColor:
                                                            Colors.transparent,
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
                                                              const Text(
                                                                "Place Your Order",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Times New Roman',
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              const Text(
                                                                "How do you want to place your order?",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Times New Roman',
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              // Options for the order placement.
                                                              ElevatedButton(
                                                                onPressed: () {
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
                                                                          BorderRadius.circular(
                                                                              12)),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  "Company will deliver the order",
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
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  // Add functionality for "I will collect my order"
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
                                                                          BorderRadius.circular(
                                                                              12)),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  "I will collect my order",
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
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Cancel",
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
                                                child: const Text(
                                                  "Confirm",
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
                            child: const Text(
                              "CHECK OUT",
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
