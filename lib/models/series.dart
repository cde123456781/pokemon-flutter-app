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

  static Serie fromJson(Map<String, Object?> json) {
    String? logo;
    List<SetBrief> sets = [];

    if (json.containsKey("logo")) {
      logo = json["logo"] as String?;
    }

    for (var e in json["sets"] as Iterable) {
      sets.add(SetBrief.fromJson(e));
    }

  

    Serie serie = Serie(
      id: json["id"] as String,
      name: json["name"] as String,
      logo: logo,
      sets: sets
    );
    
    return serie;
  }
}

class SerieBrief {
  SerieBrief({
    required this.id,
    required this.name
  });

  final String id;
  final String name;
}