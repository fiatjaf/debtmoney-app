import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:contact_picker/contact_picker.dart';

import './models.dart';
import './ui.dart';
import './style.dart';
import './router.dart';
import './peer.dart';
import './sidemenu.dart';


void main() {
  R.initRoutes();
  runApp(new MaterialApp(
    title: "Debtmoney Debt Manager",
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _GlobalState createState() => new _GlobalState();
}

class _GlobalState extends State<HomePage> {
  var me = new Peer(tempId: 1);
  var peers = <Peer>[
    new Peer(id: "fulano"),
    new Peer(id: "beltrana"),
    new Peer(id: "ciclano"),
    new Peer(id: "fulana"),
    new Peer(id: "beltrano"),
    new Peer(id: "ciclana"),
  ];

  final _contactPicker = new ContactPicker();

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
      body: new Column(
        children: <Widget>[
          new GradientAppBar('debtmoney.xyz'),
          new PeerList(peers),
        ]
      ),
      drawer: new SideMenu(me),
    );
  }
}
