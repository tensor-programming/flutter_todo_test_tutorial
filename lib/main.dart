import 'package:flutter/material.dart';
import 'package:test_todo/logic.dart';

import 'package:test_todo/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Todo> todoList;

  const MyApp({Key key, this.todoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Todo> todoList;

  MyHomePage({Key key, List<Todo> todos})
      : this.todoList = todos ?? <Todo>[],
        super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TodoLogic _logic = TodoLogic();

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _logic.streamController.sink.add(widget.todoList ?? <Todo>[]);
    super.initState();
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo App"),
      ),
      body: StreamBuilder<List<Todo>>(
          stream: _logic.streamController.stream,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: TextField(
                  key: Key('todo-field'),
                  autofocus: true,
                  controller: _textEditingController,
                )),
                ...showTodos(snapshot),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        key: Key('add-todo'),
                        child: Text("Add a Todo"),
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (_textEditingController.text.isNotEmpty) {
                            _logic.addTodo(
                              _textEditingController.text,
                            );

                            _textEditingController.text = "";
                          }
                        },
                      ),
                      FlatButton(
                        key: Key('delete-finished'),
                        child: Text("Delete Finished todos"),
                        color: Colors.orangeAccent,
                        onPressed: () {
                          _logic.removeFinishedTodos();
                        },
                      ),
                      FlatButton(
                        key: Key('delete-all'),
                        child: Text("Delete all"),
                        color: Colors.redAccent,
                        onPressed: () {
                          _logic.clearTodos();
                        },
                      ),
                    ]),
              ],
            );
          }),
    );
  }

  List<Widget> showTodos(AsyncSnapshot<List<Todo>> snapshot) {
    if (!snapshot.hasData || snapshot.data.length == 0) {
      return [
        Flexible(
          child: CircularProgressIndicator(),
        ),
      ];
    } else {
      return [
        Expanded(
          child: ListView.builder(
            itemCount: _logic.list.length,
            itemBuilder: (context, idx) => GestureDetector(
              key: Key('gd-$idx'),
              onLongPress: () {
                _logic.removeTodoByIndex(idx);
              },
              child: CheckboxListTile(
                key: ValueKey('$idx-${snapshot.data[idx].finished}-checkbox'),
                title: Text(
                  snapshot.data[idx].body,
                  key: ValueKey('$idx-todo'),
                ),
                value: snapshot.data[idx].finished,
                onChanged: (bool value) {
                  _logic.markItemFinished(idx, value);
                },
              ),
            ),
          ),
        )
      ];
    }
  }
}
