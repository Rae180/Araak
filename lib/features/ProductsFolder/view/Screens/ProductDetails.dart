import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/core/utils/services/shared_preferences.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Customizations/view/Screens/CustomizationsPage.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/ProductsFolder/Bloc/RoomDetailesBloc/room_details_bloc.dart';
import 'package:start/features/ProductsFolder/Models/RoomDetails.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    if (!url.startsWith('http')) {
      return '${ApiConstants.STORAGE_URL}/$url';
    }
    return url;
  }

  Widget _buildRatingStars(num? rating) {
    final effectiveRating = rating ?? 0.0;
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < effectiveRating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Color getColorFromName(String colorName) {
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
      'beige': Color(0xFFF5F5DC),
    };
    return colorMap[colorName.trim().toLowerCase()] ?? Colors.grey;
  }

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
        backgroundColor: Colors.transparent,
        body: BlocBuilder<RoomDetailsBloc, RoomDetailsState>(
          builder: (context, state) {
            if (state is RoomDetailesLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              );
            } else if (state is RoomDetailesError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              );
            } else if (state is RoomDetailsSuccess) {
              final room = state.room.room!;
              if (room == null) {
                return Center(child: Text('l10n.noDetailsAvailable'));
              }
              final items = room.items ?? [];
              final feedbacks = state.room.ratings ?? [];
              final fabrics = state.room.fabrics ?? [];
              final List<String> allFabricColors = getAllFabricColors(fabrics);
              final imageUrl = getValidImageUrl(room.imageUrl);
              final name = room.name ?? l10n.unnamedproduct;
              final description = room.description ?? l10n.nodescription;
              final price = room.price ?? 0.0;
              final rating = room.averageRating ?? 0.0;

              return Stack(
                children: [
                  // Hero image with gradient overlay
                  Hero(
                    tag: 'product-${room.id ?? "unknown"}',
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
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
                                      name,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  BlocBuilder<FavBloc, FavState>(
                                    builder: (context, favState) {
                                      final isFavorite =
                                          room.isFavorite ?? false;
                                      return LikeButton(
                                        size: 28,
                                        isLiked: isFavorite,
                                        onTap: (isLiked) async {
                                          BlocProvider.of<FavBloc>(context).add(
                                              AddToFavEvent(room.id, null));
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
                                  _buildRatingStars(rating),
                                  const SizedBox(width: 8),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Customize button
                              if (room.id != null)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomizationsPage(id: room.id!),
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

                              // Colors section
                              if (allFabricColors.isNotEmpty) ...[
                                Text(
                                  l10n.colors,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                    allFabricColors.length,
                                    (index) {
                                      final colorName = allFabricColors[index];
                                      final swatchColor =
                                          getColorFromName(colorName);
                                      return Tooltip(
                                        message: colorName,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: swatchColor,
                                            border: Border.all(
                                              width: 1,
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.1),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Description section with expandable text
                              Text(
                                l10n.descretion,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ExpandableText(
                                text: description,
                                maxLines: 4,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                  height: 1.5,
                                ),
                                linkColor: colorScheme.primary,
                              ),
                              const SizedBox(height: 24),

                              // Included items section
                              if (items.isNotEmpty) ...[
                                Text(
                                  l10n.includeditems,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 170,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: items.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                      final item =
                                          items[index] as Map<String, dynamic>;
                                      return _buildIncludedItemCard(
                                        context,
                                        name: item['name'],
                                        price: item['price'],
                                        imageUrl:
                                            getValidImageUrl(room.imageUrl),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

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
                                      customerName: feedback.customerName,
                                      customerImage: feedback.customerImage,
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
                                    '\$$price',
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
                                            content: Text(l10n.addtocart),
                                            backgroundColor:
                                                colorScheme.primary,
                                          ),
                                        );
                                      }
                                    },
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        BlocProvider.of<CartBloc>(context).add(
                                          AddRoomToCart(
                                            roomId: room.id!,
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
              imageUrl: imageUrl,
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
                  '\$$price',
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
          backgroundImage: CachedNetworkImageProvider(
            getValidImageUrl(customerImage),
          ),
          radius: 18,
          backgroundColor: colorScheme.surfaceVariant,
          onBackgroundImageError: (_, __) {},
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

// Expandable text widget implementation
class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;
  final Color? linkColor;

  const ExpandableText({
    Key? key,
    required this.text,
    this.maxLines = 4,
    this.style,
    this.linkColor,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _needsExpansion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: MediaQuery.of(context).size.width -
            (AppConstants.sectionPadding * 2));

    if (textPainter.didExceedMaxLines) {
      setState(() {
        _needsExpansion = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: widget.style,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (_needsExpansion) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(
              _isExpanded ? 'Show less' : 'Read more',
              style: (widget.style ?? theme.textTheme.bodyMedium)?.copyWith(
                color: widget.linkColor ?? colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
