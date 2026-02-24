import 'package:pokemon_app/models/sets.dart';

abstract class Card {
  Card({
    required this.id,
    required this.localId,
    required this.name,
    this.image,
    required this.category,
    this.illustrator,
    this.rarity,
    required this.set,
    required this.variants,
    this.boosters,
    this.pricing,
    required this.updated,
  });

  final String id;
  final String localId;
  final String name;
  final String? image;
  final String category;
  final String? illustrator;
  final String? rarity;
  final SetBrief set;
  final Variants variants;
  final List<Booster>? boosters;
  final Pricing? pricing;
  final String updated;

}


class Booster {
  Booster({
    required this.id,
    required this.name,
    this.logo,
    this.artworkFront,
    this.artworkBack
  });

  final String id;
  final String name;
  final String? logo;
  final String? artworkFront;
  final String? artworkBack;
}

class Variants {
  Variants({
    required this.normal,
    required this.reverse,
    required this.holo,
    required this.firstEdition,
  });

  final bool normal;
  final bool reverse;
  final bool holo;
  final bool firstEdition;
}



class Pricing {
  Pricing({
    this.tcgplayer,
    this.cardmarket
  });

  final TCGPlayer? tcgplayer;
  final Cardmarket? cardmarket;
}

class TCGPlayer {
  TCGPlayer({
    required this.updated,
    required this.unit,
    this.normal,
    this.holofoil,
    this.reverseHolofoil,
    this.firstEdition,
    this.firstEditionHolofoil,
    this.unlimited,
    this.unlimitedHolofoil

  });


  final num updated;
  final num unit;
  final TCGPlayerVariant? normal;
  final TCGPlayerVariant? holofoil;
  final TCGPlayerVariant? reverseHolofoil;
  final TCGPlayerVariant? firstEdition;
  final TCGPlayerVariant? firstEditionHolofoil;
  final TCGPlayerVariant? unlimited;
  final TCGPlayerVariant? unlimitedHolofoil;

}

class TCGPlayerVariant {
  TCGPlayerVariant({
    this.lowPrice,
    this.midPrice,
    this.highPrice,
    this.marketPrice,
    this.directLowPrice
  });

  final num? lowPrice;
  final num? midPrice;
  final num? highPrice;
  final num? marketPrice;
  final num? directLowPrice;
}


class Cardmarket {
  Cardmarket({
    this.updated,
    this.unit,
    this.avg,
    this.low,
    this.trend,
    this.avg1,
    this.avg7,
    this.avg30,
    this.avgHolo,
    this.lowHolo,
    this.trendHolo,
    this.avg1Holo,
    this.avg7Holo,
    this.avg30Holo
  });

  final num? updated;
  final num? unit;
  final num? avg;
  final num? low;
  final num? trend;
  final num? avg1;
  final num? avg7;
  final num? avg30;
  final num? avgHolo;
  final num? lowHolo;
  final num? trendHolo;
  final num? avg1Holo;
  final num? avg7Holo;
  final num? avg30Holo;


}


class PokemonCard extends Card {
  PokemonCard({
    required super.id,
    required super.localId,
    required super.name,
    super.image,
    super.category="Pokemon",
    super.illustrator,
    super.rarity,
    required super.set,
    required super.variants,
    super.boosters,
    super.pricing,
    required super.updated,


    this.dexId,
    this.hp,
    this.types,
    this.evolveFrom,
    this.description,
    this.level,
    this.stage,
    this.suffix,
    this.item,
     
  });


  final List<num>? dexId;
  final num? hp;
  final List<String>? types;
  final String? evolveFrom;
  final String? description;
  final String? level;
  final String? stage;
  final String? suffix;
  final Item? item;
}

class EnergyCard extends Card {
  EnergyCard({
    required super.id,
    required super.localId,
    required super.name,
    super.image,
    super.category="Energy",
    super.illustrator,
    super.rarity,
    required super.set,
    required super.variants,
    super.boosters,
    super.pricing,
    required super.updated,

    
    required this.effect,
    required this.energyType
     
  });


  final String effect;
  final String energyType;
}

class TrainerCard extends Card {
  TrainerCard({
    required super.id,
    required super.localId,
    required super.name,
    super.image,
    super.category="Trainer",
    super.illustrator,
    super.rarity,
    required super.set,
    required super.variants,
    super.boosters,
    super.pricing,
    required super.updated,

    
    required this.effect,
    required this.trainerType
     
  });


  final String effect;
  final String trainerType;
}



class Item {
  Item({
    required this.name,
    required this.effect
  });

  final String name;
  final String effect;
}

class CardBrief {
  CardBrief({
    required this.id,
    required this.localId,
    required this.name,
    this.image
  });

  final String id;
  final String localId;
  final String name;
  final String? image;

  static CardBrief fromJson(Map<String, Object?> json) {
    String? image;
    if (json.containsKey("image")) {
      image = json["image"] as String?;
    }

    

    CardBrief cardBrief = CardBrief(
      id: json["id"] as String,
      localId: json["localId"] as String,
      name: json["name"] as String,
      image: image
    );
    
    return cardBrief;
  }
}