import 'package:flutter/material.dart';
import 'package:pokemon_app/models/sets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.onPressed, required this.sets});

  final Function onPressed;
  final List<SetBrief> sets;

  @override
  SearchWidgetState createState() {
    return SearchWidgetState();
  }
}



class SearchWidgetState extends State<SearchWidget> {  
  TextEditingController controller = TextEditingController();
  String? setId;
  final _formKey = GlobalKey<FormState>();


  late List<DropdownMenuEntry<String?>> entries;

  @override 
  void initState() {
    super.initState();
    entries = [
      DropdownMenuEntry(value: null, label: "All Sets"),
      ...widget.sets.map((set) => DropdownMenuEntry(value: set.id, label: set.name))
    ];
  }

  @override
  void didUpdateWidget(covariant SearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sets != widget.sets) {
      entries = [
      DropdownMenuEntry(value: null, label: "All Sets"),
      ...widget.sets.map((set) => DropdownMenuEntry(value: set.id, label: set.name))
      ];
    }


  }


  
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(child: TextField(
                controller: controller,
                onSubmitted: (value) => widget.onPressed(value, setId),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              )
            ),
            DropdownMenu(
              initialSelection: null,
              requestFocusOnTap: false,
              menuHeight: 200,
              onSelected: (value) {
                setState(() { 
                  setId = value;
                });
              },
              dropdownMenuEntries: entries
            ),
            ElevatedButton(
                onPressed: () => widget.onPressed(controller.text, setId), 
              child: Text("Search")
            ),

          ]
      )
      )
    );

  }
}
