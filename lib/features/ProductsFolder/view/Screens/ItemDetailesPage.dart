import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Customizations/view/Screens/CustomizationsPage.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/ProductsFolder/Bloc/ItemDetaliesBloc/item_detailes_bloc.dart';
import 'package:start/features/ProductsFolder/view/widgets/FabricDetailsWidget.dart';
import 'package:start/features/ProductsFolder/view/widgets/woodDetailsWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            if (state is ItemDetailesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ItemDetailesSuccess) {
              final feedbacks = state.item.ratings ?? [];
              return Stack(
                children: [
                  // صورة

                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            getValidImageUrl(state.item.item!.imageUrl)),
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
                                  LikeButton(
                                    size: 28,
                                    isLiked: state.item.isFavorite ?? false,
                                    onTap: (bool isLiked) async {
                                      // Dispatch your event to update the favorite state.
                                      BlocProvider.of<FavBloc>(context).add(
                                          AddToFavEvent(
                                              null, state.item.item!.id));
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
                                  _buildRatingStars(state.item.averageRating!),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.item.averageRating!
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
                                label: Text(
                                  AppLocalizations.of(context)!.assignment,
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
                              // Description section.
                              Text(AppLocalizations.of(context)!.descretion,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18,
                                    color: Colors.black87,
                                  )),
                              const SizedBox(height: 8),
                              Text(
                                state.item.item!.description!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Times New Roman',
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),
                              WoodDetailsWidget(
                                woodColor: state.item.item!.woodColor,
                                woodHeight:
                                    state.item.itemDetails!.first.woodHeight,
                                woodLength:
                                    state.item.itemDetails!.first.woodLength,
                                woodType: state.item.item!.woodType,
                                woodWidth:
                                    state.item.itemDetails!.first.woodWidth,
                              ),
                              const SizedBox(height: 24),
                              FabricDetailsWidget(
                                  fabricLength: state
                                      .item.itemDetails!.first.fabricDimension,
                                  fabricType: state.item.item!.fabricType,
                                  fabricColor: state.item.item!.fabricColor),

                              const SizedBox(height: 24),
                              // Feedback (Comments) Section.
                              if (feedbacks.isNotEmpty) ...[
                                Text(
                                  AppLocalizations.of(context)!.feedback,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
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
                                              getValidImageUrl(feedback
                                                      .customer!.imageUrl ??
                                                  'http://profile.unknown.com')),
                                          radius: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feedback.customer!.name ??
                                                    'Unknown',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Times New Roman',
                                                ),
                                              ),
                                              _buildRatingStars(feedback.rate!),
                                              const SizedBox(height: 4),
                                              Text(
                                                feedback.feedback ??
                                                    'Nothing to say',
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
                                    '\$${state.item.item!.price.toString()}',
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
                                    label: Text(
                                      AppLocalizations.of(context)!.addtocart,
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
