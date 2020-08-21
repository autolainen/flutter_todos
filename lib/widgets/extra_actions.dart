import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todos/blocs/todos/todos_bloc_2.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

enum ExtraAction { toggleAllComplete, clearCompleted }

class ExtraActions extends StatelessWidget {
  ExtraActions({Key key}) : super(key: ArchSampleKeys.extraActionsButton);

  @override
  Widget build(BuildContext context) {
    final todosBloc2 = Provider.of<TodosBloc2>(context, listen: false);
    return StreamBuilder<bool>(
        stream: todosBloc2.allComplete,
        builder: (context, allCompleteSnapshot) {
          return allCompleteSnapshot.data == null
              ? SizedBox.shrink()
              : PopupMenuButton<ExtraAction>(
                  onSelected: (action) {
                    switch (action) {
                      case ExtraAction.clearCompleted:
                        todosBloc2.clearCompleted();
                        break;
                      case ExtraAction.toggleAllComplete:
                        allCompleteSnapshot.data
                            ? todosBloc2.markAllIncomplete()
                            : todosBloc2.markAllComplete();
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<ExtraAction>>[
                        PopupMenuItem<ExtraAction>(
                          key: ArchSampleKeys.toggleAll,
                          value: ExtraAction.toggleAllComplete,
                          child: Text(
                            allCompleteSnapshot.data
                                ? ArchSampleLocalizations.of(context)
                                    .markAllIncomplete
                                : ArchSampleLocalizations.of(context)
                                    .markAllComplete,
                          ),
                        ),
                        PopupMenuItem<ExtraAction>(
                            value: ExtraAction.clearCompleted,
                            child: Text(
                              ArchSampleLocalizations.of(context)
                                  .clearCompleted,
                            ))
                      ]);
        });
  }
}
