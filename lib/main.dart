import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      primarySwatch: Colors.amber,
      accentColor: Colors.amberAccent,
      scaffoldBackgroundColor: const Color(0xFF736AB7),
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

  _GlobalState () {
    getLoggedUser();
    getPeers();
  }

  Future getLoggedUser () async {
    final Database db = await getDB();
    List<Map> res = await db.rawQuery(
      'SELECT id, account FROM peers WHERE idx = 0');

    setState(() {
      me = new Peer(
        idx: 0,
        id: res[0]['id'],
        account: res[0]['account'],
      );
    });
  }

  Future getPeers () async {
    final Database db = await getDB();
    List<Map> res = await db.rawQuery(
      'SELECT idx, id, account, name FROM peers WHERE show');

    setState(() {
      peers = res.map((row) => new Peer(
        idx: row['idx'],
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
        onPressed: () {
          R.navigateTo(
            context,
            '/choose-peer',
            transition: TransitionType.fadeIn,
          );
        },
      ),
      appBar: new AppBar(title: new Text('debtmoney.xyz')),
      body: new PeerList(peers),
      drawer: new SideMenu(me,
        getLoggedUser: getLoggedUser,
        getPeers: getPeers,
      ),
    );
  }
}
