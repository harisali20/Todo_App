import 'package:flutter/material.dart';

class TaskDetails extends StatefulWidget {
  final String title;
  final String description;

  const TaskDetails({super.key, required this.title, required this.description});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.history_toggle_off_outlined)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.description, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
