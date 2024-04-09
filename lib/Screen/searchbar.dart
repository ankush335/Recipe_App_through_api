import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview/Screen/recipe_view.dart';
import 'package:webview/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class SearchPage extends StatefulWidget {
  final String? search;
  final Model model;
   const SearchPage({super.key, this.search, required this.model});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Model> list = <Model>[];
  String? text;

  @override
  void initState() {
    super.initState();
    getApiData(widget.search);
  }

  Future<void> getApiData(search) async {
    final url =
        "https://api.edamam.com/search?q=$search&app_id=290c3a18&app_key=a3676f5b2d8a5eaebafebc7c347c2729&from=0&to=100&calories=591-722&health=alcohol-free";

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = jsonDecode(response.body);
    json['hits'].forEach((e) {
      List<dynamic>? ingredientLines = e['recipe']['ingredientLines'];
      List<String>? ingredientLinesString = ingredientLines?.cast<String>();
      List<dynamic>? ingredients = e['recipe']['ingredients'];
      List<String>? ingredientsString = ingredients
          ?.map((e) => e['text'])
          .cast<String>()
          .toList(); // Extract 'text' field from each ingredient
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
        ingredientLines: ingredientLinesString,
        ingredients: ingredientsString,
      );
      setState(() {
        list.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Recipe"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeView(model: Model(url: x.url ?? '')),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(x.image.toString()),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(child: Text(x.label.toString())),
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text("Source: ${x.source}"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class SearchView extends StatefulWidget {
  final Model model;

  const SearchView({Key? key, required this.model}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe View'),
      ),
      body: WebView(
        initialUrl: widget.model.url ?? '', // Accessing the URL from the Model object
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
