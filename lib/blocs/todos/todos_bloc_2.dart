import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter_todos/models/todo.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';

import '../../models/visibility_filter.dart';

class TodosBloc2 {
  final TodosRepositoryFlutter todosRepository;
  final todosList = BehaviorSubject<List<Todo>>.seeded([]);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final visibilityFilter =
      BehaviorSubject<VisibilityFilter>.seeded(VisibilityFilter.all);

  TodosBloc2({@required this.todosRepository}) {
    () async {
      await _loadTodos();
      todosList.skip(1).listen((value) {
        todosRepository.saveTodos(
            value.map<TodoEntity>((todo) => todo.toEntity()).toList());
      });
    }();
  }

  Stream<bool> get allComplete {
    return todosList.map((todos) {
      return todos.fold(
          true, (previousValue, todo) => previousValue && todo.complete);
    });
  }

  Stream<List<Todo>> get filteredTodoList {
    return CombineLatestStream.combine2<List<Todo>, VisibilityFilter,
        List<Todo>>(todosList, visibilityFilter, (todoList, visFilter) {
      List<Todo> result;
      if (visFilter == VisibilityFilter.all) {
        result = todoList;
      } else {
        result = todoList.where((todo) {
          return todo.complete == (visFilter == VisibilityFilter.completed);
        }).toList();
      }
      return result ?? [];
    });
  }

  Stream<int> get countActive => _createCount(false);

  Stream<int> get countCompleted => _createCount(true);

  Stream<int> _createCount(bool isCompleted) {
    return todosList.map<int>((todoList) => todoList.fold(0,
        (prev, element) => prev + (element.complete == isCompleted ? 1 : 0)));
  }

  Future<void> _loadTodos() async {
    try {
      isLoading.add(true);
      todosList.add((await todosRepository.loadTodos() ?? [])
          .map<Todo>((entity) => Todo.fromEntity(entity))
          .toList());
    } finally {
      isLoading.add(false);
    }
  }

  void dispose() {
    visibilityFilter?.close();
    todosList?.close();
    isLoading?.close();
  }

  void deleteTodo(Todo deletedTodo) {
    todosList.add(List<Todo>.from(
        todosList.value.where((todo) => todo.id != deletedTodo.id)));
  }

  void addTodo(Todo todo) {
    todosList.add(List<Todo>.from(todosList.value)..add(todo));
  }

  void updateTodo(Todo updatedTodo) {
    todosList.add(List<Todo>.from(todosList.value.map((todo) {
      return todo.id == updatedTodo.id ? updatedTodo : todo;
    })));
  }

  void clearCompleted() {
    todosList.add(List<Todo>.from(todosList.value.where((todo) {
      return todo.complete != true;
    })));
  }

  void markAllComplete() => _toggleCompleteFlag(true);

  void markAllIncomplete() => _toggleCompleteFlag(false);

  void _toggleCompleteFlag(bool complete) {
    todosList.add(List<Todo>.from(todosList.value.map((todo) {
      return todo.copyWith(complete: complete);
    })));
  }
}
