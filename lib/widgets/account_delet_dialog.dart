import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';

accountDeleteDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text(
      "Delete",
      style: TextStyle(color: Colors.grey),
    ),
    onPressed: () {
      AuthMethods().deleteAccount(context);
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Account"),
    content: Text("Are you sure you want to delete this account?."),
    actions: [
      okButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
