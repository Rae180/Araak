import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/ProductsFolder/Bloc/DiscountsBloc/discounts_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
        backgroundColor: Colors.transparent,
        body: BlocBuilder<DiscountsBloc, DiscountsState>(
          builder: (context, state) {
            if (state is DiscountsLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              );
            } else if (state is DiscountsError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              );
            } else if (state is DiscountsDetailesSuccess) {
              final discount = state.discount;
              final includedItems = discount.roomItems ?? [];

              return Stack(
                children: [
                  // Top Image Section with Hero animation
                  Hero(
                    tag: 'discount-${discount.roomId}',
                    child: CachedNetworkImage(
                      imageUrl: getValidImageUrl(discount.roomImage),
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

                  // Draggable Details Sheet
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
                              // Top Section: Room name and bookmark button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      discount.roomName ?? '',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Discount Information
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.cardRadius),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${discount.discountPercentage}% ${l10n.off}",
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${l10n.start}: ${discount.startDate}",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        Text(
                                          "${l10n.ends}: ${discount.endDate}",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Price Section
                              Row(
                                children: [
                                  Text(
                                    "\$${discount.discountedPrice!}",
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "\$${discount.originalPrice!}",
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Included Items Section
                              Text(
                                l10n.includeditems,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (includedItems.isNotEmpty)
                                SizedBox(
                                  height: 170,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: includedItems.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                      final item = includedItems[index];
                                      return _buildIncludedItemCard(
                                        context,
                                        name: item.name ?? '',
                                        price: item.price ?? 0,
                                        imageUrl: item.imageUrl ?? '',
                                      );
                                    },
                                  ),
                                )
                              else
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Text(
                                      l10n.noitemsfound,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),

                              // Add to Cart Section
                              BlocListener<CartBloc, CartState>(
                                listener: (context, cartState) {
                                  if (cartState is CartAddedSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.addtocart),
                                        backgroundColor: colorScheme.primary,
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${discount.discountedPrice!}",
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        BlocProvider.of<CartBloc>(context).add(
                                          AddRoomToCart(
                                            roomId: discount.roomId!,
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
                                            horizontal: 24, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.cardRadius),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
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
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildIncludedItemCard(
    BuildContext context, {
    required String name,
    required num price,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.cardRadius),
            ),
            child: CachedNetworkImage(
              imageUrl: getValidImageUrl(imageUrl),
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 80,
                color: colorScheme.surfaceVariant,
                child: Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 80,
                color: colorScheme.surfaceVariant,
                child: Icon(
                  Icons.image_not_supported,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Item details
          Padding(
            padding: const EdgeInsets.all(AppConstants.elementSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "\$$price",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
