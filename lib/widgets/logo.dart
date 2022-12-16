import 'package:flutter/widgets.dart';

import '../Utils/global_variables.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      appName,
      style: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Raleway"),
    );
  }
}
