import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/managers/theme_manager.dart';

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
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
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
        backgroundColor: Colors.transparent,
        body: BlocBuilder<ItemDetailesBloc, ItemDetailesState>(
          builder: (context, state) {
            if (state is ItemDetailesLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              );
            } else if (state is ItemDetailesError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              );
            } else if (state is ItemDetailesSuccess) {
              final item = state.item.item!;
              final feedbacks = state.item.ratings
                      ?.where((r) => r.feedback != null)
                      .toList() ??
                  [];
              final itemDetails = state.item.itemDetails?.isNotEmpty == true
                  ? state.item.itemDetails!.first
                  : null;

              return Stack(
                children: [
                  // Hero image with gradient overlay
                  Hero(
                    tag: 'item-${item.id}',
                    child: CachedNetworkImage(
                      imageUrl: getValidImageUrl(item.imageUrl),
                      imageBuilder: (context, imageProvider) => Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                isDarkMode
                                    ? Colors.black.withOpacity(0.7)
                                    : Colors.white.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        color: colorScheme.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        color: colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.image_not_supported,
                          color: colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                      ),
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: AnimatedContainer(
                        duration: AppConstants.hoverDuration,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),

                  // Draggable details sheet
                  DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.sectionPadding,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and favorite button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name!,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  BlocBuilder<FavBloc, FavState>(
                                    builder: (context, favState) {
                                      final isFavorite =
                                          state.item.isFavorite ?? false;
                                      return LikeButton(
                                        size: 28,
                                        isLiked: isFavorite,
                                        onTap: (isLiked) async {
                                          BlocProvider.of<FavBloc>(context).add(
                                              AddToFavEvent(null, item.id));
                                          return !isLiked;
                                        },
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            isLiked
                                                ? Icons.bookmark
                                                : Icons
                                                    .bookmark_border_outlined,
                                            color: isLiked
                                                ? Colors.amber
                                                : colorScheme.onSurface
                                                    .withOpacity(0.7),
                                            size: 28,
                                          );
                                        },
                                        circleColor: CircleColor(
                                          start: colorScheme.primary,
                                          end: colorScheme.secondary,
                                        ),
                                        bubblesColor: BubblesColor(
                                          dotPrimaryColor: colorScheme.primary,
                                          dotSecondaryColor:
                                              colorScheme.secondary,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Rating row
                              Row(
                                children: [
                                  _buildRatingStars(state.item.averageRating!),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.item.averageRating!
                                        .toStringAsFixed(1),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Customize button
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomizationsPage(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.settings,
                                  color: colorScheme.onPrimary,
                                ),
                                label: Text(
                                  l10n.assignment,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.cardRadius),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Description section
                              Text(
                                l10n.descretion,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.description!,
                                maxLines: 4,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Wood details
                              if (itemDetails?.woodHeight != null ||
                                  item.woodType != null)
                                WoodDetailsWidget(
                                  woodColor: item.woodColor,
                                  woodHeight: itemDetails?.woodHeight,
                                  woodLength: itemDetails?.woodLength,
                                  woodType: item.woodType,
                                  woodWidth: itemDetails?.woodWidth,
                                ),
                              const SizedBox(height: 24),

                              // Fabric details
                              if (itemDetails?.fabricDimension != null ||
                                  item.fabricType != null)
                                FabricDetailsWidget(
                                  fabricLength: itemDetails?.fabricDimension,
                                  fabricType: item.fabricType,
                                  fabricColor: item.fabricColor,
                                ),
                              const SizedBox(height: 24),

                              // Feedback section
                              if (feedbacks.isNotEmpty) ...[
                                Text(
                                  l10n.feedback,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: feedbacks.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final feedback = feedbacks[index];
                                    return _buildFeedbackItem(
                                      context,
                                      customerName: feedback.customer?.name ??
                                          l10n.anonymous,
                                      customerImage:
                                          feedback.customer?.imageUrl,
                                      rate: feedback.rate,
                                      feedback: feedback.feedback,
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Price and add to cart
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${item.price}',
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  BlocListener<CartBloc, CartState>(
                                    listener: (context, cartState) {
                                      if (cartState is CartAddedSuccess) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.addedtocart),
                                            backgroundColor:
                                                colorScheme.primary,
                                          ),
                                        );
                                      }
                                    },
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        BlocProvider.of<CartBloc>(context).add(
                                          AddItemToCart(
                                            itemId: item.id!,
                                            count: 1,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: colorScheme.onPrimary,
                                      ),
                                      label: Text(
                                        l10n.addtocart,
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.primary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.cardRadius),
                                        ),
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
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildFeedbackItem(
    BuildContext context, {
    required String? customerName,
    required String? customerImage,
    required num? rate,
    required String? feedback,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customer avatar
        CircleAvatar(
          radius: 18,
          backgroundColor: colorScheme.surfaceVariant,
          onBackgroundImageError: (_, __) {},
          backgroundImage: CachedNetworkImageProvider(
            getValidImageUrl(customerImage),
          ),
        ),
        const SizedBox(width: 12),

        // Feedback content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName ?? l10n.anonymous,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (starIndex) {
                  return Icon(
                    starIndex < (rate ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                feedback ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
