import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/todo_detail_screen.dart';
import 'package:todo_list/services/database_service.dart';
import 'package:todo_list/widgets/functions.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().todos,
      builder: (ctx, AsyncSnapshot<List<Todo>> todosSnapshot) {
        if (todosSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );

        if (todosSnapshot.hasError)
          return Center(child: Text(todosSnapshot.error.toString()));

        if (todosSnapshot.data != null) {
          final todoList = todosSnapshot.data as List<Todo>;
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return Card(
                color: todoList[index].completed ? Colors.grey : null,
                child: ListTile(
                  onTap: todoList[index].completed
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => TodoDetailScreen(
                                todo: todoList[index],
                              ),
                            ),
                          );
                        },
                  leading: IconButton(
                    onPressed: () {
                      DatabaseService().toogleCompleted(todoList[index]);
                    },
                    icon: todoList[index].completed
                        ? Icon(Icons.check_outlined)
                        : Icon(Icons.circle_outlined),
                  ),
                  title: Text(todoList[index].title),
                  subtitle: todoList[index].dueDate == null
                      ? null
                      : Text(formatDateTime(todoList[index].dueDate)),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text(' Tidak ada data'),
          );
        }
      },
    );
  }
}
