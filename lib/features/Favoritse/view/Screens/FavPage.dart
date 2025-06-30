import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/Favoritse/Models/FavItem.dart';
import 'package:start/features/Favoritse/view/widgets/FavItemWidget.dart';
import 'package:start/features/Favoritse/view/widgets/FavRoomWidget.dart';
import 'package:start/features/ProductsFolder/Bloc/RoomDetailesBloc/room_details_bloc.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ProductDetails.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavPage extends StatelessWidget {
  static const String routeName = '/favorites_page';
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.fav,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      backgroundColor: Colors.transparent,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  FavBloc(client: NetworkApiServiceHttp())..add(GetFavs())),
          BlocProvider(
              create: (context) => CartBloc(client: NetworkApiServiceHttp())),
          BlocProvider(
            create: (context) =>
                RoomDetailsBloc(client: NetworkApiServiceHttp()),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.sectionPadding),
          child: BlocConsumer<FavBloc, FavState>(
            listener: (context, state) {
              if (state is AddedToFavsSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.addalltocart),
                    backgroundColor: colorScheme.primary,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is FavLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                );
              } else if (state is FavSuccess) {
                final favRooms = state.favs.rooms ?? [];
                final favItems = state.favs.items ?? [];

                if (favRooms.isEmpty && favItems.isEmpty) {
                  return _buildEmptyState(context, l10n);
                }

                return Column(
                  children: [
                    // Favorites count header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'l10n.favorites',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${favRooms.length + favItems.length} ${'l10n.items'}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // List of favorites with tabs
                    Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            // Tabs
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.surfaceVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TabBar(
                                labelColor: colorScheme.onPrimary,
                                unselectedLabelColor:
                                    colorScheme.onSurface.withOpacity(0.6),
                                indicator: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.room, size: 18),
                                        const SizedBox(width: 8),
                                        Text('l10n.rooms'),
                                        const SizedBox(width: 4),
                                        if (favRooms.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorScheme.primary
                                                  .withOpacity(0.2),
                                            ),
                                            child: Text(
                                              favRooms.length.toString(),
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.shopping_bag,
                                            size: 18),
                                        const SizedBox(width: 8),
                                        Text('l10n.items'),
                                        const SizedBox(width: 4),
                                        if (favItems.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorScheme.primary
                                                  .withOpacity(0.2),
                                            ),
                                            child: Text(
                                              favItems.length.toString(),
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Tab content
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // Rooms Tab
                                  _buildFavList(
                                    context,
                                    items: favRooms,
                                    isRoom: true,
                                    l10n: l10n,
                                  ),
                                  // Items Tab
                                  _buildFavList(
                                    context,
                                    items: favItems,
                                    isRoom: false,
                                    l10n: l10n,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Add All to Cart Button
                    if (favRooms.isNotEmpty || favItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16, bottom: AppConstants.sectionPadding),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final List<int?> roomsId = favRooms
                                .where((room) => room.id != null)
                                .map((room) => room.id)
                                .toList();
                            final List<int?> itemsId = favItems
                                .where((item) => item.id != null)
                                .map((item) => item.id)
                                .toList();
                            BlocProvider.of<FavBloc>(context).add(
                              AddAllToFavEvent(
                                RoomsId: roomsId,
                                ItemsId: itemsId,
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: colorScheme.onPrimary,
                          ),
                          label: Text(
                            l10n.addalltocart,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.cardRadius),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                );
              } else if (state is FavError) {
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

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'l10n.emptyfav',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'l10n.addfav',
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
            ),
            child: Text(
              'l10n.explore',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavList(
    BuildContext context, {
    required List<dynamic> items,
    required bool isRoom,
    required AppLocalizations l10n,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          isRoom ? 'l10n.noroomsfav' : 'l10n.noitemsfav',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        if (isRoom && item is Rooms) {
          return FavRoomWidget(
            details: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    roomId: item.id,
                  ),
                ),
              );
            },
            imageUrl: item.imageUrl!,
            name: item.name!,
            price: item.price!,
            onTap: () {
              BlocProvider.of<FavBloc>(context).add(
                AddToFavEvent(item.id, null),
              );
            },
            onTap2: () {
              BlocProvider.of<CartBloc>(context)
                  .add(AddRoomToCart(roomId: item.id!, count: 1));
            },
            likecount: item.likesCount!,
            averagRating: item.totalRating!,
          );
        } else if (!isRoom && item is Items) {
          return FavItemWidget(
            onDismissed: () {},
            details: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ItemDetailesPage(
                    itemId: item.id,
                  ),
                ),
              );
            },
            imageUrl: item.imageUrl!,
            name: item.name!,
            price: item.price!,
            onTap: () {
              BlocProvider.of<FavBloc>(context).add(
                AddToFavEvent(null, item.id),
              );
            },
            onTap2: () {
              BlocProvider.of<CartBloc>(context)
                  .add(AddItemToCart(itemId: item.id!, count: 1));
            },
            likecount: item.likesCount!,
            averagRating: item.totalRating!,
          );
        }
        return const SizedBox();
      },
    );
  }
}
