import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/ProductsFolder/view/Screens/DiscountDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ProductDetails.dart';
import 'package:start/features/Searching/view/Screens/SearchPage.dart';
import 'package:start/features/Settings/view/Screens/SettingsPage.dart';
import 'package:start/features/home/Bloc/CategoryBloc/category_bloc.dart';
import 'package:start/features/home/Bloc/RecommendBloc/recommend_bloc.dart';
import 'package:start/features/home/Bloc/RoomsByCategoryBloc/rooms_by_category_bloc.dart';
import 'package:start/features/home/Bloc/trending_bloc/trending_bloc.dart';
import 'package:start/features/home/Models/RecommendModel.dart';
import 'package:start/features/home/Models/Trending.dart';
import 'package:start/features/home/view/widgets/CategoryTab.dart';
import 'package:start/features/home/view/widgets/DiscountWidget.dart';
import 'package:start/features/home/view/widgets/ProductCaard.dart';
import 'package:start/features/home/view/widgets/RecommendedItems.dart';
import 'package:start/features/home/view/widgets/RecommendedRooms.dart';
import 'package:start/features/home/view/widgets/TrendingItemWidget.dart';
import 'package:start/features/home/view/widgets/TrendingRoomWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(
            client: NetworkApiServiceHttp(),
          )..add(getCategories()),
        ),
        BlocProvider(
          create: (context) => TrendingBloc(client: NetworkApiServiceHttp())
            ..add(GetTrendings()),
        ),
        BlocProvider(
          create: (context) => RecommendBloc(client: NetworkApiServiceHttp())
            ..add(GetRecommends()),
        ),
        BlocProvider(
          create: (context) =>
              RoomsByCategoryBloc(client: NetworkApiServiceHttp())
                ..add(GetAllFurEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F0EB),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SearchPage.routeName);
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_active_outlined,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SettingScreen.routeName);
              },
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ),
            )
          ],
          centerTitle: true,
          title: const Text(""),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                child: Text(
                  AppLocalizations.of(context)!.trending,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),
              SizedBox(
                height: 260,
                child: BlocBuilder<TrendingBloc, TrendingState>(
                  builder: (context, state) {
                    if (state is TrendingLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TrendingSuccess) {
                      final trendingItems = state.trending.trendingItems ?? [];
                      final trendingRooms = state.trending.trendingRooms ?? [];
                      final itemdiscounts = state.trending.itemDiscounts ?? [];
                      final roomsdiscounts = state.trending.roomDiscounts ?? [];

                      final List<dynamic> combinedList = [];
                      combinedList.addAll(trendingItems);
                      combinedList.addAll(trendingRooms);
                      combinedList.addAll(itemdiscounts);
                      combinedList.addAll(roomsdiscounts);
                      // print('combinedList : $combinedList');

                      return ListView.builder(
                        itemCount: combinedList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          final item = combinedList[index];
                          if (item is TrendingItems) {
                            return TrendingItemWidget(
                              item: item,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ItemDetailesPage(
                                          itemId: item.id,
                                        )));
                              },
                            );
                          }
                          if (item is TrendingRooms) {
                            return TrendingRoomWidget(
                              item: item,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                          roomId: item.id,
                                        )));
                              },
                            );
                          }
                          if (item is ItemDiscounts) {
                            return DiscountWidget(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DiscountDetailsPage(
                                            discountId: item.id,
                                          )));
                                },
                                imageUrl: item.imageUrl!,
                                discountPercentage: item.discountPercentage!,
                                endDate: item.endDate!,
                                originalPrice: item.originalPrice!,
                                discountedPrice: item.discountedPrice!);
                          }
                          if (item is RoomDiscounts) {
                            return DiscountWidget(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DiscountDetailsPage(
                                            discountId: item.id,
                                          )));
                                },
                                imageUrl: item.imageUrl!,
                                discountPercentage: item.discountPercentage!,
                                endDate: item.endDate!,
                                originalPrice: item.originalPrice!,
                                discountedPrice: item.discountedPrice!);
                          }
                        }),
                      );
                    } else if (state is TrendingError) {
                      return Container(
                        child: Text(state.message),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 🎯 Suggested For You Section (Horizontal Scroll)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                child: Text(
                  AppLocalizations.of(context)!.suggest,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),
              SizedBox(
                height: 260,
                child: BlocBuilder<RecommendBloc, RecommendState>(
                    builder: (context, state) {
                  if (state is RecomendLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is RecomendSuccess) {
                    final recommendedItems =
                        state.recommend.recommendedItems ?? [];
                    final recommendedRooms =
                        state.recommend.recommendedRooms ?? [];

                    final List<dynamic> combinedList = [];
                    combinedList.addAll(recommendedItems);
                    combinedList.addAll(recommendedRooms);

                    // print('combinedList : $combinedList');
                    return ListView.builder(
                      itemCount: combinedList.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = combinedList[index];
                        if (item is RecommendedItems) {
                          return RecommendedItemWidget(
                            item: item,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ItemDetailesPage(
                                        itemId: item.id,
                                      )));
                            },
                          );
                        } else if (item is RecommendedRooms) {
                          return RecommendedRoomsWidget(
                            item: item,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductDetailsPage(
                                        roomId: item.id,
                                      )));
                            },
                          );
                        }
                      },
                    );
                  } else if (state is RecommendError) {
                    return Container(
                      child: Text(state.message),
                    );
                  }
                  return SizedBox();
                }),
              ),
              const SizedBox(height: 20),

              // 📦 View All Items Section with Category Tabs
               Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                child: Text(
                  AppLocalizations.of(context)!.viewall,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 7,
                      ),
                      Builder(builder: (context) {
                        return CategoryTab(
                          title: 'All',
                          onTap: () {
                            setState(() {
                              selectedCategory = 'All';
                            });

                            BlocProvider.of<RoomsByCategoryBloc>(context)
                                .add(GetAllFurEvent());
                          },
                          isSelected: selectedCategory == 'All',
                        );
                      }),
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return CircularProgressIndicator();
                          } else if (state is CategorySuccess) {
                            return Row(
                              children: state.category.map((cat) {
                                return CategoryTab(
                                  title: cat.name,
                                  isSelected: selectedCategory == cat.name,
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = cat.name!;
                                    });
                                    BlocProvider.of<RoomsByCategoryBloc>(
                                            context)
                                        .add(
                                      GetRoomsByCategory(categoryId: cat.id!),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          } else if (state is CategoryError) {
                            return Container(
                              child: Text(state.message),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 🏆 Filtered Items Grid
              BlocBuilder<RoomsByCategoryBloc, RoomsByCategoryState>(
                builder: (context, state) {
                  if (state is RoomsByCategoryLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is RoomsByCategorySuccess) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(17.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.rooms.category!.rooms!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // mainAxisSpacing: 0.1,
                        crossAxisSpacing: 3,
                        childAspectRatio: 0.49,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.rooms.category!.rooms![index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                        roomId: state.rooms.category!
                                            .rooms?[index].id)));
                          },
                          child: ProductCard(
                            roomId: product.id!,
                            price: '${product.price ?? 0}\$',
                            name: product.name!,
                            likecount: product.likesCount!,
                            rating: product.averageRating!,
                            imageUrl: product.imageUrl!,
                          ),
                        );
                      },
                    );
                  } else if (state is GetAllFurSuccess) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(17.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.furnitures.allRooms!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // mainAxisSpacing: 0.1,
                        crossAxisSpacing: 3,
                        childAspectRatio: 0.49,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.furnitures.allRooms![index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                        roomId: product.id)));
                          },
                          child: ProductCard(
                            roomId: product.id!,
                            price: '${product.price}\$',
                            name: product.name!,
                            likecount: product.likeCount!,
                            rating: product.averageRating!,
                            imageUrl: product.imageUrl!,
                          ),
                        );
                      },
                    );
                  } else if (state is RoomsByCategoryError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return SizedBox();
                },
              ),

              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
