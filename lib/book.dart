class Book {
  String index;
  String title;
  String author;
  String rating;
  String voters;
  String price;
  String currency;
  String description;
  String publisher;
  String pageCount;
  String generes;
  String iSBN;
  String language;
  String publishedDate;

  Book(
      {this.index,
      this.title,
      this.author,
      this.rating,
      this.voters,
      this.price,
      this.currency,
      this.description,
      this.publisher,
      this.pageCount,
      this.generes,
      this.iSBN,
      this.language,
      this.publishedDate});

    factory Book.fromJson(Map<String, dynamic> json) {
      return new Book(
    index: json['index'],
    title: json['title'],
    author: json['author'],
    rating: json['rating'],
    voters: json['voters'],
    price: json['price'],
    currency: json['currency'],
    description: json['description'],
    publisher: json['publisher'],
    pageCount: json['page_count'],
    generes: json['generes'],
    iSBN: json['ISBN'],
    language: json['language'],
    publishedDate: json['published_date']
      );
  }


}

class BookList {
  final List<Book> books;

  BookList({
    this.books,
});

  factory BookList.fromJson(List<dynamic> parsedJson) {

    List<Book> books = new List<Book>();
    books = parsedJson.map((i)=>Book.fromJson(i)).toList();

    return new BookList(
      books: books
    );
  }
}

