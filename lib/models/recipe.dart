class Recipe {
  String? id;
  String? title;
  String? instructions;
  List<String>? categories;
  String? image;
  String? owner;
  List<Rating>? ratings;
  List<Ingredient>? ingredients;

  Recipe({
    this.id,
    this.title,
    this.instructions,
    this.categories,
    this.image,
    this.owner,
    this.ratings,
    this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json, {String? id}) {
    return Recipe(
      id: id,
      title: json['title'],
      instructions: json['instructions'],
      categories: (json['categories'] as List<dynamic>?)?.cast<String>(),
      image: json['image'],
      owner: json['owner'],
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((r) => Rating.fromJson(r))
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((i) => Ingredient.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'instructions': instructions,
      'categories': categories?.map((e) => e.toString().split('.').last).toList(),
      'image': image,
      'owner': owner,
      'ratings': ratings?.map((r) => r.toJson()).toList(),
      'ingredients': ingredients?.map((i) => i.toJson()).toList(),
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    List<String>? categories,
    List<Ingredient>? ingredients,
    String? instructions,
    String? image,
    List<Rating>? ratings,
    String? owner,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      categories: categories ?? this.categories,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      image: image ?? this.image,
      ratings: ratings ?? this.ratings,
      owner: owner ?? this.owner,
    );
  }
}

class Rating {
  int? value;
  String? ratedBy;

  Rating({this.value, this.ratedBy});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      value: json['value'],
      ratedBy: json['ratedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'ratedBy': ratedBy,
    };
  }
}

class Ingredient {
  String? name;
  String? unit;
  int? value;

  Ingredient({this.name, this.unit, this.value});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      unit: json['unit'],
      value: json['value'] is String ? int.tryParse(json['value']) : json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'value': value
    };
  }
}

enum Category {
  beef,
  chicken,
  seafood,
  vegan,
  vegetarian,
  dessert,
  fastfood,
  drinks;

  @override
  String toString() {
    return name; // Returns the name of the enum as a string
  }
}
