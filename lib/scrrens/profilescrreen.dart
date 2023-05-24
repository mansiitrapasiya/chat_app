import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/dilouge.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/splash.dart';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ProfileScrreen extends StatefulWidget {
  final Chatuser user;
  const ProfileScrreen({super.key, required this.user});

  @override
  State<ProfileScrreen> createState() => _ProfileScrreenState();
}

class _ProfileScrreenState extends State<ProfileScrreen> {
  final formkey = GlobalKey<FormState>();
  XFile? _image;
  final _debouncer = Debouncer(milliseconds: 500);

   _imageFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      setState(() {
        _image = image;
        UserData.updateProfile(
          File(
            _image!.path,
          ),
        );
      });

      await cropImage();

      Navigator.pop(context);
    }
  }

  _imageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _image = image;
        UserData.updateProfile(
          File(
            _image!.path,
          ),
        );
      });
      await cropImage();

      Navigator.pop(context);
    }
  }

  Future cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        compressQuality: 20,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
        ]);
    if (croppedFile != null) {
      _image = XFile(croppedFile.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 10),
            child: InkWell(
              onTap: () async {
                Diallougs.showProgressBar(context);
                await UserData.auth.signOut().then(
                  (value) async {
                    await GoogleSignIn().signOut().then((value) {
                      //for hinding progress dialouge
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Splashscreen();
                        }),
                        (route) => false,
                      );
                    });
                  },
                );
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: "Acme",
                  fontSize: 20,
                  color: Color.fromARGB(255, 180, 218, 248),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: [
                    _image != null
                        ? Hero(
                            tag: FileImage(File(_image!.path)),
                            child: CircleAvatar(
                              backgroundImage: FileImage(File(_image!.path)),
                              radius: 60,
                            ),
                          )
                        : Hero(
                            tag: UserData.user.photoURL.toString(),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                UserData.mee.image,
                              ),
                            ),
                          ),
                    InkWell(
                      onTap: () {
                        showModelsheet();
                      },
                      child: Container(
                          height: 35,
                          width: 35,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 180, 218, 248)),
                          child: const Icon(Icons.edit)),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Hero(
                tag: widget.user.email,
                child: Text(
                  widget.user.email,
                  style: const TextStyle(
                    fontFamily: "Acme",
                    fontSize: 18,
                    color: Color.fromARGB(255, 180, 218, 248),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: TextFormField(
                onChanged: (value) {
                  _debouncer.run(() {
                    UserData.updateAbout(value);
                  });
                },
                initialValue: widget.user.about,
                textAlignVertical: TextAlignVertical.bottom,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black, fontFamily: "Acme"),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.5)),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5)),
                    prefixIcon: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                      size: 25,
                    ),
                    fillColor: const Color.fromARGB(255, 180, 218, 248),
                    filled: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showModelsheet() {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 180, 218, 248),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (_) {
          return Container(
            height: 120,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Pick a Profile Picture !',
                    style: TextStyle(fontSize: 18, fontFamily: 'Acme'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _imageFromGallery();
                        // pickVideo();
                      },
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset(
                          'assets/p2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _imageFromCamera();
                      },
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset(
                          'assets/p5.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}



// const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// class Debouncer {
//   final int milliseconds;
//   Timer? _timer;

//   Debouncer({required this.milliseconds});

//   run(VoidCallback action) {
//     _timer?.cancel();
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: darkBlue,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: MyWidget(),
//         ),
//       ),
//     ); 
//   }
// }

// class MyWidget extends StatelessWidget {
  
//   final _debouncer = Debouncer(milliseconds:500);
  
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//     onChanged: (value){
//       print("normnal: "+value);
      
//       _debouncer.run((){
//          print("debounce: "+value);
//       });
//     },);
//   }
// }
