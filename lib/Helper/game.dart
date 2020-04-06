class Game {
  int appid;
  String name;
  String releaseDate;
  int english;
  String developer;
  String publisher;
  String platforms;
  int requiredAge;
  String categories;
  String genres;
  String steamspyTags;
  int achievements;
  int positiveRatings;
  int negativeRatings;
  int averagePlaytime;
  int medianPlaytime;
  String owners;
  double price;
  double sellprice;
  int quantity;
  Game.short(
      {this.appid,
        this.name,
        this.developer,
        this.publisher,
        this.genres,
        this.positiveRatings,
        this.averagePlaytime,
        this.owners,
        this.price, this.sellprice});

  Game.mid(
      {this.appid,
        this.name,
        this.developer,
        this.publisher,
        this.genres,
        this.positiveRatings,
        this.averagePlaytime,
        this.owners,
        this.price, this.sellprice, this.quantity});

  Game(
      {this.appid,
      this.name,
      this.releaseDate,
      this.english,
      this.developer,
      this.publisher,
      this.platforms,
      this.requiredAge,
      this.categories,
      this.genres,
      this.steamspyTags,
      this.achievements,
      this.positiveRatings,
      this.negativeRatings,
      this.averagePlaytime,
      this.medianPlaytime,
      this.owners,
      this.price});

  factory Game.fromJson(Map<String, dynamic> json) {
    return new Game(
    appid: json['appid'],
    name: json['name'],
    releaseDate: json['release_date'],
    english: json['english'],
    developer: json['developer'],
    publisher: json['publisher'],
    platforms: json['platforms'],
    requiredAge: json['required_age'],
    categories: json['categories'],
    genres: json['genres'],
    steamspyTags: json['steamspy_tags'],
    achievements: json['achievements'],
    positiveRatings: json['positive_ratings'],
    negativeRatings: json['negative_ratings'],
    averagePlaytime: json['average_playtime'],
    medianPlaytime: json['median_playtime'],
    owners: json['owners'],
    price: json['price'].toDouble(),
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return "Title: " + name + ", Developed by: " + developer + ", Published by: "
    + publisher + ", Price: \$" + price.toStringAsFixed(2);
  }

  String toOwnerString() {
    // TODO: implement toString
    return "Title: " + name + ", Developed by: " + developer + ", Published by: "
        + publisher + ", Sell Price: \$" + price.toStringAsFixed(2) + ", Percentage: \$" + sellprice.toInt().toString() + "%";
  }

  String toCart() {
    return "Title: " + name + ", Developed by: " + developer + ", Published by: "
        + publisher + ", Price: \$" + price.toStringAsFixed(2) + " Quantity: " + quantity.toString();
  }
}

class GameList {
  final List<Game> games;

  GameList({
    this.games,
});

  factory GameList.fromJson(List<dynamic> parsedJson) {

    List<Game> games = new List<Game>();
    games = parsedJson.map((i)=>Game.fromJson(i)).toList();

    return new GameList(
      games: games
    );
  }
}

