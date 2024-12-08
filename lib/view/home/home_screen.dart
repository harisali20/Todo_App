import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app_task/Utility.dart';
import 'package:todo_app_task/view/home/settings_screen.dart';
import 'package:todo_app_task/view/tasks/task_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> tasks = [
    {
      'title': 'Task 1',
      'description': 'Description of Task 1',
      'date': '12/12/2024',
    },
    {
      'title': 'Task 2',
      'description': 'Description of Task 2',
      'date': '12/12/2024',
    },
    {
      'title': 'Task 3',
      'description': 'Description of Task 3',
      'date': '12/12/2024',
    },
    {
      'title': 'Task 4',
      'description': 'Description of Task 4',
      'date': '12/12/2024',
    },
    {
      'title': 'Task 5',
      'description': 'Description of Task 5',
      'date': '12/12/2024',
    },
  ];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final DraggableScrollableController _draggableScrollableController = DraggableScrollableController();
  ValueNotifier<bool> isFabVisible = ValueNotifier(true);

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        size: 30,
                        weight: 0.2,
                      ),
                      color: secondaryColor,
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: tasks.length,
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
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => TaskDetails(title: tasks[index]['title']! , description: tasks[index]['description']!),
                              ));
                            },
                            child: ListTile(
                              style: ListTileStyle.list,
                              title: Padding(
                                padding: EdgeInsets.only(
                                  bottom: mq.size.height * 0.02,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tasks[index]['title']!,
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(tasks[index]['description']!,
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontSize: 15,
                                          )),
                                    ),
                                    Text(tasks[index]['date']!,
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 10,
                                        ))
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
            child: DraggableScrollableSheet(
              controller: _draggableScrollableController,
              initialChildSize: 0,
              minChildSize: 0,
              maxChildSize: 1,
              builder: (BuildContext context, ScrollController scrollController) {
                _draggableScrollableController.addListener(() {
                  if (_draggableScrollableController.size > 0.1) {
                    isFabVisible.value = false;
                  } else {
                    isFabVisible.value = true;
                  }
                });
                return Container(
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
                  child: ListView(
                    controller: scrollController,
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
                              Container(
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  border: Border.all(
                                    color: whiteColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: mq.size.height * 0.4,
                                child: Padding(
                                  padding: EdgeInsets.all(mq.size.width * 0.02),
                                  child: TextField(
                                    style: TextStyle(
                                      color: whiteColor,
                                    ),
                                    cursorColor: whiteColor,
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Description',
                                      hintStyle: TextStyle(
                                        color: whiteColor,
                                      ),
                                      suffixIconColor: textFieldColor,
                                    ),
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
                                  hintText: 'Deadline(Optional)',
                                  suffixIcon: IconButton(
                                    onPressed: (){},
                                    icon: const Icon(
                                      Icons.calendar_today_outlined,
                                    ),
                                  ),
                                  enabledBorder: borderDecor(whiteColor),
                                  focusedBorder: borderDecor(whiteColor),
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
                                decoration: InputDecoration(
                                  fillColor: whiteColor,
                                  hintText: 'Add Image(Optional)',
                                  suffixIcon: IconButton(
                                    onPressed: (){},
                                    icon: const Icon(
                                      Icons.insert_photo_outlined,
                                    ),
                                  ),
                                  enabledBorder: borderDecor(whiteColor),
                                  focusedBorder: borderDecor(whiteColor),
                                  hintStyle: TextStyle(
                                    color: whiteColor,
                                  ),
                                  suffixIconColor: whiteColor,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(mq.size.width, mq.size.height * 0.07),
                                  foregroundColor: buttonColor,
                                  backgroundColor: whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(mq.size.width * 0.05),
                                  ),
                                ),
                                child: const Text('ADD TODO'),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: isFabVisible,
        builder: (context, isVisible, child) {
          return Visibility(
            visible: isVisible,
            child: FloatingActionButton(
              onPressed: () {
                _draggableScrollableController.animateTo(
                  1.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
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
        },
      ),
    );
  }
}