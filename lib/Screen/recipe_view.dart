// //
// import 'package:flutter/material.dart';
// import 'package:webview/model/model.dart'; // Add this import statement
//
// class RecipeView extends StatelessWidget {
//   final Model model;
//
//   RecipeView({Key? key, required this.model}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Recipe View')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//             SizedBox(
//               height: 200,
//               child: Card(
//                 elevation: 0.2,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Center(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             fit: BoxFit.fill,
//                             image: NetworkImage(model.image.toString() ?? ''),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Display ingredient lines
//
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 10,),
//             Text(
//               'Ingredients:',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 4),
//             if (model.ingredientLines != null)
//               ...model.ingredientLines!.map(
//                     (ingredient) => Text(
//                   '- $ingredient',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             SizedBox(height: 10,),
//             Text(
//               'Ingredients:',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 4),
//             if (model.ingredients != null)
//               ...model.ingredients!.map(
//                     (ingredient) => Text(
//                   '- $ingredient',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview/model/model.dart';

class RecipeView extends StatelessWidget {
  final Model model;

  const RecipeView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe View'),
      ),
      body: WebView(
        initialUrl: model.url ?? '',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
