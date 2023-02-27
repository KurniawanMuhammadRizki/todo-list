//import 'dart:js_util';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_list/models/data_user.dart';
import 'package:todo_list/models/todo.dart';

class DatabaseService {
  String _uid = '';

  DatabaseService() {
    if (FirebaseAuth.instance.currentUser != null) {
      _uid = FirebaseAuth.instance.currentUser!.uid;
    }
  }

  final   _todoReference = FirebaseFirestore.instance.collection('todos');
  final _dataUserReference = FirebaseFirestore.instance.collection('users');

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Todo(
        id: doc.id,
        title: data['title'] ?? '',
        note: data['note'] ?? '',
        completed: data['completed'] ?? false,
        dueDate:
            data['dueDate'] == null ? null : DateTime.parse(data['dueDate']),
        latitude: data['location'] == null ? 0.0 : data['location'].latitude,
        longitude: data['location'] == null ? 0.0 : data['location'].longitude,
      );
    }).toList();
  }

  Stream<List<Todo>> get todos {
    return _todoReference
        .where('uid', isEqualTo: _uid)
        .orderBy('completed')
        .orderBy('dueDate')
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  DataUser _dataUSerFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DataUser(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      userImageUrl: data['user_image_url'] ?? '',
    );
  }

  Stream<DataUser> get dataUser {
    return _dataUserReference.doc(_uid).snapshots().map(_dataUSerFromSnapshot);
  }

  Future addNewTodo(String title) {
    return _todoReference.add({
      'title': title,
      'dueDate': null,
      'completed': false,
      'uid': _uid,
    });
  }

  Future updateTodo(Todo todo) {
    return _todoReference.doc(todo.id).update({
      'title': todo.title,
      'note': todo.note,
      'location': GeoPoint(todo.latitude, todo.longitude),
      'dueDate': todo.dueDate == null ? null : todo.dueDate!.toIso8601String(),
      'completed': todo.completed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future deleteTodo(String docId) {
    return _todoReference.doc(docId).delete();
  }

  Future toogleCompleted(Todo todo) {
    return _todoReference.doc(todo.id).update({
      'completed': !todo.completed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future updateUsername(String username) {
    return _dataUserReference.doc(_uid).update({
      'username': username,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future uploadUserImage(File file) async {
    final ref =
        FirebaseStorage.instance.ref().child('user_data').child('$_uid.jpg');
    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    await _dataUserReference.doc(_uid).update({
      'user_image_url': url,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
