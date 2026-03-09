import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import "dart:convert";

import 'package:pokemon_app/models/cards.dart' hide Card;
import 'package:pokemon_app/models/series.dart';
import 'package:pokemon_app/models/sets.dart';
import 'package:pokemon_app/widgets/appContainer.dart';
import 'package:pokemon_app/widgets/loadingIndicator.dart';
import 'package:pokemon_app/widgets/sidebar.dart';

import 'package:responsive_framework/responsive_framework.dart';


class SetService {
  Future<List<SetBrief>> fetchSets(String serieName) async {
    final uri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/series/$serieName"
    );


    final response = await get(uri);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body["sets"];
    } else {
      throw HttpException("Failed to update resource");
    }

  }
}

class SeriesService {
  Future<List<Serie>> fetchSeries() async {
    final briefUri = Uri.https(
      "api.tcgdex.net",
      "/v2/en/series"
    );

    


    final response = await get(briefUri);
    List<Serie> series = [];


    Response response2;
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      for (final e in list) {
        Uri uri = Uri.https(
          "api.tcgdex.net",
          "/v2/en/series/" + e["id"]
        );

        response2 = await get(uri);
        if (response2.statusCode == 200) {
          series.add(Serie.fromJson(json.decode(response2.body)));

        } else {
          throw HttpException("Failed to update resource");
        }
      }
    } else {
      throw HttpException("Failed to update resource");
    }

    return series;
  }
}



class SeriesViewModel extends ChangeNotifier {
  final SeriesService _service = SeriesService();

  String? errorMessage;
  bool loading = false;

  List<Serie> _series = [];

  List<Serie> get series => _series;

  SeriesViewModel() {
     getSeries();
  }

  Future<void> getSeries() async {
    loading = true;
    notifyListeners();
    try {
      _series = await _service.fetchSeries();
      errorMessage = null;


    } on HttpException catch (error) {
      errorMessage = error.message;

      print('Error loading article: ${error.message}');
    }

    loading = false;
    notifyListeners();
  }
}


class SeriesView extends StatelessWidget {
  SeriesView({super.key});

  final SeriesViewModel viewModel = SeriesViewModel();
  


  @override
  Widget build(BuildContext context) {


    return AppContainer(
      children: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return switch ((
                viewModel.loading,
                viewModel.series,
                viewModel.errorMessage
              )) {
                (true, _, _) => LoadingIndicator(),
                (false, _, String message) => Center(child: Text(message)),
                (false, List<Serie> series, null) => SeriesPage(
                  viewModel: viewModel,
                  //onPressed: viewModel.getCardBriefs
                )
              };
            }
              
          )
        ]
    
    );
  }
}

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key, required this.viewModel});

  final SeriesViewModel viewModel;

  @override
  SeriesPageState createState() {
    return SeriesPageState();
  }
}


class SeriesPageState extends State<SeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
        switch (widget.viewModel.series.isNotEmpty) {
          (true) => Flexible(
          child: Center(
            child: ListView.builder(
  
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {  
                return SerieWidget(serie: widget.viewModel.series[index]);
              },
              itemCount: widget.viewModel.series.length,
            ), 
    
              

          )
        ),
        (false) => Text("No results found")
        }
      
    
    );
    
    
  }

}


class SerieWidget extends StatelessWidget {
  const SerieWidget({super.key, required this.serie});

  final Serie serie;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 211, 224, 230)),
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(top: 50),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            child: Image.network(
              "${serie.logo}.webp", 
              fit: BoxFit.scaleDown,
              //loadingBuilder: (context, child, loadingProgress) => CircularProgressIndicator(),
              errorBuilder: (context, error, stackTrace) => Text(serie.name),
            )
          ),
            Flexible(
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
                    return SetWidget(set: serie.sets[index]);
                  },
                  itemCount: serie.sets.length,
                )
              )

            ),

        ],
      ),
    );
  }
}


class SetWidget extends StatelessWidget {
  const SetWidget({super.key, required this.set});

  final SetBrief set;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 211, 224, 230)),
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.only(top: 10),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
            Expanded(
              child: Image.network(
              "${set.logo}.webp", 
              fit: BoxFit.scaleDown,
              //loadingBuilder: (context, child, loadingProgress) => CircularProgressIndicator(),
              errorBuilder: (context, error, stackTrace) => Icon(Icons.question_mark),
            )),
            Text(set.name)
        ],
      ),
    );
  }

}
