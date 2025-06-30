import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/ProductsFolder/view/Screens/DiscountDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ProductDetails.dart';
import 'package:start/features/Searching/view/Screens/SearchPage.dart';
import 'package:start/features/Settings/view/Screens/SettingsPage.dart';
import 'package:start/features/home/Bloc/CategoryBloc/category_bloc.dart';
import 'package:start/features/home/Bloc/RecommendBloc/recommend_bloc.dart';
import 'package:start/features/home/Bloc/RoomsByCategoryBloc/rooms_by_category_bloc.dart';
import 'package:start/features/home/Bloc/trending_bloc/trending_bloc.dart';
import 'package:start/features/home/Models/Trending.dart';
import 'package:start/features/home/view/widgets/CategoryTab.dart';
import 'package:start/features/home/view/widgets/DiscountWidget.dart';
import 'package:start/features/home/view/widgets/ProductCaard.dart';
import 'package:start/features/home/view/widgets/RecommendedItems.dart';
import 'package:start/features/home/view/widgets/RecommendedRooms.dart';
import 'package:start/features/home/view/widgets/TrendingItemWidget.dart';
import 'package:start/features/home/view/widgets/TrendingRoomWidget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  final _trendingKey = GlobalKey();
  final _recommendedKey = GlobalKey();
  final _productsKey = GlobalKey();

  Color get shimmerBaseColor => Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[800]!
      : Colors.grey[300]!;

  Color get shimmerHighlightColor =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CategoryBloc(client: NetworkApiServiceHttp())
              ..add(getCategories())),
        BlocProvider(
            create: (context) => TrendingBloc(client: NetworkApiServiceHttp())
              ..add(GetTrendings())),
        BlocProvider(
            create: (context) => RecommendBloc(client: NetworkApiServiceHttp())
              ..add(GetRecommends())),
        BlocProvider(
            create: (context) =>
                RoomsByCategoryBloc(client: NetworkApiServiceHttp())
                  ..add(GetAllFurEvent())),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, textColor),
        body: _buildBody(context, textColor),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.search),
        color: textColor,
        onPressed: () => Navigator.of(context).pushNamed(SearchPage.routeName),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_active_outlined),
          color: textColor,
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          color: textColor,
          onPressed: () =>
              Navigator.of(context).pushNamed(SettingScreen.routeName),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context, Color textColor) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        // TRENDING SECTION
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            context: context,
            title: AppLocalizations.of(context)!.trending,
            textColor: textColor,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 260,
            child: BlocBuilder<TrendingBloc, TrendingState>(
              builder: (context, state) {
                if (state is TrendingLoading) return _buildShimmerLoader();
                if (state is TrendingSuccess) return _buildTrendingList(state);
                if (state is TrendingError)
                  return _buildErrorWidget(state.message);
                return const SizedBox();
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.sectionPadding)),

        // RECOMMENDED SECTION
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            context: context,
            title: AppLocalizations.of(context)!.suggest,
            textColor: textColor,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 260,
            child: BlocBuilder<RecommendBloc, RecommendState>(
              builder: (context, state) {
                if (state is RecomendLoading) return _buildShimmerLoader();
                if (state is RecomendSuccess)
                  return _buildRecommendedList(state);
                if (state is RecommendError)
                  return _buildErrorWidget(state.message);
                return const SizedBox();
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.sectionPadding)),

        // CATEGORY SECTION
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            context: context,
            title: AppLocalizations.of(context)!.viewall,
            textColor: textColor,
          ),
        ),
        SliverToBoxAdapter(
            child: SizedBox(
                height: 90,
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading)
                      return _buildCategoryShimmer();
                    return _buildCategorySelector(context);
                  },
                ))),
        SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.elementSpacing)),

        // PRODUCT GRID
        BlocBuilder<RoomsByCategoryBloc, RoomsByCategoryState>(
          builder: (context, state) {
            if (state is RoomsByCategoryLoading) {
              return SliverFillRemaining(child: _buildShimmerLoader());
            }
            if (state is RoomsByCategorySuccess || state is GetAllFurSuccess) {
              return _buildProductGrid(state);
            }
            if (state is RoomsByCategoryError) {
              return SliverFillRemaining(
                  child: _buildErrorWidget(state.message));
            }
            return const SliverToBoxAdapter(child: SizedBox());
          },
        ),
      ],
    );
  }

  Widget _buildHorizontalShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            width: 230,
            margin: const EdgeInsets.all(AppConstants.elementSpacing),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.sectionPadding,
        vertical: AppConstants.elementSpacing,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.elementSpacing,
        mainAxisSpacing: AppConstants.elementSpacing,
        childAspectRatio: 0.55,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(right: AppConstants.elementSpacing),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.sectionPadding,
        vertical: AppConstants.elementSpacing,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.primaryFont,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return _buildHorizontalShimmer();
  }

  Widget _buildErrorWidget(String message) {
    return Center(child: Text(message));
  }

  Widget _buildTrendingList(TrendingSuccess state) {
    final trendingItems = state.trending.trendingItems ?? [];
    final trendingRooms = state.trending.trendingRooms ?? [];
    final itemdiscounts = state.trending.itemDiscounts ?? [];
    final roomsdiscounts = state.trending.roomDiscounts ?? [];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      itemCount: trendingItems.length +
          trendingRooms.length +
          itemdiscounts.length +
          roomsdiscounts.length,
      itemBuilder: (context, index) {
        final combined = [
          ...trendingItems,
          ...trendingRooms,
          ...itemdiscounts,
          ...roomsdiscounts
        ];
        final item = combined[index];

        return Container(
          margin: const EdgeInsets.all(AppConstants.elementSpacing),
          child: _buildTrendingItem(item),
        );
      },
    );
  }

  Widget _buildTrendingItem(dynamic item) {
    if (item is TrendingItems) {
      return TrendingItemWidget(
        item: item,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailesPage(itemId: item.id),
          ),
        ),
      );
    }
    if (item is TrendingRooms) {
      return TrendingRoomWidget(
        item: item,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(roomId: item.id),
          ),
        ),
      );
    }
    if (item is ItemDiscounts || item is RoomDiscounts) {
      return DiscountWidget(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiscountDetailsPage(discountId: item.id),
          ),
        ),
        imageUrl: item.imageUrl!,
        discountPercentage: item.discountPercentage!,
        endDate: item.endDate!,
        originalPrice: item.originalPrice!,
        discountedPrice: item.discountedPrice!,
      );
    }
    return const SizedBox();
  }

  Widget _buildRecommendedList(RecomendSuccess state) {
    final recommendedItems = state.recommend.recommendedItems ?? [];
    final recommendedRooms = state.recommend.recommendedRooms ?? [];
    final itemCount = recommendedItems.length + recommendedRooms.length;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < recommendedItems.length) {
          final item = recommendedItems[index];
          return Container(
            margin: const EdgeInsets.all(AppConstants.elementSpacing),
            child: RecommendedItemWidget(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailesPage(itemId: item.id),
                ),
              ),
            ),
          );
        } else {
          final item = recommendedRooms[index - recommendedItems.length];
          return Container(
            margin: const EdgeInsets.all(AppConstants.elementSpacing),
            child: RecommendedRoomsWidget(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(roomId: item.id),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is! CategorySuccess) return const SizedBox();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.sectionPadding),
            itemCount: state.category.length + 1,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppConstants.elementSpacing),
            itemBuilder: (context, index) {
              if (index == 0) {
                return CategoryTab(
                  title: 'All',
                  isSelected: selectedCategory == 'All',
                  onTap: () {
                    setState(() => selectedCategory = 'All');
                    context.read<RoomsByCategoryBloc>().add(GetAllFurEvent());
                  },
                );
              }

              final cat = state.category[index - 1];
              return CategoryTab(
                title: cat.name,
                isSelected: selectedCategory == cat.name,
                onTap: () {
                  setState(() => selectedCategory = cat.name!);
                  context.read<RoomsByCategoryBloc>().add(
                        GetRoomsByCategory(categoryId: cat.id!),
                      );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(dynamic state) {
    List<dynamic> products;

    if (state is RoomsByCategorySuccess) {
      products = state.rooms.category?.rooms ?? [];
    } else if (state is GetAllFurSuccess) {
      products = state.furnitures.allRooms ?? [];
    } else {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.elementSpacing,
        mainAxisSpacing: AppConstants.elementSpacing,
        childAspectRatio: 0.55,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
        childCount: products.length,
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return ProductCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => ProductDetailsPage(
                  roomId: product.id,
                )),
          ),
        );
      },
      key: ValueKey('product_${product.id}'),
      roomId: product.id!,
      price: '${product.price ?? 0}\$',
      name: product.name!,
      likecount: 4,
      rating: product.averageRating!,
      imageUrl: product.imageUrl!,
    );
  }
}
