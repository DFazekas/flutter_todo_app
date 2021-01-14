import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/widgets/todo_card.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        actions: [
          IconButton(
              key: const ValueKey("signOut"),
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Auth(auth: widget.auth).signOut();
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Add Todo Here:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      key: const ValueKey("addField"),
                      controller: _todoController,
                    ),
                  ),
                  IconButton(
                      key: const ValueKey("addButton"),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Todo is not empty.
                        if (_todoController.text != "") {
                          setState(() {
                            Database(firestore: widget.firestore).addTodo(
                                uid: widget.auth.currentUser.uid,
                                content: _todoController.text);
                            _todoController.clear();
                          });
                        }
                      })
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Your Todos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: Database(firestore: widget.firestore)
                .streamTodos(uid: widget.auth.currentUser.uid),
            builder: (BuildContext context,
                AsyncSnapshot<List<TodoModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData == false || snapshot.data.isEmpty) {
                  return const Center(
                    child: Text("You don't have any incomplete Todos."),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return TodoCard(
                          todo: snapshot.data[index],
                          uid: widget.auth.currentUser.uid,
                          firestore: widget.firestore);
                    },
                  );
                }
              } else {
                return const Center(child: Text("Loading..."));
              }
            },
          )),
        ],
      ),
    );
  }
}
