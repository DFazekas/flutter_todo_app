import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({this.firestore});

  /// Return all Todos from Firestore.
  Stream<List<TodoModel>> streamTodos({String uid}) {
    try {
      return firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .where("done", isEqualTo: false)
          .snapshots()
          .map((query) {
        // Given a query, go through every document in the query,
        // appending to the list, and return the list through a stream.
        List<TodoModel> retVal = <TodoModel>[];
        for (final QueryDocumentSnapshot doc in query.docs) {
          retVal.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Add a new Todo to Firestore.
  Future<void> addTodo({String uid, String content}) async {
    try {
      await firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .add({"content": content, "done": false});
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing Todo in Firestore.
  Future<void> updateTodo({String uid, String todoId}) async {
    try {
      await firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .doc(todoId)
          .update({"done": true});
    } catch (e) {
      rethrow;
    }
  }
}
