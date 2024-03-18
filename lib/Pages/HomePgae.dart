import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/Pages/SginUpPage.dart';
import 'package:expense/Pages/ViewAllPage.dart';
import 'package:expense/auth.dart';
import 'package:expense/models/Transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'SginInPage.dart';
import '../models/categoryModel.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> category = [];
  List<Transactions> transactions = [];
  List<Transactions> t = [];
  List<Transactions> t2 = [];
  double balance = 0;
  final User? user = Auth().currentUser;
  var name = "";

  var newTransactionName = TextEditingController();
  var newTransactionCost = TextEditingController();
  var newBalance = TextEditingController();
  final _TransactionKey = GlobalKey<FormState>();
  final _BalanceKey = GlobalKey<FormState>();

  void UpdateData() async {
    List<String> arrayName = [];
    List<String> arrayCost = [];
    List<String> arraySvgPath = [];
    List<String> arrayDate = [];
    DateTime a = new DateTime(2023, 2, 6);
    print(a.year.toString());
    for (var element in transactions) {
      arrayName.add(element.name);
      arrayCost.add(element.cost);
      arraySvgPath.add(element.svgPath);
      arrayDate.add(element.date.year.toString() +
          "-" +
          element.date.month.toString() +
          "-" +
          element.date.day.toString());
    }

    final User? user = await Auth().currentUser;
    final docTransactions =
        await FirebaseFirestore.instance.collection("Transactions");
    if (transactions.length <= 1) {
      docTransactions.doc(user!.uid).set({
        'name': arrayName,
        'cost': arrayCost,
        'svgPath': arraySvgPath,
        'date': arrayDate,
        'balance': balance.toString()
      });
    } else {
      docTransactions.doc(user!.uid).update({
        'name': arrayName,
        'cost': arrayCost,
        'svgPath': arraySvgPath,
        'date': arrayDate,
        'balance': balance.toString()
      });
    }
  }

  void getCategory() {
    if (category.isEmpty) {
      category = CategoryModel.getCategoryModel();
    }
  }

  void getDataFromDataBase() async {
    List arrayName = [];
    List arrayCost = [];
    List arraySvgPath = [];
    List arrayDate = [];
    List<String> arrayDateFiltered = [];
    List<String> arrayYears = [];
    List<String> arrayMonths = [];
    List<String> arrayDays = [];

    final User? user = await Auth().currentUser;
    final docTransactions =
        await FirebaseFirestore.instance.collection("Transactions");

    var data = docTransactions.doc(user!.uid).get();
    data.then((value) {
      arrayName = value['name'];
      arrayCost = value['cost'];
      arraySvgPath = value['svgPath'];
      arrayDate = value['date'];
      arrayDateFiltered = arrayDate.toString().split(",");

      transactions.clear();
      setState(() {
        for (var i = 0; i < arrayName.length; i++) {
          var DateFiltered = arrayDateFiltered[i].split("-");
          transactions.add(Transactions(
              name: arrayName[i],
              cost: arrayCost[i],
              svgPath: arraySvgPath[i],
              date: DateTime(
                  int.parse(DateFiltered[0].replaceAll("[", "")),
                  int.parse(DateFiltered[1]),
                  int.parse(DateFiltered[2].replaceAll("]", "")))));
        }
      });
    });
  }

  void getData() {
    getCategory();
    //getTransactions();
    filter();
  }

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    getDataFromDataBase();
    final User? user = await Auth().currentUser;
    setState(() {
      name = user!.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.03,
          ),
          _Balance(context),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          _category(context),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.04,
          ),
          _transactions(context)
        ],
      ),
    );
  }

  Column _transactions(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                enableFeedback: false,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAllPage(
                            key: widget.key,
                            transactions: transactions,
                            delete: (double cost, int i) {
                              setState(() {
                                this.balance = this.balance + cost;
                                this.transactions.removeAt(i);
                                UpdateData();
                              });
                            }),
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "View All",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.02,
        ),
        SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.36,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: t2.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 0,
                        );
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: t2.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 25),
                          child: InkWell(
                            onTap: () {},
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
                                      t2[i].name,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "\$${t2[i].cost}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.05),
                                          child: Text(
                                            "${DateFormat.yMd().format(t2[i].date)} ",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                leading: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: SvgPicture.asset(Transactions
                                        .TypeTransaction[t2[i].svgPath]
                                        .toString())),
                                trailing: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: FittedBox(
                                    child: SvgPicture.asset(
                                        "assets/icons/right-arrow-svgrepo-com.svg"),
                                  ),
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

  Column _category(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.15,
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.1,
                    );
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: category.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return _bottomSheet(context, index);
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          enableFeedback: false,
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.1,
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            decoration: BoxDecoration(
                                color: category[index].backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      blurStyle: BlurStyle.outer)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: SvgPicture.asset(Transactions
                                  .TypeTransaction[category[index].SvgPath]
                                  .toString()),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.01,
                        ),
                        Text(
                          category[index].name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Padding _bottomSheet(BuildContext context, int index) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height * 0.05,
          right: MediaQuery.sizeOf(context).width * 0.05,
          left: MediaQuery.sizeOf(context).width * 0.05,
        ),
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Column(
          children: [
            Text(
              "Add New ${category[index].name}",
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _TransactionKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Name Field is Empty" : null,
                      controller: newTransactionName,
                      decoration: const InputDecoration(hintText: "Name"),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Cost Field is Empty" : null,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: newTransactionCost,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Cost"),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.08,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_TransactionKey.currentState!.validate()) {
                            setState(() {
                              transactions.add(Transactions(
                                  name: newTransactionName.value.text,
                                  cost: newTransactionCost.value.text,
                                  svgPath: category[index].SvgPath,
                                  date: DateTime.now()));
                              balance = balance -
                                  double.parse(newTransactionCost.value.text);
                            });

                            newTransactionName.clear();
                            newTransactionCost.clear();
                            UpdateData();

                            Navigator.pop(context);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 40, left: 40),
                          child: Text(
                            "Add",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Column _Balance(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.14,
          width: double.infinity,
          margin: EdgeInsets.only(
              left: MediaQuery.sizeOf(context).width * 0.25,
              right: MediaQuery.sizeOf(context).width * 0.25),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.black.withOpacity(0.8),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Balance: $balance",
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }

  AppBar _AppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Hi ${user!.email}",
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: SvgPicture.asset("assets/icons/logout-svgrepo-com.svg"),
            onPressed: () async {
              await Auth().sginOut();
            },
          )),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Enter New Balance"),
                          content: Form(
                            key: _BalanceKey,
                            child: SizedBox(
                              height: 145,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) => value!.isEmpty
                                        ? "Balance Field is Empty"
                                        : null,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: newBalance,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: "Balance"),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_BalanceKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            balance = double.parse(
                                                newBalance.value.text);
                                            newBalance.clear();
                                            UpdateData();
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Change Balance"))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text("Update Balance"),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  void filter() {
    t.clear();
    t2.clear();
    for (var j = 0; j < transactions.length; j++) {
      if (transactions[j]
                  .date
                  .difference(DateTime.now().subtract(const Duration(days: 3)))
                  .inHours >=
              0 &&
          transactions[j]
                  .date
                  .difference(DateTime.now().subtract(const Duration(days: 3)))
                  .inHours <=
              72) {
        t.add(transactions[j]);
      }
    }

    for (var i = 0; i < t.length; i++) {
      if (i > 4) {
        break;
      }
      t2.add(t[t.length - (i + 1)]);
    }
  }
}
