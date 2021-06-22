enum EveromentServer { DEV, PRODUCT }
EveromentServer eServer = EveromentServer.DEV;
final String domainServer = eServer == EveromentServer.DEV ? 'http://mode-game.e-tech.network/' : 'mode-game.e-tech.network';

class API {
  //- path : Service
  static const String allProduct = "/admin-trival-game";
  static const String createProduct = "/admin-trival-game/create-product";
  static const String updateProduct = "/admin-trival-game/update-product";
  static const String updateStatusCate = "/admin-trival-game/update-status-cate";
  static const String deleteProduct = "/admin-trival-game/delete-product";
}
