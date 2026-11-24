import 'package:cloud_firestore/cloud_firestore.dart';

/// Singleton instance is registered in GetIt as a lazy singleton.
class FirestoreService {
  FirestoreService(this.database);
  final FirebaseFirestore database;

  CollectionReference<Map<String, dynamic>> get posts =>
      database.collection('posts');

  CollectionReference<Map<String, dynamic>> get users =>
      database.collection('users');
}
