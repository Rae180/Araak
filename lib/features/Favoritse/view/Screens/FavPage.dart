import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';
import 'package:start/features/Favoritse/Models/FavItem.dart';
import 'package:start/features/Favoritse/view/widgets/FavItemWidget.dart';
import 'package:start/features/Favoritse/view/widgets/FavRoomWidget.dart';
import 'package:start/features/ProductsFolder/Bloc/RoomDetailesBloc/room_details_bloc.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/ProductsFolder/view/Screens/ProductDetails.dart';

class FavPage extends StatelessWidget {
  static const String routeName = '/favorites_page';
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FavBloc(client: NetworkApiServiceHttp())..add(GetFavs()),
        ),
        BlocProvider(
          create: (context) => CartBloc(client: NetworkApiServiceHttp()),
        ),
        BlocProvider(
          create: (context) => RoomDetailsBloc(client: NetworkApiServiceHttp()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'FAVORITES',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFF9F6F2),
        ),
        backgroundColor: const Color(0xFFF9F6F2),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<FavBloc, FavState>(
            builder: (context, state) {
              if (state is FavLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FavSuccess) {
                final FavRooms = state.favs.rooms ?? [];
                final FavItems = state.favs.items ?? [];

                final List<dynamic> combinedList = [];
                combinedList.addAll(FavRooms);
                combinedList.addAll(FavItems);
                return Column(
                  children: [
                    // List of cart items.
                    Expanded(
                      child: ListView.separated(
                        itemCount: combinedList.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 20, color: Colors.grey),
                        itemBuilder: (context, index) {
                          final item = combinedList[index];
                          if (item is Rooms) {
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
                                  BlocProvider.of<CartBloc>(context).add(
                                      AddRoomToCart(
                                          roomId: item.id!, count: 1));
                                },
                                likecount: item.likesCount!,
                                averagRating: item.totalRating!);
                          }
                          if (item is Items) {
                            return FavItemWidget(
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
                                  BlocProvider.of<CartBloc>(context).add(
                                      AddItemToCart(
                                          itemId: item.id!, count: 1));
                                },
                                likecount: item.likesCount!,
                                averagRating: item.totalRating!);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 3,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                      onPressed: () {
                        List<int?> RoomsId =
                            FavRooms.where((room) => room.id != null)
                                .map((room) => room.id)
                                .toList();
                        List<int?> ItemsId =
                            FavItems.where((item) => item.id != null)
                                .map((item) => item.id)
                                .toList();
                        BlocProvider.of<FavBloc>(context).add(AddAllToFavEvent(
                            RoomsId: RoomsId, ItemsId: ItemsId));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add all to Cart',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                );
              } else if (state is FavError) {
                return Center(
                  child: Text(state.message),
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
