import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('SandwichType', () {
    test('has correct number of values', () {
      expect(SandwichType.values.length, 4);
    });

    test('contains all expected values', () {
      expect(SandwichType.values, contains(SandwichType.veggieDelight));
      expect(SandwichType.values, contains(SandwichType.chickenTeriyaki));
      expect(SandwichType.values, contains(SandwichType.tunaMelt));
      expect(SandwichType.values, contains(SandwichType.meatballMarinara));
    });

    test('has correct enum names', () {
      expect(SandwichType.veggieDelight.name, 'veggieDelight');
      expect(SandwichType.chickenTeriyaki.name, 'chickenTeriyaki');
      expect(SandwichType.tunaMelt.name, 'tunaMelt');
      expect(SandwichType.meatballMarinara.name, 'meatballMarinara');
    });

    test('can be accessed by index', () {
      expect(SandwichType.values[0], SandwichType.veggieDelight);
      expect(SandwichType.values[1], SandwichType.chickenTeriyaki);
      expect(SandwichType.values[2], SandwichType.tunaMelt);
      expect(SandwichType.values[3], SandwichType.meatballMarinara);
    });
  });

  group('Sandwich', () {
    test('creates a sandwich with correct properties', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      expect(sandwich.type, SandwichType.veggieDelight);
      expect(sandwich.isFootlong, true);
      expect(sandwich.breadType, BreadType.white);
    });

    test('returns correct name for Veggie Delight', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      expect(sandwich.name, 'Veggie Delight');
    });

    test('returns correct name for Chicken Teriyaki', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      expect(sandwich.name, 'Chicken Teriyaki');
    });

    test('returns correct name for Tuna Melt', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      expect(sandwich.name, 'Tuna Melt');
    });

    test('returns correct name for Meatball Marinara', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.white,
      );

      expect(sandwich.name, 'Meatball Marinara');
    });

    test('returns correct image path for footlong sandwich', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      expect(sandwich.image, 'assets/images/chickenTeriyaki_footlong.png');
    });

    test('returns correct image path for six-inch sandwich', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.white,
      );

      expect(sandwich.image, 'assets/images/tunaMelt_six_inch.png');
    });

    test('image paths are consistent with enum names', () {
      for (var sandwichType in SandwichType.values) {
        final footlong = Sandwich(
          type: sandwichType,
          isFootlong: true,
          breadType: BreadType.white,
        );
        final sixInch = Sandwich(
          type: sandwichType,
          isFootlong: false,
          breadType: BreadType.white,
        );

        expect(
            footlong.image, 'assets/images/${sandwichType.name}_footlong.png');
        expect(
            sixInch.image, 'assets/images/${sandwichType.name}_six_inch.png');
      }
    });
  });
}
