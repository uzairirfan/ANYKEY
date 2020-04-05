import 'package:flutter/material.dart';
import '../Database/database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OwnerReportPage extends StatefulWidget {
  final Widget child;

  OwnerReportPage({Key key, this.child}) : super(key: key);

  _OwnerReportPageState createState() => _OwnerReportPageState();
}

class _OwnerReportPageState extends State<OwnerReportPage> {
  List<charts.Series<GraphData, String>> _genData;
  List<charts.Series<GraphData, String>> _devData;
  List<charts.Series<GraphData, String>> _pubData;

  _generateData() async {
    Map<String, List<int>> genreData = await Database().getGenreData();
    Map<String, List<int>> devData = await Database().getDeveloperData();
    Map<String, List<int>> pubData = await Database().getPublisherData();

    List<GraphData> soldGenre = [];
    List<GraphData> salesGenre = [];
    List<GraphData> expenseGenre = [];

    List<GraphData> soldDev = [];
    List<GraphData> salesDev = [];
    List<GraphData> expenseDev = [];

    List<GraphData> soldPub = [];
    List<GraphData> salesPub = [];
    List<GraphData> expensePub = [];

    genreData.forEach((k, v) {
      soldGenre.add(new GraphData(k, v[0]));
      salesGenre.add(new GraphData(k, v[1]));
      expenseGenre.add(new GraphData(k, v[2]));
    });

    devData.forEach((k, v) {
      soldDev.add(new GraphData(k, v[0]));
      salesDev.add(new GraphData(k, v[1]));
      expenseDev.add(new GraphData(k, v[2]));
    });

    pubData.forEach((k, v) {
      soldPub.add(new GraphData(k, v[0]));
      salesPub.add(new GraphData(k, v[1]));
      expensePub.add(new GraphData(k, v[2]));
    });

    _genData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '# Sold',
        data: soldGenre,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    );

    _genData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '\$ in Sales',
        data: salesGenre,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
      ),
    );

    _genData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '\$ in Expenses',
        data: expenseGenre,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.red),
      ),
    );

    _devData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '# Sold',
        data: soldDev,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    );

    _devData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '\$ in Sales',
        data: salesDev,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
      ),
    );

    _devData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '\$ in Expenses',
        data: expenseDev,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.red),
      ),
    );

    _pubData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '# Sold',
        data: soldPub,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    );

    _pubData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '\$ in Sales',
        data: salesPub,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
      ),
    );

    _pubData.add(
      charts.Series(
        domainFn: (GraphData data, _) => data.name,
        measureFn: (GraphData data, _) => data.amount,
        id: '\$ in Expenses',
        data: expensePub,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (GraphData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.red),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _genData = List<charts.Series<GraphData, String>>();
    _devData = List<charts.Series<GraphData, String>>();
    _pubData = List<charts.Series<GraphData, String>>();
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
                            _genData,
                            domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60,
                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 12, // size in Pts.
                                    color: charts.MaterialPalette.white),

                                // Change the line colors to match text color.
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.white),
                              ),
                            ),
                            primaryMeasureAxis: new charts.NumericAxisSpec(
                                renderSpec: new charts.GridlineRendererSpec(

                                    // Tick and Label styling here.
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize: 12, // size in Pts.
                                        color: charts.MaterialPalette.white),

                                    // Change the line colors to match text color.
                                    lineStyle: new charts.LineStyleSpec(
                                        color: charts.MaterialPalette.white))),
                            
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            behaviors: [
                              new charts.SeriesLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                              )
                            ],
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
                        Expanded(
                          child: charts.BarChart(
                            _devData,
                            domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60,
                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 12, // size in Pts.
                                    color: charts.MaterialPalette.white),

                                // Change the line colors to match text color.
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.white),
                              ),
                            ),
                            primaryMeasureAxis: new charts.NumericAxisSpec(
                                renderSpec: new charts.GridlineRendererSpec(

                                    // Tick and Label styling here.
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize: 12, // size in Pts.
                                        color: charts.MaterialPalette.white),

                                    // Change the line colors to match text color.
                                    lineStyle: new charts.LineStyleSpec(
                                        color: charts.MaterialPalette.white)),
                            ),
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            behaviors: [
                              new charts.SeriesLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                              )
                            ],
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
                          'Sales for the first 5 years',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _pubData,
                            domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                labelRotation: 60,
                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 12, // size in Pts.
                                    color: charts.MaterialPalette.white),

                                // Change the line colors to match text color.
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.white),
                              ),
                            ),
                            primaryMeasureAxis: new charts.NumericAxisSpec(
                                renderSpec: new charts.GridlineRendererSpec(

                                    // Tick and Label styling here.
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize: 12, // size in Pts.
                                        color: charts.MaterialPalette.white),

                                    // Change the line colors to match text color.
                                    lineStyle: new charts.LineStyleSpec(
                                        color: charts.MaterialPalette.white))),
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            behaviors: [
                              new charts.SeriesLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                              )
                            ],
                          ),
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
