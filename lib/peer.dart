import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

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
            idx: row['idx'],
            id: row['id'],
            account: row['account'],
            name: row['name'],
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

class PeerPage extends StatefulWidget {
  Map<String, dynamic> params;

  PeerPage(this.params);

  @override
  _PeerState createState() => new _PeerState(this.params);
}

class _PeerState extends State<PeerPage> {
  Peer peer;
  String amount;
  var events = <Event>[];

  _PeerState(Map<String, dynamic> params) {
    startPeer(params).then((_) { startEvents(); });
  }

  final uuid = new Uuid();

  Future startPeer (Map<String, dynamic> params) async {
    Database db = await getDB();

    Map<String, dynamic> peerRow;
    if (params['id'] != null) {
      var rows = await db.rawQuery(
        'SELECT * FROM peers WHERE id = ?', [params['id']]);
      peerRow = rows[0];
    } else {
      var rows = await db.rawQuery(
        'SELECT * FROM peers WHERE account = ?', [params['account']]);
      peerRow = rows[0];
    }

    setState(() {
      this.peer = new Peer(
        idx: peerRow['idx'],
        id: peerRow['id'],
        account: peerRow['account'],
        name: peerRow['name']
      );
    });
  }


  Future startEvents () async {
    Database db = await getDB();

    var eventRows = await db.rawQuery("""
SELECT
  things.id AS id,
  things.name AS name,
  things.asset AS asset,
  things.date AS date,
  things.saved AS saved,
  CASE WHEN pmtpeer.amount IS NULL THEN 0.0 ELSE pmtpeer.amount END AS theirpmt,
  CASE WHEN duepeer.amount IS NULL THEN 0.0 ELSE duepeer.amount END AS theirdue,
  CASE WHEN pmtme.amount IS NULL THEN 0.0 ELSE pmtme.amount END AS mypmt,
  CASE WHEN dueme.amount IS NULL THEN 0.0 ELSE dueme.amount END AS mydue
FROM things
LEFT JOIN (SELECT * FROM payments WHERE peer = ?) AS pmtpeer
  ON pmtpeer.thing = things.id
LEFT JOIN (SELECT * FROM dues WHERE peer = ?) AS duepeer
  ON duepeer.thing = things.id
LEFT JOIN (SELECT * FROM payments WHERE peer = 0) AS pmtme
  ON pmtme.thing = things.id
LEFT JOIN (SELECT * FROM dues WHERE peer = 0) AS dueme
  ON dueme.thing = things.id
WHERE pmtpeer.amount IS NOT NULL OR duepeer.amount IS NOT NULL
GROUP BY things.id
ORDER BY things.date DESC;
    """, [this.peer.idx, this.peer.idx]);

    setState(() {
      this.events = eventRows.map((row) => new Event(
        id: row['id'],
        name: row['name'],
        asset: row['asset'],
        date: row['date'],
        saved: row['saved'] == 'true',
        mypmt: row['mypmt'],
        theirpmt: row['theirpmt'],
        mydue: row['mydue'],
        theirdue: row['theirdue'],
      )).toList();
    });
  }

  Future owe () async {
    Database db = await getDB();

    await db.inTransaction(() async {
      if (this.amount == null) { return; }
      String id = uuid.v1();
      double amount = double.parse(this.amount);
      await db.execute('UPDATE peers SET show = 1 WHERE idx = ?', [peer.idx]);
      await db.insert('things', {'id': id, 'name': ''});
      await db.insert('dues', {'thing': id, 'peer': 0, 'amount': amount});
      await db.insert('payments', {'thing': id, 'peer': peer.idx, 'amount': amount});
    });

    startEvents();
  }

  Future paid () async {
    Database db = await getDB();

    await db.inTransaction(() async {
      if (this.amount == null) { return; }
      String id = uuid.v1();
      double amount = double.parse(this.amount);
      await db.execute('UPDATE peers SET show = 1 WHERE idx = ?', [peer.idx]);
      await db.insert('things', {'id': id, 'name': ''});
      await db.insert('dues', {'thing': id, 'peer': peer.idx, 'amount': amount});
      await db.insert('payments', {'thing': id, 'peer': 0, 'amount': amount});
    });

    startEvents();
  }

  @override
  Widget build(BuildContext context) {
    if (peer == null) {
      return new Text("loading profile...");
    }

    final messages = new ListView(
      reverse: true,
      padding: const EdgeInsets.all(20.0),
      children: this.events
        .map((ev) => new FractionallySizedBox(
          widthFactor: 60.0,
          alignment: (ev.mypmt - ev.mydue) > (ev.theirpmt - ev.theirdue)
            ? Alignment.centerRight
            : Alignment.centerLeft,
          child: new Container(
            padding: const EdgeInsets.all(7.0),
            margin: const EdgeInsets.all(6.0),
            decoration: new BoxDecoration(
              color: Colors.white.withAlpha(100),
              borderRadius: new BorderRadius.all(const Radius.circular(7.0)),
            ),
            child: new Text(
              '${ev.theirpmt} ${ev.theirdue} ${ev.name} ${ev.mypmt} ${ev.mydue}',
              textAlign: (ev.mypmt - ev.mydue) > (ev.theirpmt - ev.theirdue)
                ? TextAlign.right
                : TextAlign.left,
            ),
          ),
        ))
        .toList()
    );

    final bottom = new Row(
      children: <Widget>[
        new FlatButton(
          child: new Column(
            children: <Widget>[
              new Text('OWE'),
              new Icon(FontAwesomeIcons.caretSquareOUp),
            ],
          ),
          onPressed: this.owe,
        ),
        new Container(width: 10.0),
        new Expanded(
          child: new TextField(
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              hideDivider: true,
            ),
            autofocus: true,
            maxLines: 1,
            onChanged: (value) {
              setState(() { this.amount = value; });
            },
          ),
        ),
        new Container(width: 10.0),
        new FlatButton(
          child: new Column(
            children: <Widget>[
              new Text('PAID'),
              new Icon(FontAwesomeIcons.caretSquareODown),
            ],
          ),
          onPressed: this.paid,
        ),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(peer.id ?? peer.account),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(child: messages),
          new Divider(height: 1.0),
          new Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: bottom,
          ),
        ],
      ),
    );
  }
}
