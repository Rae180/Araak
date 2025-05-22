class ApiConstants {
  static const String baseUrl = 'http://192.168.1.7:8000/api/';
  static const String STORAGE_URL = "192.168.1.7:8000";
  static const String register = '${baseUrl}signup';
  static const String login = '${baseUrl}login';
  static const String getcat = '${baseUrl}showCategories';
  static const String getTrend = '${baseUrl}getTrending';
  static const String getRecom = '${baseUrl}Recommend';
  static const String getRoomsbyCat = '${baseUrl}getRoomsByCategory/';
  static const String getRoomDet = '${baseUrl}getRoomDetails/';
  static const String addtocart = '${baseUrl}addtocart2';
  static const String getcart = '${baseUrl}cart_details';
  static const String getfavos = '${baseUrl}getFavoritesWithDetails';
  static const String liketog = '${baseUrl}like_toggle';
  //static const String addcart = '${baseUrl}addToCart';
  static const String itemdet = '${baseUrl}getItemDetails/';
  static const String searchQuery =
      '${baseUrl}searchItemsByTypeName?type_name=';
  static const String addtofav = '${baseUrl}addToFavorites';
  static const String getdis = '${baseUrl}discount/';
  static const String addalltofav = '${baseUrl}addToCartFavorite';
  static const String removecart = '${baseUrl}cart_remove-partial';
  static const String showAllFur = '${baseUrl}showFerniture';
}
