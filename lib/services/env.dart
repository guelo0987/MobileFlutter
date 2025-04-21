class Environment {
  static const String apiUrl = 'http://localhost:3000/api';

  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String bannerEndpoint = '/banner';
  static const String categoriesEndpoint = '/categories';
  static const String subCategoriesBaseEndpoint = '/category';
  static const String currentUserEndpoint = '/user/current';
  static const String productsEndpoint = '/products';
  static const String popularProductsEndpoint = '/popular-products';
  static const String recommendedProductsEndpoint = '/recommended-products';
  static const String productByIdBase = '/product';

  // Endpoints constants
  static String get register => '$apiUrl$registerEndpoint';
  static String get login => '$apiUrl$loginEndpoint';
  static String get banner => '$apiUrl$bannerEndpoint';
  static String get categories => '$apiUrl$categoriesEndpoint';
  static String get currentUser => '$apiUrl$currentUserEndpoint';
  static String get products => '$apiUrl$productsEndpoint';
  static String get popularProducts => '$apiUrl$popularProductsEndpoint';
  static String get recommendedProducts =>
      '$apiUrl$recommendedProductsEndpoint';
  static String getProductById(String id) => '$apiUrl$productByIdBase/$id';
  static String getSubcategoriesByCategoryName(String categoryName) =>
      '$apiUrl$subCategoriesBaseEndpoint/$categoryName/subcategories';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Headers with token
  static Map<String, String> getAuthHeaders(String token) => {
        ...headers,
        'Authorization': 'Bearer $token',
      };
}
