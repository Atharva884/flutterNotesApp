import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/service/AuthService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistic extends StatefulWidget {
  var id;
  Statistic({required this.id, super.key});

  @override
  _StatisticState createState() => _StatisticState(id: id);
}

class _StatisticState extends State<Statistic> {
  var id;
  _StatisticState({required this.id});
  // List notes = [];
  // bool loading = true;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getData();
  // }

  // void getData() async {
  //   var response = await AuthService.getStatisticData(id);
  //   print(response.runtimeType); 
  //   // setState(() {
  //   //   notes = jsonDecode(response.body)
  //   // });
  // }

  // var data;

  // @override
  // void initState(){
  //   // TODO: implement initState
  //   print(id);
  //   data = getData(id);
  //   // print(jsonDecode(data));
  //   super.initState();
  // }

  // Future<String?> getData(id)async{
  //   var data = await AuthService.getStatisticData(id);
  //   // print(data);
  //   return data;
  // } 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(

            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'Chart'),
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                dataSource:  <SalesData>[
                  SalesData('Jan', 35),
                  SalesData('Feb', 28),
                  SalesData('Mar', 34),
                  SalesData('Apr', 32),
                  SalesData('May', 100)
                ],
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}