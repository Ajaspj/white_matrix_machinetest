import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whitematrix/model/productmodel.dart';

class AdddataScreen extends StatefulWidget {
  const AdddataScreen({super.key});

  @override
  State<AdddataScreen> createState() => _AdddataScreenState();
}

class _AdddataScreenState extends State<AdddataScreen> {
  XFile? file;
  String? url; // Change `var url` to `String? url`
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController reviewcontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController sellercontroller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();
  TextEditingController quantitycontroller = TextEditingController();
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("products");

  Future<void> uploadImage() async {
    if (file != null) {
      final storageref = FirebaseStorage.instance.ref();
      var imageref = storageref.child("image");
      var uploadref = imageref.child(file!.name);
      await uploadref.putFile(File(file!.path));
      url = await uploadref.getDownloadURL();
      log(url.toString());
    }
  }

  void addProduct() async {
    if (titlecontroller.text.isEmpty ||
        reviewcontroller.text.isEmpty ||
        descriptioncontroller.text.isEmpty ||
        sellercontroller.text.isEmpty ||
        pricecontroller.text.isEmpty ||
        ratecontroller.text.isEmpty ||
        quantitycontroller.text.isEmpty ||
        url == null) {
      const snackBar = SnackBar(
        content: Text(
          "Please fill all fields and upload an image!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    await collectionRef.add(ProductModel(
      title: titlecontroller.text,
      review: reviewcontroller.text,
      description: descriptioncontroller.text,
      image: url!,
      price: double.parse(pricecontroller.text),
      seller: sellercontroller.text,
      rate: double.parse(ratecontroller.text),
      quantity: int.parse(quantitycontroller.text),
    ).toMap());

    const snackBar = SnackBar(
      content: Text(
        "Successfully added!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Clear the form after adding the product
    titlecontroller.clear();
    reviewcontroller.clear();
    descriptioncontroller.clear();
    pricecontroller.clear();
    sellercontroller.clear();
    ratecontroller.clear();
    quantitycontroller.clear();
    setState(() {
      file = null;
      url = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {});
                  await uploadImage();
                },
                child: file != null
                    ? Container(
                        height: 130,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image(
                          image: FileImage(File(file!.path)),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 130,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.add_a_photo, size: 40),
                      ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: titlecontroller,
                decoration: const InputDecoration(
                  label: Text("Enter title"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: reviewcontroller,
                decoration: const InputDecoration(
                  label: Text("Enter review"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptioncontroller,
                decoration: const InputDecoration(
                  label: Text("Enter description"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: sellercontroller,
                decoration: const InputDecoration(
                  label: Text("Enter seller"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pricecontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Enter price"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ratecontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Enter rating"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: quantitycontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Enter quantity"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addProduct,
                child: const Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
