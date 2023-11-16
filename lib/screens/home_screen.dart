import 'package:distillermaster_control/components/change_notifier_builder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../services/thermometer_service.dart';
import 'thermometer_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final thermometerServiceInstance = thermometerService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Thermometers'),
          Divider(),
          Expanded(
            child: ChangeNotifierBuilder(
                notifier: thermometerServiceInstance,
                builder: (context) {
                  return MasonryGridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 600,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: thermometerServiceInstance.data.length,
                    itemBuilder: (context, index) {
                      final thermometer =
                          thermometerServiceInstance.data[index];
                      return IntrinsicHeight(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ThermometerDetail(
                                          thermometer: thermometer,
                                        )));
                              },
                              child: Text(
                                thermometer.name ?? thermometer.uuid,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 300,
                              child: ChangeNotifierBuilder(
                                builder: (context) {
                                  return LineChart(
                                    duration: Duration.zero,
                                    LineChartData(
                                        titlesData: FlTitlesData(
                                            bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                              reservedSize: 100,
                                              interval: 20,
                                              showTitles: true,
                                              // getTitlesWidget: (value, meta) {
                                              //   return Text(value.toString());
                                              // },
                                            )),
                                            topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false)),
                                            rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false))),
                                        borderData: FlBorderData(show: false),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: thermometer.data
                                                .map((e) => FlSpot(
                                                    e.timestamp
                                                        .difference(
                                                            DateTime.now())
                                                        .inSeconds
                                                        .toDouble(),
                                                    e.temperature))
                                                .toList(),
                                          )
                                        ]),
                                  );
                                },
                                notifier: thermometer,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
