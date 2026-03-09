import 'package:pokemon_app/models/cards.dart';
import 'package:pokemon_app/models/series.dart';

class Set {
  Set({
    required this.id,
    required this.name,
    this.logo,
    this.symbol,
    required this.cardCount,
    required this.serie,
    this.tcgOnline,
    required this.releaseDate,
    required this.legal,
    this.boosters,
    required this.cards

  });

  final String id;
  final String name;
  final String? logo;
  final String? symbol;
  final CardCount cardCount;
  final SerieBrief serie;
  final String? tcgOnline;
  final String releaseDate;
  final Legal legal;
  final List<Booster>? boosters;
  final List<CardBrief> cards;
}

class SetBrief {
  SetBrief({
    required this.id,
    required this.name,
    this.logo,
    this.symbol,
    required this.cardCount
  });

  final String id;
  final String name;
  final String? logo;
  final String? symbol;
  final CardCountBrief cardCount;


  static SetBrief fromJson(Map<String, Object?> json) {
    String? logo;
    String? symbol;
    CardCountBrief cardCountBrief;
    if (json.containsKey("logo")) {
      logo = json["logo"] as String?;
    }

    if (json.containsKey("symbol")) {
      symbol = json["symbol"] as String?;
    }

    cardCountBrief = CardCountBrief.fromJson(json["cardCount"] as Map<String, Object?>);

    

    SetBrief setBrief = SetBrief(
      id: json["id"] as String,
      name: json["name"] as String,
      logo: logo,
      symbol: symbol,
      cardCount: cardCountBrief
    );
    
    return setBrief;
  }
}


class CardCountBrief {
  CardCountBrief({
    required this.total,
    required this.official
  });

  final num total;
  final num official;

  static CardCountBrief fromJson(Map<String, Object?> json) {
    return CardCountBrief(total: json["total"] as num, official: json["official"] as num);
  }

}


class CardCount {
  CardCount({
    required this.total,
    required this.official,
    required this.reverse,
    required this.holo,
    required this.firstEd,

  });

  final num total;
  final num official;
  final num reverse;
  final num holo;
  final num firstEd;
}

class Legal {
  Legal({
    required this.standard,
    required this.expanded
  });

  final bool standard;
  final bool expanded;
}
