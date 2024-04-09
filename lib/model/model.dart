class Model {
  final String? url;
  final String? image;
  final String? source;
  final String? label;
  final List<String>? ingredientLines;
  final List<String>? ingredients;// Add this field

  Model({
    this.url,
    this.image,
    this.source,
    this.label,
    this.ingredientLines,
    this.ingredients,// Initialize it in the constructor
  });
}
