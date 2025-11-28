enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
  });

  String get name {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    const String base = 'assets/images/';
    switch (type) {
      case SandwichType.chickenTeriyaki:
        return base +
            (isFootlong
                ? 'chickenTeriyaki_footlong.jpg'
                : 'chickenTeriyaki_six_inch.jpg');
      case SandwichType.tunaMelt:
        return base +
            (isFootlong ? 'tunaMelt_footlong.jpeg' : 'tunaMelt_six_inch.jpeg');
      case SandwichType.meatballMarinara:
        return base +
            (isFootlong
                ? 'Meetball_Marinara_footlong.jpeg'
                : 'Meetball_Marinara_six_inch.jpg');
      case SandwichType.veggieDelight:
        return base +
            (isFootlong
                ? 'veggieDelight_footlong.webp'
                : 'veggieDelight_six_inch.jpeg');
    }
  }
}
