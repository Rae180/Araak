import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Customizations/view/Screens/CustomizationsPage.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/ProductsFolder/Bloc/ItemDetaliesBloc/item_detailes_bloc.dart';
import 'package:start/features/ProductsFolder/Bloc/RoomDetailesBloc/room_details_bloc.dart';

class ItemDetailesPage extends StatefulWidget {
  static const String routeName = '/item_detailes_page';
  final int? itemId;
  const ItemDetailesPage({super.key, this.itemId});

  @override
  State<ItemDetailesPage> createState() => _ItemDetailesPageState();
}

class _ItemDetailesPageState extends State<ItemDetailesPage> {
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemDetailesBloc(client: NetworkApiServiceHttp())
            ..add(GetItemDetailesEvent(itemId: widget.itemId)),
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
        body: BlocBuilder<ItemDetailesBloc, ItemDetailesState>(
          builder: (context, state) {
            if (state is RoomDetailesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ItemDetailesSuccess) {
              final items = state.item.item ?? [];
              final feedbacks = state.item.item!.feedbacks ?? [];
              return Stack(
                children: [
                  // صورة

                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            getValidImageUrl(state.item.item!.image)),
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
                                      state.item.item!.name!,
                                      style: const TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  // LikeButton(
                                  //   size: 28,
                                  //   isLiked:
                                  //       state.item.item.isFavorite ?? false,
                                  //   onTap: (bool isLiked) async {
                                  //     // Dispatch your event to update the favorite state.
                                  //     BlocProvider.of<FavBloc>(context).add(
                                  //         AddToFavEvent(
                                  //             state.item.item!.id, null));
                                  //     // Return the new state for the LikeButton animation.
                                  //     return !isLiked;
                                  //   },
                                  //   likeBuilder: (bool isLiked) {
                                  //     // Build the icon based on the liked state.
                                  //     return Icon(
                                  //       isLiked
                                  //           ? Icons.bookmark
                                  //           : Icons.bookmark_border_outlined,
                                  //       color: Colors.black,
                                  //       size: 28,
                                  //     );
                                  //   },
                                  //   circleColor: const CircleColor(
                                  //     start: Colors.black26,
                                  //     end: Colors.black12,
                                  //   ),
                                  //   bubblesColor: const BubblesColor(
                                  //     dotPrimaryColor: Colors.black38,
                                  //     dotSecondaryColor: Colors.black45,
                                  //   ),
                                  // )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildRatingStars(
                                      state.item.item!.averageRate!),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.item.item!.averageRate!.toStringAsFixed(1),
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
                              Row(
                                children: List.generate(
                                  6,
                                  (index) => Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.primaries[
                                              index % Colors.primaries.length]
                                          .withOpacity(0.8),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                    ),
                                  ),
                                ),
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
                                'state.item.item.descreption!',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: 'Times New Roman',
                                  fontSize: 17,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // // Horizontal list of included items.
                              // const Text(
                              //   'Included Materials',
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontFamily: 'Times New Roman',
                              //     fontSize: 18,
                              //     color: Colors.black87,
                              //   ),
                              // ),
                              // const SizedBox(height: 12),
                              // SizedBox(
                              //   height: 170,
                              //   child: ListView.builder(
                              //     scrollDirection: Axis.horizontal,
                              //     itemCount: state.item.item.,
                              //     itemBuilder: (context, index) {
                              //       final item = items[index];
                              //       return Container(
                              //         width: 140,
                              //         margin: const EdgeInsets.only(right: 12),
                              //         decoration: BoxDecoration(
                              //           color: Colors.grey[200],
                              //           borderRadius: BorderRadius.circular(12),
                              //         ),
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: [
                              //             ClipRRect(
                              //               borderRadius:
                              //                   const BorderRadius.vertical(
                              //                       top: Radius.circular(12)),
                              //               child: Image.network(
                              //                 getValidImageUrl(
                              //                     state.room.room!.imageUrl!),
                              //                 height: 80,
                              //                 width: double.infinity,
                              //                 fit: BoxFit.cover,
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(8.0),
                              //               child: Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     items[index].name!,
                              //                     style: const TextStyle(
                              //                       fontWeight: FontWeight.bold,
                              //                       fontFamily:
                              //                           'Times New Roman',
                              //                     ),
                              //                     maxLines: 1,
                              //                     overflow:
                              //                         TextOverflow.ellipsis,
                              //                   ),
                              //                   const SizedBox(height: 4),
                              //                   Text(
                              //                     '\//$${item.price}',
                              //                     style: const TextStyle(
                              //                       fontFamily:
                              //                           'Times New Roman',
                              //                       color: Colors.black87,
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
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
                                        // CircleAvatar(
                                        //   backgroundImage: NetworkImage(
                                        //       getValidImageUrl(
                                        //           feedback.profilePic)),
                                        //   radius: 18,
                                        // ),
                                        // const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   feedback.userName,
                                              //   style: const TextStyle(
                                              //     fontWeight: FontWeight.bold,
                                              //     fontFamily: 'Times New Roman',
                                              //   ),
                                              // ),
                                              const SizedBox(height: 4),
                                              Text(
                                                feedback,
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
                                    state.item.item!.price.toString(),
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                        AddItemToCart(
                                            itemId: state.item.item!.id!,
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
            } else if (state is ItemDetailesError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
