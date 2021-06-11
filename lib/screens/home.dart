import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:get/get.dart';
import 'package:gyn/dialogs/chooseActionDIalog.dart';
import 'package:gyn/screens/qrcode.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String scanResult = "";
  String _mobileNumber = "";
  List<SimCard> _simCard = <SimCard>[];
  List<String> numbers = [];

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: double.infinity,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 50, bottom: 25, left: 20),
            child: Text(
              "Give me your number",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 0, bottom: 30, left: 20),
            child: Text(
              "Bienvenue dans votre application d'évhange de numéros de téléphones. Choisissez une action à effectuer.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 0, bottom: 30, left: 20),
            child: Text(
              "En utilisant cette application, vous attestez être responsable des risques que vous encourez quant au partage de votre numéro.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mobile_screen_share_outlined),
        backgroundColor: Colors.amber,
        onPressed: () {
          Get.bottomSheet(Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Partager mon numéro'),
                  onTap: () {
                    for (int i = 0; i < _simCard.length; i++) {
                      if (_simCard.elementAt(i).number != null) {
                        numbers.add(_simCard.elementAt(i).number);
                        Get.to(Qrcode(numbers));
                        numbers = [];
                        debugPrint("Numbers : " + numbers.toString());
                        debugPrint("Simcard : " + _simCard.toString());
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.perm_contact_cal),
                  title: Text('Enregistrer un numéro'),
                  onTap: () => _scan(),
                ),
              ],
            ),
          ));
          //Get.dialog(ChooseActionDialog());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
      return null;
    } else {
      setState(() {
        scanResult = barcode;
      });
      List<String> explodedNumbers = scanResult.split(":");
      Contact newContact = new Contact();
      newContact.givenName = "TestTestTest";
      List<Item> items = [];
      explodedNumbers.forEach((element) {
        Item item = new Item();
        item.value = element;
        items.add(item);
      });
      newContact.phones = items;
      await Contacts.addContact(newContact);
      debugPrint("Exploded number : " + explodedNumbers.toString());
      return barcode;
    }
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    String mobileNumber = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber = (await MobileNumber.mobileNumber);
      _simCard = (await MobileNumber.getSimCards);
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _mobileNumber = mobileNumber;
    });
  }

  Widget fillCards() {
    List<Widget> widgets = _simCard
        .map((SimCard sim) => Text(
            'Sim Card Number: (${sim.countryPhonePrefix}) - ${sim.number}\nCarrier Name: ${sim.carrierName}\nCountry Iso: ${sim.countryIso}\nDisplay Name: ${sim.displayName}\nSim Slot Index: ${sim.slotIndex}\n\n'))
        .toList();
    return Column(children: widgets);
  }
}
