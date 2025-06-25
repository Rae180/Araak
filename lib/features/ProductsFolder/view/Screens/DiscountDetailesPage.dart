import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/ProductsFolder/Bloc/DiscountsBloc/discounts_bloc.dart';

class DiscountDetailsPage extends StatefulWidget {
  static const String routeName = '/discount_details';
  final int? discountId;
  const DiscountDetailsPage({Key? key, this.discountId}) : super(key: key);

  @override
  State<DiscountDetailsPage> createState() => _DiscountDetailsPageState();
}

class _DiscountDetailsPageState extends State<DiscountDetailsPage> {
  String getValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains("localhost")) {
      return url.replaceAll("localhost", ApiConstants.STORAGE_URL);
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DiscountsBloc(client: NetworkApiServiceHttp())
            ..add(GetDiscountsDeailesEvent(discountId: widget.discountId)),
        ),
        BlocProvider(
          create: (context) => CartBloc(client: NetworkApiServiceHttp()),
        ),
        BlocProvider(
          create: (context) => FavBloc(client: NetworkApiServiceHttp()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<DiscountsBloc, DiscountsState>(
          builder: (context, state) {
            if (state is DiscountsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DiscountsDetailesSuccess) {
              final discount = state.discount;
              final includedItems = discount.roomItems ?? [];
              return Stack(
                children: [
                  // Top Image Section.
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          getValidImageUrl(discount.roomImage),
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Draggable Details Sheet.
                  DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
                    maxChildSize: 1.0,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Section: Room name and bookmark button.
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      discount.roomName ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Discount Information: Percentage, Start Date, End Date.
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${discount.discountPercentage}% OFF",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Start: ${discount.startDate}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'Times New Roman',
                                        ),
                                      ),
                                      Text(
                                        "End: ${discount.endDate}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'Times New Roman',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Price Section.
                              Row(
                                children: [
                                  Text(
                                    "\$${discount.discountedPrice!}",
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "\$${discount.originalPrice!}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.shade600,
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Horizontal List of Included Items.
                              const Text(
                                'Included Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman',
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: includedItems.length,
                                  itemBuilder: (context, index) {
                                    final item = includedItems[index];
                                    return Container(
                                      width: 140,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(12)),
                                            child: Image.network(
                                              getValidImageUrl(item.imageUrl),
                                              height: 80,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'Times New Roman',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "\$${item.price!}",
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'Times New Roman',
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Price and Add-to-Cart Section.
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${discount.discountedPrice!}",
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                        AddRoomToCart(
                                            roomId: discount.roomId!, count: 1),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Back button.
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.84),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is DiscountsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
