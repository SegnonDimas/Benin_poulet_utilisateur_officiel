import 'package:benin_poulet/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreStoreService {
  final CollectionReference _storesRef =
      FirebaseFirestore.instance.collection('stores');

  Future<void> addStore(Store storeData) async {
    final docRef = _storesRef.doc();
    final storeWithId = storeData.copyWith(sellerId: docRef.id);
    await docRef.set(storeWithId.toMap());
  }
}
