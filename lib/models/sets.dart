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
}


class CardCountBrief {
  CardCountBrief({
    required this.total,
    required this.official
  });

  final num total;
  final num official;
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
