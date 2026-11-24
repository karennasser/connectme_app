import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../services/firestore_service.dart';
import '../models/user_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this.firestore, this.storage);
  final FirestoreService firestore;
  final FirebaseStorage storage;

  Future<UserModel> getProfile(String uid) async {
    final doc = await firestore.users.doc(uid).get();
    final data = doc.data() ?? {};
    return UserModel(
      id: uid,
      fullName: data['fullName'] as String? ?? 'ConnectMe Member',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
    );
  }

  Future<String> uploadPhoto(String uid, String path) async {
    final ref = storage.ref('profile_photos/$uid.jpg');
    await ref.putFile(File(path));
    final url = await ref.getDownloadURL();
    await firestore.users.doc(uid).set({'photoUrl': url}, SetOptions(merge: true));
    return url;
  }
}
