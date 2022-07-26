import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/resources/auth_methods.dart';
import 'package:social_app/responsive/mobile_screen_layout.dart';
import 'package:social_app/responsive/responsive_layout.dart';
import 'package:social_app/screens/signin.dart';
import 'package:social_app/widgets/text_field.dart';
import 'package:social_app/Utils/utils.dart';

import '../responsive/web_screen_layout.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().signUp(
        username: _usernameController.text,
        email: _emailController.text,
        bio: _bioController.text,
        password: _passwordController.text,
        file: _image!);
    if (result == "success") {
      var route = MaterialPageRoute(
          builder: (BuildContext) => ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ));
      Navigator.pushReplacement(context, route);
      // Navigator.pushReplacementNamed(context, "Home");
    } else {
      showSnackBar(result, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(children: [
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  SvgPicture.asset(
                    "assets/images/ic_instagram.svg",
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  NetworkImage("https://bit.ly/3msSZIF"),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                            ),
                            onPressed: () {
                              pickImage();
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextInputField(
                      textEditingController: _usernameController,
                      textInputType: TextInputType.text,
                      hintText: "Username"),
                  SizedBox(
                    height: 24,
                  ),
                  TextInputField(
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      hintText: "Email"),
                  SizedBox(
                    height: 24,
                  ),
                  TextInputField(
                      textEditingController: _bioController,
                      textInputType: TextInputType.text,
                      hintText: "Boi"),
                  SizedBox(
                    height: 24,
                  ),
                  TextInputField(
                      isPass: true,
                      textEditingController: _passwordController,
                      textInputType: TextInputType.emailAddress,
                      hintText: "Password"),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      if (_image != null) {
                        signupUser();
                      } else {
                        showSnackBar(
                            "Please select a profile picture", context);
                      }
                    },
                    child: Container(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Text("Sign up"),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: ShapeDecoration(
                          color: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Already have an account?"),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          var route = MaterialPageRoute(
                              builder: (BuildContext) => SignIn());
                          Navigator.push(context, route);
                        },
                        child: Container(
                          child: Text(
                            "Sign in.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      )
                    ],
                  )
                ]))));
  }

  pickImage() async {
    Uint8List im = await pickFile(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }
}
