import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    // Check if product is already in cart
    final existingIndex =
        state.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // If product exists, increase quantity
      final updatedCart = List<CartItem>.from(state);
      updatedCart[existingIndex].quantity++;
      state = updatedCart;
    } else {
      // If product doesn't exist, add new cart item
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void updateQuantity(Product product, int quantity) {
    final updatedCart = state.map((item) {
      if (item.product.id == product.id) {
        return CartItem(product: product, quantity: quantity);
      }
      return item;
    }).toList();

    state = updatedCart;
  }

  double getTotalPrice() {
    return state.fold(
        0,
        (total, item) =>
            total + (item.product.discountedPrice * item.quantity));
  }

  // New method to clear the cart
  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
