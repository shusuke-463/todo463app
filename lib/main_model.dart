import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo463_app/todo.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];
  String newTodoText = '';

  Future getTodoList() async {
    final snapshot = await FirebaseFirestore.instance.collection('todoList')
        .get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc) => Todo(doc)).toList();
    this.todoList = todoList; //上にアクセス
    notifyListeners(); //←代入したことを伝える
  }

  void getTodoListRealtime() {
    final snapshots = FirebaseFirestore.instance.collection('todoList')
        .snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final todoList = docs.map((doc) => Todo(doc)).toList();
      todoList.sort((a, b) => a.createdAt.compareTo(b.createdAt)); //ソートの記述
      this.todoList = todoList;
      notifyListeners();
    });
  }

  Future add() async {
    final collection = FirebaseFirestore.instance.collection('todoList');
    await collection.add({
      'title': newTodoText,
      'createdAt': Timestamp.now(),
    });
  }

  void reload() {
    notifyListeners();
  }

  Future deleteCheckedItems() async {
    final checkedItems = todoList.where((todo) => todo.isDone).toList(); //絞り込み
    final references = checkedItems.map((todo) => todo.documentReference)
        .toList();

    final batch = FirebaseFirestore.instance.batch();

    references.forEach((references) {
      batch.delete(references);
    });
    return batch.commit();
  }
  bool checkShouldActiveCompleteButton() {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    return checkedItems.length > 0;
  }
}
