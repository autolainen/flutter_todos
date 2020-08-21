import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todos/localization.dart';
import 'package:flutter_todos/widgets/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  BehaviorSubject<int> _currentPageIndex;

  _HomeScreenState() {
    _tabController = TabController(length: 2, vsync: this);
    _currentPageIndex = BehaviorSubject<int>.seeded(_tabController.index);
    _tabController.addListener(() {
      _currentPageIndex.add(_tabController.index);
    });
  }

  @override
  void dispose() {
    _currentPageIndex?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(FlutterBlocLocalizations.of(context).appTitle),
          actions: [
            StreamBuilder<int>(
                stream: _currentPageIndex,
                builder: (context, pageIndexSnapshot) {
                  return FilterButton(visible: pageIndexSnapshot.data == 0);
                }),
            ExtraActions()
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[FilteredTodos(), Stats()],
        ),
        floatingActionButton: FloatingActionButton(
          key: ArchSampleKeys.addTodoFab,
          onPressed: () {
            Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
          },
          child: Icon(Icons.add),
          tooltip: ArchSampleLocalizations.of(context).addTodo,
        ),
        bottomNavigationBar: TabBar(controller: _tabController, tabs: <Widget>[
          _createBottomNavButton(
              Icon(Icons.list), ArchSampleLocalizations.of(context).todos),
          _createBottomNavButton(
              Icon(Icons.show_chart), ArchSampleLocalizations.of(context).stats)
        ]));
  }

  Widget _createBottomNavButton(Widget icon, String caption) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[icon, Text(caption)]);
  }
}
