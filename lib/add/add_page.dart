import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo463_app/main_model.dart';

class AddPage extends StatelessWidget {
  final MainModel model;
  AddPage(this.model);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>.value(
      //MaterialAppは一つでオッケ。複数作るとマトリョーシカみたいになる
      value: MainModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規追加'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration:
                      InputDecoration(labelText: '追加するTODO', hintText: '洗濯する'),
                  onChanged: (text) {
                    model.newTodoText = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  child: Text('追加'),
                  onPressed: () async {
                    //TODO: firestoreに値を追加する
                    await model.add();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
