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
    required this.boosters,
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
  final List<Booster> boosters;
  final Pricing? pricing;
  final String updated;


  static Map<String, Object?> extractCardJsonValues(Map<String, Object?> json) {
    String? image;
    String? illustrator;
    String? rarity;
    List<Booster> boosters = [];
    Pricing? pricing;


    if (json.containsKey("image")) {
      image = json["image"] as String?;
    }
    if (json.containsKey("illustrator")) {
      illustrator = json["illustrator"] as String?;
    }
    if (json.containsKey("rarity")) {
      rarity = json["rarity"] as String?;
    }
    if (json.containsKey("boosters")) {
      for (var booster in json["boosters"] as Iterable? ?? []) {
        boosters.add(Booster.fromJson(booster));
      }
    }

    if (json.containsKey("pricing")) {
      if (json["pricing"] != null) {
        pricing = Pricing.fromJson(json["pricing"] as Map<String, Object?>);
      }
    }


    return {
      "id": json["id"] as String,
      "localId": json["localId"] as String,
      "name": json["name"] as String,
      "image": image,
      "category": json["category"] as String,
      "illustrator": illustrator,
      "rarity": rarity,
      "set": SetBrief.fromJson(json["set"] as Map<String, Object?>),
      "variants": Variants.fromJson(json["variants"] as Map<String, Object?>),
      "boosters": boosters,
      "pricing": pricing,
      "updated": json["updated"] as String
    };

  }

  factory Card.fromJson(Map<String, Object?> json) {
    final category = json["category"] as String;
    if (category == "Pokemon") {
      return PokemonCard.fromJson(json);
    } else if (category == "Energy") {
      return EnergyCard.fromJson(json);
    } else {
      return TrainerCard.fromJson(json);
    }
  }
  
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

  static Booster fromJson(Map<String, Object?> json) {
    String? logo;
    String? artworkBack;
    String? artworkFront;

    if (json.containsKey("logo")) {
      logo = json["logo"] as String?;
    }
    if (json.containsKey("artworkBack")) {
      artworkBack = json["artworkBack"] as String?;
    }
    if (json.containsKey("artworkFront")) {
      artworkFront = json["artworkFront"] as String?;
    }

    return Booster(
      id: json["id"] as String,
      name: json["name"] as String,
      logo: logo,
      artworkBack: artworkBack,
      artworkFront: artworkFront
    );
  }
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

  static Variants fromJson(Map<String, Object?> json) {
    return Variants(
      normal: json["normal"] as bool,
      reverse: json["reverse"] as bool,
      holo: json["holo"] as bool,
      firstEdition: json["firstEdition"] as bool
    );
  }
}



class Pricing {
  Pricing({
    this.tcgplayer,
    this.cardmarket
  });

  final TCGPlayer? tcgplayer;
  final Cardmarket? cardmarket;

  static Pricing fromJson(Map<String, Object?> json) {
    TCGPlayer? tcgPlayer;
    Cardmarket? cardmarket;


    if (json.containsKey("cardmarket")) {
      if (json["cardmarket"] != null) {
        cardmarket = Cardmarket.fromJson(json["cardmarket"] as Map<String, Object?>);
      }
    }


    if (json.containsKey("tcgplayer")) {
      if (json["tcgplayer"] != null) {
        tcgPlayer = TCGPlayer.fromJson(json["tcgplayer"] as Map<String, Object?>);
      }
    }


    return Pricing(
      cardmarket: cardmarket,
      tcgplayer: tcgPlayer
    );
  }
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


  final String updated;
  final String unit;
  final TCGPlayerVariant? normal;
  final TCGPlayerVariant? holofoil;
  final TCGPlayerVariant? reverseHolofoil;
  final TCGPlayerVariant? firstEdition;
  final TCGPlayerVariant? firstEditionHolofoil;
  final TCGPlayerVariant? unlimited;
  final TCGPlayerVariant? unlimitedHolofoil;

