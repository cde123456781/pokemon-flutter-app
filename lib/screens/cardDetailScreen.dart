import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import "dart:convert";

import 'package:pokemon_app/models/cards.dart' as cards;
import 'package:pokemon_app/widgets/appContainer.dart';
import 'package:pokemon_app/widgets/loadingIndicator.dart';


class CardService {
  Future<cards.Card> fetchCard(String id) async {
    final uri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/cards/$id",
    );


    final response = await get(uri);
    cards.Card card;

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      card = cards.Card.fromJson(body);
      print(card);
      print(card is cards.PokemonCard);
      return card;
    } else {
      throw HttpException("Failed to update resource");
    }

  }
}



class CardViewModel extends ChangeNotifier {
  final CardService _service = CardService();
  String? errorMessage;
  bool loading = false;

  cards.Card? _card;

  cards.Card? get card => _card;

  CardViewModel(String id) {
    getCard(id);
  }

  Future<void> getCard(String id) async {
    loading = true;
    notifyListeners();
    try {
      _card = await _service.fetchCard(id);
      errorMessage = null;


    } on HttpException catch (error) {
      errorMessage = error.message;

      print('Error loading article: ${error.message}');
    }

    loading = false;
    notifyListeners();
  }
}



class CardView extends StatelessWidget {
  const CardView({super.key, this.goRouterState});

  final GoRouterState? goRouterState;


  

  @override
  Widget build(BuildContext context) {
    final String cardId = goRouterState!.pathParameters["cardId"] as String;
    final CardViewModel viewModel = CardViewModel(cardId);
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: BackButton(onPressed: () => context.pop(),),
        ),
        Expanded(child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return switch ((
                viewModel.loading,
                viewModel.card,
                viewModel.errorMessage
              )) {
                (true, _, _) => LoadingIndicator(),
                (false, null, _) => Center(child: Text("Card does not exist")),
                (false, _, String message) => Center(child: Text(message)),
                (false, cards.Card card, null) => 
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      if (card is cards.PokemonCard) {
                        return PokemonPhonePage(card: card,);
                      } else {
                        return Text("");

                      }

                    } else {
                      if (card is cards.PokemonCard) {
                        return PokemonWidePage(card: card);

                      } else {
                        return EnergyWidePage(card: card);
                      }

                    }

                  }

                )
              };
            }
              
          )

        )


      ]
      
      
    );
  }
}

class PokemonPhonePage extends StatelessWidget {
  const PokemonPhonePage({
    super.key,
    required this.card,
    //required this.onPressed
  });

  final cards.Card card;
  //final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Flexible(
          child: Image.network(
            "${card.image}/high.webp", 
            fit: BoxFit.scaleDown,
              //loadingBuilder: (context, child, loadingProgress) => CircularProgressIndicator(),
            errorBuilder: (context, error, stackTrace) => Icon(Icons.question_mark),
          )
        ),





      ]
      
    
    );
    
    
  }

}



class PokemonWidePage extends StatelessWidget {
  const PokemonWidePage({
    super.key,
    required this.card,
    //required this.onPressed
  });

  final cards.Card card;
  //final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return buildWidePage(card, []);
    
    
  }

}

class EnergyWidePage extends StatelessWidget {
  const EnergyWidePage({
    super.key,
    required this.card,
    //required this.onPressed
  });

  final cards.Card card;
  //final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return buildWidePage(card, []);
    
    
  }

}




Widget buildWidePage(cards.Card card, List<Widget> additional) {
  return SizedBox.expand(
      child: FractionallySizedBox(
      heightFactor: 0.8,
      widthFactor: 0.8,
      
      child: Row(

      children: [
        Expanded(
          child: Image.network(
            "${card.image}/low.webp", 
            fit: BoxFit.fitHeight,
              //loadingBuilder: (context, child, loadingProgress) => CircularProgressIndicator(),
            errorBuilder: (context, error, stackTrace) => Icon(Icons.question_mark),
          )
        ),
        Expanded(

          child: NestedTabBar(card: card)

        )

      
     




        ]
        
      
      )
    )
    );
}


class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key, required this.card});
  final cards.Card card;

  @override
  State<NestedTabBar> createState() => NestedTabBarState();
}

