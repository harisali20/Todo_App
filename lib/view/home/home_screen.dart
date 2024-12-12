import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app_task/Utility.dart';
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

List<Todo> tasks = [ ];
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int menuValue = 1;
  bool isDatePassed(DateTime currentDate, endDate) {
    return currentDate.isBefore(endDate);
  }
  List<Todo> filteredTasks = [];
  @override
  Widget build(BuildContext context) {

    MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('TO DO LIST',
            style: TextStyle(
              color: buttonColor,
            )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/images/Logo.svg',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mq.size.width * 0.03),
                      child: Text('LIST OF TODO',
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                // IconButton(
                //   onPressed: () {
                //
                //     showDialog(context: context, builder: (context){
                //       return Dialog(
                //         backgroundColor: buttonColor,
                //         child: SizedBox(
                //           height: mq.size.height * 0.2,
                //           child: Column(
                //             children: [
                //               ElevatedButton(
                //                 onPressed: (){
                //                   filteredTasks = tasks;
                //                 },
                //                 child: const Text('All'),
                //               ),
                //               ElevatedButton(
                //                 onPressed: (){
                //                   filteredTasks = tasks.where((element) => isDatePassed(element.currentDate, element.endDate)).toList();
                //                 },
                //                 child: const Text('By Time'),
                //               ),
                //               ElevatedButton(
                //                 onPressed: (){
                //                   filteredTasks = tasks.where((element) => !isDatePassed(element.currentDate, element.endDate)).toList();
                //                 },
                //                 child: const Text('Deadline'),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     });
                //   },
                //   icon: const Icon(
                //     Icons.filter_alt_outlined,
                //     size: 30,
                //     weight: 0.2,
                //   ),
                //   color: secondaryColor,
                // ),
                PopupMenuButton(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      size: 30,
                      color: secondaryColor,
                    ),
                    onSelected: (value) {
                      setState(() {
                        switch (value) {
                          case 1:
                            filteredTasks = tasks;
                            menuValue = 1;
                            break;
                          case 2:
                            filteredTasks = tasks.where((element) => isDatePassed(element.currentDate, element.endDate)).toList();
                            menuValue = 2;
                            break;
                          case 3:
                            filteredTasks = tasks.where((element) => !isDatePassed(element.currentDate, element.endDate)).toList();
                            menuValue = 3;
                            break;
                        }
                      });
                    },
                    itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      child: Text('All',style: TextStyle(color: (menuValue == 1) ? buttonColor : Colors.black)),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text('By Time',style: TextStyle(color: (menuValue == 2) ? buttonColor : Colors.black))
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Text('Deadline',style: TextStyle(color: (menuValue == 3) ? buttonColor : Colors.black))),
                  ];
                }),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredTasks.length,
                padding: EdgeInsets.symmetric(
                  horizontal: mq.size.width * 0.05,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: mq.size.height * 0.01),
                    child: Container(
                      height: mq.size.height * 0.17,
                      decoration: BoxDecoration(
                          color: index.isEven ? secondaryColor : buttonColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetails(
                                    title: filteredTasks[index].title,
                                    description: filteredTasks[index].description,
                                    index: index,
                                    currentDate: filteredTasks[index].currentDate,
                                    endDate: filteredTasks[index].endDate),
                              ));
                        },
                        child: ListTile(
                          style: ListTileStyle.list,
                          title: Padding(
                            padding: EdgeInsets.only(
                              bottom: mq.size.height * 0.02,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(filteredTasks[index].title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Visibility(
                                          visible: isDatePassed(tasks[index].currentDate, tasks[index].endDate),
                                          child: Image.asset('lib/assets/images/clock.png'),
                                        ),
                                      ],
                                    ),


                                Expanded(
                                  child: Text(filteredTasks[index].description,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 15,
                                      )),
                                ),
                                Text("Created at ${filteredTasks[index].currentDate.toString().substring(0,16)}",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 10,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dateController.clear();
          _descriptionController.clear();
          _titleController.clear();
          showModalBottomSheet(
            isScrollControlled: true,
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(top: mq.viewInsets.bottom),
                  child: Container(
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
                                    hintText: 'Title',
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
                                      hintText: 'Description',
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
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                  cursorColor: whiteColor,
                                  canRequestFocus: false,
                                  decoration: InputDecoration(
                                    fillColor: whiteColor,
                                    enabledBorder: borderDecor(whiteColor),
                                    focusedBorder: borderDecor(whiteColor),
                                    hintText: 'Add Image(Optional)',
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        showDialog(context: context, builder: (context){
                                          return SizedBox(
                                            height: mq.size.height * 0.2,
                                            child: AlertDialog(
                                              title: Text('Add Image'),
                                              content: Column(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: (){},
                                                    child: Text('Camera'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: (){},
                                                    child: Text('Gallery'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      },
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
                                    tasks.add(Todo(
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      currentDate: DateTime.now(),
                                      endDate: (_dateController.text == "") ?
                                        DateTime.now() : formatter.parse(_dateController.text),
                                    ));
                                    });
                                    // print(formatter.parse(_dateController.text));
                                    Navigator.pop(context);
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
                                  child: const Text('ADD TODO'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
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
