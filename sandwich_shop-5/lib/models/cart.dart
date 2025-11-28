import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;
  final String? notes;

  CartItem({
    required this.sandwich,
    this.quantity = 1,
    this.notes,
  });

  double getPrice(PricingRepository pricingRepository) {
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }
}

class Cart {
  final List<CartItem> _items = [];
  final PricingRepository _pricingRepository;

  Cart({required PricingRepository pricingRepository})
      : _pricingRepository = pricingRepository;

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(CartItem item) {
    _items.remove(item);
  }

  void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  void clear() {
    _items.clear();
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _items.length && newQuantity > 0) {
      _items[index].quantity = newQuantity;
    }
  }

  double getItemPrice(int index) {
    if (index >= 0 && index < _items.length) {
      return _items[index].getPrice(_pricingRepository);
    }
    return 0.0;
  }

  double get totalPrice {
    return _items.fold(
      0.0,
      (sum, item) => sum + item.getPrice(_pricingRepository),
    );
  }

  int countSandwichType(SandwichType type) {
    return _items.where((item) => item.sandwich.type == type).length;
  }

  int countFootlongs() {
    return _items
        .where((item) => item.sandwich.isFootlong)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  int countSixInch() {
    return _items
        .where((item) => !item.sandwich.isFootlong)
        .fold(0, (sum, item) => sum + item.quantity);
  }
}
