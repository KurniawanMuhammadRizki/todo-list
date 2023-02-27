import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/widgets/new_todo.dart';
import 'package:todo_list/widgets/todo_list.dart';

class AllTodoScreen extends StatelessWidget {
  const AllTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Todo'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: TodoList(),
            ),
            NewTodo(),
          ],
        ),
      ),
    );
  }
}
