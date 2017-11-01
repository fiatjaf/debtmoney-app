import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:sqflite/sqflite.dart';

import './models.dart';
import './db.dart';
import './router.dart';
import './peer.dart';
import './sidemenu.dart';


void main() {
  R.initRoutes();
  runApp(new MaterialApp(
    title: "Debtmoney Debt Manager",
    theme: new ThemeData(
      primarySwatch: Colors.deepPurple,
      accentColor: Colors.amberAccent,
    ),
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _GlobalState createState() => new _GlobalState();
}

class _GlobalState extends State<HomePage> {
  Peer me;
  var peers = <Peer>[];

  final _contactPicker = new ContactPicker();

  void setLoggedUser (Peer logged) {
    setState(() {
      me = logged;
    });
  }

  void getPeers () async {
    final Database db = await getDB();
    List<Map> res = await db.rawQuery('SELECT * FROM contacts');

    setState(() {
      peers = res.map((row) => new Peer(
        id: row['id'],
        account: row['account'],
        name: row['name'],
      )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Icon(FontAwesomeIcons.money),
        tooltip: 'Start managing debts with a new contact',
        backgroundColor: new Color(0xFF42A5F5),
        onPressed: () async {
          var contact = await _contactPicker.selectContact();
          if (contact != null) {
            R.navigateTo(
              context,
              '/peer/${contact.phoneNumber.number}',
              transition: TransitionType.fadeIn,
            );
          } else {
            print('contact is null');
          }
        },
      ),
      appBar: new AppBar(title: new Text('debtmoney.xyz')),
      body: new PeerList(peers),
      drawer: new SideMenu(me,
        setLoggedUser: setLoggedUser,
        getPeers: getPeers,
      ),
    );
  }
}
