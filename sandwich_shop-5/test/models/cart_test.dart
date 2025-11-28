import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  late PricingRepository pricingRepository;
  late Cart cart;

  setUp(() {
    pricingRepository = PricingRepository();
    cart = Cart(pricingRepository: pricingRepository);
  });

  group('CartItem', () {
    test('creates cart item with default quantity of 1', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final cartItem = CartItem(sandwich: sandwich);

      expect(cartItem.quantity, 1);
      expect(cartItem.sandwich, sandwich);
      expect(cartItem.notes, isNull);
    });

    test('creates cart item with custom quantity and notes', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      final cartItem = CartItem(
        sandwich: sandwich,
        quantity: 3,
        notes: 'No pickles',
      );

      expect(cartItem.quantity, 3);
      expect(cartItem.notes, 'No pickles');
    });

    test('calculates price for footlong sandwich', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      final cartItem = CartItem(sandwich: sandwich, quantity: 2);

      final price = cartItem.getPrice(pricingRepository);
      expect(price, 22.00); // 2 * 11.00
    });

    test('calculates price for six-inch sandwich', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.white,
      );
      final cartItem = CartItem(sandwich: sandwich, quantity: 3);

      final price = cartItem.getPrice(pricingRepository);
      expect(price, 21.00); // 3 * 7.00
    });
  });

  group('Cart - Initialization', () {
    test('creates empty cart', () {
      expect(cart.isEmpty, true);
      expect(cart.isNotEmpty, false);
      expect(cart.items.length, 0);
      expect(cart.totalItems, 0);
      expect(cart.totalPrice, 0.0);
    });
  });

  group('Cart - Add Items', () {
    test('adds single item to cart', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final cartItem = CartItem(sandwich: sandwich);

      cart.addItem(cartItem);

      expect(cart.isEmpty, false);
      expect(cart.isNotEmpty, true);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 1);
    });

    test('adds multiple items to cart', () {
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.addItem(CartItem(sandwich: sandwich1, quantity: 2));
      cart.addItem(CartItem(sandwich: sandwich2, quantity: 3));

      expect(cart.items.length, 2);
      expect(cart.totalItems, 5); // 2 + 3
    });
  });

  group('Cart - Remove Items', () {
    test('removes item from cart', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      final cartItem = CartItem(sandwich: sandwich);

      cart.addItem(cartItem);
      expect(cart.items.length, 1);

      cart.removeItem(cartItem);
      expect(cart.isEmpty, true);
      expect(cart.items.length, 0);
    });

    test('removes item by index', () {
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.addItem(CartItem(sandwich: sandwich1));
      cart.addItem(CartItem(sandwich: sandwich2));

      cart.removeAt(0);
      expect(cart.items.length, 1);
      expect(cart.items[0].sandwich.type, SandwichType.chickenTeriyaki);
    });

    test('handles invalid index when removing', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      cart.addItem(CartItem(sandwich: sandwich));

      cart.removeAt(-1);
      expect(cart.items.length, 1);

      cart.removeAt(10);
      expect(cart.items.length, 1);
    });

    test('clears all items from cart', () {
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ),
      ));
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
        ),
      ));

      expect(cart.items.length, 2);

      cart.clear();
      expect(cart.isEmpty, true);
      expect(cart.items.length, 0);
    });
  });

  group('Cart - Update Quantity', () {
    test('updates quantity of item at index', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(CartItem(sandwich: sandwich, quantity: 2));

      cart.updateQuantity(0, 5);
      expect(cart.items[0].quantity, 5);
      expect(cart.totalItems, 5);
    });

    test('does not update quantity with invalid index', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.addItem(CartItem(sandwich: sandwich, quantity: 2));

      cart.updateQuantity(-1, 5);
      expect(cart.items[0].quantity, 2);

      cart.updateQuantity(10, 5);
      expect(cart.items[0].quantity, 2);
    });

    test('does not update quantity to zero or negative', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(CartItem(sandwich: sandwich, quantity: 3));

      cart.updateQuantity(0, 0);
      expect(cart.items[0].quantity, 3);

      cart.updateQuantity(0, -5);
      expect(cart.items[0].quantity, 3);
    });
  });

  group('Cart - Price Calculations', () {
    test('calculates total price for single item', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(CartItem(sandwich: sandwich, quantity: 2));

      expect(cart.totalPrice, 22.00); // 2 * 11.00
    });

    test('calculates total price for multiple items', () {
      final footlong = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      final sixInch = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.addItem(CartItem(sandwich: footlong, quantity: 2));
      cart.addItem(CartItem(sandwich: sixInch, quantity: 3));

      expect(cart.totalPrice, 43.00); // (2 * 11.00) + (3 * 7.00)
    });

    test('gets item price by index', () {
      final footlong = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      final sixInch = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.addItem(CartItem(sandwich: footlong, quantity: 3));
      cart.addItem(CartItem(sandwich: sixInch, quantity: 2));

      expect(cart.getItemPrice(0), 33.00); // 3 * 11.00
      expect(cart.getItemPrice(1), 14.00); // 2 * 7.00
    });

    test('returns 0 for invalid index when getting item price', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(CartItem(sandwich: sandwich, quantity: 1));

      expect(cart.getItemPrice(-1), 0.0);
      expect(cart.getItemPrice(10), 0.0);
    });
  });

  group('Cart - Statistics', () {
    test('counts sandwich types correctly', () {
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ),
      ));
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.wheat,
        ),
      ));
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wholemeal,
        ),
      ));

      expect(cart.countSandwichType(SandwichType.veggieDelight), 2);
      expect(cart.countSandwichType(SandwichType.chickenTeriyaki), 1);
      expect(cart.countSandwichType(SandwichType.tunaMelt), 0);
    });

    test('counts footlong sandwiches correctly', () {
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ),
        quantity: 2,
      ));
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat,
        ),
        quantity: 3,
      ));
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wholemeal,
        ),
        quantity: 4,
      ));

      expect(cart.countFootlongs(), 5); // 2 + 3
    });

    test('counts six-inch sandwiches correctly', () {
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        ),
        quantity: 2,
      ));
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat,
        ),
        quantity: 3,
      ));
      cart.addItem(CartItem(
        sandwich: Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wholemeal,
        ),
        quantity: 4,
      ));

      expect(cart.countSixInch(), 6); // 2 + 4
    });
  });

  group('Cart - Immutability', () {
    test('items list is unmodifiable', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(CartItem(sandwich: sandwich));

      final items = cart.items;
      expect(() => items.add(CartItem(sandwich: sandwich)),
          throwsUnsupportedError);
    });
  });
}
