import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_task/Utility.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

class TaskDetails extends StatefulWidget {
  final String userId;
  final String taskId;

  TaskDetails({super.key, required this.userId, required this.taskId});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DocumentSnapshot? task;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    task = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('tasks')
        .doc(widget.taskId)
        .get();

    _titleController.text = task!['title'];
    _descriptionController.text = task!['description'];
    _dateController.text = formatter.format((task!['endDate'] as Timestamp).toDate());
    setState(() {});
  }

  Future<void> _updateTask() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('tasks')
        .doc(widget.taskId)
        .update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'endDate': _dateController.text.isEmpty ? DateTime.now() : formatter.parse(_dateController.text),
    });
  }

  Future<void> _deleteTask() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('tasks')
        .doc(widget.taskId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final overlay = Overlay.of(context);
              final overlayEntry = OverlayEntry(
                builder: (context) {
                  return Positioned(
                    top: mq.size.height * 0.1,
                    left: mq.size.width / 2 - 10,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.02, vertical: mq.size.height * 0.011),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _dateController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

              overlay.insert(overlayEntry);

              Future.delayed(const Duration(seconds: 3), () {
                overlayEntry.remove();
              });
            },
            icon: const Icon(Icons.history_toggle_off_outlined),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    height: mq.size.height * 0.9,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: mq.size.height * 0.01),
                            child: Container(
                              height: mq.size.height * 0.01,
                              width: mq.size.width * 0.2,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: mq.size.height * 0.8,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextField(
                                  style: TextStyle(color: whiteColor),
                                  cursorColor: whiteColor,
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    enabledBorder: borderDecor(whiteColor),
                                    focusedBorder: borderDecor(whiteColor),
                                    hintStyle: TextStyle(color: whiteColor),
                                    suffixIconColor: textFieldColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(mq.size.width * 0.02),
                                  child: TextField(
                                    style: TextStyle(color: whiteColor),
                                    cursorColor: whiteColor,
                                    maxLines: 10,
                                    autofocus: false,
                                    controller: _descriptionController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Description',
                                      enabledBorder: borderDecor(whiteColor),
                                      focusedBorder: borderDecor(whiteColor),
                                      hintStyle: TextStyle(color: whiteColor),
                                      suffixIconColor: textFieldColor,
                                    ),
                                  ),
                                ),
                                TextField(
                                  style: TextStyle(color: whiteColor),
                                  cursorColor: whiteColor,
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    hintText: 'Deadline(Optional)',
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2025),
                                        ).then((date) {
                                          if (date != null) {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((time) {
                                              if (time != null) {
                                                final DateTime dateTime = DateTime(
                                                  date.year,
                                                  date.month,
                                                  date.day,
                                                  time.hour,
                                                  time.minute,
                                                );
                                                _dateController.text = formatter.format(dateTime);
                                              }
                                            });
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.calendar_today_outlined),
                                    ),
                                    border: borderDecor(whiteColor),
                                    focusedBorder: borderDecor(whiteColor),
                                    enabledBorder: borderDecor(whiteColor),
                                    hintStyle: TextStyle(color: whiteColor),
                                    suffixIconColor: whiteColor,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _updateTask();
                                    Navigator.pop(context);
                                    setState(() {
                                      _fetchTaskDetails();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                                    foregroundColor: buttonColor,
                                    backgroundColor: whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                                    ),
                                  ),
                                  child: const Text('EDIT TODO'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(mq.size.width * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _deleteTask();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                                foregroundColor: Colors.red,
                                backgroundColor: whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                                ),
                              ),
                              child: const Text('DELETE TODO'),
                            ),
                            SizedBox(
                              height: mq.size.height * 0.03,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                                foregroundColor: Colors.lightGreenAccent,
                                backgroundColor: whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                                ),
                              ),
                              child: const Text('CANCEL'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: task == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
                  child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(_titleController.text, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: mq.size.height * 0.02),
                  Text(_descriptionController.text, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
            task!['image'].toString().isEmpty ? Text('') :Image(image: FileImage(File(task!['image']))),

            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Created at ${(task!['currentDate'] as Timestamp).toDate().toString().substring(0, 16)}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: mq.size.width * 0.04,
                ),
              ),
            ),
          ],
                  ),
                ),
    );
  }
}