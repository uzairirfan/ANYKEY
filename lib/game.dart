class Game {
  int appid;
  String name;
  String releaseDate;
  String developer;
  String publisher;
  String genres;
  double price;

  Game(
      {this.appid,
      this.name,
      this.releaseDate,
      this.developer,
      this.publisher,
      this.genres,
      this.price});

  factory Game.fromJson(Map<String, dynamic> json) {
    return new Game(
    appid: json['appid'],
    name: json['name'],
    releaseDate: json['release_date'],
    developer: json['developer'],
    publisher:  json['publisher'],
    genres: json['genres'],
    price: json['price'].toDouble()
    );
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