  static TCGPlayer fromJson(Map<String, Object?> json) {
    TCGPlayerVariant? normal;
    TCGPlayerVariant? holofoil;
    TCGPlayerVariant? reverseHolofoil;
    TCGPlayerVariant? firstEdition;
    TCGPlayerVariant? firstEditionHolofoil;
    TCGPlayerVariant? unlimited;
    TCGPlayerVariant? unlimitedHolofoil;

    if (json.containsKey("normal")) {
      if (json["normal"] != null) {
        normal = TCGPlayerVariant.fromJson(json["normal"] as Map<String, Object?>);
      }
    }
    if (json.containsKey("holofoil")) {
      if (json["holofoil"] != null) {
        holofoil = TCGPlayerVariant.fromJson(json["holofoil"] as Map<String, Object?>);
      }
    }
    if (json.containsKey("reverse-holofoil")) {
      if (json["reverse-holofoil"] != null) {
        reverseHolofoil = TCGPlayerVariant.fromJson(json["reverse-holofoil"] as Map<String, Object?>);
      }
    }
    if (json.containsKey("1st-edition")) {
      if (json["1st-edition"] != null) {
        firstEdition = TCGPlayerVariant.fromJson(json["1st-edition"] as Map<String, Object?>);
      }
    }
    if (json.containsKey("1st-edition-holofoil")) {
      if (json["1st-edition-holofoil"] != null) {
        firstEditionHolofoil = TCGPlayerVariant.fromJson(json["1st-edition-holofoil"] as Map<String, Object?>);
      }
    }
    if (json.containsKey("unlimited")) {
      if (json["unlimited"] != null) {
        unlimited = TCGPlayerVariant.fromJson(json["unlimited"] as Map<String, Object?>);
      }
    }
    if (json.containsKey("unlimited-holofoil")) {
      if (json["unlimited-holofoil"] != null) {
        unlimitedHolofoil = TCGPlayerVariant.fromJson(json["unlimited-holofoil"] as Map<String, Object?>);
      }
    }

    return TCGPlayer(
      unit: json["unit"] as String,
      updated: json["updated"] as String,
      normal: normal,
      holofoil: holofoil,
      reverseHolofoil: reverseHolofoil,
      firstEdition: firstEdition,
      firstEditionHolofoil: firstEditionHolofoil,
      unlimited: unlimited,
      unlimitedHolofoil: unlimitedHolofoil
    );


  }

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

  static TCGPlayerVariant fromJson(Map<String, Object?> json) {
    num? lowPrice;
    num? midPrice;
    num? highPrice;
    num? marketPrice;
    num? directLowPrice;

    if (json.containsKey("lowPrice")) {
      lowPrice = json["lowPrice"] as num?;
    }
    if (json.containsKey("midPrice")) {
      midPrice = json["midPrice"] as num?;
    }
    if (json.containsKey("highPrice")) {
      highPrice = json["highPrice"] as num?;
    }
    if (json.containsKey("marketPrice")) {
      marketPrice = json["marketPrice"] as num?;
    }
    if (json.containsKey("directLowPrice")) {
      directLowPrice = json["directLowPrice"] as num?;
    }


    return TCGPlayerVariant(
      lowPrice: lowPrice,
      midPrice: midPrice,
      highPrice: highPrice,
      marketPrice: marketPrice,
      directLowPrice: directLowPrice
    );
  }
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

  final String? updated;
  final String? unit;
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


  static Cardmarket fromJson(Map<String, Object?> json) {
    String? updated;
    String? unit;
    num? avg;
    num? low;
    num? trend;
    num? avg1;
    num? avg7;
    num? avg30;
    num? avgHolo;
    num? lowHolo;
    num? trendHolo;
    num? avg1Holo;
    num? avg7Holo;
    num? avg30Holo;


    if (json.containsKey("updated")) {
      updated = json["updated"] as String?;
    }
    if (json.containsKey("unit")) {
      unit = json["unit"] as String?;
    }
    if (json.containsKey("avg")) {
      avg = json["avg"] as num?;
    }
    if (json.containsKey("low")) {
      low = json["low"] as num?;
    }
    if (json.containsKey("trend")) {
      trend = json["trend"] as num?;
    }
    if (json.containsKey("avg1")) {
      avg1 = json["avg1"] as num?;
    }
    if (json.containsKey("avg7")) {
      avg7 = json["avg7"] as num?;
    }
    if (json.containsKey("avg30")) {
      avg30 = json["avg30"] as num?;
    }
    if (json.containsKey("avg-holo")) {
      avgHolo = json["avg-holo"] as num?;
    }
    if (json.containsKey("low-holo")) {
      lowHolo = json["low-holo"] as num?;
    }
    if (json.containsKey("trend-holo")) {
      trendHolo = json["trend-holo"] as num?;
    }
    if (json.containsKey("avg1-holo")) {
      avg1Holo = json["avg1-holo"] as num?;
    }
    if (json.containsKey("avg7-holo")) {
      avg7Holo = json["avg7-holo"] as num?;
    }
    if (json.containsKey("avg30-holo")) {
      avg30Holo = json["avg30-holo"] as num?;
    }


    return Cardmarket(
      updated: updated,
      unit: unit,
      avg: avg,
      low: low,
      trend: trend,
      avg1: avg1,
      avg7: avg7,
      avg30: avg30,
      avgHolo: avgHolo,
      lowHolo: lowHolo,
      trendHolo: trendHolo,
      avg1Holo: avg1Holo,
      avg7Holo: avg7Holo,
      avg30Holo: avg30Holo

    );
  }

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
    required super.boosters,
    super.pricing,
    required super.updated,


