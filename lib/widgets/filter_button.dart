import 'package:flutter/material.dart';
import 'package:flutter_todos/blocs/todos/todos_bloc_2.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../models/visibility_filter.dart';

class FilterButton extends StatelessWidget {
  final bool visible;

  FilterButton({this.visible, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    final defaultStyle = themeData.textTheme.bodyText2;
    final activeStyle =
        themeData.textTheme.bodyText2.copyWith(color: themeData.accentColor);
    final todosBloc2 = Provider.of<TodosBloc2>(context, listen: false);

    return StreamBuilder(
        stream: todosBloc2.visibilityFilter,
        builder: (context, visibilityFilterSnapshot) {
          final button = _Button(
            onSelected: (filter) {
              todosBloc2.visibilityFilter.add(filter);
            },
            activeFilter: visibilityFilterSnapshot.data ?? VisibilityFilter.all,
            activeStyle: activeStyle,
            defaultStyle: defaultStyle,
          );
          return AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 150),
            child: visible ? button : IgnorePointer(child: button),
          );
        });
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.onSelected,
    @required this.activeFilter,
    @required this.activeStyle,
    @required this.defaultStyle,
  }) : super(key: key);

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
        key: ArchSampleKeys.filterButton,
        tooltip: ArchSampleLocalizations.of(context).filterTodos,
        onSelected: onSelected,
        itemBuilder: (BuildContext context) =>
            <PopupMenuItem<VisibilityFilter>>[
              PopupMenuItem<VisibilityFilter>(
                  key: ArchSampleKeys.allFilter,
                  value: VisibilityFilter.all,
                  child: Text(
                    ArchSampleLocalizations.of(context).showAll,
                    style: activeFilter == VisibilityFilter.all
                        ? activeStyle
                        : defaultStyle,
                  )),
              PopupMenuItem<VisibilityFilter>(
                  key: ArchSampleKeys.activeFilter,
                  value: VisibilityFilter.active,
                  child: Text(
                    ArchSampleLocalizations.of(context).showActive,
                    style: activeFilter == VisibilityFilter.active
                        ? activeStyle
                        : defaultStyle,
                  )),
              PopupMenuItem<VisibilityFilter>(
                  key: ArchSampleKeys.completedFilter,
                  value: VisibilityFilter.completed,
                  child: Text(
                    ArchSampleLocalizations.of(context).showCompleted,
                    style: activeFilter == VisibilityFilter.completed
                        ? activeStyle
                        : defaultStyle,
                  ))
            ],
        icon: Icon(Icons.filter_list));
  }
}