class NestedTabBarState extends State<NestedTabBar> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> cardInfo;

    if (widget.card is cards.PokemonCard) {
      cardInfo = getPokemonProperties(widget.card as cards.PokemonCard);
    } else if (widget.card is cards.EnergyCard) {
      cardInfo = getEnergyProperties(widget.card as cards.EnergyCard);
    } else {
      cardInfo = getTrainerProperties(widget.card as cards.TrainerCard);
    }

    List<Widget> variants = getVariants(widget.card);
    List<Widget> pricing = getPricing(widget.card);



    return Column(
      children: [
        Material(
          child: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              const Tab(icon: Icon(Icons.looks_one)),
              Tab(icon: Icon(Icons.looks_two)),
              const Tab(icon: Icon(Icons.looks_3)),
              const Tab(icon: Icon(Icons.looks_4))
            ],
          )
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Material(child: ListTile(leading: Text("Name"), trailing: Text(widget.card.name))),
                  Material(child: ListTile(leading: Text("Category"), trailing: Text(widget.card.category))),
                  Material(child: ListTile(leading: Text("Illustrator"), trailing: Text(widget.card.illustrator ?? "Not Found"))),
                  Material(child: ListTile(leading: Text("Rarity"), trailing: Text(widget.card.rarity ?? "Not Found"))),
                  Material(child: ListTile(leading: Text("Set"), trailing: Row(mainAxisSize: MainAxisSize.min, children: [Image.network("${widget.card.set.symbol}.webp", 
                      fit: BoxFit.scaleDown,
                      errorBuilder: (context, error, stackTrace) => Text(""),
                      ),
                      Text(widget.card.set.name), 
                      ]
                      )
                    )
                  ),
                ]
              ),
              ListView(
                shrinkWrap: true,
                children: cardInfo
              ),
              ListView(
                shrinkWrap: true,
                children: variants.isNotEmpty ? variants : [Material(child: ListTile(title: Text("Variants"))), Material(child: ListTile(title: Text("Not Found")))]
              ),
              ListView(
                shrinkWrap: true,
                children: pricing.isNotEmpty ? pricing : [Material(child: ListTile(title: Text("Pricing"))), Material(child: ListTile(title: Text("Not Found")))]
              ),

            ]
          )
        )

      ]
    );
  }

}

List<Widget> getVariants(cards.Card card) {
  return [
    Material(child: ListTile(title: Text("Variants"))),
    Material(child: ListTile(leading: Text("Normal"), trailing: card.variants.normal ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.close, color: Colors.red))),
    Material(child: ListTile(leading: Text("Holo"), trailing: card.variants.holo ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red))),
    Material(child: ListTile(leading: Text("Reverse"), trailing: card.variants.reverse ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red))),
    Material(child: ListTile(leading: Text("First Edition"), trailing: card.variants.firstEdition ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red))),
  ];
}



List<Widget> getEnergyProperties(cards.EnergyCard card) {
  return [
    Material(child: ListTile(leading: Text("Energy Type"), trailing: Text(card.energyType))),
    Material(child: ListTile(leading: Text("Effect"),  trailing: SizedBox(width: 120, child: Expanded(child: SingleChildScrollView(child: Text(card.effect ?? "Not Found", softWrap: true, overflow: TextOverflow.fade)))))),
  ];

}


List<Widget> getTrainerProperties(cards.TrainerCard card) {
  return [
    Material(child: ListTile(leading: Text("Trainer Type"), trailing: Text(card.trainerType))),
    Material(child: ListTile(leading: Text("Effect"), trailing: SizedBox(width: 120, child: Expanded(child: SingleChildScrollView(child: Text(card.effect ?? "Not Found", softWrap: true, overflow: TextOverflow.fade,)))))),
  ];

}

