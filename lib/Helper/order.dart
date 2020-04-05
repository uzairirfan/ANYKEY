import 'game.dart';

class Order{
  List<Game> orders = new List<Game>();
  DateTime date;
  int card;
  int streetNo;
  String street;
  String city;
  String province;
  String country;
  int orderId;

  Order(this.orders, this.date, this.card, this.streetNo, this.street, this.city, this.province, this.country, this.orderId);
}