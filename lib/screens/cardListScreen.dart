import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import "dart:convert";

import 'package:pokemon_app/models/cards.dart' hide Card;
import 'package:pokemon_app/widgets/appContainer.dart';
import 'package:pokemon_app/widgets/loadingIndicator.dart';
import 'package:pokemon_app/widgets/sidebar.dart';

import 'package:responsive_framework/responsive_framework.dart';


class CardBriefService {
  Future<List<CardBrief>> fetchCards(String name) async {
    final uri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/cards",
      {"name": name}
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

  Future<void> getCardBriefs(String name) async {
    loading = true;
    notifyListeners();
    try {
      _cardBriefs = await _service.fetchCards(name);
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
    return AppContainer(children: [
          Center(
            child: SearchWidget(onPressed: viewModel.getCardBriefs)
          ),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return switch ((
                viewModel.loading,
                viewModel.cardBriefs,
                viewModel.errorMessage
              )) {
                (true, _, _) => LoadingIndicator(),
                (false, _, String message) => Center(child: Text(message)),
                (false, List<CardBrief> cardBriefs, null) => CardBriefPage(
                  cardBriefs: cardBriefs,
                  //onPressed: viewModel.getCardBriefs
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
    //required this.onPressed
  });

  final List<CardBrief> cardBriefs;
  //final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: 
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
      
    
    );
    
    
  }

}


class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.onPressed});

  final Function onPressed;

  @override
  SearchWidgetState createState() {
    return SearchWidgetState();
  }
}



class SearchWidgetState extends State<SearchWidget> {  
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Row(
        children: [
          Expanded(child: TextField(
              
              controller: controller,
              onSubmitted: (value) => widget.onPressed(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            )
          ),
          ElevatedButton(
              onPressed: () => widget.onPressed(controller.text), 
            child: Text("Search")
          ),

        ]
      )
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