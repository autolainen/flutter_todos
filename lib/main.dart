import 'package:flutter/material.dart';
import 'package:flutter_todos/localization.dart';
import 'package:flutter_todos/screens/screens.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

import 'blocs/todos/todos_bloc_2.dart';
import 'models/todo.dart';

void main() {
  runApp(Provider<TodosBloc2>(
      create: (context) {
        return TodosBloc2(
            todosRepository: const TodosRepositoryFlutter(
                fileStorage: const FileStorage(
                    '__flutter_bloc_app__', getApplicationDocumentsDirectory)));
      },
      child: TodosApp()));
}

class TodosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: FlutterBlocLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          FlutterBlocLocalizationsDelegate()
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return HomeScreen();
          },
          ArchSampleRoutes.addTodo: (context) {
            return AddEditScreen(
              key: ArchSampleKeys.addTodoScreen,
              onSave: (task, note) {
                Provider.of<TodosBloc2>(context, listen: false)
                    .addTodo(Todo(task, note: note));
              },
              isEditing: false,
            );
          }
        });
  }
}
