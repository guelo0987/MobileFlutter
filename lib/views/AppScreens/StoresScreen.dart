import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dartproyect/models/Product.dart';
import 'package:dartproyect/services/product_service.dart';
import 'package:dartproyect/views/AppScreens/product_detail_screen.dart';

class Storesscreen extends StatefulWidget {
  const Storesscreen({super.key});

  @override
  State<Storesscreen> createState() => _StoresscreenState();
}

class _StoresscreenState extends State<Storesscreen>
    with SingleTickerProviderStateMixin {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _searchQuery = '';
  List<String> _categories = [];
  String? _selectedCategory;

  late TabController _tabController;
  final List<String> _tabs = ['Todos', 'Populares', 'Recomendados'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _filterProductsByTab();
      });
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final products = await ProductService.getAllProducts();

      // Extraer categorías únicas
      final Set<String> categoriesSet = {};
      for (var product in products) {
        categoriesSet.add(product.category);
      }

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _categories = categoriesSet.toList()..sort();
        _isLoading = false;
        _filterProductsByTab();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error al cargar productos: $e';
      });
    }
  }

  void _filterProductsByTab() {
    if (_tabController.index == 0) {
      // Todos los productos
      _filteredProducts = _allProducts;
    } else if (_tabController.index == 1) {
      // Solo productos populares
      _filteredProducts =
          _allProducts.where((product) => product.popular).toList();
    } else {
      // Solo productos recomendados
      _filteredProducts =
          _allProducts.where((product) => product.recommend).toList();
    }

    // Aplicar filtro de categoría si hay uno seleccionado
    if (_selectedCategory != null) {
      _filteredProducts = _filteredProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Aplicar búsqueda si hay una consulta
    if (_searchQuery.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((product) =>
              product.productName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              product.category
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              product.subCategory
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      _filterProductsByTab();
    });
  }

  void _selectCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      _filterProductsByTab();
    });
  }

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

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      return Image.memory(
        _base64ToBytes(imageUrl),
        fit: BoxFit.cover,
        height: 120,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: 120,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    }
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
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: product.images.isNotEmpty
                  ? _buildProductImage(product.images[0])
                  : Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.productPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.subCategory,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Disponible: ${product.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              product.quantity > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: const Text(
                          'Añadir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tiendas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProducts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Search and filter
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search bar
                          TextField(
                            onChanged: _searchProducts,
                            decoration: InputDecoration(
                              hintText: 'Buscar productos...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Horizontal category list
                          SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: const Text('Todas'),
                                    selected: _selectedCategory == null,
                                    onSelected: (selected) {
                                      if (selected) {
                                        _selectCategory(null);
                                      }
                                    },
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: Colors.orange[100],
                                    labelStyle: TextStyle(
                                      color: _selectedCategory == null
                                          ? Colors.orange[800]
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                ..._categories.map(
                                  (category) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text(category),
                                      selected: _selectedCategory == category,
                                      onSelected: (selected) {
                                        if (selected) {
                                          _selectCategory(category);
                                        } else {
                                          _selectCategory(null);
                                        }
                                      },
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: Colors.orange[100],
                                      labelStyle: TextStyle(
                                        color: _selectedCategory == category
                                            ? Colors.orange[800]
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Results count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Encontrados: ${_filteredProducts.length} productos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          PopupMenuButton(
                            icon: const Icon(Icons.sort),
                            tooltip: 'Ordenar',
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'price_asc',
                                child: Text('Precio: menor a mayor'),
                              ),
                              const PopupMenuItem(
                                value: 'price_desc',
                                child: Text('Precio: mayor a menor'),
                              ),
                              const PopupMenuItem(
                                value: 'name_asc',
                                child: Text('Nombre: A-Z'),
                              ),
                              const PopupMenuItem(
                                value: 'name_desc',
                                child: Text('Nombre: Z-A'),
                              ),
                            ],
                            onSelected: (value) {
                              setState(() {
                                if (value == 'price_asc') {
                                  _filteredProducts.sort((a, b) =>
                                      a.productPrice.compareTo(b.productPrice));
                                } else if (value == 'price_desc') {
                                  _filteredProducts.sort((a, b) =>
                                      b.productPrice.compareTo(a.productPrice));
                                } else if (value == 'name_asc') {
                                  _filteredProducts.sort((a, b) =>
                                      a.productName.compareTo(b.productName));
                                } else if (value == 'name_desc') {
                                  _filteredProducts.sort((a, b) =>
                                      b.productName.compareTo(a.productName));
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Product grid
                    Expanded(
                      child: _filteredProducts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No se encontraron productos',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Intenta con otros criterios de búsqueda',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadProducts,
                              color: Colors.orange,
                              child: GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return _buildProductCard(
                                      _filteredProducts[index]);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}
