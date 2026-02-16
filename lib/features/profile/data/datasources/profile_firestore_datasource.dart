import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile_model.dart';

class ProfileFirestoreDataSource {
  final FirebaseFirestore firestore;

  ProfileFirestoreDataSource(this.firestore);

  Future<void> createProfile(ProfileModel profile) async {
    await firestore
        .collection('users')
        .doc(profile.id)
        .set(profile.toMap());
  }

  Future<ProfileModel> getProfile(String userId) async {
    final doc =
        await firestore.collection('users').doc(userId).get();

    final data = doc.data()!;
    return ProfileModel.fromMap(data, doc.id);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await firestore
        .collection('users')
        .doc(profile.id)
        .update(profile.toMap());
  }
}
