import 'dart:io';

import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/myhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const ProfilePage(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameContoller = TextEditingController();
  XFile? _image;

  _imageFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = image;
    });
    await cropImage();
  }

  _imageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = image;
    });
    await cropImage();
  }

  Future cropImage() async {
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: _image!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio5x4,
    ]);
    _image = XFile(croppedFile!.path);
    setState(() {});
  }

  void showPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Upload Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _imageFromCamera();
                  },
                  title: Text('Select From Gallery'),
                  leading: Icon(Icons.photo),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _imageFromGallery();
                  },
                  leading: Icon(Icons.photo),
                  title: Text('Take a Photo'),
                ),
              ],
            ),
          );
        });
  }

  void checkVal() {
    String fullname = nameContoller.text.trim();
    if (fullname == "" || _image == null) {
      print('Please fill the details');
    } else {
      updateData();
    }
  }

  void updateData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepic")
        .child(widget.userModel.uid.toString())
        .putFile(File(_image!.path));
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = nameContoller.text.trim();
    await FirebaseFirestore.instance
        .collection("user")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      print('Data Uploadded');
       Navigator.push(context, MaterialPageRoute(builder: (context) {
         return MyHomePage(firebaseUser: widget.firebaseUser, userModel: widget.userModel);
        }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                CupertinoButton(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 60,
                      child: (_image != null)
                          ? Image.file(File(_image!.path))
                          : const Icon(Icons.person),
                    ),
                    onPressed: () {
                      showPhoto();
                    }),
                TextField(
                  controller: nameContoller,
                  decoration: InputDecoration(labelText: 'Full name'),
                ),
               const SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                    color: Colors.black,
                    child: Text(
                      'Sign up ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      checkVal();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
