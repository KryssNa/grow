
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:groceteria/repo.dart';

import 'model.dart';



class ItemViewModel with ChangeNotifier{
  ItemRepository _ItemRepository =ItemRepository();
  Stream<QuerySnapshot<ItemModel>>? _Item;
  Stream<QuerySnapshot<ItemModel>>? get Item => _Item;

  Future<void> getItem() async{
    var response = _ItemRepository.getData();
    _Item = response as Stream<QuerySnapshot<ItemModel>>?;
    notifyListeners();
  }
}