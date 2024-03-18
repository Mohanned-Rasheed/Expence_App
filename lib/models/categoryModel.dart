import 'package:flutter/material.dart';

class CategoryModel {
  String name = "";
  String SvgPath = "";
  Color backgroundColor = Colors.transparent;

  CategoryModel(
      {required this.name,
      required this.SvgPath,
      required this.backgroundColor});

  static List<CategoryModel> getCategoryModel() {
    List<CategoryModel> category = [];

    category.add(CategoryModel(
        name: "Expenses",
        SvgPath: "expence",
        backgroundColor: Colors.green.withOpacity(0.3)));
    category.add(CategoryModel(
        name: "Subscriptions",
        SvgPath: "subscription",
        backgroundColor: Colors.orange.withOpacity(0.3)));
    category.add(CategoryModel(
        name: "Transfer",
        SvgPath: "transfer",
        backgroundColor: Colors.blue.withOpacity(0.3)));

    return category;
  }
}
