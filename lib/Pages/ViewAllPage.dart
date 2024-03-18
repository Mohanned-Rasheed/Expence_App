import 'package:expense/models/Transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ViewAllPage extends StatefulWidget {
  List<Transactions> transactions = [];
  final Function delete;
  ViewAllPage({super.key, required this.transactions, required this.delete});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  @override
  Widget build(BuildContext context) {
    _currentMonth =
        _map[DateFormat.MMM().format(DateTime.now()).toLowerCase()]!.toInt();
    spots = getData();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade200,
        title: const Text(
          "All Transactions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: IconButton(
              enableFeedback: false,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset("assets/icons/left arrow.svg")),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _LineChart(context),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.03,
          ),
          widget.transactions.isNotEmpty
              ? const Text(
                  "Long Press To Delete a Transaction",
                  textAlign: TextAlign.end,
                )
              : const Text(""),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.005,
          ),
          _transactions(context, widget.transactions),
        ],
      ),
    );
  }

  Padding _LineChart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.sizeOf(context).width * 0.1,
          top: MediaQuery.sizeOf(context).height * 0.05),
      child: SizedBox(
          height: 200,
          child: LineChart(LineChartData(
              maxY: maxY,
              backgroundColor: Colors.blue.shade100,
              titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    interval: 10,
                    getTitlesWidget: (value, meta) {
                      return Text(_months[value ~/ 10]);
                    },
                    showTitles: true,
                  )),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(
                      axisNameWidget: Text(
                        "Spent",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      axisNameSize: 35,
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 60))),
              lineBarsData: [
                LineChartBarData(
                    spots: spots,
                    color: Colors.orange.shade900,
                    barWidth: 4,
                    isStepLineChart: true)
              ]))),
    );
  }

  Column _transactions(context, transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.559,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.transactions.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 0,
                        );
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: widget.transactions.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 25),
                          child: InkWell(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Alert"),
                                    content: const Text(
                                        "Are you Sure Want To Delete Transaction"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.delete(
                                                  double.parse(widget
                                                      .transactions[i].cost),
                                                  i);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Delete")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"))
                                    ],
                                  );
                                },
                              );
                            },
                            splashColor: Colors.transparent,
                            enableFeedback: false,
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.sizeOf(context).height * 0.15,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        blurRadius: 5,
                                        spreadRadius: 0.1,
                                        offset: const Offset(5, 5))
                                  ],
                                  borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transactions[i].name,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "\$${transactions[i].cost}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                leading: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: SvgPicture.asset(Transactions
                                        .TypeTransaction[
                                            transactions[i].svgPath]
                                        .toString())),
                                trailing: Text(
                                  "${DateFormat.yMd().format(transactions[i].date)} ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(1)),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                              "There are no Transaction"),
                        ],
                      ),
                    ),
            )),
      ],
    );
  }

  var _currentMonth = 0;
  double maxY = 500;

  void filterHlafMonth() {
    if (_currentMonth <= 50) {
      _currentMonth = 0;
    } else {
      _currentMonth = 60;
    }
  }

  double getCurrentMonth() {
    double month = _currentMonth.toDouble();
    _currentMonth = _currentMonth + 10;
    return month;
  }

  void getMaxY(double totalMonth) {
    if (totalMonth > maxY) {
      setState(() {
        maxY = totalMonth * 1.2;
      });
    }
  }

  double calculateMonth(var CurrentMonth) {
    double totalMonth = 0;
    for (var i = 0; i < widget.transactions.length; i++) {
      if (DateFormat.MMM().format(widget.transactions[i].date).toLowerCase() ==
          _months[CurrentMonth ~/ 10]) {
        totalMonth = totalMonth + double.parse(widget.transactions[i].cost);
      }
    }
    getMaxY(totalMonth);
    return totalMonth;
  }

  List<FlSpot> getData() {
    filterHlafMonth();

    return [
      FlSpot(getCurrentMonth(), calculateMonth(_currentMonth - 10)),
      FlSpot(getCurrentMonth(), calculateMonth(_currentMonth - 10)),
      FlSpot(getCurrentMonth(), calculateMonth(_currentMonth - 10)),
      FlSpot(getCurrentMonth(), calculateMonth(_currentMonth - 10)),
      FlSpot(getCurrentMonth(), calculateMonth(_currentMonth - 10)),
      FlSpot(getCurrentMonth(), calculateMonth(_currentMonth - 10)),
    ];
  }
}

final _months = [
  "jan",
  "feb",
  "mar",
  "apr",
  "may",
  "jun",
  "jul",
  "aug",
  "sep",
  "oct",
  "nov",
  "dec"
];

var _map = {
  'jan': 0,
  'feb': 10,
  'mar': 20,
  'apr': 30,
  'may': 40,
  'jun': 50,
  'jul': 60,
  'aug': 70,
  'sep': 80,
  'oct': 90,
  'nov': 100,
  'dec': 110
};
List<FlSpot> spots = const [];
