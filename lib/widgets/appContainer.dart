import 'package:flutter/material.dart';
import 'package:pokemon_app/widgets/sidebar.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Pokemon"),
        actions: []
      ),
      body: Column(
        children: children
      ),
      drawer: Sidebar(),
    );
  }
}