import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo463_app/todo.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];

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
        todoList.sort((a,b) => a.createdAt.compareTo(b.createdAt)); //ソートの記述
        this.todoList = todoList;
        notifyListeners();
      });
    }
}