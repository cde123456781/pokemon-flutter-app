import 'package:pokemon_app/models/sets.dart';

class Serie {
  Serie({
    required this.id,
    required this.name,
    this.logo,
    required this.sets
  });


  final String id;
  final String name;
  final String? logo;
  final List<SetBrief> sets;
}

class SerieBrief {
  SerieBrief({
    required this.id,
    required this.name
  });

  final String id;
  final String name;
}