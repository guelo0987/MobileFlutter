import 'dart:convert';
import 'dart:typed_data';

import 'package:dartproyect/models/Banner.dart' as app_banner;
import 'package:dartproyect/models/Category.dart';
import 'package:dartproyect/models/Product.dart';
import 'package:dartproyect/models/SubCategory.dart';
import 'package:dartproyect/services/banner_service.dart';
import 'package:dartproyect/services/category_service.dart';
import 'package:dartproyect/services/product_service.dart';
import 'package:dartproyect/services/subcategory_service.dart';
import 'package:dartproyect/services/user_service.dart';
import 'package:dartproyect/views/AppScreens/AccountScreen.dart';
import 'package:dartproyect/views/AppScreens/CartScreen.dart';
import 'package:dartproyect/views/AppScreens/FavoriteScreen.dart';
import 'package:dartproyect/views/AppScreens/StoresScreen.dart';
import 'package:dartproyect/views/AppScreens/product_detail_screen.dart';
import 'package:dartproyect/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<app_banner.Banner> _banners = [];
  List<Category> _categories = [];
  List<Product> _popularProducts = [];
  List<Product> _recommendedProducts = [];
  Map<String, List<SubCategory>> _subCategoriesMap = {};
  String? _selectedCategoryName;

  bool _isLoadingBanners = false;
  bool _isLoadingCategories = false;
  bool _isLoadingSubCategories = false;
  bool _isLoadingPopularProducts = false;
  bool _isLoadingRecommendedProducts = false;

  @override
  void initState() {
    super.initState();
    _loadBanners();
    _loadCategories();
    _loadPopularProducts();
    _loadRecommendedProducts();

    // Si recibimos datos del usuario desde el login, los guardamos también
    if (widget.user.isNotEmpty) {
      _saveUserData();
    }
  }

  Future<void> _saveUserData() async {
    // Esto asegura que los datos del usuario que vienen del login se guarden en SharedPreferences
    final String? token = await UserService.getToken();
    if (token != null) {
      await UserService.saveToken(token, widget.user);
    }
  }

  Future<void> _loadBanners() async {
    setState(() {
      _isLoadingBanners = true;
    });

    try {
      final banners = await BannerService.getBanners();
      setState(() {
        _banners = banners;
        _isLoadingBanners = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBanners = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final categories = await CategoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;

        // Si hay categorías, seleccionar la primera por defecto
        if (categories.isNotEmpty) {
          _selectedCategoryName = categories.first.name;
          _loadSubCategories(_selectedCategoryName!);
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadPopularProducts() async {
    setState(() {
      _isLoadingPopularProducts = true;
    });

    try {
      final products = await ProductService.getPopularProducts();
      setState(() {
        _popularProducts = products;
        _isLoadingPopularProducts = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPopularProducts = false;
      });
    }
  }

  Future<void> _loadRecommendedProducts() async {
    setState(() {
      _isLoadingRecommendedProducts = true;
    });

    try {
      final products = await ProductService.getRecommendedProducts();
      setState(() {
        _recommendedProducts = products;
        _isLoadingRecommendedProducts = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRecommendedProducts = false;
      });
    }
  }

  Future<void> _loadSubCategories(String categoryName) async {
    // Si ya tenemos subcategorías para esta categoría, no hacemos la petición de nuevo
    if (_subCategoriesMap.containsKey(categoryName)) {
      setState(() {
        _selectedCategoryName = categoryName;
      });
      return;
    }

    setState(() {
      _isLoadingSubCategories = true;
      _selectedCategoryName = categoryName;
    });

    try {
      final subCategories =
          await SubCategoryService.getSubCategories(categoryName);
      setState(() {
        _subCategoriesMap[categoryName] = subCategories;
        _isLoadingSubCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSubCategories = false;
      });
    }
  }

  void logout() async {
    await UserService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Método que construye el contenido de la pestaña de inicio
  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          _loadBanners(),
          _loadCategories(),
          _loadPopularProducts(),
          _loadRecommendedProducts(),
        ]);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '¡Hola, ${widget.user['name'] ?? 'Usuario'}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Banner carousel
            _buildBannerCarousel(),

            // Categories section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoriesSection(),
                ],
              ),
            ),

            // Subcategories section
            if (_selectedCategoryName != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subcategorías de $_selectedCategoryName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSubCategoriesSection(),
                  ],
                ),
              ),

            // Popular products section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Productos Populares',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPopularProductsSection(),
                ],
              ),
            ),

            // Recommended products section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Productos Recomendados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendedProductsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    if (_isLoadingBanners) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    if (_banners.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('No hay banners disponibles'),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: _banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: banner.image.startsWith('data:image')
                        ? Image.memory(
                            _base64ToBytes(banner.image),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                height: 180,
                                width: double.infinity,
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.network(
                            banner.image,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: Colors.orange,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                height: 180,
                                width: double.infinity,
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(
                  entry.key == 0 ? 0.9 : 0.4,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Función para convertir base64 a bytes
  Uint8List _base64ToBytes(String base64String) {
    // Extraer solo la parte de datos
    String dataString = base64String;

    // Verificar si es una cadena data URI y extraer solo la parte de base64
    if (base64String.contains(',')) {
      dataString = base64String.split(',')[1];
    }

    // Decodificar base64 a bytes
    return base64Decode(dataString);
  }

  Widget _buildCategoriesSection() {
    if (_isLoadingCategories) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('No hay categorías disponibles'),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryName == category.name;

          return GestureDetector(
            onTap: () => _loadSubCategories(category.name),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.orange.withOpacity(0.2) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildImageWidget(category.image),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubCategoriesSection() {
    if (_isLoadingSubCategories) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    final subCategories = _subCategoriesMap[_selectedCategoryName] ?? [];

    if (subCategories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('No hay subcategorías disponibles'),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = subCategories[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: _buildImageWidget(subCategory.image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subCategory.subCategoryName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularProductsSection() {
    if (_isLoadingPopularProducts) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    if (_popularProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('No hay productos populares disponibles'),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _popularProducts.length,
        itemBuilder: (context, index) {
          final product = _popularProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildRecommendedProductsSection() {
    if (_isLoadingRecommendedProducts) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    if (_recommendedProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('No hay productos recomendados disponibles'),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recommendedProducts.length,
        itemBuilder: (context, index) {
          final product = _recommendedProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: SizedBox(
                height: 120,
                width: 160,
                child: product.images.isNotEmpty
                    ? _buildImageWidget(product.images.first,
                        boxFit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),
            // Product details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.productPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Disponible: ${product.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl, {BoxFit boxFit = BoxFit.contain}) {
    if (imageUrl.startsWith('data:image')) {
      return Image.memory(
        _base64ToBytes(imageUrl),
        fit: boxFit,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.orange);
        },
      );
    } else {
      return Image.network(
        imageUrl,
        fit: boxFit,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.orange);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomeContent(), // Contenido de inicio (MainScreen es el home)
      const Favoritescreen(),
      const Storesscreen(),
      const Cartscreen(),
      const Accountscreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PediYa', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
            tooltip: 'Buscar',
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
            tooltip: 'Notificaciones',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Tiendas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
        ],
      ),
    );
  }
}
