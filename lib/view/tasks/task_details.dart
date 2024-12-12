import 'package:flutter/material.dart';
import 'package:todo_app_task/view/home/home_screen.dart';
import 'package:todo_app_task/Utility.dart';

import '../../model/todo_model.dart';

class TaskDetails extends StatefulWidget {
  String title;
  String description;
  DateTime currentDate;
  DateTime endDate;
  int index;

  TaskDetails({super.key, required this.title, required this.description, required this.index, required this.currentDate, required this.endDate});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {
              final overlay = Overlay.of(context);
              final overlayEntry = OverlayEntry(
                builder: (context) {
                  // Position the message directly below the icon
                  return Positioned(
                    top: mq.size.height * 0.1, // Adjust based on your icon's position
                    left: mq.size.width / 2 - 10, // Center horizontally
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.02, vertical: mq.size.height * 0.011),
                        decoration: BoxDecoration(
                          color: Colors.red, // Match the background color
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
                          widget.endDate.toString().substring(0,16), // Display the current date
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

              // Insert the overlay
              overlay.insert(overlayEntry);

              // Remove the overlay after 2 seconds
              Future.delayed(const Duration(seconds: 3), () {
                overlayEntry.remove();
              });
            },
            icon: const Icon(Icons.history_toggle_off_outlined),
          ),

          IconButton(onPressed: (){
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    height: mq.size.height * 0.9,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: mq.size.width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextField(
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                  cursorColor: whiteColor,
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    hintText: widget.title,
                                    enabledBorder: borderDecor(whiteColor),
                                    focusedBorder: borderDecor(whiteColor),
                                    hintStyle: TextStyle(
                                      color: whiteColor,
                                    ),
                                    suffixIconColor: textFieldColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(mq.size.width * 0.02),
                                  child: TextField(
                                    style: TextStyle(
                                      color: whiteColor,
                                    ),
                                    cursorColor: whiteColor,
                                    maxLines: 10,
                                    autofocus: false,
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: widget.description,
                                      enabledBorder: borderDecor(whiteColor),
                                      focusedBorder: borderDecor(whiteColor),

                                      hintStyle: TextStyle(
                                        color: whiteColor,
                                      ),
                                      suffixIconColor: textFieldColor,
                                    ),
                                  ),
                                ),
                                TextField(
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                  cursorColor: whiteColor,
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    hintText: widget.endDate.toString().substring(0,16),
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
                                      icon: const Icon(
                                        Icons.calendar_today_outlined,
                                      ),
                                    ),
                                    border: borderDecor(whiteColor),
                                    focusedBorder: borderDecor(whiteColor),
                                    enabledBorder: borderDecor(whiteColor),

                                    hintStyle: TextStyle(
                                      color: whiteColor,
                                    ),
                                    suffixIconColor: whiteColor,
                                  ),
                                ),
                                TextField(
                                  enabled: false,
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                  cursorColor: whiteColor,
                                  decoration: InputDecoration(
                                    fillColor: whiteColor,
                                    hintText: 'Add Image(Optional)',
                                    suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.insert_photo_outlined,
                                      ),
                                    ),
                                    border: borderDecor(whiteColor),
                                    hintStyle: TextStyle(
                                      color: textFieldColor,
                                    ),
                                    suffixIconColor: textFieldColor,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      tasks[widget.index] = Todo(
                                        title: _titleController.text,
                                        description: _descriptionController.text,
                                        currentDate: widget.currentDate,
                                        endDate: formatter.parse(_dateController.text),
                                      );
                                    });
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        mq.size.width, mq.size.height * 0.07),
                                    foregroundColor: buttonColor,
                                    backgroundColor: whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          mq.size.width * 0.05),
                                    ),
                                  ),
                                  child: const Text('EDIT TODO'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }, icon: const Icon(Icons.edit)),
          IconButton(onPressed: (){
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
                          onPressed: () {
                            tasks.removeAt(widget.index);
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
            });
          }, icon: const Icon(Icons.delete)),
        ],
      ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Text(widget.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: mq.size.height * 0.02),
                    Text(widget.description, style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Created at ${tasks[widget.index].currentDate.toString().substring(0, 16)}",
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
