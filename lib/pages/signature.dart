// IMPORT PACKAGE
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePage extends StatefulWidget {
  SignaturePage({Key? key, required this.collection, required this.document})
      : super(key: key);

  final String collection;
  final String document;

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  // initialize the signature controller
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => log('Value changed'));
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  Future push(context, widget) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
      ),
    );
  }

  Future<void> addSignature(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes(height: 250, width: 300);
    if (data == null) {
      return;
    }

    if (!mounted) return;

    // upload sign to firebase storage
    final storageRef = FirebaseStorage.instance.ref();

    var id = UniqueKey().hashCode;

    final mountainsRef = storageRef.child('$id.png');

    UploadTask uploadTask=mountainsRef.putData(data);
    TaskSnapshot snapshot = await uploadTask;

    var imageUrl = await snapshot.ref.getDownloadURL();

    // upload sign link to firebase firestore
    await FirebaseFirestore.instance
        .collection('visanka_complex')
        .doc(widget.collection)
        .collection('PaymentHistory')
        .doc(widget.document)
        .update({'Sign': imageUrl});

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Your Signature',
          style: TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Signature(
                  key: const Key('signature'),
                  controller: _controller,
                  height: 250,
                  width: 300,
                  backgroundColor: Colors.grey[300]!,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => {addSignature(context)},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => {_controller.clear()},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
