// To parse this JSON data, do
//
//     final progressBarValueModel = progressBarValueModelFromJson(jsonString);

import 'package:flutter/material.dart';
import 'dart:convert';

ProgressBarValueModel? progressBarValueModelFromJson(String str) =>
    ProgressBarValueModel.fromJson(json.decode(str));

String progressBarValueModelToJson(ProgressBarValueModel? data) =>
    json.encode(data!.toJson());

class ProgressBarValueModel {
  ProgressBarValueModel({
    required this.color,
    required this.value,
  });

  Color? color;
  double? value;

  factory ProgressBarValueModel.fromJson(Map<String, dynamic> json) =>
      ProgressBarValueModel(
        color: json["color"],
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "value": value,
      };
}
