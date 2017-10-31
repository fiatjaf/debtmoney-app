import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './style.dart';
import './router.dart';
import './models.dart';

class PeerList extends StatelessWidget {
  final List<Peer> peers;

  const PeerList(this.peers);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
        color: Colours.peerPageBackground,
        child: new ListView.builder(
          itemCount: peers.length,
          itemBuilder: (_, index) {
            var peer = peers[index];

            return new FlatButton(
              onPressed: () => R.navigateTo(
                context,
                '/peer/${peer.id ?? peer.account}',
                transition: TransitionType.fadeIn,
              ),
              child: new PeerItem(peer),
            );
          },
        ),
      ),
    );
  }
}

class PeerItem extends StatelessWidget {
  final Peer peer;

  const PeerItem(this.peer);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 120.0,
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: new Stack(
        children: <Widget>[
          new Container (
            margin: const EdgeInsets.only(top: 16.0, left: 72.0),
            constraints: new BoxConstraints.expand(),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(peer.id ?? peer.account, style: TextStyles.peerTitle),
                new Text(peer.id ?? peer.account, style: TextStyles.peerLocation),
                new Container(
                  color: const Color(0xFF00C6FF),
                  width: 24.0,
                  height: 1.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                new Row(
                  children: <Widget>[
                    new Icon(FontAwesomeIcons.arrowUp, size: 14.0, color: Colours.peerDistance),
                    new Text(' ' + '17', style: TextStyles.peerDistance),
                    new Container(width: 24.0),
                    new Icon(FontAwesomeIcons.arrowDown, size: 14.0, color: Colours.peerDistance),
                    new Text(' ' + '5', style: TextStyles.peerDistance),
                  ],
                ),
              ],
            ),
          ),
          new Container(
            alignment: new FractionalOffset(0.0, 0.5),
            margin: const EdgeInsets.only(left: 24.0),
            child: new Hero(
              tag: 'peer-icon-${peer.id ?? peer.account}',
              child: new CircleAvatar(
                radius: 50.0,
                backgroundColor: Hashcolor(peer.id ?? peer.account),
                child: new Text((peer.id ?? peer.account)[0]),
              ),
            ),
          )
        ]
      ),
    );
  }
}

class PeerPage extends StatefulWidget {
  final String id;

  const PeerPage(this.id);

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
          new Text(peer.name),
        ],
      ),
    );
  }
}
