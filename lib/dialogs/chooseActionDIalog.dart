import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChooseActionDialog extends StatefulWidget {
  ChooseActionDialog({Key key}) : super(key: key);

  @override
  _ChooseActionDialogState createState() => _ChooseActionDialogState();
}

class _ChooseActionDialogState extends State<ChooseActionDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Test")],
        ),
      ),
    );
  }
}
