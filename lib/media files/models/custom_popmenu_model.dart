import 'package:flutter/material.dart';

class CustomPopMenuItemModel {
  final String title;
  final VoidCallback onSelected;

  const CustomPopMenuItemModel({
    required this.title,
    required this.onSelected,
  });

  // Add additional properties if needed based on your actual data usage

  @override
  String toString() {
    return 'CustomPopMenuItemModel{title: $title, onSelected: $onSelected}';
  }

  // Optional: Equality operator if necessary for comparisons
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomPopMenuItemModel &&
        other.title == title &&
        other.onSelected == onSelected;
  }

  @override
  int get hashCode => title.hashCode ^ onSelected.hashCode;
}
