import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import "dart:convert";

import 'package:pokemon_app/models/cards.dart' as cards;

import 'package:responsive_framework/responsive_framework.dart';


class CardService {
  Future<cards.Card> fetchCard(String id) async {
    final uri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/cards/$id",
    );


    final response = await get(uri);
    cards.Card card;

    if (response.statusCode == 200) {
      card = json.decode(response.body);

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

  late cards.Card _card;

  cards.Card get card => _card;

  CardViewModel() {
    getCard(ModalRoute.of(context)!.settings.arguments as Car);
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
  CardView({super.key});

  final CardViewModel viewModel = CardViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.card.name),
        actions: []
      ),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return switch ((
                viewModel.loading,
                viewModel.card,
                viewModel.errorMessage
              )) {
                (true, _, _) => Container(alignment: Alignment.center ,child: CircularProgressIndicator()),
                (false, _, String message) => Center(child: Text(message)),
                (false, cards.Card card, null) => CardPage(
                  card: card,
                  //onPressed: viewModel.getCardBriefs
                )
              };
            }
              
          )
        ]
      )
    );
  }
}

class CardPage extends StatelessWidget {
  const CardPage({
    super.key,
    required this.card,
    //required this.onPressed
  });

  final cards.Card card;
  //final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: 
        switch (card.isNotEmpty) {
          (true) => Flexible(
          child: Center(
            child: ResponsiveGridView.builder(
  
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              gridDelegate: ResponsiveGridDelegate(
                crossAxisExtent: 150,
                crossAxisSpacing: 30,
                mainAxisSpacing: 10

                
              ),
              itemBuilder: (BuildContext context, int index) {  
                return CardBriefWidget(cardBrief: cardBriefs[index]);
              },
              itemCount: cardBriefs.length,
            ), 
    
              

          )
        ),
        (false) => Text("No results found")
        }
      
    
    );
    
    
  }

}



class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.card});

  final cards.Card card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 211, 224, 230)),
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.only(top: 10),
      
      child: Column(
        children: [
            Expanded(
              child: Image.network(
              "${card.image}/low.webp", 
              fit: BoxFit.fill,
              //loadingBuilder: (context, child, loadingProgress) => CircularProgressIndicator(),
              errorBuilder: (context, error, stackTrace) => Icon(Icons.question_mark),
            )),
            Text(card.name)
        ],
      ),
    );
  }
}