List<Widget> getPokemonProperties(cards.PokemonCard card) {
  List<Widget> returnList = [];
  returnList.add(Material(child: ListTile(leading: Text("Dex ID"), trailing: Text(card.dexId.isNotEmpty ? card.dexId.join(", ") : "Not Found"))));
  returnList.add(Material(child: ListTile(leading: Text("HP"), trailing: Text(card.hp != null ? card.hp.toString() :"Not Found"))));
  returnList.add(Material(child: ListTile(leading: Text("Types"), trailing: Text(card.types.isNotEmpty ? card.types.join("/") : "Not Found"))));
  if (card.evolveFrom != null) {
    returnList.add(Material(child: ListTile(leading: Text("Evolve From"), trailing: Text(card.evolveFrom!))));
  }
  returnList.add(Material(child: ListTile(leading: Text("Description"), trailing: SizedBox(width: 120, child: Expanded(child: SingleChildScrollView(child: Text(card.description ?? "Not Found", softWrap: true, overflow: TextOverflow.fade,)))))));
  returnList.add(Material(child: ListTile(leading: Text("Level"), trailing: Text(card.level ?? "Not Found"))));
  returnList.add(Material(child: ListTile(leading: Text("Stage"), trailing: Text(card.stage ?? "Not Found"))));
  returnList.add(Material(child: ListTile(leading: Text("Suffix"), trailing: Text(card.suffix ?? "Not Found"))));

  if (card.item != null) {
    returnList.add(Divider());
    returnList.add(Material(child: ListTile(title: Text("Variants"))));
    returnList.add(Material(child: ListTile(leading: Text("Name"), trailing: Text(card.item!.name))));
    returnList.add(Material(child: ListTile(leading: Text("Effect"), trailing: SizedBox(width: 120, child: Expanded(child: SingleChildScrollView(child: Text(card.item!.effect, softWrap: true, overflow: TextOverflow.fade,)))))));
  }


  return returnList;
}

List<Widget> getPricing(cards.Card card) {
  

  if (card.pricing != null) {
    if (card.pricing!.tcgplayer != null) {
      List<Widget> returnList = [Material(child: ListTile(title: Text("Pricing")))];
      var tcgplayer = card.pricing!.tcgplayer!;
      if (tcgplayer.normal != null) {
        returnList.add(Material(child: ListTile(leading: Text("Normal"), trailing: Text(tcgplayer.normal!.marketPrice != null ? tcgplayer.normal!.marketPrice.toString(): "Not Found"))));
      }
      if (tcgplayer.holofoil != null) {
        returnList.add(Material(child: ListTile(leading: Text("Holofoil"), trailing: Text(tcgplayer.holofoil!.marketPrice != null ? tcgplayer.holofoil!.marketPrice.toString(): "Not Found"))));
      }

      if (tcgplayer.reverseHolofoil != null) {
        returnList.add(Material(child: ListTile(leading: Text("Reverse Holofoil"), trailing: Text(tcgplayer.reverseHolofoil!.marketPrice != null ? tcgplayer.reverseHolofoil!.marketPrice.toString(): "Not Found"))));
      }
      if (tcgplayer.firstEdition != null) {
        returnList.add(Material(child: ListTile(leading: Text("First Edition"), trailing: Text(tcgplayer.firstEdition!.marketPrice != null ? tcgplayer.firstEdition!.marketPrice.toString(): "Not Found"))));
      }
      if (tcgplayer.firstEditionHolofoil != null) {
        returnList.add(Material(child: ListTile(leading: Text("First Edition Holofoil"), trailing: Text(tcgplayer.firstEditionHolofoil!.marketPrice != null ? tcgplayer.firstEditionHolofoil!.marketPrice.toString(): "Not Found"))));
      }
      if (tcgplayer.unlimited != null) {
        returnList.add(Material(child: ListTile(leading: Text("Unlimited"), trailing: Text(tcgplayer.unlimited!.marketPrice != null ? tcgplayer.unlimited!.marketPrice.toString(): "Not Found"))));
      }
      if (tcgplayer.unlimitedHolofoil != null) {
        returnList.add(Material(child: ListTile(leading: Text("Unlimited Holofoil"), trailing: Text(tcgplayer.unlimitedHolofoil!.marketPrice != null ? tcgplayer.unlimitedHolofoil!.marketPrice.toString(): "Not Found"))));
      }

      if (returnList.length > 1) {
        return returnList;
      } else {
        return [];
      }
    }
  }
  
  return [];
 
                    

}