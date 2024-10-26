import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/domain/models/todo.dart';
import 'package:flutter_application_1/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[100],
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            hintText: 'Enter your task',
            hintStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'SpaceGrotesk',
              )
            ),
          ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoCubit.addTodo(textController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('tasked'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'SpaceGrotesk',
          )
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoBox(context),
        backgroundColor: Colors.red[400],
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return ListTile(
                title: Text(
                  todo.text,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) => todoCubit.toggleCompletion(todo),
                  activeColor: Colors.red[400],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () => todoCubit.deleteTodo(todo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
