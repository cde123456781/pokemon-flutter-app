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

  static Set fromJson(Map<String, Object?> json) {
    String? logo;
    String? symbol;
    CardCount cardCount;
    SerieBrief serie;
    String? tcgOnline;
    Legal legal;
    List<Booster> boosters = [];
    List<CardBrief> cards = [];


    if (json.containsKey("logo")) {
      logo = json["logo"] as String?;
    }

    if (json.containsKey("symbol")) {
      symbol = json["symbol"] as String?;
    }
    
    Map<String, dynamic> cardCountMap = json["cardCount"] as Map<String, dynamic>;
    cardCount = CardCount.fromJson(cardCountMap);
    
    serie = SerieBrief.fromJson(json["serie"] as Map<String, dynamic>);
    


    if (json.containsKey("tcgOnline")) {
      tcgOnline = json["tcgOnline"] as String?;
    }

    legal = Legal.fromJson(json["legal"] as Map<String, dynamic>);

    if (json.containsKey("boosters")) {
      if (json["boosters"] != null) {
        for (var e in boosters as Iterable) {
          boosters.add(Booster.fromJson(e));
        }
      }
    }

    if (json.containsKey("cards")) {
      if (json["cards"] != null) {
        for (var e in json["cards"] as Iterable) {
          cards.add(CardBrief.fromJson(e));
        }
      }
    }

    return Set(
      id: json["id"] as String,
      name: json["name"] as String,
      logo: logo,
      symbol: symbol,
      cardCount: cardCount,
      serie: serie,
      tcgOnline: tcgOnline,
      releaseDate: json["releaseDate"] as String,
      legal: legal,
      boosters: boosters,
      cards: cards

    );


  }
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

  static CardCount fromJson(Map<String, dynamic> json) {
    return CardCount(
      total: json["total"] as num,
      official: json["official"] as num,
      reverse: json["reverse"] as num,
      holo: json["holo"] as num,
      firstEd: json["firstEd"] as num
    );
  }
}

class Legal {
  Legal({
    required this.standard,
    required this.expanded
  });

  final bool standard;
  final bool expanded;


  static Legal fromJson(Map<String, dynamic> json) {
    return Legal(
      standard: json["standard"] as bool,
      expanded: json["expanded"] as bool
    );
  }
}
