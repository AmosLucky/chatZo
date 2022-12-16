// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Utils/global_variables.dart';
import 'package:social_app/models/User.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/Utils/utils.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/resources/firestore_methods.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  final TextEditingController _textEditingController = TextEditingController();
  bool isLoading = false;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickFile(ImageSource.camera);
                  _file = file;
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Select from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickFile(ImageSource.gallery);
                  _file = file;
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void postImage(String uid, String username, String profileImage) async {
    try {
      if (_textEditingController.text.length > 2) {
        if (_file != null) {
          setState(() {
            isLoading = true;
          });
          String res = await FirestoreMethod().uploadPost(
              _textEditingController.text, _file!, uid, username, profileImage);

          if (res == "success") {
            showSnackBar(res, context);
            _textEditingController.clear();
            clearImage();
          } else {
            showSnackBar(res, context);
          }
        } else {
          showSnackBar("Please select  image", context);
        }
      } else {
        showSnackBar("Content too short", context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    clearImage();
  }

  @override
  void initState() {
    // _selectImage(context);
    //_modalBottomSheetMenu();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            clearImage();
          },
        ),
        title: const Text("Post to"),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                postImage(user.uid, user.username, user.photoUrl);
              },
              child: Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ))
        ],
      ),
      body: Column(children: [
        isLoading
            ? Container(
                margin: EdgeInsets.only(bottom: 5),
                child: LinearProgressIndicator())
            : Container(
                margin: EdgeInsets.only(bottom: 5),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Container(
              color: Colors.amber,
              // height: 2,
              padding: EdgeInsets.all(5),
              child: Text(
                "Your post will be approved by " +
                    appName +
                    " before it appears on Feeds",
                style: TextStyle(color: blackColor),
              ),
            ))

            // SizedBox(
            //   width: 45,
            //   height: 45,
            //   child: AspectRatio(
            //       aspectRatio: 487 / 451,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //               image: MemoryImage(_file!),
            //               fit: BoxFit.fill,
            //               alignment: FractionalOffset.topCenter),
            //         ),
            //       )),
            // )
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: size.width * 0.8,
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                      hintText: "Write a caption...", border: InputBorder.none),
                  maxLines: 10,
                ),
              ),
            ),
          ],
        ),
        _file != null
            ? Column(
                children: [
                  Container(
                    width: size.width / 1.5,
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        clearImage();
                      },
                    ),
                  ),
                  SizedBox(
                    // width: size.width / 1.5,
                    height: 300,
                    child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        )),
                  ),
                ],
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListView(shrinkWrap: true, children: [
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Add a photo"),
                    onTap: () async {
                      Uint8List file = await pickFile(ImageSource.gallery);
                      _file = file;
                      setState(() {});
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Take a picture"),
                    onTap: () async {
                      Uint8List file = await pickFile(ImageSource.camera);
                      _file = file;
                      setState(() {});
                    },
                  ),
                  Divider()
                ]),
              )
      ]),
    );
  }

  _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.white, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                  child: new Text("This is a modal sheet"),
                )),
          );
        });
  }
}
