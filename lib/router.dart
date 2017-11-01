import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import './peer.dart';

class R {
  static final Router _router = new Router();

  static var peerHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new PeerPage(params);
    },
  );

  static void initRoutes() {
    _router.define("/peer-id/:id", handler: peerHandler);
    _router.define("/peer-account/:account", handler: peerHandler);
  }

  static void navigateTo(context, String route, {TransitionType transition}) {
    _router.navigateTo(context, route, transition: transition);
  }
}

