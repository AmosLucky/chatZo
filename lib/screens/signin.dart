import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/Utils/dimensions.dart';
import 'package:social_app/Utils/utils.dart';
import 'package:social_app/resources/auth_methods.dart';
import 'package:social_app/responsive/mobile_screen_layout.dart';
import 'package:social_app/responsive/responsive_layout.dart';
import 'package:social_app/responsive/web_screen_layout.dart';
import 'package:social_app/screens/home.dart';
import 'package:social_app/screens/signup.dart';
import 'package:social_app/widgets/text_field.dart';

import '../widgets/logo.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _loading = true;
    });
    String res = await AuthMethods().signInUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      var route = MaterialPageRoute(
          builder: (BuildContext) => ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ));
      Navigator.pushReplacement(context, route);
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: size.width > webScreenSize
                    ? EdgeInsets.symmetric(horizontal: size.width / 3)
                    : const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(children: [
                  SizedBox(
                    height: size.height / 4,
                  ),
                  // Flexible(
                  //   child: Container(),
                  //   flex: 2,
                  // ),
                  Logo(),
                  // SvgPicture.asset(
                  //   "assets/images/ic_instagram.svg",
                  //   color: primaryColor,
                  //   height: 60,
                  // ),
                  SizedBox(
                    height: size.height / 7,
                  ),
                  TextInputField(
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      hintText: "Email"),
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
                      loginUser();
                    },
                    child: Container(
                      child: _loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Text("Log in"),
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
                  // Flexible(
                  //   child: Container(),
                  //   flex: 2,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Don't have an account?"),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          var route = MaterialPageRoute(
                              builder: (BuildContext) => SignUp());
                          Navigator.push(context, route);
                        },
                        child: Container(
                          child: Text(
                            "Sign up.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      )
                    ],
                  )
                ]))));
  }
}
