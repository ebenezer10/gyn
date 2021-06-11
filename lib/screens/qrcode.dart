import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qrcode extends StatefulWidget {
  List<String> numbers = [];

  Qrcode(this.numbers, {Key key}) : super(key: key);

  @override
  _QrcodeState createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  String explodedNumbers = "";

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.numbers.length; i++) {
      explodedNumbers += widget.numbers.elementAt(i);
      if (i < (widget.numbers.length - 1)) {
        explodedNumbers += ":";
      }
    }
    debugPrint("explodedNumber : "+explodedNumbers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 0,
        title: Text(
          "Partage de numéro(s)",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              QrImage(
                data: explodedNumbers,
                version: QrVersions.auto,
                size: 200.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                child: Text(
                  "L'intéressé doit scanner ce code QR pour enregistrer automatiquement votre numéro.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
