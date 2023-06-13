import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebaseService.dart';
import 'model.dart';



class ItemRepository{
  CollectionReference<ItemModel> ref =
  FirebaseService.db.collection("Item")
      .withConverter<ItemModel>(
    fromFirestore: (snapshot, _) {
      return ItemModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
  Stream<QuerySnapshot<ItemModel>> getData()  {
    Stream<QuerySnapshot<ItemModel>> response = ref
        .snapshots();
    return response;
  }
  Future<ItemModel?> getOneData(String id) async {
    DocumentSnapshot<ItemModel> response = await ref.doc(id).get();
    return response.data();
  }


  Future<bool> addItem(ItemModel data) async {
    await ref.add(data);
    return true;
  }
}