    required this.dexId,
    this.hp,  
    required this.types,
    this.evolveFrom,
    this.description,
    this.level,
    this.stage,
    this.suffix,
    this.item,
     
  });


  final List<num> dexId;
  final num? hp;
  final List<String> types;
  final String? evolveFrom;
  final String? description;
  final String? level;
  final String? stage;
  final String? suffix;
  final Item? item;

  static PokemonCard fromJson(Map<String, Object?> json) {
    final cardDetails = Card.extractCardJsonValues(json);


    List<num> dexId = [];
    num? hp;
    List<String> types = [];
    String? evolveFrom;
    String? description;
    String? level;
    String? stage;
    String? suffix;
    Item? item;

    if (json.containsKey("dexId")) {
      for (var i in json["dexId"] as Iterable? ?? []) {
        dexId.add(i);
      }
    }

    if (json.containsKey("hp")) {
      hp = json["hp"] as num?;
    }
    if (json.containsKey("types")) {
      for (var i in json["types"] as Iterable? ?? []) {
        types.add(i);
      }
    }
    if (json.containsKey("evolveFrom")) {
      evolveFrom = json["evolveFrom"] as String?;
    }
    if (json.containsKey("description")) {
      description = json["description"] as String?;
    }
    if (json.containsKey("level")) {
      level = json["level"] as String?;
    }
    if (json.containsKey("stage")) {
      stage = json["stage"] as String?;
    }
    if (json.containsKey("suffix")) {
      suffix = json["suffix"] as String?;
    }
    if (json.containsKey("item")) {
      if (json["item"] != null) {
        item = Item.fromJson(json["item"] as Map<String, Object?>);
      }
    }

  

    
    
    return PokemonCard(
      id: cardDetails["id"] as String, 
      localId: cardDetails["localId"] as String, 
      name: cardDetails["name"] as String, 
      image: cardDetails["image"] as String?, 
      category: "Pokemon",
      illustrator: cardDetails["illustrator"] as String?,
      rarity: cardDetails["rarity"] as String?,
      set: cardDetails["set"] as SetBrief,
      variants: cardDetails["variants"] as Variants,
      boosters: cardDetails["boosters"] as List<Booster>,
      pricing: cardDetails["pricing"] as Pricing?,
      updated: cardDetails["updated"] as String,

      dexId: dexId,
      hp: hp,
      types: types,
      evolveFrom: evolveFrom,
      description: description,
      level: level,
      stage: stage,
      suffix: suffix,
      item: item
    );
  }
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
    required super.boosters,
    super.pricing,
    required super.updated,

    
    this.effect,
    required this.energyType
     
  });


  final String? effect;
  final String? energyType;

  static EnergyCard fromJson(Map<String, Object?> json) {
    final cardDetails = Card.extractCardJsonValues(json);

    String? effect;
    String? energyType;
    
    if (json.containsKey("effect")) {
      effect = json["effect"] as String?;
    }

    if (json.containsKey("energyType")) {
      energyType = json["energyType"] as String?;
    }

    return EnergyCard(
      id: cardDetails["id"] as String, 
      localId: cardDetails["localId"] as String, 
      name: cardDetails["name"] as String, 
      image: cardDetails["image"] as String?, 
      category: "Energy",
      illustrator: cardDetails["illustrator"] as String?,
      rarity: cardDetails["rarity"] as String?,
      set: cardDetails["set"] as SetBrief,
      variants: cardDetails["variants"] as Variants,
      boosters: cardDetails["boosters"] as List<Booster>,
      pricing: cardDetails["pricing"] as Pricing?,
      updated: cardDetails["updated"] as String,

      effect: effect,
      energyType: energyType
    );

  }
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
    required super.boosters,
    super.pricing,
    required super.updated,

    
    this.effect,
    required this.trainerType
     
  });


  final String? effect;
  final String? trainerType;


  static TrainerCard fromJson(Map<String, Object?> json) {
    final cardDetails = Card.extractCardJsonValues(json);

    String? effect;
    String? trainerType;
    
    if (json.containsKey("effect")) {
      effect = json["effect"] as String?;
    }

    if (json.containsKey("trainerType")) {
      trainerType = json["trainerType"] as String?;
    }

    return TrainerCard(
      id: cardDetails["id"] as String, 
      localId: cardDetails["localId"] as String, 
      name: cardDetails["name"] as String, 
      image: cardDetails["image"] as String?, 
      category: "Trainer",
      illustrator: cardDetails["illustrator"] as String?,
      rarity: cardDetails["rarity"] as String?,
      set: cardDetails["set"] as SetBrief,
      variants: cardDetails["variants"] as Variants,
      boosters: cardDetails["boosters"] as List<Booster>,
      pricing: cardDetails["pricing"] as Pricing?,
      updated: cardDetails["updated"] as String,

      effect: effect,
      trainerType: trainerType
    );

  }
  
}



class Item {
  Item({
    required this.name,
    required this.effect
  });

  final String name;
  final String effect;

  static Item fromJson(Map<String, Object?> json) {
    return Item(
      name: json["name"] as String,
      effect: json["effect"] as String
    );
  }
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