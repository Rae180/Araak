import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Customizations/view/Screens/CustomizationsPage.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/ProductsFolder/Bloc/RoomDetailesBloc/room_details_bloc.dart';
import 'package:start/features/ProductsFolder/Models/RoomDetails.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/products_details';
  final int? roomId;
  const ProductDetailsPage({this.roomId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String getValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', ApiConstants.STORAGE_URL);
    }
    return url;
  }

  Widget _buildRatingStars(num rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (rating >= i + 1) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
      } else if (rating > i && rating < i + 1) {
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
      }
    }
    return Row(children: stars);
  }

  Color getColorFromName(String colorName) {
    // Define a mapping from color name (in lowercase) to a Color.
    const colorMap = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'black': Colors.black,
      'white': Colors.white,
      'beige': Colors.blueAccent,

      // Add more mappings as needed.
    };

    // Convert the incoming name to lowercase and return the matching Color.
    // If the name isn't found, use a default color (here, grey).
    return colorMap[colorName.trim().toLowerCase()] ?? Colors.grey;
  }

// Example: Extract all the colors from every fabric.
  List<String> getAllFabricColors(List<Fabrics> fabrics) {
    return fabrics.expand((fabric) => fabric.colors ?? []).map((color) {
      if (color is Map && color.containsKey('name')) {
        return color['name'].toString();
      }
      return color.toString();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RoomDetailsBloc(client: NetworkApiServiceHttp())
            ..add(GetRoomDetailes(roomId: widget.roomId)),
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
        body: BlocBuilder<RoomDetailsBloc, RoomDetailsState>(
          builder: (context, state) {
            if (state is RoomDetailesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is RoomDetailsSuccess) {
              final items = state.room.room!.items ?? [];
              final feedbacks = state.room.ratings ?? [];
              final fabrics = state.room.fabrics ?? [];
              final List<String> allFabricColors = getAllFabricColors(fabrics);
              return Stack(
                children: [
                  // صورة

                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            getValidImageUrl(state.room.room?.imageUrl)),
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
                  DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
                    maxChildSize: 1.0,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
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
                              // Top Section: Title, rating and assignment button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.room.room!.name!,
                                      style: const TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  LikeButton(
                                    size: 28,
                                    isLiked:
                                        state.room.room!.isFavorite ?? false,
                                    onTap: (bool isLiked) async {
                                      // Dispatch your event to update the favorite state.
                                      BlocProvider.of<FavBloc>(context).add(
                                          AddToFavEvent(
                                              state.room.room!.id, null));
                                      // Return the new state for the LikeButton animation.
                                      return !isLiked;
                                    },
                                    likeBuilder: (bool isLiked) {
                                      // Build the icon based on the liked state.
                                      return Icon(
                                        isLiked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border_outlined,
                                        color: Colors.black,
                                        size: 28,
                                      );
                                    },
                                    circleColor: const CircleColor(
                                      start: Colors.black26,
                                      end: Colors.black12,
                                    ),
                                    bubblesColor: const BubblesColor(
                                      dotPrimaryColor: Colors.black38,
                                      dotSecondaryColor: Colors.black45,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildRatingStars(
                                      state.room.room!.averageRating!),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.room.room!.averageRating!
                                        .toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontFamily: 'Times New Roman',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CustomizationsPage()),
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Assignment',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Colors section.
                              const Text(
                                'Colors',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman',
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(allFabricColors.length,
                                    (index) {
                                  final colorName = allFabricColors[index];
                                  final swatchColor =
                                      getColorFromName(colorName)
                                          .withOpacity(0.8);
                                  return Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: swatchColor,
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 24),
                              // Description section.
                              const Text('Description',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18,
                                    color: Colors.black87,
                                  )),
                              const SizedBox(height: 8),
                              Text(
                                state.room.room!.description!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Times New Roman',
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Horizontal list of included items.
                              if (items != null && items.isNotEmpty) ...[
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
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return Container(
                                        width: 140,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                getValidImageUrl(
                                                    state.room.room!.imageUrl!),
                                                height: 80,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (items[index] as Map<String,
                                                        dynamic>)['name'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'Times New Roman',
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '\$${(items[index] as Map<String, dynamic>)['price']}',
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
                              ],

                              const SizedBox(height: 24),
                              // Feedback (Comments) Section.
                              if (feedbacks.isNotEmpty) ...[
                                const Text(
                                  'Feedback',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: feedbacks.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final feedback = feedbacks[index];
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              getValidImageUrl(
                                                  feedback.customerImage)),
                                          radius: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feedback.customerName!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Times New Roman',
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: List.generate(5,
                                                    (starIndex) {
                                                  return Icon(
                                                    // Fill the star if the current index is less than the rate.
                                                    starIndex <
                                                            (feedback.rate ?? 0)
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: Colors.amber,
                                                    size: 16,
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                feedback.feedback ?? '',
                                                style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 14,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                              ],
                              // Price and Add-to-cart section.
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${state.room.room!.price}',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                        AddRoomToCart(
                                            roomId: state.room.room!.id!,
                                            count: 1),
                                      );
                                    },
                                    icon: const Icon(Icons.shopping_cart,
                                        color: Colors.white),
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
                              // Extra spacing in case the content is short.
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.84),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_outlined,
                            color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is RoomDetailesError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
