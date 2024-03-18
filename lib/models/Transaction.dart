//
class Transactions {
  String name = "";
  String cost = "";
  String svgPath = "";
  DateTime date = DateTime(0);

  static var TypeTransaction = {
    "expence": "assets/icons/money-check-dollar-svgrepo-com.svg",
    "subscription": "assets/icons/recurring-subscription-icon.svg",
    "transfer": "assets/icons/transaction-svgrepo-com.svg"
  };

  Transactions(
      {required this.name,
      required this.cost,
      required this.svgPath,
      required this.date});

  static List<Transactions> getTransaction() {
    List<Transactions> transaction = [];

    return transaction;
  }
}

// transaction.add(Transaction(
//         name: "Netflix",
//         cost: "60.00",
//         svgPath: "assets/icons/recurring-subscription-icon.svg",
//         date: DateTime.now().subtract(const Duration(days: 7))));
// //اي شي من 0 الى 168 يعتبر داخل الاسبوع
//     transaction.add(Transaction(
//         name: "TShirt",
//         cost: "1400.00",
//         svgPath: "assets/icons/transaction-svgrepo-com.svg",
//         date: DateTime.now()));

//     transaction.add(Transaction(
//         name: "TShirt",
//         cost: "140.00",
//         svgPath: "assets/icons/money-check-dollar-svgrepo-com.svg",
//         date: DateTime.now().add(const Duration(days: 60))));

//     transaction.add(Transaction(
//         name: "TShirt",
//         cost: "140.00",
//         svgPath: "assets/icons/money-check-dollar-svgrepo-com.svg",
//         date: DateTime.now().subtract(const Duration(days: 2))));

//     transaction.add(Transaction(
//         name: "Netflix",
//         cost: "60.00",
//         svgPath: "assets/icons/recurring-subscription-icon.svg",
//         date: DateTime.now().subtract(const Duration(days: 7))));

//     transaction.add(Transaction(
//         name: "TShirt",
//         cost: "140.00",
//         svgPath: "assets/icons/money-check-dollar-svgrepo-com.svg",
//         date: DateTime.now().subtract(const Duration(days: 2))));

//     transaction.add(Transaction(
//         name: "Netflix",
//         cost: "60.00",
//         svgPath: "assets/icons/recurring-subscription-icon.svg",
//         date: DateTime.now().subtract(const Duration(days: 30))));

//     transaction.add(Transaction(
//         name: "TShirt",
//         cost: "140.00",
//         svgPath: "assets/icons/money-check-dollar-svgrepo-com.svg",
//         date: DateTime.now().subtract(const Duration(days: 30))));

//     transaction.add(Transaction(
//         name: "TShirt",
//         cost: "1400.00",
//         svgPath: "assets/icons/transaction-svgrepo-com.svg",
//         date: DateTime.now()));
