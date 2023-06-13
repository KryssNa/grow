import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceteria/viewmodel.dart';
import 'package:image_picker/image_picker.dart';

import 'model.dart';


class AdminAddItems extends StatefulWidget {
  const  AdminAddItems ({super.key});
  static const routeName = '/ItemAddPlace';
  @override
  State< AdminAddItems > createState() => _ItemPlace ();
}

class  _ItemPlace  extends State< AdminAddItems > {
  TextEditingController Item_name = TextEditingController();
  TextEditingController Item_price = TextEditingController();
  TextEditingController Item_description = new TextEditingController();
  int id = new DateTime.now().millisecondsSinceEpoch;
  File? pickedImage;
  // var uuid = Uuid();
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          child: Container(
            color: Colors.blue,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }
  Future<void> add_Item(ItemViewModel) async {
    if(pickedImage == null){
      // ScaffoldMessenger.of(context).showSnackBar(snackBar)
      return;
    }
    FirebaseFirestore db = FirebaseFirestore.instance;
    Reference storageRef = FirebaseStorage.instance.ref();

    String dt = DateTime.now().millisecondsSinceEpoch.toString();
    var photo = await storageRef.child("Items").child("$dt.jpg").putFile(File(pickedImage!.path));
    var url = await photo.ref.getDownloadURL();

    final data = ItemModel(
        ItemId: id.toString(),
        ItemName:Item_name.text,
        price: Item_price.text,
        description: Item_description.text,
        imageUrl: url,
        imagepath: photo.ref.fullPath
    );
    db.collection("Item").add(data.toJson()).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item added")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
        title: const Text('Add Item',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            // fontFamily: 'SF-Pro',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(
                      //     color: Colors.grey.withOpacity(0.6), width: 2),
                    ),
                    child: ClipRect(
                      child: pickedImage != null ? Image.file(
                        pickedImage!,
                        width: 500,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                          : Image.asset('Assets/images/insert_image.png'),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0,vertical:4.0),
              child: ElevatedButton.icon(
                  onPressed: ()=>imagePickerOption(),
                  icon: const Icon(Icons.add_a_photo_sharp),
                  label: const Text('Item Image')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 4.0),
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: Item_name,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "empty";
                  }
                  if (!RegExp(r"^[a-zA-Z]").hasMatch(value)) {
                    return "Please enter the Item name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.local_grocery_store,
                    color: Colors.black,
                  ),
                  hintText: "Item Name",
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 4.0),
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: Item_price,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Item price is needed";
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.attach_money_outlined,
                    color: const Color.fromARGB(255, 151, 135, 135),
                  ),
                  hintText: "Item Price",
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 4.0),
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: Item_description,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Item description is required";
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.description,
                    color: Colors.black,
                  ),
                  hintText: "Item description",
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 4.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    add_Item(ItemViewModel);
                  },
                  icon: const Icon(Icons.local_grocery_store),
                  label: const Text('Add Item')),
            ),
          ],
        ),
      ),
    );
  }
}