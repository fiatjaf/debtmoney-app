import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../style.dart';
import '../router.dart';
import './peer.dart';

class PeerList extends StatefulWidget {
  @override
  _PeerListState createState() => new _PeerListState();
}

class _PeerListState extends State<PeerList> {
  var peers = <Peer>[
    const Peer(id: "fulano"),
    const Peer(id: "beltrana"),
    const Peer(id: "ciclano"),
    const Peer(id: "fulana"),
    const Peer(id: "beltrano"),
    const Peer(id: "ciclana"),
  ];

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
                '/peer/${peer.id}',
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
