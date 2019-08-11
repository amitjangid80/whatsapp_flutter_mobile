import 'package:flutter/material.dart';

String format(DateTime date, [String format = "dd/MM/yyyy HH:mm:ss"]) {
  String response = date == null
      ? "None"
      : format
          .replaceAll("dd", date.day.toString().padLeft(2, '0'))
          .replaceAll("MM", date.month.toString().padLeft(2, '0'))
          .replaceAll("yyyy", date.year.toString().padLeft(4, '0'))
          .replaceAll("HH", date.hour.toString().padLeft(2, '0'))
          .replaceAll("mm", date.minute.toString().padLeft(2, '0'))
          .replaceAll("ss", date.second.toString().padLeft(2, '0'));

  return response;
}

String formatTime(TimeOfDay time) {
  String response = time == null
      ? "None"
      : "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  return response;
}
