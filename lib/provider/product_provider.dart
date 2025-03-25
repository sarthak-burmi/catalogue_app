import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/models/product_model.dart';
import 'package:shopping_app/services/product_services.dart';

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;
  int _currentPage = 1;
  final int _limit = 30;
  bool _hasMore = true;

  ProductsNotifier(this._productService) : super(const AsyncValue.loading());

  Future<void> fetchInitialProducts() async {
    try {
      state = const AsyncValue.loading();
      final products =
          await _productService.fetchProducts(_currentPage, limit: _limit);
      state = AsyncValue.data(products);
      _currentPage++;
      _hasMore = products.length == _limit;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> fetchMoreProducts() async {
    if (!_hasMore) return;

    try {
      final currentProducts = state.asData?.value ?? [];
      final newProducts =
          await _productService.fetchProducts(_currentPage, limit: _limit);

      if (newProducts.isNotEmpty) {
        state = AsyncValue.data([...currentProducts, ...newProducts]);
        _currentPage++;
        _hasMore = newProducts.length == _limit;
      } else {
        _hasMore = false;
      }
    } catch (error, stackTrace) {
      // Handle error without changing the current state
    }
  }
}

// Update the provider initialization
final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  final productService = ref.watch(productServiceProvider);
  final notifier = ProductsNotifier(productService);
  notifier.fetchInitialProducts(); // Fetch initial 10 items
  return notifier;
});
