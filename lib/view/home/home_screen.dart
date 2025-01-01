import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app_task/Utility.dart';
import 'package:todo_app_task/main.dart';
import 'package:todo_app_task/view/home/settings_screen.dart';
import 'package:todo_app_task/view/tasks/task_details.dart';

import '../../model/todo_model.dart';

import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  File? _image;
  final userId = prefs?.getString('userId');

  bool isDatePassed(DateTime currentDate, endDate) {
    return currentDate.isBefore(endDate);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageController.text = _image!.path;
      });
      snackBar('Image added successfully');
    }
  }

  Future<void> _addTask() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'currentDate': DateTime.now(),
      'endDate': _dateController.text.isEmpty ? DateTime.now() : formatter.parse(_dateController.text),
      'image': _imageController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('TO DO LIST', style: TextStyle(color: buttonColor)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: mq.size.height * 0.01),
                child: Container(
                  height: mq.size.height * 0.17,
                  decoration: BoxDecoration(
                    color: index.isEven ? secondaryColor : buttonColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetails(
                            userId: userId??'',
                            taskId: task.id,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      style: ListTileStyle.list,
                      title: Padding(
                        padding: EdgeInsets.only(bottom: mq.size.height * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    task['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isDatePassed(
                                    (task['currentDate'] as Timestamp).toDate(),
                                    (task['endDate'] as Timestamp).toDate(),
                                  ),
                                  child: Image.asset('lib/assets/images/clock.png'),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Text(
                                task['description'],
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              "Created at ${(task['currentDate'] as Timestamp).toDate().toString().substring(0, 16)}",
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dateController.clear();
          _descriptionController.clear();
          _titleController.clear();
          _imageController.clear();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.all(mq.viewInsets.bottom),
                child: Container(
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
                                  keyboardType: TextInputType.name,
                                  controller: _descriptionController,
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
                                canRequestFocus: false,
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
                              TextField(
                                style: TextStyle(color: whiteColor),
                                cursorColor: whiteColor,
                                canRequestFocus: false,
                                controller: _imageController,
                                decoration: InputDecoration(
                                  fillColor: whiteColor,
                                  enabledBorder: borderDecor(whiteColor),
                                  focusedBorder: borderDecor(whiteColor),
                                  hintText: 'Add Image(Optional)',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Add Image'),
                                            content: SizedBox(
                                              height: mq.size.height * 0.15,
                                              child: Column(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                        await _pickImage(ImageSource.camera);
                                                        Navigator.pop(context);
                                                    },
                                                    child: Text('Camera'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await _pickImage(ImageSource.gallery);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Gallery'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.insert_photo_outlined),
                                  ),
                                  border: borderDecor(whiteColor),
                                  hintStyle: TextStyle(color: whiteColor),
                                  suffixIconColor: whiteColor,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _addTask();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                                  foregroundColor: buttonColor,
                                  backgroundColor: whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                                  ),
                                ),
                                child: const Text('ADD TODO'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        foregroundColor: whiteColor,
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 3,
        child: Icon(Icons.add, size: mq.size.width * 0.13),
      ),
    );
  }
}