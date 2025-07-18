class ApiConstants {
  static const String baseURLVPN = 'https://9d2a-190-2-152-251.ngrok-free.app';
  static const String baseUrl = 'http://192.168.50.151:8000/api/';
  static const String STORAGE_URL = "http://192.168.1.6.151:8000";
  static const String register = '${baseUrl}signup';
  static const String login = '${baseUrl}login';
  static const String getcat = '${baseUrl}showCategories';
  static const String getTrend = '${baseUrl}trending';
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
  static const String nearBranch = '${baseUrl}nearest-branch';
  static const String delprice = '${baseUrl}getDeliveryPrice';
  static const String confirmcartdel = '${baseUrl}confirmCart';
  static const String walletBal = '${baseUrl}wallet_balance';
  static const String topup = '${baseUrl}ChargeInvestmentWallet';
  static const String allorders = '${baseUrl}GetAllOrders';
  static const String showpro = '${baseUrl}showProfile';
  static const String updateuser = '${baseUrl}updateProfile';
}
