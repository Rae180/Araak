import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Cart/Bloc/CartBloc/cart_bloc.dart';
import 'package:start/features/ProductsFolder/view/Screens/ItemDetailesPage.dart';
import 'package:start/features/Searching/Bloc/bloc/search_res_bloc.dart';
import 'package:start/features/Searching/view/Widgets/searchResultWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/search_screen';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Whether the search field is currently focused.
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchResBloc(client: NetworkApiServiceHttp()),
        ),
        BlocProvider(
          create: (context) => CartBloc(client: NetworkApiServiceHttp()),
        ),
      ],
      child: Scaffold(
        // Extend the background gradient behind the app bar.
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.whatlook,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Serif',
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF4F0EB),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Glassmorphism search field.
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(_isFocused ? 12 : 16),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Builder(builder: (context) {
                      return TextFormField(
                        focusNode: _focusNode,
                        controller: _controller,
                        onChanged: (query) {
                          BlocProvider.of<SearchResBloc>(context)
                              .add(GetSearchResultsEvent(query: query));
                        },
                        style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontFamily: 'Serif'),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black45,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Animated list view for search results.
              Expanded(
                child: BlocBuilder<SearchResBloc, SearchResState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchSuccess) {
                      final results = state.results.items;
                      if (results == null || results.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.noitemsfound,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        );
                      }
                      return AnimationLimiter(
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final item = results[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: SearchResultItemWidget(
                                    imageUrl: item.imageUrl!,
                                    name: item.name!,
                                    price: item.price!,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ItemDetailesPage(
                                            itemId: item.id,
                                          ),
                                        ),
                                      );
                                    },
                                    onAddToCart: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                          AddItemToCart(
                                              itemId: item.id!, count: 1));
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is SearchError) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.anerrorocc,
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
