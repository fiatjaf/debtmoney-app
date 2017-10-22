import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../style.dart';

class Peer {
  final String tempId;
  final String id;

  const Peer({this.tempId, this.id});
}

class Record {
  var String record_date;
  var String created_at;
  var String asset;
  var Debt description;

  const Record({this.record_date, this.created_at, this.asset, this.description});
}

class Debt {
  var String from
  var String to
  var String amt

  const Debt({this.from, this.to, this.amt})
}

class PeerItem extends StatelessWidget {
  final Peer peer;

  const PeerItem(this.peer);

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Text(peer.id + " é bacana."),
      ],
    );
  }
}

class PeerPage extends StatefulWidget {
  final String id;

  PeerPage(this.id);

  @override
  _PeerState createState() => new _PeerState(id);
}

class _PeerState extends State<PeerPage> {
  final Peer peer;

  var debts = <Record>[];

  _PeerState(String id) :
    peer = new Peer(id: id);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Row(
          children: <Widget>[
            new Text(
              peer.id,
              style: new TextStyle(
                color: new Color(0xFF736AB7),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        actions: null,
      ),
      body: new Stack(
        children: <Widget>[
          new Text(peer.id),
        ],
      ),
    );
  }
}
