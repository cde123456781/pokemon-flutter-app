import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import "dart:convert";

import 'package:pokemon_app/models/cards.dart' hide Card;

import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardBriefView(),
    );
  }
}


class CardBriefService {
  Future<List<CardBrief>> fetchCards() async {
    final uri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/cards",
      {"name": "pikachu"}
    );


    final response = await get(uri);
    List<CardBrief> cards = [];

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      for (final e in list) {
        cards.add(CardBrief.fromJson(e));
      }
      return cards;
    } else {
      throw HttpException("Failed to update resource");
    }

  }
}



class CardBriefViewModel extends ChangeNotifier {
  final CardBriefService _service = CardBriefService();
  String? errorMessage;
  bool loading = false;

  List<CardBrief> _cardBriefs = [];

  List<CardBrief> get cardBriefs => _cardBriefs;

  Future<void> getCardBriefs() async {
    loading = true;
    notifyListeners();
    try {
      _cardBriefs = await _service.fetchCards();
      errorMessage = null;


    } on HttpException catch (error) {
      errorMessage = error.message;

      print('Error loading article: ${error.message}');
    }

    loading = false;
    notifyListeners();
  }
}


class CardBriefView extends StatelessWidget {
  CardBriefView({super.key});

  final CardBriefViewModel viewModel = CardBriefViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Pokemon"),
        actions: []
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return switch ((
            viewModel.loading,
            viewModel.cardBriefs,
            viewModel.errorMessage
          )) {
            (true, _, _) => Container(alignment: Alignment.center ,child: CircularProgressIndicator()),
            (false, _, String message) => Center(child: Text(message)),
            (false, List<CardBrief> cardBriefs, null) => CardBriefPage(
              cardBriefs: cardBriefs,
              onPressed: viewModel.getCardBriefs
            )
          };
        }
          
      )
    );
  }
}

class CardBriefPage extends StatelessWidget {
  const CardBriefPage({
    super.key,
    required this.cardBriefs,
    required this.onPressed
  });

  final List<CardBrief> cardBriefs;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
            onPressed: onPressed, 
            child: Text("Next Random Article")
          ) 
        ),
      
        switch (cardBriefs.isNotEmpty) {
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
        
         
        

      ]
    
    );
    
    
  }

}


class CardBriefWidget extends StatelessWidget {
  const CardBriefWidget({super.key, required this.cardBrief});

  final CardBrief cardBrief;

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
              "${cardBrief.image}/low.webp", 
              fit: BoxFit.fill,
              //loadingBuilder: (context, child, loadingProgress) => CircularProgressIndicator(),
              errorBuilder: (context, error, stackTrace) => Icon(Icons.question_mark),
            )),
            Text(cardBrief.name)
        ],
      ),
    );
  }
}