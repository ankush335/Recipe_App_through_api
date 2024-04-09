import 'package:flutter/material.dart';
import 'package:webview/Screen/searchbar.dart';
import 'dart:convert';
import 'package:webview/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:webview/Screen/recipe_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Model> list = <Model>[];
  String? text;


  @override
  void initState() {
    super.initState();
    getApiData();
  }

  Future<void> getApiData() async {
    final url =
        "https://api.edamam.com/search?q=chicken&app_id=290c3a18&app_key=a3676f5b2d8a5eaebafebc7c347c2729&from=0&to=100&calories=591-722&health=alcohol-free";

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = jsonDecode(response.body);
    json['hits'].forEach((e) {
      List<dynamic>? ingredientLines = e['recipe']['ingredientLines'];
      List<String>? ingredientLinesString = ingredientLines?.cast<String>();
      List<dynamic>? ingredients = e['recipe']['ingredients'];
      List<String>? ingredientsString = ingredients?.map((e) => e['text']).cast<String>().toList(); // Extract 'text' field from each ingredient
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
              TextField(
                onChanged: (v){
                  text =v;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(search: text, model: Model())));

                    },
                    icon: Icon(Icons.search),
                  ),
                  hintText: "Search for Recipe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.grey.withOpacity(0.04),
                  filled: true,
                ),
              ),
              SizedBox(height: 15),
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
                          builder: (context) => RecipeView(model: Model(url: x.url ?? '' )),
                              //RecipeView(model: Model(url: x.url ?? '')),
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
                            height: 50,
                            color: Colors.black.withOpacity(0.3),
                            child: Center(child: Text(x.label.toString())),
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 50,
                            color: Colors.black.withOpacity(0.3),
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
//
// import 'package:flutter/material.dart';
// import 'package:webview/Screen/searchbar.dart';
// import 'dart:convert';
// import 'package:webview/model/model.dart';
// import 'package:http/http.dart' as http;
// import 'package:webview/Screen/recipe_view.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   List<Model> list = <Model>[];
//   List<Model> filteredList = <Model>[]; // New filtered list
//
//   String? text;
//
//   @override
//   void initState() {
//     super.initState();
//     getApiData();
//   }
//
//   Future<void> getApiData() async {
//     final url =
//         "https://api.edamam.com/search?q=chicken&app_id=290c3a18&app_key=a3676f5b2d8a5eaebafebc7c347c2729&from=0&to=100&calories=591-722&health=alcohol-free";
//
//     try {
//       var response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> json = jsonDecode(response.body);
//         json['hits'].forEach((e) {
//           List<dynamic>? ingredientLines = e['recipe']['ingredientLines'];
//           List<String>? ingredientLinesString =
//           ingredientLines?.cast<String>();
//           List<dynamic>? ingredients = e['recipe']['ingredients'];
//           List<String>? ingredientsString = ingredients
//               ?.map<String>((e) => e['text'].toString())
//               .toList(); // Extract 'text' field from each ingredient
//           Model model = Model(
//             url: e['recipe']['url'],
//             image: e['recipe']['image'],
//             source: e['recipe']['source'],
//             label: e['recipe']['label'],
//             ingredientLines: ingredientLinesString,
//             ingredients: ingredientsString,
//           );
//           setState(() {
//             list.add(model);
//             filteredList = List.from(list); // Initially, filteredList is the same as list
//           });
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       // Handle error, show a snackbar, or retry
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Text("Recipe"),
//       ),
//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextField(
//                 onChanged: (v) {
//                   setState(() {
//                     text = v;
//                     filteredList = list.where((model) =>
//                     model.label?.contains(text ?? '') ?? false).toList(); // Update filteredList when text changes
//                   });
//                 },
//                 decoration: InputDecoration(
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       // The filteredList is already updated in onChanged, so no need to filter again here
//                     },
//                     icon: Icon(Icons.search),
//                   ),
//                   hintText: "Search for Recipe",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   fillColor: Colors.grey.withOpacity(0.04),
//                   filled: true,
//                 ),
//               ),
//               SizedBox(height: 15),
//               GridView.builder(
//                 physics: ScrollPhysics(),
//                 shrinkWrap: true,
//                 primary: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 15,
//                 ),
//                 itemCount: filteredList.length, // Use filteredList instead of list
//                 itemBuilder: (context, i) {
//                   final x = filteredList[i]; // Use filteredList instead of list
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               RecipeView(model: Model(url: x.url ?? '')),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: NetworkImage(x.image.toString()),
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(3),
//                             height: 40,
//                             color: Colors.black.withOpacity(0.5),
//                             child: Center(child: Text(x.label.toString())),
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(3),
//                             height: 40,
//                             color: Colors.black.withOpacity(0.5),
//                             child: Center(
//                               child: Text("Source: ${x.source}"),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
