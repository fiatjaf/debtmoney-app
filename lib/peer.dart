import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';

import './style.dart' as style;
import './router.dart';
import './db.dart';
import './models.dart';

class PeerList extends StatelessWidget {
  final List<Peer> peers;

  const PeerList(this.peers);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListView.builder(
        itemCount: peers.length,
        itemBuilder: (_, index) {
          var peer = peers[index];
          return new PeerItem(peer);
        },
      ),
    );
  }
}

class PeerItem extends StatelessWidget {
  final Peer peer;

  const PeerItem(this.peer);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () => R.navigateTo(
        context,
        peer.id != null ? '/peer-id/${peer.id}' : '/peer-account/${peer.account}',
        transition: TransitionType.fadeIn,
      ),
      leading: new Hero(
        tag: 'peer-icon-${peer.id ?? peer.account}',
        child: new CircleAvatar(
          radius: 50.0,
          backgroundColor: style.hashcolor(peer.id ?? peer.account),
          child: new Text((peer.id ?? peer.account)[0].toUpperCase()),
        ),
      ),
      title: new Text(
        peer.name ?? peer.id ?? peer.account,
        style: new TextStyle(color: Colors.white),
      ),
      subtitle: new Row(
        children: <Widget>[
          new Icon(FontAwesomeIcons.arrowUp, size: 14.0, color: Colors.white),
          new Text(' ' + '17'),
          new Container(width: 24.0),
          new Icon(FontAwesomeIcons.arrowDown, size: 14.0, color: Colors.white),
          new Text(' ' + '5'),
        ],
      ),
    );
  }
}

class PeerPage extends StatefulWidget {
  Map<String, dynamic> params;

  PeerPage(this.params);

  @override
  _PeerState createState() => new _PeerState(this.params);
}

class _PeerState extends State<PeerPage> {
  Peer peer;

  _PeerState(Map<String, dynamic> params) {
    getDB()
      .then((db) {
        if (params['id'] != null) {
          return db.rawQuery(
            'SELECT * FROM peers WHERE id = ?', [params['id']]);
        } else {
          return db.rawQuery(
            'SELECT * FROM peers WHERE account = ?', [params['account']]);
        }
      })
      .then((List<Map> rows) {
        setState(() {
          this.peer = new Peer(
            id: rows[0]['id'],
            account: rows[0]['account'],
            name: rows[0]['name']
          );
        });
      })
      .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    if (peer == null) {
      return new Text("loading profile...");
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(peer.id ?? peer.account),
      ),
      body: new Stack(
        children: <Widget>[
          new Text(peer.name ?? '~'),
        ],
      ),
    );
  }
}

class ChoosePeer extends StatefulWidget {
  @override
  _ChoosePeerState createState() => new _ChoosePeerState();
}

class _ChoosePeerState extends State<ChoosePeer> {
  var peers = <Peer>[];

  _ChoosePeerState() {
    getDB()
      .then((db) {
        return db.rawQuery('SELECT * FROM peers WHERE idx > 0 ORDER BY name');
      })
      .then((List<Map> rows) {
        setState(() {
          this.peers = rows.map((row) => new Peer(
            id: row['id'],
            account: row['account'],
            name: row['name']
          )).toList();
        });
      })
      .catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Row(
          children: <Widget>[
            new Text(
              'New Debt',
            ),
          ],
        ),
      ),
      body: new Container(
        child: new ListView.builder(
          itemCount: this.peers.length,
          itemBuilder: (_, index) {
            var peer = this.peers[index];
            return new PeerItem(peer);
          },
        ),
      ),
    );
  }
}
