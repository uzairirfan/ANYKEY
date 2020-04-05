import 'package:flutter/material.dart';
import '../Database/database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OwnerReportPage extends StatefulWidget {
  final Widget child;

  OwnerReportPage({Key key, this.child}) : super(key: key);

  _OwnerReportPageState createState() => _OwnerReportPageState();
}

class _OwnerReportPageState extends State<OwnerReportPage> {
  List<charts.Series<GraphData, String>> _seriesData;

  _generateData() async {

    Map<String, List<int>> genreData = await Database().getGenreData();
    print(genreData);

    List<GraphData> sold = [];
    List<GraphData> sales = [];
    List<GraphData> expense = [];
    
    genreData.forEach((k,v){
        sold.add(new GraphData(k, v[0]));
        sales.add(new GraphData(k, v[1]));
        expense.add(new GraphData(k, v[2]));
    });

    

    _seriesData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '2017',
        data: sold,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '2018',
        data: sales,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '2019',
        data: expense,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<GraphData, String>>();
  _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              //  color: Colors.green,
              child: new SafeArea(
                  child: Column(children: <Widget>[
                new Expanded(child: new Container()),
                new TabBar(
                  indicatorColor: Theme.of(context).accentColor,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.book),
                    ),
                    Tab(icon: Icon(Icons.check)),
                    Tab(icon: Icon(Icons.insert_chart)),
                  ],
                ),
              ])),
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Amount Sold, Sales and Expenditures of Genres',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            behaviors: [new charts.SeriesLegend(
                              outsideJustification: charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts.MaterialPalette.purple.shadeDefault,
                                  fontFamily: 'Georgia',
                                  fontSize: 11),
                            
                            )],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Time spent on daily tasks',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Sales for the first 5 years',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class GraphData {
  String name;
  int amount;

  GraphData(this.name, this.amount);
}
