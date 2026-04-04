import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import "dart:convert";

import 'package:pokemon_app/models/cards.dart' as cards;
import 'package:pokemon_app/models/sets.dart';
import 'package:pokemon_app/widgets/appContainer.dart';
import 'package:pokemon_app/widgets/loadingIndicator.dart';
import 'package:pokemon_app/widgets/searchWidget.dart';

import 'package:responsive_framework/responsive_framework.dart';


class CardBriefService {
  Future<List<cards.CardBrief>> fetchCards(String name, String? setId) async {

    final uri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/cards",
      {"name": name}
    );

    final setUri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/sets/${setId}",
    );

    List<cards.CardBrief> retrievedCards = [];
    

    if (setId == null) {
      final response = await get(uri);
      if (response.statusCode == 200) {

        Iterable list = json.decode(response.body);
        for (final e in list) {
          retrievedCards.add(cards.CardBrief.fromJson(e));
        }
        
        return retrievedCards;
          
      } else {
        throw HttpException("Failed to update resource");
      }

    } else {
      List<cards.CardBrief> returnCards = [];
      final response = await get(setUri);
      if (response.statusCode == 200) {
        Set set = Set.fromJson(json.decode(response.body));
        for (var i in set.cards) {
          if (i.name.toLowerCase().contains(name.trim().toLowerCase())) {
            returnCards.add(i);
          }
        }

        return returnCards;

      } else {
        throw HttpException("Failed to update resource");
      }
    }
    

  }
}

class SetBriefService {
  Future<List<SetBrief>> fetchSets() async {
    final uri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/sets"
    );

    final response = await get(uri);
    List<SetBrief> sets = [];

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      for (final e in list) {
        sets.add(SetBrief.fromJson(e));
      }
      return sets;
    } else {
      throw HttpException("Failed to update resource");
    }

  }

}


class CardBriefViewModel extends ChangeNotifier {
  final CardBriefService _service = CardBriefService();
  String? errorMessage;
  bool loading = false;

  List<cards.CardBrief> _cardBriefs = [];

  List<cards.CardBrief> get cardBriefs => _cardBriefs;


  Future<void> getCardBriefs(String name, String? setId) async {
    loading = true;
    notifyListeners();
    try {
      _cardBriefs = await _service.fetchCards(name, setId);
      errorMessage = null;


    } on HttpException catch (error) {
      errorMessage = error.message;

      print('Error loading article: ${error.message}');
    }

    loading = false;
    notifyListeners();
  }

}


class SetBriefViewModel extends ChangeNotifier {
  final SetBriefService _service = SetBriefService();
  String? errorMessage;
  bool loading = false;

  List<SetBrief> _sets = [];
  List<SetBrief> get sets => _sets;

  String? initialSet;

  SetBriefViewModel() {
    getSets();
  }



  Future<void> getSets() async {
    try {
      _sets = await _service.fetchSets();
      errorMessage = null;


    } on HttpException catch (error) {
      errorMessage = error.message;

      print('Error loading article: ${error.message}');
    }
    notifyListeners();

  }


}


class CardBriefView extends StatefulWidget {
  CardBriefView({super.key, this.initialSet});

  final String? initialSet; 

  @override
  CardBriefViewState createState() {
    return CardBriefViewState();
  }
}




class CardBriefViewState extends State<CardBriefView> {

  final CardBriefViewModel cardBriefViewModel = CardBriefViewModel();
  final SetBriefViewModel setBriefViewModel = SetBriefViewModel();
  String? initialSet;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialSet != null) {
      cardBriefViewModel.getCardBriefs("", widget.initialSet);

    }
  }

  @override
  void didUpdateWidget(covariant CardBriefView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSet != widget.initialSet) {
      cardBriefViewModel.getCardBriefs("", widget.initialSet);

    }

  }



  @override
  Widget build(BuildContext context) {


    return Column(children: [
          ListenableBuilder(
            listenable: setBriefViewModel,
            builder: (context, child) {
              return Center(
                child: SearchWidget(onPressed: cardBriefViewModel.getCardBriefs, sets: setBriefViewModel.sets)
              );
            }
          ),
          ListenableBuilder(
            listenable: cardBriefViewModel,
            builder: (context, child) {
              return switch ((
                cardBriefViewModel.loading,
                cardBriefViewModel.cardBriefs,
                cardBriefViewModel.errorMessage
              )) {
                (true, _, _) => LoadingIndicator(),
                (false, _, String message) => Center(child: Text(message)),
                (false, List<cards.CardBrief> cardBriefs, null) => Expanded(child: CardBriefPage(
                    cardBriefs: cardBriefs,
                    //onPressed: viewModel.getCardBriefs
                  )
                )
              };
            }
              
          )
        ]);
  }
}

class CardBriefPage extends StatelessWidget {
  const CardBriefPage({
    super.key,
    required this.cardBriefs,
  });

  final List<cards.CardBrief> cardBriefs;
  //final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: 
        switch (cardBriefs.isNotEmpty) {
          (true) =>  Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 1000), child: ResponsiveGridView.builder(
  
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              gridDelegate: ResponsiveGridDelegate(
                crossAxisExtent: 150,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0

                
              ),
              itemBuilder: (BuildContext context, int index) {  
                return CardBriefWidget(cardBrief: cardBriefs[index]);
              },
              itemCount: cardBriefs.length,
            ))), 
        (false) => Text("No results found")
        }
      
    
    );
    
    
  }

}



class CardBriefWidget extends StatelessWidget {
  const CardBriefWidget({super.key, required this.cardBrief});

  final cards.CardBrief cardBrief;

  @override
  Widget build(BuildContext context) {
    return Container(child: Material(child: InkWell(
      onTap: () => {
        context.pushNamed("cardDetails", pathParameters: {"cardId": cardBrief.id})
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 211, 224, 230)),
          borderRadius: BorderRadius.circular(20)
        ),
        padding: EdgeInsets.only(top: 10),
        
        child: Column(
          children: [
              Expanded(
                child: Image.network(
                "${cardBrief.image}/low.webp", 
                fit: BoxFit.fill,
                //loadingBuilder: (context, child, loadingProgress) => CircularProgressIndicator(),
                errorBuilder: (context, error, stackTrace) => Icon(Icons.question_mark),
              )),
              Text(cardBrief.name)
          ],
        ),
      )
    )));
  }
}