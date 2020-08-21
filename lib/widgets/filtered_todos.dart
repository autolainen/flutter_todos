import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todos/blocs/todos/todos_bloc_2.dart';
import 'package:flutter_todos/screens/screens.dart';
import 'package:flutter_todos/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../models/todo.dart';

class FilteredTodos extends StatelessWidget {
  FilteredTodos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final todosBloc2 = Provider.of<TodosBloc2>(context, listen: false);
    return StreamBuilder(
        stream: todosBloc2.isLoading,
        builder: (context, isLoadingSnapshot) {
          return isLoadingSnapshot.data == true
              ? LoadingIndicator()
              : StreamBuilder<List<Todo>>(
                  stream: todosBloc2.filteredTodoList,
                  builder: (context, todosListSnapshot) {
                    final todos = todosListSnapshot.data ?? [];
                    return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final todo = todos[index];
                          return TodoItem(
                              todo: todo,
                              onDismissed: (direction) {
                                todosBloc2.deleteTodo(todo);
                                Scaffold.of(context)
                                    .showSnackBar(DeleteTodoSnackBar(
                                  todo: todo,
                                  onUndo: () => todosBloc2.addTodo(todo),
                                  localizations: localizations,
                                ));
                              },
                              onTap: () async {
                                final removedTodo =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute<Todo>(builder: (_) {
                                    return DetailsScreen(id: todo.id);
                                  }),
                                );
                                if (removedTodo != null) {
                                  Scaffold.of(context)
                                      .showSnackBar(DeleteTodoSnackBar(
                                    todo: removedTodo,
                                    onUndo: () =>
                                        todosBloc2.addTodo(removedTodo),
                                    localizations: localizations,
                                  ));
                                }
                              },
                              onCheckboxChanged: (_) {
                                todosBloc2.updateTodo(
                                    todo.copyWith(complete: !todo.complete));
                              });
                        });
                  });
        });
  }
}
