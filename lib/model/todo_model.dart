import 'dart:io';

class Todo{
  //title,description,date
  final String title;
  final String description;
  final DateTime currentDate;
  final DateTime endDate;
  File? image;

  Todo({
    required this.title,
    required this.description,
    required this.currentDate,
    required this.endDate,
    this.image,
  });
}