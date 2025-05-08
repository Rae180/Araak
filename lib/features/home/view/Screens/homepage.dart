import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/home/Bloc/CategoryBloc/category_bloc.dart';
import 'package:start/features/home/Bloc/RecommendBloc/recommend_bloc.dart';
import 'package:start/features/home/Bloc/RoomsByCategoryBloc/rooms_by_category_bloc.dart';
import 'package:start/features/home/Bloc/trending_bloc/trending_bloc.dart';
import 'package:start/features/home/Models/RecommendModel.dart';
import 'package:start/features/home/Models/Trending.dart';
import 'package:start/features/home/view/widgets/CategoryTab.dart';
import 'package:start/features/home/view/widgets/ProductCaard.dart';
import 'package:start/features/home/view/widgets/RecommendedItems.dart';
import 'package:start/features/home/view/widgets/RecommendedRooms.dart';
import 'package:start/features/home/view/widgets/TrendingItemWidget.dart';
import 'package:start/features/home/view/widgets/TrendingRoomWidget.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Living Room';

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
              RoomsByCategoryBloc(client: NetworkApiServiceHttp()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F0EB), // Soft beige background
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(), // Smooth scrolling
          slivers: [
            // 🏆 SliverAppBar (Pinned & Elevates When Scrolled)
            SliverAppBar(
              pinned: true, // Keeps AppBar visible while scrolling
              floating: false,
              elevation: 0, // Adds slight elevation when scrolling down
              backgroundColor: const Color(0xFFF4F0EB), // Stays consistent
              expandedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'homePage',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman'),
                ),
                centerTitle: true,
              ),
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.black),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart, color: Colors.black),
                ),
              ],
            ),

            // 🏆 Page Content (Three Sections)
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 12),

                // 🔥 Trending & Discounts Section (Horizontal Scroll)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "🔥 Trending & Discounts",
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
                        print('success');
                        final trendingItems =
                            state.trending.trendingItems ?? [];
                        final trendingRooms =
                            state.trending.trendingRooms ?? [];

                        final List<dynamic> combinedList = [];
                        combinedList.addAll(trendingItems);
                        combinedList.addAll(trendingRooms);
                        // print('combinedList : $combinedList');

                        return ListView.builder(
                          itemCount: combinedList.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: ((context, index) {
                            final item = combinedList[index];
                            if (item is TrendingItems) {
                              print('trending items');
                              return TrendingItemWidget(item: item);
                            }
                            if (item is TrendingRooms) {
                              print('trending rooms');
                              return TrendingRoomWidget(item: item);
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "🎯 Suggested For You",
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
                            return RecommendedItemWidget(item: item);
                          } else if (item is RecommendedRooms) {
                            return RecommendedRoomsWidget(item: item);
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "📦 View All Items",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return CircularProgressIndicator();
                      } else if (state is CategorySuccess) {
                        return ListView.builder(
                          itemCount: state.category.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (context, index) {
                            return CategoryTab(
                                title: state.category[index].name,
                                isSelected: selectedCategory ==
                                    state.category[index].name,
                                onTap: () {
                                  setState(() {
                                    selectedCategory =
                                        state.category[index].name!;
                                  });
                                  BlocProvider.of<RoomsByCategoryBloc>(context)
                                      .add(GetRoomsByCategory(
                                          categoryId:
                                              state.category[index].id!));
                                });
                          },
                        );
                      } else if (state is CategoryError) {
                        return Container(
                          child: Text(state.message),
                        );
                      }
                      return Container();
                    },
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
                          return ProductCard(
                            price: '100\$',
                            name: product.name!,
                            likecount: product.likesCount!,
                            rating: product.averageRating!,
                            imageUrl: product.imageUrl!,
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

                const SizedBox(height: 20),
              ]),
            ),
          ],
        ),

        // 🏆 Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          currentIndex: 0,
          onTap: (index) {},
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}
