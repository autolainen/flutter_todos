import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todos/blocs/todos/todos_bloc_2.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'loading_indicator.dart';

class Stats extends StatelessWidget {
  Stats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todosBloc2 = Provider.of<TodosBloc2>(context, listen: false);
    return StreamBuilder(
      stream: todosBloc2.isLoading,
      builder: (context, isLoadingSnapshot) {
        return isLoadingSnapshot.data == true
            ? LoadingIndicator()
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            ArchSampleLocalizations.of(context).completedTodos,
                            style: Theme.of(context).textTheme.headline6)),
                    Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: StreamBuilder(
                            stream: todosBloc2.countCompleted,
                            builder: (context, countCompletedSnapshot) {
                              return Text('${countCompletedSnapshot.data ?? 0}',
                                  style: Theme.of(context).textTheme.subtitle1);
                            })),
                    Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ArchSampleLocalizations.of(context).activeTodos,
                          style: Theme.of(context).textTheme.headline6,
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: StreamBuilder(
                            stream: todosBloc2.countActive,
                            builder: (context, countActiveSnapshot) {
                              return Text('${countActiveSnapshot.data ?? 0}',
                                  style: Theme.of(context).textTheme.subtitle1);
                            }))
                  ]));
      },
    );
  }
}
