import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
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
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    //   _focusNode.addListener(_handleFocusChange);
  }

  // void _handleFocusChange() {
  //   setState(() => _isFocused = _focusNode.hasFocus);
  //   if (!_focusNode.hasFocus && _controller.text.isEmpty) {
  //     BlocProvider.of<SearchResBloc>(context).add(ClearSearchEvent());
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    //  _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            l10n.whatlook,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: AppConstants.primaryFont,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + 40,
            left: AppConstants.sectionPadding,
            right: AppConstants.sectionPadding,
            bottom: AppConstants.sectionPadding,
          ),
          child: Column(
            children: [
              // Enhanced Glassmorphism Search Field
              Builder(
                builder: (context) {
                  return _buildSearchField(context, l10n);
                }
              ),
              const SizedBox(height: AppConstants.sectionPadding),

              // Search Results Section
              Expanded(
                child: BlocBuilder<SearchResBloc, SearchResState>(
                  builder: (context, state) {
                    return _buildSearchResults(context, state, l10n);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, AppLocalizations l10n) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppConstants.hoverDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius * 2),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.deepPurple.withOpacity(0.4)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius * 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _isFocused ? 15 : 10,
            sigmaY: _isFocused ? 15 : 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(AppConstants.cardRadius * 2),
              border: Border.all(
                color: _isFocused
                    ? colorScheme.primary.withOpacity(0.4)
                    : colorScheme.onSurface.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: TextFormField(
              focusNode: _focusNode,
              controller: _controller,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  BlocProvider.of<SearchResBloc>(context)
                      .add(GetSearchResultsEvent(query: query));
                } else {
                  // BlocProvider.of<SearchResBloc>(context)
                  //     .add(ClearSearchEvent());
                }
              },
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: AppConstants.primaryFont,
                  ),
              decoration: InputDecoration(
                hintText: l10n.search,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear,
                            color: colorScheme.onSurface.withOpacity(0.6)),
                        onPressed: () {
                          // _controller.clear();
                          // BlocProvider.of<SearchResBloc>(context)
                          //     .add(ClearSearchEvent());
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.sectionPadding,
                  vertical: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
      BuildContext context, SearchResState state, AppLocalizations l10n) {
    if (state is SearchResInitial) {
      return _buildEmptyState(
        context,
        icon: Icons.search_off_rounded,
        title: 'l10n.searchSomething',
        subtitle: 'l10n.findProducts',
      );
    }

    if (state is SearchLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is SearchSuccess) {
      final results = state.results.items;
      if (results == null || results.isEmpty) {
        return _buildEmptyState(
          context,
          icon: Icons.search_off_rounded,
          title: l10n.noitemsfound,
          subtitle: 'l10n.tryDifferent',
        );
      }

      return AnimationLimiter(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return Padding(
              padding:
                  const EdgeInsets.only(bottom: AppConstants.elementSpacing),
              child: AnimationConfiguration.staggeredList(
                position: index,
                duration: AppConstants.hoverDuration * 2,
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: SearchResultItemWidget(
                      imageUrl: item.imageUrl!,
                      name: item.name!,
                      price: item.price!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailesPage(
                              itemId: item.id,
                            ),
                          ),
                        );
                      },
                      onAddToCart: () {
                        BlocProvider.of<CartBloc>(context).add(
                          AddItemToCart(itemId: item.id!, count: 1),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    if (state is SearchError) {
      return _buildEmptyState(
        context,
        icon: Icons.error_outline_rounded,
        title: l10n.anerrorocc,
        subtitle: 'l10n.tryAgainLater',
        isError: true,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isError = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: isError
                ? colorScheme.error
                : colorScheme.onBackground.withOpacity(0.5),
          ),
          const SizedBox(height: AppConstants.sectionPadding),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isError ? colorScheme.error : colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
